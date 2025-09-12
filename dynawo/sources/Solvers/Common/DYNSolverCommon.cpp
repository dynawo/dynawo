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
 * @file  DYNSolverCommon.cpp
 *
 * @brief Common utility method shared between all solvers
 *
 */
#include <string>
#include <cmath>
#include <sunmatrix/sunmatrix_sparse.h>
#include <sunlinsol/sunlinsol_klu.h>

#include "DYNMacrosMessage.h"
#include "DYNModel.h"
#include "DYNSubModel.h"
#include "DYNSolverCommon.h"

#include <DYNFileSystemUtils.h>

#include "DYNSparseMatrix.h"
#include "DYNTrace.h"

namespace DYN {

static int symbolicFacto = 0;

int SolverCommon::getNumSymbolicFactorization() {
  return symbolicFacto;
}

void SolverCommon::resetNumSymbolicFactorization() {
  symbolicFacto = 0;
}

bool
SolverCommon::copySparseToKINSOL(SparseMatrix& smj, SUNMatrix& sundialsMatrix, const std::vector<sunindextype>& lastRowVals) {
  bool matrixStructChange = false;
  if (SM_NNZ_S(sundialsMatrix) < smj.nbElem()) {
    matrixStructChange = true;
  }

  copySparseMatrixToSUNMatrix(smj, sundialsMatrix);

  if (!std::equal(lastRowVals.begin(), lastRowVals.end(), smj.getAi().begin())) {
    matrixStructChange = true;
  }

  return matrixStructChange;
}

void
SolverCommon::copySparseMatrixToSUNMatrix(SparseMatrix& smj, SUNMatrix& sundialsMatrix) {
  SM_NNZ_S(sundialsMatrix) = smj.nbElem();
  SM_INDEXPTRS_S(sundialsMatrix) = &(smj.getNonCstAp())[0];
  SM_INDEXVALS_S(sundialsMatrix) = &(smj.getNonCstAi())[0];
  SM_DATA_S(sundialsMatrix) = &(smj.getNonCstAx())[0];
}

void
SolverCommon::cleanSUNMatrix(SUNMatrix& sundialsMatrix) {
  if (SM_INDEXPTRS_S(sundialsMatrix) != NULL) {
    SM_INDEXPTRS_S(sundialsMatrix) = NULL;
    SM_CONTENT_S(sundialsMatrix)->colptrs = NULL;
    SM_CONTENT_S(sundialsMatrix)->rowptrs = NULL;
  }
  if (SM_INDEXVALS_S(sundialsMatrix) != NULL) {
    SM_INDEXVALS_S(sundialsMatrix) = NULL;
    SM_CONTENT_S(sundialsMatrix)->rowvals = NULL;
    SM_CONTENT_S(sundialsMatrix)->colvals = NULL;
  }
  if (SM_DATA_S(sundialsMatrix) != NULL) {
    SM_DATA_S(sundialsMatrix) = NULL;
  }
}

void
SolverCommon::freeSUNMatrix(SUNMatrix& sundialsMatrix) {
  if (SM_INDEXPTRS_S(sundialsMatrix) != NULL) {
    free(SM_INDEXPTRS_S(sundialsMatrix));
    SM_INDEXPTRS_S(sundialsMatrix) = NULL;
  }
  if (SM_INDEXVALS_S(sundialsMatrix) != NULL) {
    free(SM_INDEXVALS_S(sundialsMatrix));
    SM_INDEXVALS_S(sundialsMatrix) = NULL;
  }
  if (SM_DATA_S(sundialsMatrix) != NULL) {
    free(SM_DATA_S(sundialsMatrix));
    SM_DATA_S(sundialsMatrix) = NULL;
  }
}

void SolverCommon::propagateMatrixStructureChangeToKINSOL(SparseMatrix& smj, SUNMatrix& sundialsMatrix, std::vector<sunindextype>& lastRowVals,
                                                          SUNLinearSolver& LS, bool log) {
  bool matrixStructChange = copySparseToKINSOL(smj, sundialsMatrix, lastRowVals);

  if (matrixStructChange) {
    ++symbolicFacto;
    SUNLinSol_KLUReInit(LS, sundialsMatrix, SM_NNZ_S(sundialsMatrix), 2);  // reinit symbolic factorisation
    lastRowVals.resize(SM_NNZ_S(sundialsMatrix));
    lastRowVals = smj.getAi();
    if (log)
      Trace::info() << DYNLog(MatrixStructureChange) << Trace::endline;
  }
}

void
SolverCommon::printLargestErrors(std::vector<std::pair<double, size_t> >& fErr, const Model& model,
                   int nbErr) {
  std::sort(fErr.begin(), fErr.end(), mapcompabs());

  size_t size = nbErr;
  if (fErr.size() < size)
    size = fErr.size();
  for (size_t i = 0; i < size; ++i) {
    std::string subModelName("");
    int subModelIndexF = 0;
    std::string fEquation("");
    std::pair<double, size_t> currentErr = fErr[i];
    model.getFInfos(static_cast<int>(currentErr.second), subModelName, subModelIndexF, fEquation);

    Trace::debug() << DYNLog(KinErrorValue, currentErr.second, currentErr.first,
                             subModelName, subModelIndexF, fEquation) << Trace::endline;
  }
}

void
SolverCommon::printLargestErrors(std::vector<std::pair<double, size_t> >& fErr, const SubModel& subModel, int nbErr) {
  std::sort(fErr.begin(), fErr.end(), mapcompabs());

  size_t size = nbErr;
  if (fErr.size() < size)
    size = fErr.size();
  for (size_t i = 0; i < size; ++i) {
    std::string subModelName(subModel.name());
    std::pair<double, size_t> currentErr = fErr[i];
    std::string fEquation = subModel.getFequationByLocalIndex(currentErr.second);
    Trace::debug() << DYNLog(KinErrorValue, currentErr.second, currentErr.first,
                             subModelName, currentErr.second, fEquation) << Trace::endline;
  }
}

double SolverCommon::weightedInfinityNorm(const std::vector<double>& vec, const std::vector<double>& weights) {
  assert(vec.size() == weights.size() && "Vectors must have same length.");
  double norm = 0.;
  double product = 0.;
  for (unsigned int i = 0; i < vec.size(); ++i) {
    product = std::fabs(vec[i] * weights[i]);
    if (product > norm) {
      norm = product;
    }
  }
  return norm;
}

double SolverCommon::weightedL2Norm(const std::vector<double>& vec, const std::vector<double>& weights) {
  assert(vec.size() == weights.size() && "Vectors must have same length.");
  double squared_norm = 0.;
  for (unsigned int i = 0; i < vec.size(); ++i) {
    squared_norm += (vec[i] * weights[i]) * (vec[i] * weights[i]);
  }
  return std::sqrt(squared_norm);
}

double SolverCommon::weightedInfinityNorm(const std::vector<double>& vec, const std::vector<int>& vec_index, const std::vector<double>& weights) {
  assert(vec_index.size() == weights.size() && "Weights and indices must have same length.");
  double norm = 0.;
  double product = 0.;
  for (unsigned int i = 0; i < vec_index.size(); ++i) {
    product = std::fabs(vec[vec_index[i]] * weights[i]);
    if (product > norm) {
      norm = product;
    }
  }
  return norm;
}

double SolverCommon::weightedL2Norm(const std::vector<double>& vec, const std::vector<int>& vec_index, const std::vector<double>& weights) {
  assert(vec_index.size() == weights.size() && "Weights and indices must have same length.");
  double squared_norm = 0.;
  for (unsigned int i = 0; i < vec_index.size(); ++i) {
    squared_norm += (vec[vec_index[i]] * weights[i]) * (vec[vec_index[i]] * weights[i]);
  }
  return std::sqrt(squared_norm);
}

void SolverCommon::printVector(const std::string& folder, const std::string& name, const double* vec, const unsigned int size) {
  const std::string filename = folder + "/" + name;

  if (!exists(folder)) {
    create_directory(folder);
  }

  std::ofstream file;
  file.open(filename.c_str(), std::ofstream::out);

  for (unsigned int i = 0; i < size; ++i) {
    file << i << " " << vec[i] << "\n";
  }

  file.close();
}

void SolverCommon::printVector(const std::string& folder, const std::string& name, const std::vector<double>& vec) {
  printVector(folder, name, vec.data(), vec.size());
}

}  // namespace DYN
