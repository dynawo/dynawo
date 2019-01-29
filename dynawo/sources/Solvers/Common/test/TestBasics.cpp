//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file Solvers/Common/TestBasics.cpp
 * @brief Unit tests for Solvers Common lib
 *
 */

#include <fstream>

#include <boost/filesystem.hpp>
#include <sundials/sundials_sparse.h>

#include "gtest_dynawo.h"
#include "DYNParameterSolver.h"
#include "DYNSparseMatrix.h"
#include "DYNTrace.h"
#include "DYNSolverCommon.h"
#include "DYNFileSystemUtils.h"

namespace DYN {

TEST(SimulationCommonTest, testParameterSolver) {
  ParameterSolver psd("MyDoubleParam", DOUBLE);
  psd.setValue<double>(42.);
  ASSERT_THROW_DYNAWO(psd.setValue<bool>(true), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(psd.setValue<int>(4), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(psd.setValue<std::string>("MyString"), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_DOUBLE_EQUALS_DYNAWO(42., psd.getDoubleValue());

  ParameterSolver psb("MyBoolParam", BOOL);
  psb.setValue<bool>(true);
  ASSERT_THROW_DYNAWO(psb.setValue<double>(42.), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(psb.setValue<int>(4), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(psd.setValue<std::string>("MyString"), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_DOUBLE_EQUALS_DYNAWO(1., psb.getDoubleValue());

  ParameterSolver psi("MyIntParam", INT);
  psi.setValue<int>(4);
  ASSERT_THROW_DYNAWO(psi.setValue<double>(42.), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(psi.setValue<bool>(true), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(psd.setValue<std::string>("MyString"), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_DOUBLE_EQUALS_DYNAWO(4., psi.getDoubleValue());

  ParameterSolver pss("MyStringParam", STRING);
  pss.setValue<std::string>("MyString");
  ASSERT_THROW_DYNAWO(pss.setValue<double>(42.), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(pss.setValue<bool>(true), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(psb.setValue<int>(4), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(pss.getDoubleValue(), DYN::Error::GENERAL, DYN::KeyError_t::ParameterUnableToConvertToDouble);

  ASSERT_EQ(pss.getTypeError(), DYN::Error::GENERAL);
}

TEST(SimulationCommonTest, testSolverCommon) {
  SparseMatrix smj;
  smj.init(3, 3);
  smj.changeCol();
  smj.addTerm(1, 1.);
  smj.changeCol();
  smj.addTerm(0, 2.);
  smj.addTerm(2, 3.);
  smj.changeCol();
  smj.addTerm(1, 4.);
  smj.changeCol();
  SlsMat JJ = (SlsMat) malloc(sizeof(struct _SlsMat));
  JJ->NNZ = 2;

  int row = 0;
  int col = 0;
  smj.getRowColIndicesFromPosition(2, row, col);
  ASSERT_EQ(row, 2);
  ASSERT_EQ(col, 1);

  JJ->indexptrs = reinterpret_cast<int*> (malloc(3 * sizeof (int)));
  JJ->indexvals = reinterpret_cast<int*> (malloc(JJ->NNZ * sizeof (int)));
  JJ->data = reinterpret_cast<realtype*> (malloc(JJ->NNZ * sizeof (realtype)));
  for (unsigned i = 0; i < 3; ++i) {
    JJ->indexptrs[i] = i;
  }
  JJ->indexvals[0] = 0;
  JJ->indexvals[1] = 1;
  JJ->data[0] = 1;
  JJ->data[1] = 2;

  ASSERT_EQ(copySparseToKINSOL(smj, JJ, 3, NULL), true);
  ASSERT_EQ(JJ->NNZ, 4);
  ASSERT_EQ(JJ->indexptrs[0], 0);
  ASSERT_EQ(JJ->indexptrs[1], 1);
  ASSERT_EQ(JJ->indexptrs[2], 3);
  ASSERT_EQ(JJ->indexptrs[3], 4);

  ASSERT_EQ(JJ->indexvals[0], 1);
  ASSERT_EQ(JJ->indexvals[1], 0);
  ASSERT_EQ(JJ->indexvals[2], 2);
  ASSERT_EQ(JJ->indexvals[3], 1);

  ASSERT_EQ(JJ->data[0], 1);
  ASSERT_EQ(JJ->data[1], 2);
  ASSERT_EQ(JJ->data[2], 3);
  ASSERT_EQ(JJ->data[3], 4);
  ASSERT_EQ(JJ->NNZ, 4);
  delete[] JJ->indexptrs;
  delete[] JJ->indexvals;
  delete[] JJ->data;
  delete JJ;
}

TEST(SimulationCommonTest, testNormVectors) {
  std::vector<double> vec;
  vec.push_back(1.);
  vec.push_back(4.);
  vec.push_back(8.);
  vec.push_back(9.);
  std::vector<double> weights;
  weights.push_back(1.);
  weights.push_back(1.);
  weights.push_back(1.);
  weights.push_back(1.);
  std::vector<int> indices;
  indices.push_back(0);
  indices.push_back(1);
  indices.push_back(2);
  std::vector<double> sub_weights;
  sub_weights.push_back(1.);
  sub_weights.push_back(1.);
  sub_weights.push_back(2.);

  ASSERT_DOUBLE_EQ(weightedInfinityNorm(vec, weights), 9.);
  ASSERT_DOUBLE_EQ(weightedL2Norm(vec, weights), 12.72792206135785519905);
  ASSERT_DOUBLE_EQ(weightedInfinityNorm(vec, indices, sub_weights), 16.);
  ASSERT_DOUBLE_EQ(weightedL2Norm(vec, indices, sub_weights), 16.52271164185830443216);
}

}  // namespace DYN
