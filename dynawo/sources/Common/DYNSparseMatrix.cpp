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
 * @file  DYNSparseMatrix.cpp
 *
 * @brief  Sparse Matrix class implementation
 *
 */
#include <map>
#include <set>
#include <sstream>
#include <iomanip>
#include <vector>
#include <iostream>
#include <fstream>
#include <cassert>
#include <cmath>

#include "DYNCommon.h"
#include "DYNMacrosMessage.h"
#include "DYNFileSystemUtils.h"
#include "DYNSparseMatrix.h"
#include "DYNTrace.h"
#include "DYNFileSystemUtils.h"

using std::map;
using std::set;
using std::vector;
using std::stringstream;

namespace DYN {

/// @brief Namespace for local helper elements
namespace helper {

/**
 * @brief Sparse matrix helper implementation
 *
 * For debug purpose (check of matrix validity), it is relevant to use another implementation of the SparseMatrix, more user-friendly
 */
class SparseMatrix {
 private:
  /**
   * @brief Representation of a non nul term
   */
  struct Term {
    Term(unsigned int i, unsigned int j, double val) : iRow(i), jCol(j), value(val) {}

    unsigned int iRow;  ///< row index of the term
    unsigned int jCol;  ///< column index of the term
    double value;       ///< Value of the terme
  };

  /**
   * @brief Structure containing the equality operator used in set for terms
   */
  struct TermEqual {
    /**
     * @brief Equality comparator for Terms
     *
     * 2 terms are equal if their location in the matrix (i,j) is the same
     *
     * @param lhs left term
     * @param rhs right term
     * @returns equality in set comparaison
     */
    bool operator()(const SparseMatrix::Term& lhs, const SparseMatrix::Term& rhs) const {
      return (lhs.iRow == rhs.iRow) && (lhs.jCol == rhs.jCol);
    }
  };

  /**
   * @brief Hash structure for term
   *
   * required to use set on terms
   */
  struct HashTerm {
    /**
     * @brief Hash function
     *
     * no need to use the value as 2 terms with same (i,j) are equal
     *
     * @param t the term to hash
     * @returns the hash value of @p t
     */
    std::size_t operator()(const Term& t) const {
      std::size_t seed = 0;
      boost::hash_combine(seed, t.iRow);
      boost::hash_combine(seed, t.jCol);
      return seed;
    }
  };

 public:
  /**
   * @brief Constructor
   *
   * @param nbRows number of rows of the sparse matrix
   * @param nbCols number of cols of the sparse matrix
   */
  SparseMatrix(unsigned int nbRows, unsigned int nbCols) : nbRows_(nbRows), nbCols_(nbCols) {}

  /**
   * @brief Add a term
   *
   * @param iRow row index of the new term
   * @param jCol column index of the new term
   * @returns whether the element has been added
   */
  bool add(unsigned int iRow, unsigned int jCol, double value) {
    return elems_.insert(Term(iRow, jCol, value)).second;
  }

  /**
   * @brief Retrieves the number of rows
   *
   * @returns number of rows
   */
  unsigned int nbRows() const {
    return nbRows_;
  }

  /**
   * @brief Retrieves the number of columns
   *
   * @returns the number of columns
   */
  unsigned int nbCols() const {
    return nbCols_;
  }

  /**
   * @brief Retrieves a value at a location
   *
   * Will return 0 if the location is outside the matrix
   *
   * @param iRow the row index of the value
   * @param jCol the column index of the value
   * @returns the value at the location (iRow, jCol)
   */
  double value(unsigned int iRow, unsigned int jCol) const {
    boost::unordered_set<Term, HashTerm, TermEqual>::const_iterator it = elems_.find(Term(iRow, jCol, 0.0));
    return (it != elems_.end()) ? it->value : 0.0;
  }

