//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNSparseMatrix.h
 *
 * @brief Sparse Matrix class header
 *
 */
#ifndef COMMON_DYNSPARSEMATRIX_H_
#define COMMON_DYNSPARSEMATRIX_H_

#include <vector>
#include <boost/shared_ptr.hpp>
#include <unordered_set>

namespace DYN {
class Model;

/**
 * @class SparseMatrix
 * @brief class Sparse Matrix : store Jacobian value in sparse structure
 * before copying value in KINSOL structure
 */
class SparseMatrix {
 public:
  /**
   * @brief type of the matrix
   */
  typedef enum {
    J = 1,  ///< "normal" matrix is stored
    Jt = -1  ///< transpose matrix is stored
  } SparseMatrixType;

  /**
   * @brief Error code for checking matrix
   */
  typedef enum {
    CHECK_OK = 0,            ///< no error
    CHECK_ZERO_ROW,          ///< at least one row is full of 0
    CHECK_ZERO_COLUMN        ///< at least one column is full of 0
  } CheckErrorCode;

  /**
   * @brief Check error representation
   */
  struct CheckError {
    /**
     * @brief Constructor
     *
     * @param err error code
     * @param index index for error info
     */
    explicit CheckError(CheckErrorCode err = CHECK_OK, unsigned int index = 0) : code(err), info(index) {}

    CheckErrorCode code;    ///< error code
    unsigned int info;      ///<  relevant if not CHECK_OK: line / column index
  };


 public:
  /**
   * @brief default constructor
   */
  SparseMatrix();

  /**
   * @brief destructor
   */
  ~SparseMatrix();

  /**
   * @brief initialize the sparse matrix object
   *
   * @param nbRow number row of the matrix
   * @param nbCol number columns of the matrix
   */
  void init(const int nbRow, const int nbCol);

  /**
   * @brief reserve structure memory
   *
   * @param nbCol number columns that will be use in the matrix
   */
  void reserve(const int nbCol);

  /**
   * @brief change the column currently used when filling the matrix
   *
   */
  void changeCol();

  /**
   * @brief add a new term in the matrix
   *
   * @param row row of the term in the matrix
   * @param val new value to add in the matrix
   */
  void addTerm(const int row, const double val);

  /**
   * @brief print the Frobenius norm of the matrix
   *
   * @return value of the Frobenius norm of the matrix
   */
  double frobeniusNorm() const;

  /**
   * @brief print the 1-norm of the matrix
   *
   * @return value of the 1-norm of the matrix
   */
  double norm1() const;

  /**
   * @brief print the infinity-norm of the matrix
   *
   * This norm is much more costly than the two others so choose the other ones for big matrices.
   *
   * @return value of the infinity-norm of the matrix
   */
  double infinityNorm() const;

   /**
   * @brief print all the values stored in the matrix
   *
   */
  void print() const;

  /**
   * @brief print all the values stored in the matrix in a file
   *
   * @param sparse @b true if the matrix should be printed with a sparse pattern
   */
  void printToFile(bool sparse = false) const;

  /**
   * @brief erase some rows and columns in the matrix and returns a new matrix
   *
   * @param rows rows to erase
   * @param columns columns to erase
   * @param M new matrix allocated
   */
  void erase(const std::unordered_set<int>& rows, const std::unordered_set<int>& columns, SparseMatrix& M) const;

  /**
   * @brief Get the row and colum indices from a position in the data array
   *
   * This function is intended to be used in debug mode but can be called in release mode but will allocate a lot of memory
   * and will slow down the computation as it is not optimized at all
   *
   * @param position index in data array (0 to nnz)
   * @param iRow row index of the data in the matrix
   * @param jCol column index of the data in the matrix
   */
  void getRowColIndicesFromPosition(unsigned int position, int& iRow, int& jCol) const;

  /**
   * @brief getter to see if the matrix is without NAN value
   *
   * @return @b true if there isn't any NAN value in the matrix
   */
  inline bool withoutNan() const {
    return withoutNan_;
  }

  /**
   * @brief getter to see if the matrix is without infinite value
   *
   * @return @b true if there isn't any infinite value in the matrix
   */
  inline bool withoutInf() const {
    return withoutInf_;
  }

  /**
   * @brief getter of the number of elements stored in the matrix
   * @return number of elements stored in the matrix
   */
  inline int nbElem() const {
    return (nbCol_ == 0 ? 0 : Ap_[nbCol_]);
  }

  /**
   * @brief getter of the number of columns of the matrix
   * @return number of columns of the matrix
   */
  inline int nbCol() const {
    return nbCol_;
  }

  /**
   * @brief Check matrix validity
   *
   * This checks that:
   * - no null row is present
   * - no null column is present
   * - 2 lines are not equal
   * - 2 columns are not equal
   * The test to fail will trigger an error
   *
   * @returns check error status
   */
  CheckError check() const;

 private:
  /**
   * @brief delete all allocated memory of the matrix
   */
  void free();

  /**
   * @brief increase the memory allocated to store values
   */
  void increaseReserve();

  /**
   * @brief equality operator
   *
   * @param M matrix to copy
   *
   * @return a new matrix
   * @warning should not be used
   */
  SparseMatrix& operator=(const SparseMatrix& M);

  /**
   * @brief constructor by copy
   *
   * @param M matrix to copy
   * @warning should not be used
   */
  SparseMatrix(const SparseMatrix & M);

 public:
  std::vector<unsigned> Ap_;  ///< for each column, first non-null element index in Ai and Ax
  std::vector<unsigned> Ai_;  ///< row index for each non-null element
  std::vector<double> Ax_;  ///< non-null element value;

 private:
  bool withoutNan_;  ///< @b true if there isn't any NaN value in the Sparse Matrix
  bool withoutInf_;  ///< @b true if there isn't any infinite value in the Sparse Matrix
  // @b index begins with the zero value (0<=i<nbRow_, 0<=j<nbCol_)
  int nbRow_;  ///< number of row in the sparse Matrix structure
  int nbCol_;  ///< number of column in the sparse Matrix structure

  int iAp_;  ///< current index in the Ap_ array
  int iAi_;  ///< current index in the Ai_ array
  int iAx_;  ///< current index in the Ax_ array
  int nbTerm_;  ///< current number of values stored in the matrix
  int currentMaxTerm_;  ///< current maximum number of term that could be stored in the matrix without increasing the size of arrays
};

}  // end of namespace DYN

#endif  // COMMON_DYNSPARSEMATRIX_H_
