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

#include <boost/filesystem.hpp>

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

namespace fs = boost::filesystem;

namespace DYN {

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
SparseMatrix::addTerm(const int row, const double val) {
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
SparseMatrix::init(const int nbRow, const int nbCol) {
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
SparseMatrix::reserve(const int nbCol) {
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
  static fs::path folder = "tmpMat";
  static fs::path base = folder / "mat-";
  static int nbPrint = 0;
  stringstream fileName;
  fileName << base.string() << nbPrint << ".txt";

  if (!exists(folder.string())) {
    create_directory(folder.string());
  }

  std::ofstream file;
  file.open(fileName.str().c_str(), std::ofstream::out);

  if (!sparse) {
    std::vector< std::vector<double> > matrix;
    for (int i = 0; i < nbCol_; ++i) {
      std::vector<double> row(nbCol_, 0);
      matrix.push_back(row);
    }

    for (int iCol = 0; iCol < nbCol_; ++iCol) {
      for (unsigned ind = Ap_[iCol]; ind < Ap_[iCol + 1]; ++ind) {
        int iRow = static_cast<int>(Ai_[ind]);
        double val = Ax_[ind];
        matrix[iRow][iCol] = val;
      }
    }

    stringstream val;
    for (unsigned int i = 0; i < matrix.size(); ++i) {
      std::vector<double> row = matrix[i];
      for (unsigned int j = 0; j < row.size(); ++j) {
        val.str("");
        val.clear();
        val << std::setprecision(5) << row[j];
        file << val.str() << ";";
      }
      file << "\n";
    }
  } else {
    stringstream val;
    for (int iCol = 0; iCol < nbCol_; ++iCol) {
      for (unsigned ind = Ap_[iCol]; ind < Ap_[iCol + 1]; ++ind) {
        int iRow = static_cast<int>(Ai_[ind]);
        val.str("");
        val.clear();
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
SparseMatrix::erase(const std::unordered_set<int>& rows, const std::unordered_set<int>& columns, SparseMatrix& M) {
  // Modifying the rows and columns numbers in the matrixes
  // However, the size allocated by KINSOL isn't modified
  M.nbRow_ = nbRow_ - static_cast<int>(rows.size());
  M.nbCol_ = nbCol_ - static_cast<int>(columns.size());

  // Map between the row numbers in the existing matrix and the rows that must be kept
  map<int, int> correspondance;
  int num = 0;
  for (int i = 0; i < nbRow_; ++i) {
    std::unordered_set<int>::const_iterator itL = rows.find(i);
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
  std::unordered_set<int>::const_iterator itC = columns.end();
  std::unordered_set<int>::const_iterator itL = rows.end();
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
  auto lower = std::upper_bound(Ap_.begin(), Ap_.end(), position);
  iRow = static_cast<int>(Ai_[position]);
  jCol = static_cast<int>(lower-Ap_.begin()) - 1;
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
  return CheckError();
}

}  // end of namespace DYN
