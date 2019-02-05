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
 * @file  DYNSolverEulerKIN.h
 *
 * @brief Solver euler file header
 *
 * SolverEulerKIN is the implementation of a solver with euler method based on
 * kinsol solver.
 */
#ifndef SOLVERS_SOLVERSIM_DYNSOLVEREULERKIN_H_
#define SOLVERS_SOLVERSIM_DYNSOLVEREULERKIN_H_

#include <boost/shared_ptr.hpp>
#include <boost/core/noncopyable.hpp>
#include <sundials/sundials_nvector.h>
#include <sundials/sundials_sparse.h>
#include <sundials/sundials_matrix.h>
#include <sundials/sundials_linearsolver.h>
#include "DYNEnumUtils.h"

namespace DYN {
class Model;

/**
 * @class SolverEulerKIN
 * @brief Solver euler class
 *
 * SolverEulerKIN is the implementation of a solver with euler method based on
 * kinsol solver.
 */
class SolverEulerKIN : private boost::noncopyable{
 public:
  /**
   * @brief Default constructor
   */
  SolverEulerKIN();

  /**
   * @brief Destructor
   */
  ~SolverEulerKIN();

  /**
   * @brief initialize all memory of kinsol
   *
   * @param model instance of model to interact with
   * @param linearSolverName choice for linear solver (KLU or NICSLU at the moment)
   */
  void init(const boost::shared_ptr<Model>& model, const std::string& linearSolverName);

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
   *
   * @return @b KIN_SUCCESS if everything ok, error flag else
   */
  int solve(bool noInitSetup);

  /**
   * @brief Clean method: call kinsol method to desallocated all memory
   */
  void clean();

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
   * @brief update statistics of solver Euler kin execution
   *
   * @param nni non linear iterations number
   * @param nre residual functions call number
   * @param nje Jacobian call number
   */
  void updateStatistics(int64_t& nni, int64_t& nre, int64_t& nje);

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
   * @brief error message handler function : process error and warning messages
   *
   * @param error_code error code
   * @param module name of the KINSOL module reporting the error
   * @param function name of the function in which the error occurred
   * @param msg error message
   * @param eh_data pointer to user data
   */
  static void errHandlerFn(int error_code, const char* module, const char* function,
          char* msg, void* eh_data);

  /**
   * @brief Model instance getter
   *
   * @return instance of the model for the solver
   */
  inline boost::shared_ptr<Model> getModel() const {
    return model_;
  }

  /**
   * @brief set if solver is in first iteration step or not
   * @return @b true if first iteration, @b false otherwise
   */
  inline bool getFirstIteration() const {
    return firstIteration_;
  }

  /**
   * @brief set if solver is in first iteration step or not
   * @param firstIteration @b true if first iteration, @b false otherwise
   */
  inline void setFirstIteration(bool firstIteration) {
    firstIteration_ = firstIteration;
  }

  /**
   * @brief linear solver name getter
   *
   * @return linear solver name
   */
  inline const std::string& getLinearSolverName() const {
    return linearSolverName_;
  }

 private:
  /**
   * @brief translate the flag into a clear message
   *
   * @param flag flag error to translate
   */
  void errorTranslate(int flag);


  boost::shared_ptr<Model> model_;  ///< instance of model to interact with
  void* KINMem_;  ///< KINSol memory pointer
  SUNLinearSolver LS_;  ///< Linear Solver pointer
  SUNMatrix M_;  ///< sparse SUNMatrix
  N_Vector yy_;  ///< Current values of variables during the call of the solver
  ///< (allocated by kinsol)
  N_Vector yscale_;  ///< Scaling vector for variables allocated by kinsol
  N_Vector fscale_;  ///<  Scaling vector for residual functions allocated by kinsol
  std::vector<double> vFscale_;  ///< Scaling vector for residual functions
  std::vector<double> vYscale_;  ///< Scaling vector for variables
  std::vector<double> vYy_;  ///< Current values of variables during the call of the solver
  std::vector<double> y0_;  ///< Initial values of Y variables before call of kinsol
  std::vector<int> differentialVars_;  ///< index of each differential variables
  std::vector<double> F_;  ///< current values of residual function
  std::vector<double> YP_;  ///< calculated values of derivatives
  double t0_;  ///< Initial value of time before call of the solver
  double h0_;  ///< Step of the solver to reach
  sunindextype* lastRowVals_;  ///< save of last jacobian structure, to force symbolic factorisation if structure change
  bool firstIteration_;  ///< @b true if first iteration, @b false otherwise
  std::string linearSolverName_;  ///< name of the linear solver (KLU or NICSLU at the moment)
};

}  // namespace DYN

#endif  // SOLVERS_SOLVERSIM_DYNSOLVEREULERKIN_H_

