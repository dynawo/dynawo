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
#include <iostream>
#include <string.h>
#include <stdlib.h>
#include <cmath>

#include "DYNMacrosMessage.h"
#include "DYNModel.h"
#include "DYNSolverCommon.h"
#include "DYNSparseMatrix.h"
#include "DYNTrace.h"

namespace DYN {

bool
copySparseToKINSOL(const SparseMatrix& smj, SlsMat JJ, const int& size, int * lastRowVals) {
  bool matrixStructChange = false;
  if (JJ->NNZ < smj.nbElem()) {
    free(JJ->indexvals);
    free(JJ->data);
    JJ->NNZ = smj.nbElem();
    JJ->indexvals = reinterpret_cast<int*> (malloc(JJ->NNZ * sizeof (int)));
    JJ->data = reinterpret_cast<realtype*> (malloc(JJ->NNZ * sizeof (realtype)));
    matrixStructChange = true;
  }

  // NNZ has to be actualized anyway
  JJ->NNZ = smj.nbElem();

  memcpy(JJ->indexptrs, smj.Ap_, (size + 1) * sizeof (int));
  memcpy(JJ->indexvals, smj.Ai_, smj.nbElem() * sizeof (int));
  memcpy(JJ->data, smj.Ax_, smj.nbElem() * sizeof (double));

  if (lastRowVals != NULL) {
    if (memcmp(lastRowVals, JJ->indexvals, sizeof (int)*JJ->NNZ) != 0) {
      matrixStructChange = true;
    }
  } else {  // first time or size change
    matrixStructChange = true;
  }

  return matrixStructChange;
}

void
printLargestErrors(std::vector<std::pair<double, int> >& fErr, const boost::shared_ptr<Model>& model,
                   int nbErr, double tolerance) {
  std::sort(fErr.begin(), fErr.end(), mapcompabs());

  std::vector<std::pair<double, int> >::iterator it;
  int i = 0;
  for (it = fErr.begin(); it != fErr.end(); ++it) {
    std::string subModelName("");
    int subModelIndexF = 0;
    std::string fEquation("");
    model->getFInfos(it->second, subModelName, subModelIndexF, fEquation);

    Trace::debug() << DYNLog(SolverKINErrorValue, tolerance, it->second, it->first,
                             subModelName, subModelIndexF, fEquation) << Trace::endline;
    if (i >= nbErr)
      break;
    ++i;
  }
}

double weightedInfinityNorm(const std::vector<double>& vec, const std::vector<double>& weights) {
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

double weightedL2Norm(const std::vector<double>& vec, const std::vector<double>& weights) {
  assert(vec.size() == weights.size() && "Vectors must have same length.");
  double squared_norm = 0.;
  for (unsigned int i = 0; i < vec.size(); ++i) {
    squared_norm += (vec[i] * weights[i]) * (vec[i] * weights[i]);
  }
  return std::sqrt(squared_norm);
}

double weightedInfinityNorm(const std::vector<double>& vec, const std::vector<int>& vec_index, const std::vector<double>& weights) {
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

double weightedL2Norm(const std::vector<double>& vec, const std::vector<int>& vec_index, const std::vector<double>& weights) {
  assert(vec_index.size() == weights.size() && "Weights and indices must have same length.");
  double squared_norm = 0.;
  for (unsigned int i = 0; i < vec_index.size(); ++i) {
    squared_norm += (vec[vec_index[i]] * weights[i]) * (vec[vec_index[i]] * weights[i]);
  }
  return std::sqrt(squared_norm);
}

}  // fin namespace DYN
