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
 * @file  DYNSolverCommon.h
 *
 * @brief Common utility function header
 *
 */
#ifndef SOLVERS_COMMON_DYNSOLVERCOMMON_H_
#define SOLVERS_COMMON_DYNSOLVERCOMMON_H_

#include <sunmatrix/sunmatrix_band.h>
#include <sunmatrix/sunmatrix_sparse.h>
#include <cmath>

namespace DYN {
class SparseMatrix;
class Model;

/**
 * @brief Copy one sparse matrix to the KINSOL structure
 *
 * @param smj Sparse matrix to copy to the KINSOL structure
 * @param JJ KINSOL structure where to copy the matrix
 * @param size size of the square matrix (nb columns)
 * @param lastRowVals pointer to the latest value of the previous matrix
 *
 * @return @b true if the matrix structure has changed, @b false else
 */
bool copySparseToKINSOL(const SparseMatrix& smj, SUNMatrix JJ, const int& size, sunindextype * lastRowVals);

/**
 * @brief Print the largest residuals errors
 *
 * @param fErr vector containing a pair with the residual function value and the global index of the residual function
 * @param model model currently simulated
 * @param nbErrors maximum number of errors to be displayed
 * @param tolerance tolerance over which an error is displayed
 */
void printLargestErrors(std::vector<std::pair<double, int> >& fErr, const boost::shared_ptr<Model>& model, int nbErrors, double tolerance);

/**
 * @brief Compute the weighted infinity norm of a vector
 *
 * @param vec vector which norm is to be computed
 * @param weights vector of weights to compute the norm
 *
 * @return value of the weighted infinity-norm of the vector
 *
 */
double weightedInfinityNorm(const std::vector<double>& vec, const std::vector<double>& weights);

/**
 * @brief Compute the weighted l2 norm of a vector
 *
 * @param vec vector which norm is to be computed
 * @param weights vector of weights to compute the norm
 *
 * @return value of the weighted l2 norm of the vector
 *
 */
double weightedL2Norm(const std::vector<double>& vec, const std::vector<double>& weights);

/**
 * @brief Compute the weighted infinity norm of a sub vector
 *
 * @param vec vector which norm is to be computed
 * @param vec_index indices of sub vector to compute norm
 * @param weights vector of weights to compute the norm, must have the same size as vec_index
 *
 * @return value of the weighted infinity-norm of the sub vector
 *
 */
double weightedInfinityNorm(const std::vector<double>& vec, const std::vector<int>& vec_index, const std::vector<double>& weights);

/**
 * @brief Compute the weighted l2 norm of a sub vector
 *
 * @param vec vector which norm is to be computed
 * @param vec_index indices of sub vector to compute norm
 * @param weights vector of weights to compute the norm, must have the same size as vec_index
 *
 * @return value of the weighted l2 norm of the sub vector
 *
 */
double weightedL2Norm(const std::vector<double>& vec, const std::vector<int>& vec_index, const std::vector<double>& weights);

/**
 * @brief structure use for sorting pairs in a vector
 */
struct mapcompabs {
  /**
   * @brief compare two pairs
   * @param p1 first pair to compare
   * @param p2 second pair to compare
   * @return @b true is the first pair double argument's absolute value is greater that the second one's
   */
  bool operator()(const std::pair<double, int>& p1, const std::pair<double, int>& p2) const {
    return fabs(p1.first) > fabs(p2.first);
  }
};

}  // end of namespace DYN

#endif  // SOLVERS_COMMON_DYNSOLVERCOMMON_H_
