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
 * @file  DYNSolverKINEuler.h
 *
 * @brief Solver euler file header
 *
 * SolverKINEuler is the implementation of a solver with euler method based on
 * KINSOL solver.
 */
#ifndef SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINEULER_H_
#define SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINEULER_H_

#include <boost/shared_ptr.hpp>
#include <boost/core/noncopyable.hpp>
#include <sundials/sundials_nvector.h>
#include <sundials/sundials_sparse.h>
#include <sundials/sundials_matrix.h>
#include <sundials/sundials_linearsolver.h>
#include "DYNSolverKINCommon.h"

namespace DYN {
class Model;

/**
 * @class SolverKINEuler
 * @brief Solver euler class
 *
 * SolverKINEuler is the implementation of a solver with euler method based on
 * KINSOL solver.
 */
class SolverKINEuler : public SolverKINCommon, private boost::noncopyable{
 public:
  /**
   * @brief Default constructor
   */
  SolverKINEuler();

  /**
   * @brief Destructor
   */
  ~SolverKINEuler();

  /**
   * @brief initialize all memory of KINSOL
   *
   * @param model instance of model to interact with
   * @param linearSolverName choice for linear solver (KLU or NICSLU at the moment)
   * @param fnormtol stopping tolerance on L2-norm of function value
   * @param initialaddtol stopping tolerance at initialization
   * @param scsteptol scaled step length tolerance
   * @param mxnewtstep maximum allowable scaled step length
   * @param msbset maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine
   * @param mxiter maximum number of nonlinear iterations
   * @param printfl level of verbosity of output
   */
  void init(const boost::shared_ptr<Model>& model, const std::string& linearSolverName, double fnormtol, double initialaddtol, double scsteptol,
          double mxnewtstep, int msbset, int mxiter, int printfl);

  /**
   * @brief set identity of each variable
   *
   * Are they algebraic variable or differential variable ?
   */
  void setIdVars();

  /**
   * @brief solve the problem
   *
   * @param noInitSetup indicate if kinsol have to rebuilt the jacobian at the beginning
   * @param skipAlgebraicResidualsEvaluation indicate if algebraic residuals needs to be be evaluated
   *
   * @return @b KIN_SUCCESS if everything ok, error flag else
   */
  int solve(bool noInitSetup, bool skipAlgebraicResidualsEvaluation);

  /**
   * @brief get the final value of variable after the solver call
   *
   * @param y final value after the solver call
   * @param yp final value after the solver call
   */
  inline void getValues(std::vector<double>& y, std::vector<double>& yp) {
    std::copy(vYy_.begin(), vYy_.end(), y.begin());
    std::copy(YP_.begin(), YP_.end(), yp.begin());
  }

  /**
   * @brief set initial values of the problem to solver
   *
   * @param t initial time value
   * @param h step to reach
   * @param y initial variables values
   */
  void setInitialValues(const double& t, const double& h, const std::vector<double>& y);

  /**
   * @brief calculated F(u) for a given value of u
   *
   * @param yy variable vector current value
   * @param rr output vector of F
   * @param data pointer to user data
   *
   * @return 0 if successful
   */
  static int evalF_KIN(N_Vector yy, N_Vector rr, void* data);

  /**
   * @brief computes the Jacobian for a given value of variables
   *
   * @param yy variables current value
   * @param rr F current value
   * @param JJ Jacobian matrix calculated
   * @param data pointer to user data
   * @param tmp1 unused
   * @param tmp2 unused
   *
   * @return 0 if successful
   */
  static int evalJ_KIN(N_Vector yy, N_Vector rr,
          SUNMatrix JJ, void* data, N_Vector tmp1, N_Vector tmp2);

  /**
   * @brief Model instance getter
   *
   * @return instance of the model for the solver
   */
  inline boost::shared_ptr<Model> getModel() const {
    return model_;
  }

 private:
  boost::shared_ptr<Model> model_;  ///< instance of model to interact with

  std::vector<double> y0_;  ///< Initial values of Y variables before call of kinsol
  std::vector<int> differentialVars_;  ///< index of each differential variables
  std::vector<double> F_;  ///< current values of residual function
  std::vector<double> YP_;  ///< calculated values of derivatives
  double h0_;  ///< Step of the solver to reach
};

}  // namespace DYN

#endif  // SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINEULER_H_
