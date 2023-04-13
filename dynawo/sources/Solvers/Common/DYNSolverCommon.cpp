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

#ifdef WITH_NICSLU
#include <sunlinsol/sunlinsol_nicslu.h>
#endif

#include "DYNMacrosMessage.h"
#include "DYNModel.h"
#include "DYNSolverCommon.h"
#include "DYNSparseMatrix.h"
#include "DYNTrace.h"

namespace DYN {

bool
SolverCommon::copySparseToKINSOL(SparseMatrix& smj, SUNMatrix& JJ, const std::vector<sunindextype>& lastRowVals) {
  bool matrixStructChange = false;
  if (SM_NNZ_S(JJ) < smj.nbElem()) {
    matrixStructChange = true;
  }

  SM_NNZ_S(JJ) = smj.nbElem();
  SM_INDEXPTRS_S(JJ) = &(smj.getNonCstAp())[0];
  SM_INDEXVALS_S(JJ) = &(smj.getNonCstAi())[0];
  SM_DATA_S(JJ) = &(smj.getNonCstAx())[0];

  if (!std::equal(lastRowVals.begin(), lastRowVals.end(), smj.getAi().begin())) {
    matrixStructChange = true;
  }

  return matrixStructChange;
}

void SolverCommon::propagateMatrixStructureChangeToKINSOL(SparseMatrix& smj, SUNMatrix& JJ, std::vector<sunindextype>& lastRowVals,
                                                          SUNLinearSolver& LS, const std::string& linearSolverName, bool log) {
  bool matrixStructChange = copySparseToKINSOL(smj, JJ, lastRowVals);

  if (matrixStructChange) {
    if (linearSolverName == "KLU") {
      SUNLinSol_KLUReInit(LS, JJ, SM_NNZ_S(JJ), 2);  // reinit symbolic factorisation
#ifdef WITH_NICSLU
    } else if (linearSolverName == "NICSLU") {
      SUNLinSol_NICSLUReInit(LS, JJ, SM_NNZ_S(JJ), 2);  // reinit symbolic factorisation
    }
#else
  }
#endif
    lastRowVals.resize(SM_NNZ_S(JJ));
    lastRowVals = smj.getAi();
    if (log)
      Trace::debug() << DYNLog(MatrixStructureChange) << Trace::endline;
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

}  // namespace DYN
