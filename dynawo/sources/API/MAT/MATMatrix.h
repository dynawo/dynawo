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
 * @file  MATMatrix.h
 *
 * @brief Sparse matrix to export : interface file
 *
 */

#ifndef API_MAT_MATMATRIX_H_
#define API_MAT_MATMATRIX_H_

#include <vector>

namespace matrix {

/**
 * @class Matrix
 * @brief Sparse matrix in compressed format, stored by rows (CSR) or by columns (CSC)
 */
class Matrix {
 public:
  /**
   * @brief storage of the non-zero values
   */
  enum class Storage {
    BY_ROWS,  ///< compressed sparse row: one pointer per row, the indexes are column indexes
    BY_COLUMNS  ///< compressed sparse column: one pointer per column, the indexes are row indexes
  };

  /**
   * @brief constructor of an empty matrix
   */
  Matrix();

  /**
   * @brief constructor
   *
   * @param nbRows number of rows
   * @param nbColumns number of columns
   * @param storage storage of the non-zero values
   * @param pointers for each row (or column), index in indexes and values of its first non-zero value, plus the number of non-zero values
   * @param indexes column (or row) index of each non-zero value
   * @param values non-zero values
   */
  Matrix(unsigned int nbRows, unsigned int nbColumns, Storage storage, std::vector<unsigned int> pointers, std::vector<unsigned int> indexes,
         std::vector<double> values);

  /**
   * @brief number of rows getter
   * @return the number of rows
   */
  unsigned int getNbRows() const {
    return nbRows_;
  }

  /**
   * @brief number of columns getter
   * @return the number of columns
   */
  unsigned int getNbColumns() const {
    return nbColumns_;
  }

  /**
   * @brief number of non-zero values getter
   * @return the number of non-zero values
   */
  unsigned int getNbNonZeros() const {
    return static_cast<unsigned int>(values_.size());
  }

  /**
   * @brief storage getter
   * @return the storage of the non-zero values
   */
  Storage getStorage() const {
    return storage_;
  }

  /**
   * @brief pointers getter
   * @return for each row (or column), index of its first non-zero value, plus the number of non-zero values
   */
  const std::vector<unsigned int>& getPointers() const {
    return pointers_;
  }

  /**
   * @brief indexes getter
   * @return column (or row) index of each non-zero value
   */
  const std::vector<unsigned int>& getIndexes() const {
    return indexes_;
  }

  /**
   * @brief values getter
   * @return the non-zero values
   */
  const std::vector<double>& getValues() const {
    return values_;
  }

  /**
   * @brief transposed matrix
   *
   * The transposed of a matrix stored by columns is the same pointers, indexes and values stored by rows (and conversely),
   * no value is moved.
   *
   * @return the transposed matrix
   */
  Matrix transposed() const;

 private:
  unsigned int nbRows_;  ///< number of rows
  unsigned int nbColumns_;  ///< number of columns
  Storage storage_;  ///< storage of the non-zero values
  std::vector<unsigned int> pointers_;  ///< for each row (or column), index of its first non-zero value, plus the number of non-zero values
  std::vector<unsigned int> indexes_;  ///< column (or row) index of each non-zero value
  std::vector<double> values_;  ///< non-zero values
};

}  // namespace matrix

#endif  // API_MAT_MATMATRIX_H_