 private:
  const unsigned int nbRows_;                              ///< Number of rows
  const unsigned int nbCols_;                              ///< number of columns
  boost::unordered_set<Term, HashTerm, TermEqual> elems_;  ///< set of terms
};

}  // namespace helper

const int MATRIX_BLOCK_LENGTH = 1024;  ///< Number of block reallocated when maximum number of variables allocated is reached

SparseMatrix::SparseMatrix() :
withoutNan_(true),
withoutInf_(true),
nbRow_(0),
nbCol_(0),
iAp_(0),
iAi_(0),
iAx_(0),
nbTerm_(0),
currentMaxTerm_(0) { }

SparseMatrix::~SparseMatrix() {
  free();
}

void
SparseMatrix::changeCol() {
  ++iAp_;
  assert(iAp_ < nbCol_ + 1);
  Ap_[iAp_] = Ap_[iAp_ - 1];
}

void
SparseMatrix::addTerm(const int& row, const double& val) {
  if (!doubleIsZero(val)) {
    assert(row < nbRow_);
    // To deal with exploding matrix sizes
    if (nbTerm_ >= currentMaxTerm_) increaseReserve();
    ++Ap_[iAp_];
    Ai_[iAi_] = row;
    Ax_[iAx_] = val;
    ++iAi_;
    ++iAx_;
    ++nbTerm_;
    if (std::isnan(val)) {   // right way to check is the value is a NaN value
      withoutNan_ = false;
    }

    if (std::isinf(val)) {  // if val is INFINITY
      withoutInf_ = false;
    }
  }
}

void
SparseMatrix::init(const int& nbRow, const int& nbCol) {
  free();

  if (nbRow == 0) return;
  nbRow_ = nbRow;
  nbCol_ = nbCol;
  currentMaxTerm_ = MATRIX_BLOCK_LENGTH;
  Ap_.resize(nbCol_ + 1);
  Ap_[0] = 0;
  // Allocation based on the Jacobian maximum size
  Ai_.resize(currentMaxTerm_);
  Ax_.resize(currentMaxTerm_);

  iAp_ = 0;
  iAi_ = 0;
  iAx_ = 0;
  nbTerm_ = 0;

  withoutNan_ = true;
  withoutInf_ = true;
}

void
SparseMatrix::reserve(const int& nbCol) {
  free();

  if (nbCol == 0) return;
  nbRow_ = 0;
  nbCol_ = 0;
  currentMaxTerm_ = MATRIX_BLOCK_LENGTH;

  Ap_.resize(nbCol + 1);
  Ap_[0] = 0;
  // Allocation based on the Jacobian maximum size
  Ai_.resize(currentMaxTerm_);
  Ax_.resize(currentMaxTerm_);

  iAp_ = 0;
  iAi_ = 0;
  iAx_ = 0;
  nbTerm_ = 0;
}

void
SparseMatrix::increaseReserve() {
  currentMaxTerm_ += MATRIX_BLOCK_LENGTH;
  Ai_.resize(currentMaxTerm_);
  Ax_.resize(currentMaxTerm_);
}

void
SparseMatrix::free() {
  nbRow_ = 0;
  nbCol_ = 0;
  Ap_.clear();
  Ai_.clear();
  Ax_.clear();

  iAp_ = 0;
  iAi_ = 0;
  iAx_ = 0;
  nbTerm_ = 0;
  currentMaxTerm_ = 0;
}

void SparseMatrix::printToFile(bool sparse) const {
  static std::string base = "tmpMat/mat-";
  static int nbPrint = 0;
  stringstream nomFichier;
  nomFichier << base << nbPrint << ".txt";

  if (!exists("tmpMat")) {
    create_directory("tmpMat");
    }

  std::ofstream file;
  file.open(nomFichier.str().c_str(), std::ofstream::out);

  if (!sparse) {
    std::vector< std::vector<double> > matrix;
    for (int i = 0; i < nbCol_; ++i) {
      std::vector<double> row(nbCol_, 0);
      matrix.push_back(row);
    }

    for (int iCol = 0; iCol < nbCol_; ++iCol) {
      for (unsigned ind = Ap_[iCol]; ind < Ap_[iCol + 1]; ++ind) {
        int iRow = Ai_[ind];
        double val = Ax_[ind];
        matrix[iRow][iCol] = val;
      }
    }

    for (unsigned int i = 0; i < matrix.size(); ++i) {
      std::vector<double> row = matrix[i];
      for (unsigned int j = 0; j < row.size(); ++j) {
        stringstream val;
        val << std::setprecision(5) << row[j];
        file << val.str() << ";";
      }
      file << "\n";
    }
  } else {
    for (int iCol = 0; iCol < nbCol_; ++iCol) {
      for (unsigned ind = Ap_[iCol]; ind < Ap_[iCol + 1]; ++ind) {
        int iRow = Ai_[ind];
        stringstream val;
        val << std::setprecision(16) << Ax_[ind];
        file << iRow << ";" << iCol << ";" << val.str() << "\n";
      }
    }
  }

  ++nbPrint;
  file.close();
}

void SparseMatrix::print() const {
  for (int iCol = 0; iCol < nbCol_; ++iCol) {
    for (unsigned ind = Ap_[iCol]; ind < Ap_[iCol + 1]; ++ind) {
      int iRow = Ai_[ind];
      Trace::debug() << "A(" << iRow << ";" << iCol << ")" << std::setprecision(16) << Ax_[ind] << Trace::endline;
    }
  }
}

void
SparseMatrix::erase(const boost::unordered_set<int>& rows, const boost::unordered_set<int>& columns, SparseMatrix& M) {
  // Modifying the rows and columns numbers in the matrixes
  // However, the size allocated by KINSOL isn't modified
  M.nbRow_ = nbRow_ - rows.size();
  M.nbCol_ = nbCol_ - columns.size();

  // Map between the row numbers in the existing matrix and the rows that must be kept
  map<int, int> correspondance;
  int num = 0;
  for (int i = 0; i < nbRow_; ++i) {
    boost::unordered_set<int>::const_iterator itL = rows.find(i);
    if (itL != rows.end()) {
      correspondance[i] = -1;  // Won't serve later on
    } else {
      correspondance[i] = num;
      ++num;
    }
  }

  // Values from rows and columns given in inputs aren't copied
  // All the others are.
  M.iAp_ = 0;
  M.iAi_ = 0;
  M.iAx_ = 0;
  boost::unordered_set<int>::const_iterator itC = columns.end();
  boost::unordered_set<int>::const_iterator itL = rows.end();
  for (int iCol = 0; iCol < nbCol_; ++iCol) {
    itC = columns.find(iCol);
    if (itC == columns.end()) {
      M.changeCol();
      for (unsigned ind = Ap_[iCol]; ind < Ap_[iCol + 1]; ++ind) {
        int iRow = Ai_[ind];
        itL = rows.find(iRow);

        if (itL == rows.end()) {
          // New line number
          int rowNum = correspondance[iRow];
          // Copy of the value
          M.addTerm(rowNum, Ax_[ind]);
        }
      }
    }
  }
  return;
}

double SparseMatrix::frobeniusNorm() const {
  double squared_froNorm = 0.;
  for (int i = 0; i < nbTerm_; ++i) {
    squared_froNorm += Ax_[i] * Ax_[i];
  }
  return std::sqrt(squared_froNorm);
}

double SparseMatrix::norm1() const {
  double norm1 = 0.;
  double colSum = 0.;
  for (int iCol = 0; iCol < nbCol_; ++iCol) {
    colSum = 0.;
    for (unsigned ind = Ap_[iCol]; ind < Ap_[iCol + 1]; ++ind) {
      colSum += std::fabs(Ax_[ind]);
    }
    if (colSum > norm1) {
      norm1 = colSum;
    }
  }
  return norm1;
}

double SparseMatrix::infinityNorm() const {
  double infNorm = 0.;
  double rowSum = 0.;
  for (int row = 0 ; row < nbRow_ ; ++row) {
    rowSum = 0.;
    for (int ind = 0; ind < nbTerm_ ; ++ind) {
      if (Ai_[ind] == static_cast<unsigned>(row)) {
        rowSum += std::fabs(Ax_[ind]);
      }
    }
    if (rowSum > infNorm) {
      infNorm = rowSum;
    }
  }
  return infNorm;
}

void SparseMatrix::getRowColIndicesFromPosition(unsigned int position, int& iRow, int& jCol) const {
  assert(position < static_cast<unsigned int>(nbTerm_) && "Position must be lower than number of terms");
  std::vector<unsigned>::const_iterator lower = std::upper_bound(Ap_.begin(), Ap_.end(), position);
  iRow = Ai_[position];
  jCol = (lower-Ap_.begin()) - 1;
}

SparseMatrix::CheckError
SparseMatrix::check() const {
  // check all lines are not zeros
  for (unsigned int i = 0; i < static_cast<unsigned int>(nbRow_); i++) {
    if (std::find(Ai_.begin(), Ai_.end(), i) == Ai_.end()) {
      return CheckError(CHECK_ZERO_ROW, i);
    }
  }

  // check all columns are not zeros
  for (int j = 0; j < nbCol_; j++) {
    if (Ap_[j] == Ap_[j + 1]) {
      return CheckError(CHECK_ZERO_COLUMN, static_cast<unsigned int>(j));
    }
  }

  // build user-friendly sparse matrix
  helper::SparseMatrix matrix(nbRow_, nbCol_);
  for (unsigned int i = 0; i < static_cast<unsigned int>(nbTerm_); i++) {
    int iRow;
    int jCol;
    getRowColIndicesFromPosition(i, iRow, jCol);
    matrix.add(iRow, jCol, Ax_[i]);
  }

  // check that there are not 2 equal lines
  for (unsigned int i = 0; i < static_cast<unsigned int>(nbRow_); i++) {
    for (unsigned int ii = i + 1; ii < static_cast<unsigned int>(nbRow_); ii++) {
      bool is_same = true;
      for (unsigned int j = 0; j < static_cast<unsigned int>(nbCol_); j++) {
        if (DYN::doubleNotEquals(matrix.value(i, j), matrix.value(ii, j))) {
          is_same = false;
          break;
        }
      }

      if (is_same) {
        return CheckError(CHECK_TWO_EQUAL_LINES, i, ii);
      }
    }
  }

  // check that there are not 2 equal columns
  for (unsigned int j = 0; j < static_cast<unsigned int>(nbCol_); j++) {
    for (unsigned int jj = j + 1; jj < static_cast<unsigned int>(nbCol_); jj++) {
      bool is_same = true;
      for (unsigned int i = 0; i < static_cast<unsigned int>(nbRow_); i++) {
        if (DYN::doubleNotEquals(matrix.value(i, j), matrix.value(i, jj))) {
          is_same = false;
          break;
        }
      }

      if (is_same) {
        return CheckError(CHECK_TWO_EQUAL_COLUMNS, j, jj);
      }
    }
  }


  return CheckError();
}

}  // end of namespace DYN
