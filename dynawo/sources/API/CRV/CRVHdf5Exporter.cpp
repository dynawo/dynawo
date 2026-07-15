//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  CRVHdf5Exporter.cpp
 *
 * @brief Dynawo curves collection HDF5 exporter : implementation file
 */
#include "CRVHdf5Exporter.h"

#include "DYNMacrosMessage.h"

#include <algorithm>
#include <functional>
#include <string>
#include <vector>

#ifdef DYNAWO_WITH_HDF5
#include <H5Cpp.h>

#if defined(_MSC_VER)
#include <xmmintrin.h>
#define DYNAWO_PREFETCH(addr) _mm_prefetch(reinterpret_cast<const char*>(addr), _MM_HINT_NTA)
#elif defined(__GNUC__) || defined(__clang__)
#define DYNAWO_PREFETCH(addr) __builtin_prefetch((addr), 0, 0)
#else
#define DYNAWO_PREFETCH(addr) ((void)(addr))
#endif
#endif

namespace curves {

// ---------------------------------------------------------------------------
// Pimpl struct: contains HDF5 objects when compiled with HDF5 support,
// otherwise an empty struct so the unique_ptr is always valid.
// ---------------------------------------------------------------------------
#ifdef DYNAWO_WITH_HDF5
struct Hdf5ExporterPrivate {
  // Target ~64 MB per chunk. For very wide datasets (e.g. 400 K curves × 8 B = 3.2 MB/row)
  // this gives ~20 rows/batch → ~60 HDF5 flushes instead of ~600 with an 8 MB target.
  static constexpr size_t TARGET_CHUNK_BYTES = 64 * 1024 * 1024;
  H5::H5File           file;
  H5::DataSet          timeDs;
  H5::DataSet          dataDs;
  hsize_t              chunkRows = 1;
  std::vector<double>  rowBuf;        ///< scratch buffer for one row (ncols wide)
  std::vector<double>  timePending;   ///< buffered time values (up to chunkRows)
  std::vector<double>  dataPending;   ///< buffered data rows  (chunkRows × ncols)
  size_t               pendingCount = 0;
};
#else
struct Hdf5ExporterPrivate {};
#endif

// ---------------------------------------------------------------------------
// Hdf5Exporter
// ---------------------------------------------------------------------------

#ifdef DYNAWO_WITH_HDF5
Hdf5Exporter::Hdf5Exporter(const std::shared_ptr<CurvesCollection>& curves) :
    curveCollection_(curves),
    pimpl_(new Hdf5ExporterPrivate()),
    nrows_(0),
    ncols_(0),
    isOpen_(false) {}

Hdf5Exporter::~Hdf5Exporter() {
  if (isOpen_) {
    try { close(); } catch (...) {}
  }
}
#else
Hdf5Exporter::Hdf5Exporter(const std::shared_ptr<CurvesCollection>& /*curves*/) {}

Hdf5Exporter::~Hdf5Exporter() { }
#endif

void
Hdf5Exporter::open(const std::string& filePath) {
#ifdef DYNAWO_WITH_HDF5

  // Only export curves that carry a full time series (skip EXPORT_AS_FINAL_STATE_VALUE).
  const auto& allCurves = curveCollection_->getCurves();
  std::vector<std::reference_wrapper<const Curve>> exportCurves;
  exportCurves.reserve(allCurves.size());
  for (const auto& c : allCurves) {
    if (c->getExportType() != Curve::EXPORT_AS_FINAL_STATE_VALUE && c->getAvailable())
      exportCurves.emplace_back(*c);
  }
  ncols_ = exportCurves.size();
  if (ncols_ == 0)
    return;  // nothing to export — leave isOpen_ false so appendRow/close are no-ops

  // Build flat lookup arrays once so appendRow() never touches Curve objects or shared_ptrs.
  bufPtrs_.resize(ncols_);
  factors_.resize(ncols_);
  fixedValues_.resize(ncols_, 0.0);
  for (size_t i = 0; i < ncols_; ++i) {
    const Curve& c = exportCurves[i];
    if (!c.isParameterCurve()) {
      bufPtrs_[i] = c.getBuffer();
      factors_[i] = c.getNegated() ? -c.getFactor() : c.getFactor();
    } else {
      fixedValues_[i] = c.getFixedValue();
      bufPtrs_[i] = &fixedValues_[i];
      factors_[i] = 1.0;
    }
  }

  // Adaptive chunk rows: target ~64 MB per chunk, clamped to [10, 1000].
  // Floor: avoids 1–2 row batches for very wide datasets (e.g. 400 K curves → ~20 rows).
  // Cap:   avoids pre-allocating hundreds of MB for small datasets (e.g. 44 curves → 186 K rows uncapped).
  const hsize_t chunkRows = static_cast<hsize_t>(
      std::min(size_t(1000),
      std::max(size_t(10), Hdf5ExporterPrivate::TARGET_CHUNK_BYTES / (ncols_ * sizeof(double)))));

  // Scale the HDF5 chunk cache to hold at least one full chunk.
  // Default is 1 MB; with many columns the default evicts chunks immediately.
  const size_t cacheBytes = std::max(
      size_t(1024 * 1024),
      static_cast<size_t>(chunkRows) * ncols_ * sizeof(double));

  try {
    H5::Exception::dontPrint();

    H5::FileAccPropList fapl;
    // nslots=521 (prime), chunk cache sized to one full batch, w0=0.75
    fapl.setCache(0, 521, cacheBytes, 0.75);
    // Write metadata in 4 MB blocks so each extend() doesn't trigger a separate metadata I/O.
    hsize_t metaBlockSize = 4 * 1024 * 1024;
    fapl.setMetaBlockSize(metaBlockSize);
    pimpl_->file = H5::H5File(filePath, H5F_ACC_TRUNC, H5::FileCreatPropList::DEFAULT, fapl);

    // --- time dataset (1-D, unlimited) ---
    {
      hsize_t initDim[1]  = {0};
      hsize_t maxDim[1]   = {H5S_UNLIMITED};
      hsize_t chunkDim[1] = {chunkRows};

      H5::DataSpace space(1, initDim, maxDim);
      H5::DSetCreatPropList prop;
      prop.setChunk(1, chunkDim);

      pimpl_->timeDs = pimpl_->file.createDataSet("time", H5::PredType::NATIVE_DOUBLE, space, prop);
    }

    // --- data dataset (2-D, unlimited first dim) ---
    {
      hsize_t initDim[2]  = {0,             static_cast<hsize_t>(ncols_)};
      hsize_t maxDim[2]   = {H5S_UNLIMITED, static_cast<hsize_t>(ncols_)};
      hsize_t chunkDim[2] = {chunkRows,     static_cast<hsize_t>(ncols_)};

      H5::DataSpace space(2, initDim, maxDim);
      H5::DSetCreatPropList prop;
      prop.setChunk(2, chunkDim);

      pimpl_->dataDs = pimpl_->file.createDataSet("data", H5::PredType::NATIVE_DOUBLE, space, prop);

      // write curve names as a variable-length string attribute
      std::vector<std::string> names;
      names.reserve(ncols_);
      for (const Curve& c : exportCurves)
        names.push_back(c.getUniqueName());

      std::vector<const char*> namePtrs;
      namePtrs.reserve(names.size());
      for (const auto& n : names)
        namePtrs.push_back(n.c_str());

      H5::StrType   strType(H5::PredType::C_S1, H5T_VARIABLE);
      hsize_t       namesDim[1] = {static_cast<hsize_t>(ncols_)};
      H5::DataSpace namesSpace(1, namesDim);
      H5::DataSet   namesDs = pimpl_->file.createDataSet("curve_names", strType, namesSpace);
      namesDs.write(namePtrs.data(), strType);
    }

    // pre-allocate buffers once so neither appendRow() nor flushPending() heap-allocates
    pimpl_->chunkRows    = chunkRows;
    pimpl_->rowBuf.assign(ncols_, 0.0);
    pimpl_->timePending.reserve(chunkRows);
    pimpl_->dataPending.reserve(chunkRows * ncols_);
    pimpl_->pendingCount = 0;

    nrows_  = 0;
    isOpen_ = true;
  } catch (const H5::Exception& /*e*/) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }
#else
  (void)filePath;
  throw DYNError(DYN::Error::MODELER, HDF5NotEnabled);
#endif
}

