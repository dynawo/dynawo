//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  CRVHdf5Exporter.h
 *
 * @brief Dynawo curves collection HDF5 exporter
 */
#ifndef API_CRV_CRVHDF5EXPORTER_H_
#define API_CRV_CRVHDF5EXPORTER_H_

#include "CRVCurvesCollection.h"
#include "CRVExporter.h"

#include <memory>
#include <ostream>
#include <string>
#include <vector>

namespace curves {

/**
 * @brief Private implementation structure (forward declaration).
 * Defined in CRVHdf5Exporter.cpp, conditionally contains H5:: members.
 */
struct Hdf5ExporterPrivate;

/**
 * @class Hdf5Exporter
 * @brief Incremental HDF5 exporter for curves collections.
 *
 * Layout of the output file (when HDF5 support is compiled in):
 *   /time          — 1-D unlimited dataset (nsteps,)             NATIVE_DOUBLE
 *   /data          — 2-D unlimited dataset (nsteps, ncurves)     NATIVE_DOUBLE
 *                    attribute "curve_names": variable-length string array
 *
 * Chunk size is CHUNK_ROWS rows so HDF5 buffers writes internally and
 * flushes to disk in large batches, keeping per-step overhead negligible.
 */
class Hdf5Exporter : public Exporter {
 public:
  /**
   * @brief Constructor
   * @param curves  curves collection whose time-series curves will be exported
   */
  explicit Hdf5Exporter(const std::shared_ptr<CurvesCollection>& curves);

  /**
   * @brief Destructor — flushes and closes the HDF5 file if still open
   */
  virtual ~Hdf5Exporter() override;

  /**
   * @brief Open (create) the HDF5 file and build the datasets.
   *
   * Must be called after all curve buffers have been wired (i.e. after
   * model_->initCurves() has run for every curve). Curves marked
   * EXPORT_AS_FINAL_STATE_VALUE are excluded from the HDF5 output.
   *
   * @param filePath  path of the .h5 file to create (truncates if exists)
   */
  void open(const std::string& filePath) override;

  /**
   * @brief Append one row (one time step) to the datasets.
   * @param time  current simulation time
   */
  void appendRow(double time) override;

  /**
   * @brief Flush pending writes and close the HDF5 file.
   */
  void close() override;

#ifdef DYNAWO_WITH_HDF5
  /**
   * @brief Whether the file is open and ready to receive rows.
   * @return @b true if the file is open, @b false else
   */
  bool isOpen() const { return isOpen_; }
#else
  /**
   * @brief Whether the file is open and ready to receive rows.
   * @return @b true if the file is open, @b false else
   */
  bool isOpen() const { return false; }
#endif

  /**
   * @brief Not supported for incremental HDF5 export — use open()/appendRow()/close() instead.
   */
  void exportToFile(const std::shared_ptr<CurvesCollection>& /*curves*/, const std::string& /*filePath*/) const override {}

  /**
   * @brief Not supported — HDF5 cannot be written to an arbitrary stream.
   */
  void exportToStream(const std::shared_ptr<CurvesCollection>& /*curves*/, std::ostream& /*stream*/) const override {}

 private:
  /**
   * @brief Write the current pending batch to the HDF5 datasets and reset the buffers.
   */
  void flushPending();

#ifdef DYNAWO_WITH_HDF5
  const std::shared_ptr<CurvesCollection>& curveCollection_;  ///< curves collection passed at construction
  std::unique_ptr<Hdf5ExporterPrivate> pimpl_;                ///< HDF5 objects (pimpl to keep H5Cpp.h out of this header)
  std::vector<const double*>           bufPtrs_;              ///< direct pointer to buffer[0] per exported curve
  std::vector<double>                  factors_;              ///< pre-negated scale factor per exported curve
  std::vector<double>                  fixedValues_;          ///< stable storage for unavailable/parameter curve values
  size_t nrows_;                                              ///< number of rows written so far
  size_t ncols_;                                              ///< number of exported curves (columns in /data)
  bool   isOpen_;                                             ///< @b true if the HDF5 file is open
#endif
};

}  // namespace curves

#endif  // API_CRV_CRVHDF5EXPORTER_H_
