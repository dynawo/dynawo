// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite
// of simulation tools for power systems.

/**
 * @file API/CRV/test/TestHdf5Exporter.cpp
 * @brief Unit tests for the incremental HDF5 curves exporter
 */

#include "gtest_dynawo.h"

#include "CRVCurvesCollectionFactory.h"
#include "CRVCurvesCollection.h"
#include "CRVCurveFactory.h"
#include "CRVCurve.h"
#include "CRVHdf5Exporter.h"

#ifdef DYNAWO_WITH_HDF5
#include <H5Cpp.h>
#include <cstdio>
#endif

namespace curves {

// ---------------------------------------------------------------------------
// Test cases compiled only when HDF5 is available
// ---------------------------------------------------------------------------
#ifdef DYNAWO_WITH_HDF5

namespace {

static const char kTestFile[] = "test_hdf5exporter.h5";

static std::vector<double> h5ReadTime(const std::string& path) {
  H5::H5File f(path, H5F_ACC_RDONLY);
  H5::DataSet ds = f.openDataSet("time");
  H5::DataSpace sp = ds.getSpace();
  hsize_t dim[1];
  sp.getSimpleExtentDims(dim);
  std::vector<double> v(static_cast<size_t>(dim[0]));
  ds.read(v.data(), H5::PredType::NATIVE_DOUBLE);
  return v;
}

static std::vector<double> h5ReadData(const std::string& path, size_t& nrows, size_t& ncols) {
  H5::H5File f(path, H5F_ACC_RDONLY);
  H5::DataSet ds = f.openDataSet("data");
  H5::DataSpace sp = ds.getSpace();
  hsize_t dims[2];
  sp.getSimpleExtentDims(dims);
  nrows = static_cast<size_t>(dims[0]);
  ncols = static_cast<size_t>(dims[1]);
  std::vector<double> v(nrows * ncols);
  ds.read(v.data(), H5::PredType::NATIVE_DOUBLE);
  return v;
}

}  // namespace

TEST(APICRVTest, Hdf5ExporterBasicLifecycle) {
  std::shared_ptr<CurvesCollection> coll = CurvesCollectionFactory::newInstance("Curves");

  double buf = 0.0;
  std::shared_ptr<Curve> c = CurveFactory::newCurve();
  c->setVariable("v1");
  c->setAvailable(true);
  c->setBuffer(&buf);
  coll->add(c);

  Hdf5Exporter exp(coll);
  ASSERT_FALSE(exp.isOpen());

  ASSERT_NO_THROW(exp.open(kTestFile));
  ASSERT_TRUE(exp.isOpen());

  buf = 1.0; ASSERT_NO_THROW(exp.appendRow(0.0));
  buf = 2.0; ASSERT_NO_THROW(exp.appendRow(1.0));
  buf = 3.0; ASSERT_NO_THROW(exp.appendRow(2.0));

  ASSERT_NO_THROW(exp.close());
  ASSERT_FALSE(exp.isOpen());

  auto time = h5ReadTime(kTestFile);
  ASSERT_EQ(time.size(), 3u);
  ASSERT_DOUBLE_EQ(time[0], 0.0);
  ASSERT_DOUBLE_EQ(time[1], 1.0);
  ASSERT_DOUBLE_EQ(time[2], 2.0);

  size_t nrows, ncols;
  auto data = h5ReadData(kTestFile, nrows, ncols);
  ASSERT_EQ(nrows, 3u);
  ASSERT_EQ(ncols, 1u);
  ASSERT_DOUBLE_EQ(data[0], 1.0);
  ASSERT_DOUBLE_EQ(data[1], 2.0);
  ASSERT_DOUBLE_EQ(data[2], 3.0);

  std::remove(kTestFile);
}

TEST(APICRVTest, Hdf5ExporterFactorAndNegation) {
  std::shared_ptr<CurvesCollection> coll = CurvesCollectionFactory::newInstance("Curves");

  double buf = 4.0;
  std::shared_ptr<Curve> c = CurveFactory::newCurve();
  c->setVariable("v1");
  c->setAvailable(true);
  c->setFactor(3.0);
  c->setNegated(true);
  c->setBuffer(&buf);
  coll->add(c);

  Hdf5Exporter exp(coll);
  ASSERT_NO_THROW(exp.open(kTestFile));
  ASSERT_NO_THROW(exp.appendRow(0.0));
  ASSERT_NO_THROW(exp.close());

  size_t nrows, ncols;
  auto data = h5ReadData(kTestFile, nrows, ncols);
  ASSERT_EQ(nrows, 1u);
  ASSERT_EQ(ncols, 1u);
  ASSERT_DOUBLE_EQ(data[0], -12.0);  // 4.0 * (-3.0)

  std::remove(kTestFile);
}

TEST(APICRVTest, Hdf5ExporterParameterCurve) {
  std::shared_ptr<CurvesCollection> coll = CurvesCollectionFactory::newInstance("Curves");

  std::shared_ptr<Curve> c = CurveFactory::newCurve();
  c->setVariable("p1");
  c->setAvailable(true);
  c->setAsParameterCurve(true);
  c->setFixedValue(42.0);
  double buf = 999.0;
  c->setBuffer(&buf);
  coll->add(c);

  Hdf5Exporter exp(coll);
  ASSERT_NO_THROW(exp.open(kTestFile));
  ASSERT_NO_THROW(exp.appendRow(0.0));
  ASSERT_NO_THROW(exp.appendRow(1.0));
  ASSERT_NO_THROW(exp.close());

  size_t nrows, ncols;
  auto data = h5ReadData(kTestFile, nrows, ncols);
  ASSERT_EQ(nrows, 2u);
  ASSERT_EQ(ncols, 1u);
  ASSERT_DOUBLE_EQ(data[0], 42.0);
  ASSERT_DOUBLE_EQ(data[1], 42.0);

  std::remove(kTestFile);
}

TEST(APICRVTest, Hdf5ExporterFSVCurveExcluded) {
  std::shared_ptr<CurvesCollection> coll = CurvesCollectionFactory::newInstance("Curves");

  double buf1 = 1.0;
  std::shared_ptr<Curve> c1 = CurveFactory::newCurve();
  c1->setVariable("v1");
  c1->setAvailable(true);
  c1->setBuffer(&buf1);
  coll->add(c1);

  double buf2 = 99.0;
  std::shared_ptr<Curve> c2 = CurveFactory::newCurve();
  c2->setVariable("v2");
  c2->setAvailable(true);
  c2->setExportType(Curve::EXPORT_AS_FINAL_STATE_VALUE);
  c2->setBuffer(&buf2);
  coll->add(c2);

  Hdf5Exporter exp(coll);
  ASSERT_NO_THROW(exp.open(kTestFile));
  ASSERT_NO_THROW(exp.appendRow(0.0));
  ASSERT_NO_THROW(exp.close());

  size_t nrows, ncols;
  auto data = h5ReadData(kTestFile, nrows, ncols);
  ASSERT_EQ(nrows, 1u);
  ASSERT_EQ(ncols, 1u);  // v2 excluded
  ASSERT_DOUBLE_EQ(data[0], 1.0);

  std::remove(kTestFile);
}

TEST(APICRVTest, Hdf5ExporterMultipleCurves) {
  std::shared_ptr<CurvesCollection> coll = CurvesCollectionFactory::newInstance("Curves");

  double buf1 = 0.0;
  std::shared_ptr<Curve> c1 = CurveFactory::newCurve();
  c1->setVariable("v1");
  c1->setAvailable(true);
  c1->setBuffer(&buf1);
  coll->add(c1);

  double buf2 = 0.0;
  std::shared_ptr<Curve> c2 = CurveFactory::newCurve();
  c2->setVariable("v2");
  c2->setAvailable(true);
  c2->setFactor(2.0);
  c2->setBuffer(&buf2);
  coll->add(c2);

  Hdf5Exporter exp(coll);
  ASSERT_NO_THROW(exp.open(kTestFile));
  buf1 = 1.0; buf2 = 3.0; ASSERT_NO_THROW(exp.appendRow(0.0));
  buf1 = 2.0; buf2 = 4.0; ASSERT_NO_THROW(exp.appendRow(1.0));
  ASSERT_NO_THROW(exp.close());

  auto time = h5ReadTime(kTestFile);
  ASSERT_EQ(time.size(), 2u);
  ASSERT_DOUBLE_EQ(time[0], 0.0);
  ASSERT_DOUBLE_EQ(time[1], 1.0);

  size_t nrows, ncols;
  auto data = h5ReadData(kTestFile, nrows, ncols);
  ASSERT_EQ(nrows, 2u);
  ASSERT_EQ(ncols, 2u);
  // row 0: v1=1.0, v2=3.0*2.0=6.0
  ASSERT_DOUBLE_EQ(data[0], 1.0);
  ASSERT_DOUBLE_EQ(data[1], 6.0);
  // row 1: v1=2.0, v2=4.0*2.0=8.0
  ASSERT_DOUBLE_EQ(data[2], 2.0);
  ASSERT_DOUBLE_EQ(data[3], 8.0);

  std::remove(kTestFile);
}

TEST(APICRVTest, Hdf5ExporterUnavailableCurveExcluded) {
  std::shared_ptr<CurvesCollection> coll = CurvesCollectionFactory::newInstance("Curves");

  double buf1 = 7.0;
  std::shared_ptr<Curve> c1 = CurveFactory::newCurve();
  c1->setVariable("v1");
  c1->setAvailable(true);
  c1->setBuffer(&buf1);
  coll->add(c1);

  std::shared_ptr<Curve> c2 = CurveFactory::newCurve();
  c2->setVariable("v2");
  c2->setAvailable(false);  // not found in model — must be excluded
  coll->add(c2);

  Hdf5Exporter exp(coll);
  ASSERT_NO_THROW(exp.open(kTestFile));
  ASSERT_NO_THROW(exp.appendRow(0.0));
  ASSERT_NO_THROW(exp.close());

  size_t nrows, ncols;
  auto data = h5ReadData(kTestFile, nrows, ncols);
  ASSERT_EQ(nrows, 1u);
  ASSERT_EQ(ncols, 1u);  // v2 excluded
  ASSERT_DOUBLE_EQ(data[0], 7.0);

  std::remove(kTestFile);
}

TEST(APICRVTest, Hdf5ExporterParameterCurveNoBuffer) {
  std::shared_ptr<CurvesCollection> coll = CurvesCollectionFactory::newInstance("Curves");

  std::shared_ptr<Curve> c = CurveFactory::newCurve();
  c->setVariable("p1");
  c->setAvailable(true);
  c->setAsParameterCurve(true);
  c->setFixedValue(3.14);
  // no buffer set — real-world case for parameter curves
  coll->add(c);

  Hdf5Exporter exp(coll);
  ASSERT_NO_THROW(exp.open(kTestFile));
  ASSERT_NO_THROW(exp.appendRow(0.0));
  ASSERT_NO_THROW(exp.appendRow(1.0));
  ASSERT_NO_THROW(exp.close());

  size_t nrows, ncols;
  auto data = h5ReadData(kTestFile, nrows, ncols);
  ASSERT_EQ(nrows, 2u);
  ASSERT_EQ(ncols, 1u);
  ASSERT_DOUBLE_EQ(data[0], 3.14);
  ASSERT_DOUBLE_EQ(data[1], 3.14);

  std::remove(kTestFile);
}

TEST(APICRVTest, Hdf5ExporterDoubleCloseIsSafe) {
  std::shared_ptr<CurvesCollection> coll = CurvesCollectionFactory::newInstance("Curves");
  double buf = 0.0;
  std::shared_ptr<Curve> c = CurveFactory::newCurve();
  c->setVariable("v1");
  c->setAvailable(true);
  c->setBuffer(&buf);
  coll->add(c);

  Hdf5Exporter exp(coll);
  ASSERT_NO_THROW(exp.open(kTestFile));
  ASSERT_NO_THROW(exp.close());
  ASSERT_NO_THROW(exp.close());  // second close must be a no-op

  std::remove(kTestFile);
}

TEST(APICRVTest, Hdf5ExporterAppendRowBeforeOpenIsNoop) {
  std::shared_ptr<CurvesCollection> coll = CurvesCollectionFactory::newInstance("Curves");
  Hdf5Exporter exp(coll);
  ASSERT_NO_THROW(exp.appendRow(0.0));
  ASSERT_FALSE(exp.isOpen());
}

TEST(APICRVTest, Hdf5ExporterDestructorAutoCloses) {
  std::shared_ptr<CurvesCollection> coll = CurvesCollectionFactory::newInstance("Curves");
  double buf = 5.0;
  std::shared_ptr<Curve> c = CurveFactory::newCurve();
  c->setVariable("v1");
  c->setAvailable(true);
  c->setBuffer(&buf);
  coll->add(c);

  {
    Hdf5Exporter exp(coll);
    ASSERT_NO_THROW(exp.open(kTestFile));
    ASSERT_NO_THROW(exp.appendRow(0.0));
    // destructor flushes and closes here
  }

  size_t nrows, ncols;
  auto data = h5ReadData(kTestFile, nrows, ncols);
  ASSERT_EQ(nrows, 1u);
  ASSERT_EQ(ncols, 1u);
  ASSERT_DOUBLE_EQ(data[0], 5.0);

  std::remove(kTestFile);
}

// ---------------------------------------------------------------------------
// Test cases compiled only when HDF5 is NOT available
// ---------------------------------------------------------------------------
#else  // DYNAWO_WITH_NO_HDF5

TEST(APICRVTest, Hdf5ExporterOpenThrowsWhenNoHdf5) {
  std::shared_ptr<CurvesCollection> coll = CurvesCollectionFactory::newInstance("Curves");
  Hdf5Exporter exp(coll);
  ASSERT_FALSE(exp.isOpen());
  ASSERT_THROW_DYNAWO(exp.open("ignored.h5"), DYN::Error::MODELER, DYN::KeyError_t::HDF5NotEnabled);
  ASSERT_FALSE(exp.isOpen());
}

TEST(APICRVTest, Hdf5ExporterNoOpsWhenNoHdf5) {
  std::shared_ptr<CurvesCollection> coll = CurvesCollectionFactory::newInstance("Curves");
  Hdf5Exporter exp(coll);
  ASSERT_NO_THROW(exp.appendRow(0.0));
  ASSERT_NO_THROW(exp.close());
  ASSERT_FALSE(exp.isOpen());
}

#endif  // DYNAWO_WITH_HDF5

}  // namespace curves
