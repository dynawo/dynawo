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

#include "DYNCommun.h"
#include "DYNMacrosMessage.h"
#include "DYNFileSystemUtils.h"
#include "DYNSparseMatrix.h"
#include "DYNTrace.h"
#include "DYNTimer.h"
#include "DYNFileSystemUtils.h"

using std::map;
using std::set;
using std::vector;
using std::stringstream;

namespace DYN {

const int MATRIX_BLOCK_LENGTH = 50;  ///< Number of block reallocated when maximum number of variables allocated is reached, to deal with exploding matrix size

SparseMatrix::SparseMatrix() {
  withoutNan_ = true;
  withoutInf_ = true;
  nbCol_ = 0;
  nbRow_ = 0;
  nbTerm_ = 0;
  Ap_ = NULL;
  Ai_ = NULL;
  Ax_ = NULL;

  iAp_ = 0;
  iAi_ = 0;
  iAx_ = 0;
  currentMaxTerm_ = 0;
}

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
  Ap_ = reinterpret_cast<int*> (malloc(sizeof (int)*(nbCol_ + 1)));
  Ap_[0] = 0;
  // Allocation based on the Jacobian maximum size
  Ai_ = reinterpret_cast<int*> (malloc(sizeof (int)*(currentMaxTerm_)));
  Ax_ = reinterpret_cast<double*> (malloc(sizeof (double)*(currentMaxTerm_)));

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

  Ap_ = reinterpret_cast<int*> (malloc(sizeof (int)*(nbCol + 1)));
  Ap_[0] = 0;
  // Allocation based on the Jacobian maximum size
  Ai_ = reinterpret_cast<int*> (malloc(sizeof (int)*(currentMaxTerm_)));
  Ax_ = reinterpret_cast<double*> (malloc(sizeof (double)*(currentMaxTerm_)));

  iAp_ = 0;
  iAi_ = 0;
  iAx_ = 0;
  nbTerm_ = 0;
}

void
SparseMatrix::increaseReserve() {
  currentMaxTerm_ += MATRIX_BLOCK_LENGTH;

  int *new_Ai = reinterpret_cast<int*> (realloc(Ai_, currentMaxTerm_ * sizeof (int)));
  if (new_Ai == NULL) {
    throw DYNError(Error::GENERAL, CouldNotRealloc);
  } else {
    Ai_ = new_Ai;
  }
  double *new_Ax = reinterpret_cast<double*> (realloc(Ax_, currentMaxTerm_ * sizeof (double)));
  if (new_Ax == NULL) {
    throw DYNError(Error::GENERAL, CouldNotRealloc);
  } else {
    Ax_ = new_Ax;
  }
}

void
SparseMatrix::free() {
  nbRow_ = 0;
  nbCol_ = 0;
  if (Ap_ != NULL) std::free(Ap_);
  if (Ai_ != NULL) std::free(Ai_);
  if (Ax_ != NULL) std::free(Ax_);
  Ap_ = NULL;
  Ai_ = NULL;
  Ax_ = NULL;

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
      for (int ind = Ap_[iCol]; ind < Ap_[iCol + 1]; ++ind) {
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
      for (int ind = Ap_[iCol]; ind < Ap_[iCol + 1]; ++ind) {
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
    for (int ind = Ap_[iCol]; ind < Ap_[iCol + 1]; ++ind) {
      int iRow = Ai_[ind];
      Trace::debug() << "A(" << iRow << ";" << iCol << ")" << std::setprecision(16) << Ax_[ind] << Trace::endline;
    }
  }
}

void
SparseMatrix::erase(const vector<int>& rows, const vector<int>& columns, SparseMatrix& M) {
  // Modifying the rows and columns numbers in the matrixes
  // However, the size allocated by KINSOL isn't modified
  M.nbRow_ = nbRow_ - rows.size();
  M.nbCol_ = nbCol_ - columns.size();

  // Map between the row numbers in the existing matrix and the rows that must be kept
  map<int, int> correspondance;
  int num = 0;
  for (int i = 0; i < nbRow_; ++i) {
    vector<int>::const_iterator itL = std::find(rows.begin(), rows.end(), i);
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
  vector<int>::const_iterator itC = columns.end();
  vector<int>::const_iterator itL = rows.end();
  for (int iCol = 0; iCol < nbCol_; ++iCol) {
    itC = find(columns.begin(), columns.end(), iCol);
    if (itC == columns.end()) {
      M.changeCol();
      for (int ind = Ap_[iCol]; ind < Ap_[iCol + 1]; ++ind) {
        int iRow = Ai_[ind];
        itL = find(rows.begin(), rows.end(), iRow);

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
    for (int ind = Ap_[iCol]; ind < Ap_[iCol + 1]; ++ind) {
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
      if (Ai_[ind] == row) {
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
  assert(position < static_cast<unsigned int>(nbTerm_) && "Position must be lower than number ot terms");
  std::vector<int> apVec(Ap_,  Ap_ + nbCol_ + 1);
  std::vector<int>::iterator lower = std::upper_bound(apVec.begin(), apVec.end(), position);
  iRow = Ai_[position];
  jCol = (lower-apVec.begin()) - 1;
}


}  // end of namespace DYN
