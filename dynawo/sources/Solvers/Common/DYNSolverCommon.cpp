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
#include "DYNSolverCommon.h"
#include "DYNSparseMatrix.h"
#include "DYNTrace.h"

namespace DYN {

bool
SolverCommon::copySparseToKINSOL(const SparseMatrix& smj, SUNMatrix& JJ, const int& size, sunindextype * lastRowVals) {
  bool matrixStructChange = false;
  if (SM_NNZ_S(JJ) < smj.nbElem()) {
    free(SM_INDEXPTRS_S(JJ));
    free(SM_INDEXVALS_S(JJ));
    free(SM_DATA_S(JJ));
    SM_NNZ_S(JJ) = smj.nbElem();
    SM_INDEXPTRS_S(JJ) = reinterpret_cast<sunindextype*> (malloc((size + 1) * sizeof (sunindextype)));
    SM_INDEXVALS_S(JJ) = reinterpret_cast<sunindextype*> (malloc(SM_NNZ_S(JJ) * sizeof (sunindextype)));
    SM_DATA_S(JJ) = reinterpret_cast<realtype*> (malloc(SM_NNZ_S(JJ) * sizeof (realtype)));
    matrixStructChange = true;
  }

  // NNZ has to be actualized anyway
  SM_NNZ_S(JJ) = smj.nbElem();

  for (unsigned i = 0, iEnd = size + 1; i < iEnd; ++i) {
    SM_INDEXPTRS_S(JJ)[i] = smj.Ap_[i];  //!!! implicit conversion from unsigned to sunindextype
  }
  for (unsigned i = 0, iEnd = smj.nbElem(); i < iEnd; ++i) {
    SM_INDEXVALS_S(JJ)[i] = smj.Ai_[i];  //!!! implicit conversion from int to sunindextype
    SM_DATA_S(JJ)[i] = smj.Ax_[i];  //!!! implicit conversion from double to realtype
  }

  if (lastRowVals != NULL) {
    if (memcmp(lastRowVals, SM_INDEXVALS_S(JJ), sizeof (sunindextype)*SM_NNZ_S(JJ)) != 0) {
      matrixStructChange = true;
    }
  } else {  // first time or size change
    matrixStructChange = true;
  }

  return matrixStructChange;
}

void SolverCommon::propagateMatrixStructureChangeToKINSOL(const SparseMatrix& smj, SUNMatrix& JJ, const int& size, sunindextype** lastRowVals,
                                                          SUNLinearSolver& LS, bool log) {
  bool matrixStructChange = copySparseToKINSOL(smj, JJ, size, *lastRowVals);

  if (matrixStructChange) {
    SUNLinSol_KLUReInit(LS, JJ, SM_NNZ_S(JJ), 2);  // reinit symbolic factorisation
    if (*lastRowVals != NULL) {
      free(*lastRowVals);
    }
    *lastRowVals = reinterpret_cast<sunindextype*> (malloc(sizeof (sunindextype)*SM_NNZ_S(JJ)));
    memcpy(*lastRowVals, SM_INDEXVALS_S(JJ), sizeof (sunindextype)*SM_NNZ_S(JJ));
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
