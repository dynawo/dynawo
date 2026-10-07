//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file API/MAT/test/TestLinearizedSystem.cpp
 * @brief Unit tests for API_MAT LinearizedSystem class
 *
 */

#include "DYNCommon.h"
#include "MATLinearizedSystem.h"
#include "gtest_dynawo.h"

using DYN::doubleEquals;

namespace matrix {

TEST(APIMATTest, LinearizedSystem) {
  LinearizedSystem linearizedSystem(5.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(linearizedSystem.getTime(), 5.);
  ASSERT_EQ(linearizedSystem.getJacobian().getNbNonZeros(), 0u);
  ASSERT_EQ(linearizedSystem.getJacobianPrim().getNbNonZeros(), 0u);
  ASSERT_TRUE(linearizedSystem.getVariables().empty());
  ASSERT_TRUE(linearizedSystem.getEquations().empty());

  // 1x2 jacobian | 1 2 |: row 0 has the values k in [0, 2), 1 in column 0 and 2 in column 1
  linearizedSystem.setJacobian(Matrix(1, 2, Matrix::Storage::BY_ROWS, {0, 2}, {0, 1}, {1., 2.}));
  // 1x2 prim jacobian | 3 0 |: row 0 has the value k in [0, 1), 3 in column 0
  linearizedSystem.setJacobianPrim(Matrix(1, 2, Matrix::Storage::BY_ROWS, {0, 1}, {0}, {3.}));
  linearizedSystem.addVariable("x", "model1", "DIFFERENTIAL");
  linearizedSystem.addVariable("y", "model2", "ALGEBRAIC");
  linearizedSystem.addEquation("DIFFERENTIAL");

  ASSERT_EQ(linearizedSystem.getJacobian().getValues(), std::vector<double>({1., 2.}));
  ASSERT_EQ(linearizedSystem.getJacobianPrim().getValues(), std::vector<double>({3.}));
  ASSERT_EQ(linearizedSystem.getVariables().size(), 2u);
  ASSERT_EQ(linearizedSystem.getVariables()[1].name, "y");
  ASSERT_EQ(linearizedSystem.getVariables()[1].modelName, "model2");
  ASSERT_EQ(linearizedSystem.getVariables()[1].type, "ALGEBRAIC");
  ASSERT_EQ(linearizedSystem.getEquations().size(), 1u);
  ASSERT_EQ(linearizedSystem.getEquations()[0].type, "DIFFERENTIAL");
}

}  // namespace matrix