void
Hdf5Exporter::appendRow(double time) {
#ifdef DYNAWO_WITH_HDF5
  if (!isOpen_)
    return;

  // Collect current curve values using pre-computed flat arrays.
  // Prefetch 32 buffer pointers ahead to hide DRAM latency (~100 ns per cache miss).
  static constexpr size_t PF = 32;
  std::vector<double>& row = pimpl_->rowBuf;
  for (size_t i = 0; i < ncols_; ++i) {
    if (i + PF < ncols_ && bufPtrs_[i + PF])
      DYNAWO_PREFETCH(bufPtrs_[i + PF]);
    row[i] = bufPtrs_[i][0] * factors_[i];
  }

  // Accumulate into the pending batch — no HDF5 call until the batch is full.
  pimpl_->timePending.push_back(time);
  pimpl_->dataPending.insert(pimpl_->dataPending.end(), row.begin(), row.end());
  if (++pimpl_->pendingCount == static_cast<size_t>(pimpl_->chunkRows))
    flushPending();
#else
  (void)time;
#endif
}

void
Hdf5Exporter::flushPending() {
#ifdef DYNAWO_WITH_HDF5
  const size_t n = pimpl_->pendingCount;
  if (n == 0)
    return;

  try {
    const hsize_t hn   = static_cast<hsize_t>(n);
    const hsize_t base = static_cast<hsize_t>(nrows_);
    const hsize_t ncols = static_cast<hsize_t>(ncols_);

    // --- time: extend by n, write the n values in one call ---
    {
      hsize_t newDim[1] = {base + hn};
      pimpl_->timeDs.extend(newDim);
      H5::DataSpace filespace = pimpl_->timeDs.getSpace();
      hsize_t offset[1] = {base};
      hsize_t count[1]  = {hn};
      filespace.selectHyperslab(H5S_SELECT_SET, count, offset);
      H5::DataSpace memspace(1, count);
      pimpl_->timeDs.write(pimpl_->timePending.data(), H5::PredType::NATIVE_DOUBLE, memspace, filespace);
    }

    // --- data: extend by n rows, write the n×ncols block in one call ---
    {
      hsize_t newDim[2] = {base + hn, ncols};
      pimpl_->dataDs.extend(newDim);
      H5::DataSpace filespace = pimpl_->dataDs.getSpace();
      hsize_t offset[2] = {base, 0};
      hsize_t count[2]  = {hn, ncols};
      filespace.selectHyperslab(H5S_SELECT_SET, count, offset);
      H5::DataSpace memspace(2, count);
      pimpl_->dataDs.write(pimpl_->dataPending.data(), H5::PredType::NATIVE_DOUBLE, memspace, filespace);
    }

    nrows_ += n;
  } catch (const H5::Exception& /*e*/) {
    // do not abort: continue simulation even if a batch write fails
  }

  pimpl_->timePending.clear();
  pimpl_->dataPending.clear();
  pimpl_->pendingCount = 0;
#endif
}

void
Hdf5Exporter::close() {
#ifdef DYNAWO_WITH_HDF5
  if (!isOpen_)
    return;
  flushPending();
  try {
    pimpl_->file.flush(H5F_SCOPE_GLOBAL);
    pimpl_->file.close();
  } catch (const H5::Exception& /*e*/) {}
  isOpen_ = false;
#endif
}

}  // namespace curves
