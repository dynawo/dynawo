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
 * @file API/MAT/test/TestMatrix.cpp
 * @brief Unit tests for API_MAT Matrix class
 *
 */

#include "MATMatrix.h"
#include "gtest_dynawo.h"

namespace matrix {

TEST(APIMATTest, MatrixEmpty) {
  const Matrix matrix;
  ASSERT_EQ(matrix.getNbRows(), 0u);
  ASSERT_EQ(matrix.getNbColumns(), 0u);
  ASSERT_EQ(matrix.getNbNonZeros(), 0u);
  ASSERT_EQ(matrix.getStorage(), Matrix::Storage::BY_ROWS);
  ASSERT_EQ(matrix.getPointers(), std::vector<unsigned int>({0}));
  ASSERT_TRUE(matrix.getIndexes().empty());
  ASSERT_TRUE(matrix.getValues().empty());
}

TEST(APIMATTest, Matrix) {
  // 2x3 matrix stored by columns
  // | 1 0 3 |
  // | 0 2 4 |
  // the values of column j are values[k] for k in [pointers[j], pointers[j + 1]), in row indexes[k]:
  // - column 0: k in [0, 1) -> value 1 in row 0
  // - column 1: k in [1, 2) -> value 2 in row 1
  // - column 2: k in [2, 4) -> value 3 in row 0, value 4 in row 1
  // the last pointer is the number of non-zero values
  const Matrix matrix(2, 3, Matrix::Storage::BY_COLUMNS, {0, 1, 2, 4}, {0, 1, 0, 1}, {1., 2., 3., 4.});
  ASSERT_EQ(matrix.getNbRows(), 2u);
  ASSERT_EQ(matrix.getNbColumns(), 3u);
  ASSERT_EQ(matrix.getNbNonZeros(), 4u);
  ASSERT_EQ(matrix.getStorage(), Matrix::Storage::BY_COLUMNS);
  ASSERT_EQ(matrix.getPointers(), std::vector<unsigned int>({0, 1, 2, 4}));
  ASSERT_EQ(matrix.getIndexes(), std::vector<unsigned int>({0, 1, 0, 1}));
  ASSERT_EQ(matrix.getValues(), std::vector<double>({1., 2., 3., 4.}));
}

TEST(APIMATTest, MatrixTransposed) {
  // same 2x3 matrix as in the previous test, its 3x2 transposed is
  // | 1 0 |
  // | 0 2 |
  // | 3 4 |
  // row j of the transposed is column j of the matrix: the transposed stored by rows has the same arrays as the matrix stored by columns
  const Matrix matrix(2, 3, Matrix::Storage::BY_COLUMNS, {0, 1, 2, 4}, {0, 1, 0, 1}, {1., 2., 3., 4.});
  const Matrix transposed = matrix.transposed();
  ASSERT_EQ(transposed.getNbRows(), 3u);
  ASSERT_EQ(transposed.getNbColumns(), 2u);
  ASSERT_EQ(transposed.getStorage(), Matrix::Storage::BY_ROWS);
  ASSERT_EQ(transposed.getPointers(), matrix.getPointers());
  ASSERT_EQ(transposed.getIndexes(), matrix.getIndexes());
  ASSERT_EQ(transposed.getValues(), matrix.getValues());

  const Matrix twiceTransposed = transposed.transposed();
  ASSERT_EQ(twiceTransposed.getNbRows(), 2u);
  ASSERT_EQ(twiceTransposed.getNbColumns(), 3u);
  ASSERT_EQ(twiceTransposed.getStorage(), Matrix::Storage::BY_COLUMNS);
}

}  // namespace matrix
