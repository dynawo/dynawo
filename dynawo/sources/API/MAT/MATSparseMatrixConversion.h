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
 * @file  MATSparseMatrixConversion.h
 *
 * @brief Conversion of the dynawo sparse matrices into matrices to export : interface file
 *
 */

#ifndef API_MAT_MATSPARSEMATRIXCONVERSION_H_
#define API_MAT_MATSPARSEMATRIXCONVERSION_H_

#include "MATMatrix.h"

namespace DYN {
class SparseMatrix;
}  // namespace DYN

namespace matrix {

/**
 * @brief convert a dynawo sparse matrix into a matrix to export
 *
 * The dynawo sparse matrix is stored by columns: so is the converted matrix.
 * The sparse matrix must be complete, i.e. all its columns must have been filled.
 *
 * @param sparseMatrix sparse matrix to convert
 * @return the matrix to export, with the same values as the sparse matrix
 */
Matrix fromSparseMatrix(const DYN::SparseMatrix& sparseMatrix);

}  // namespace matrix

#endif  // API_MAT_MATSPARSEMATRIXCONVERSION_H_
