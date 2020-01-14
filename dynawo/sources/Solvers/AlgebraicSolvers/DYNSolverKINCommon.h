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
 * @file  DYNSolverKINCommon.h
 *
 * @brief Common class for all algebraic solvers based on sundials/KINSOL.
 *
 */
#ifndef SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINCOMMON_H_
#define SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINCOMMON_H_

#include <kinsol/kinsol.h>
#include <sundials/sundials_nvector.h>
#include <boost/shared_ptr.hpp>

namespace DYN {

/**
 * @brief class SolverKINCommon: common part of all the KINSOL-based solvers
 * Generic class for KINSOL-based solver
 */
class SolverKINCommon {
 public:
  /**
   * @brief default constructor
   */
  SolverKINCommon();

  /**
   * @brief destructor
   */
  ~SolverKINCommon();

  /**
   * @brief initialize KINSOL memory and parameters
   *
   * @param linearSolverName choice for linear solver
   * @param fnormtol stopping tolerance on L2-norm of function value
   * @param initialaddtol stopping tolerance on initialization
   * @param scsteptol scaled step length tolerance
   * @param mxnewtstep maximum allowable scaled step length
   * @param mxiter maximum number of nonlinear iterations
   * @param msbset maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine
   * @param printfl level of verbosity of output
   * @param evalF method to evaluate the residuals
   * @param evalJ method to evaluate the Jacobian
   */
  void initCommon(const std::string& linearSolverName, double fnormtol, double initialaddtol, double scsteptol,
            double mxnewtstep, int msbset, int mxiter, int printfl, KINSysFn evalF, KINLsJacFn evalJ);

  /**
   * @brief delete all internal structure allocated by init method
   */
  void clean();

  /**
   * @brief common parts for the solve method (scaling vectors copy, call to KINSOL, analyseflag)
   * @return a flag indicating the resolution status
   */
  int solveCommon();

  /**
   * @brief processes error and warning messages from KINSOL solver
   *
   * @param error_code error code returns by KINSOL
   * @param module name of the KINSOL module reporting error
   * @param function name of the function in which error occurred
   * @param msg error message
   * @param eh_data unused
   */
  static void errHandlerFn(int error_code, const char *module, const char *function,
          char *msg, void *eh_data);

  /**
   * @brief processes info messages from KINSOL solver
   *
   * @param module name of the KINSOL module reporting info
   * @param function name of the function reporting the message
   * @param msg information message
   * @param eh_data unused
   */
  static void infoHandlerFn(const char *module, const char *function,
          char *msg, void *eh_data);

  /**
   * @brief  Analyze the flag returned by KINSOL
   *
   * @param flag flag to analyze
   */
  void analyseFlag(const int & flag);

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

  /**
   * @brief update statistics of solver Euler kin execution
   *
   * @param nni non linear iterations number
   * @param nre residual functions call number
   * @param nje Jacobian call number
   */
  void updateStatistics(long int& nni, long int& nre, long int& nje);

 protected:
  void* KINMem_;  ///< KINSOL internal memory structure
  SUNLinearSolver LS_;  ///< Linear Solver pointer
  SUNMatrix M_;  ///< sparse SUNMatrix
  N_Vector yy_;  ///< variables values stored in Sundials structure
  sunindextype* lastRowVals_;  ///< save of last Jacobian structure, to force symbolic factorization if structure change

  std::string linearSolverName_;  ///< linear solver name used
  std::vector<double> vYy_;  ///< Current values of variables during the call of the solver
  unsigned int nbF_;  ///< number of equations to solve
  double t0_;  ///< initial time to use
  bool firstIteration_;  ///< @b true if first iteration, @b false otherwise

  std::vector<double> fScale_;  ///< Scaling vector for residual functions
  std::vector<double> yScale_;  ///< Scaling vector for variables
};

}  // end of namespace DYN

#endif  // SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINCOMMON_H_
