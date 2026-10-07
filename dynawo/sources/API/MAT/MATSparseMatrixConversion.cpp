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
 * @file  MATSparseMatrixConversion.cpp
 *
 * @brief Conversion of the dynawo sparse matrices into matrices to export : implementation file
 *
 */

#include "MATSparseMatrixConversion.h"

#include <vector>

#include "DYNSparseMatrix.h"

namespace matrix {

Matrix
fromSparseMatrix(const DYN::SparseMatrix& sparseMatrix) {
  const unsigned int nbColumns = sparseMatrix.nbCol();
  if (nbColumns == 0)  // the arrays of a sparse matrix without column may not be allocated
    return Matrix(sparseMatrix.nbRow(), 0, Matrix::Storage::BY_COLUMNS, {0}, {}, {});

  // the arrays of the sparse matrix are allocated by blocks, only the first values are meaningful
  const unsigned int nbNonZeros = sparseMatrix.nbElem();
  return Matrix(sparseMatrix.nbRow(), nbColumns, Matrix::Storage::BY_COLUMNS,
                std::vector<unsigned int>(sparseMatrix.Ap_.begin(), sparseMatrix.Ap_.begin() + nbColumns + 1),
                std::vector<unsigned int>(sparseMatrix.Ai_.begin(), sparseMatrix.Ai_.begin() + nbNonZeros),
                std::vector<double>(sparseMatrix.Ax_.begin(), sparseMatrix.Ax_.begin() + nbNonZeros));
}

}  // namespace matrix
