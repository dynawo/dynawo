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
 * @file API/MAT/test/TestSparseMatrixConversion.cpp
 * @brief Unit tests for API_MAT conversion of the dynawo sparse matrices
 *
 */

#include "DYNSparseMatrix.h"
#include "MATSparseMatrixConversion.h"
#include "gtest_dynawo.h"

namespace matrix {

TEST(APIMATTest, SparseMatrixConversion) {
  // 3x3 matrix
  // | 0 2 0 |
  // | 1 0 4 |
  // | 0 3 0 |
  // the dynawo sparse matrix is filled column after column: changeCol() starts a new column, addTerm(row, value) adds a value in it
  DYN::SparseMatrix sparseMatrix;
  sparseMatrix.init(3, 3);
  sparseMatrix.changeCol();  // column 0
  sparseMatrix.addTerm(1, 1.);
  sparseMatrix.changeCol();  // column 1
  sparseMatrix.addTerm(0, 2.);
  sparseMatrix.addTerm(2, 3.);
  sparseMatrix.changeCol();  // column 2
  sparseMatrix.addTerm(1, 4.);

  // so the converted matrix is stored by columns: column 0 has k in [0, 1), column 1 k in [1, 3), column 2 k in [3, 4)
  const Matrix matrix = fromSparseMatrix(sparseMatrix);
  ASSERT_EQ(matrix.getNbRows(), 3u);
  ASSERT_EQ(matrix.getNbColumns(), 3u);
  ASSERT_EQ(matrix.getStorage(), Matrix::Storage::BY_COLUMNS);
  ASSERT_EQ(matrix.getPointers(), std::vector<unsigned int>({0, 1, 3, 4}));
  // the arrays of the sparse matrix are bigger (allocated by blocks): only the meaningful values are kept
  ASSERT_EQ(matrix.getIndexes(), std::vector<unsigned int>({1, 0, 2, 1}));
  ASSERT_EQ(matrix.getValues(), std::vector<double>({1., 2., 3., 4.}));
}

TEST(APIMATTest, SparseMatrixConversionNotSquare) {
  // 2x3 matrix
  // | 1 0 3 |
  // | 0 2 0 |
  DYN::SparseMatrix sparseMatrix;
  sparseMatrix.init(2, 3);
  sparseMatrix.changeCol();  // column 0
  sparseMatrix.addTerm(0, 1.);
  sparseMatrix.changeCol();  // column 1
  sparseMatrix.addTerm(1, 2.);
  sparseMatrix.changeCol();  // column 2
  sparseMatrix.addTerm(0, 3.);

  const Matrix matrix = fromSparseMatrix(sparseMatrix);
  ASSERT_EQ(matrix.getNbRows(), 2u);
  ASSERT_EQ(matrix.getNbColumns(), 3u);
  ASSERT_EQ(matrix.getPointers(), std::vector<unsigned int>({0, 1, 2, 3}));
  ASSERT_EQ(matrix.getIndexes(), std::vector<unsigned int>({0, 1, 0}));
  ASSERT_EQ(matrix.getValues(), std::vector<double>({1., 2., 3.}));
}

TEST(APIMATTest, SparseMatrixConversionEmpty) {
  const DYN::SparseMatrix sparseMatrix;
  const Matrix matrix = fromSparseMatrix(sparseMatrix);
  ASSERT_EQ(matrix.getNbRows(), 0u);
  ASSERT_EQ(matrix.getNbColumns(), 0u);
  ASSERT_EQ(matrix.getNbNonZeros(), 0u);
}

}  // namespace matrix
