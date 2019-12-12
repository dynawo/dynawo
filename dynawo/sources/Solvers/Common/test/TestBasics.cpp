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
#include <sunmatrix/sunmatrix_sparse.h>

#include "gtest_dynawo.h"
#include "DYNParameterSolver.h"
#include "DYNSparseMatrix.h"
#include "DYNTrace.h"
#include "DYNSolverCommon.h"
#include "DYNFileSystemUtils.h"

namespace DYN {

TEST(SimulationCommonTest, testParameterSolver) {
  ParameterSolver psd("MyDoubleParam", VAR_TYPE_DOUBLE);
  ASSERT_NO_THROW(psd.setValue<double>(42.));
  ASSERT_THROW_DYNAWO(psd.setValue<bool>(true), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(psd.setValue<int>(4), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(psd.setValue<std::string>("MyString"), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_DOUBLE_EQUALS_DYNAWO(42., psd.getDoubleValue());

  ParameterSolver psb("MyBoolParam", VAR_TYPE_BOOL);
  ASSERT_NO_THROW(psb.setValue<bool>(true));
  ASSERT_THROW_DYNAWO(psb.setValue<double>(42.), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(psb.setValue<int>(4), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(psd.setValue<std::string>("MyString"), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_DOUBLE_EQUALS_DYNAWO(1., psb.getDoubleValue());

  ParameterSolver psi("MyIntParam", VAR_TYPE_INT);
  ASSERT_NO_THROW(psi.setValue<int>(4));
  ASSERT_THROW_DYNAWO(psi.setValue<double>(42.), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(psi.setValue<bool>(true), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(psd.setValue<std::string>("MyString"), DYN::Error::MODELER, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_DOUBLE_EQUALS_DYNAWO(4., psi.getDoubleValue());

  ParameterSolver pss("MyStringParam", VAR_TYPE_STRING);
  ASSERT_NO_THROW(pss.setValue<std::string>("MyString"));
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
  SUNMatrix JJ = SUNSparseMatrix(3, 3, 2, CSC_MAT);
  assert(JJ != NULL);

  int row = 0;
  int col = 0;
  smj.getRowColIndicesFromPosition(2, row, col);
  ASSERT_EQ(row, 2);
  ASSERT_EQ(col, 1);

  SM_INDEXPTRS_S(JJ) = reinterpret_cast<sunindextype*> (malloc(3 * sizeof (sunindextype)));
  SM_INDEXVALS_S(JJ) = reinterpret_cast<sunindextype*> (malloc(SM_NNZ_S(JJ) * sizeof (sunindextype)));
  SM_DATA_S(JJ) = reinterpret_cast<realtype*> (malloc(SM_NNZ_S(JJ) * sizeof (realtype)));
  for (unsigned i = 0; i < 3; ++i) {
    SM_INDEXPTRS_S(JJ)[i] = i;
  }
  SM_INDEXVALS_S(JJ)[0] = 0;
  SM_INDEXVALS_S(JJ)[1] = 1;
  SM_DATA_S(JJ)[0] = 1;
  SM_DATA_S(JJ)[1] = 2;

  ASSERT_EQ(SolverCommon::copySparseToKINSOL(smj, JJ, 3, NULL), true);
  ASSERT_EQ(SM_NNZ_S(JJ), 4);
  ASSERT_EQ(SM_INDEXPTRS_S(JJ)[0], 0);
  ASSERT_EQ(SM_INDEXPTRS_S(JJ)[1], 1);
  ASSERT_EQ(SM_INDEXPTRS_S(JJ)[2], 3);
  ASSERT_EQ(SM_INDEXPTRS_S(JJ)[3], 4);

  ASSERT_EQ(SM_INDEXVALS_S(JJ)[0], 1);
  ASSERT_EQ(SM_INDEXVALS_S(JJ)[1], 0);
  ASSERT_EQ(SM_INDEXVALS_S(JJ)[2], 2);
  ASSERT_EQ(SM_INDEXVALS_S(JJ)[3], 1);

  ASSERT_EQ(SM_DATA_S(JJ)[0], 1);
  ASSERT_EQ(SM_DATA_S(JJ)[1], 2);
  ASSERT_EQ(SM_DATA_S(JJ)[2], 3);
  ASSERT_EQ(SM_DATA_S(JJ)[3], 4);
  ASSERT_EQ(SM_NNZ_S(JJ), 4);
  SUNMatDestroy_Sparse(JJ);
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

  ASSERT_DOUBLE_EQ(SolverCommon::weightedInfinityNorm(vec, weights), 9.);
  ASSERT_DOUBLE_EQ(SolverCommon::weightedL2Norm(vec, weights), 12.72792206135785519905);
  ASSERT_DOUBLE_EQ(SolverCommon::weightedInfinityNorm(vec, indices, sub_weights), 16.);
  ASSERT_DOUBLE_EQ(SolverCommon::weightedL2Norm(vec, indices, sub_weights), 16.52271164185830443216);
}

}  // namespace DYN
