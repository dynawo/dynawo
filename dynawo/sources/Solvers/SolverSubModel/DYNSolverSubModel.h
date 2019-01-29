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
 * @file  DYNSolverSubModel.h
 *
 * @brief Class of the solver used to calculate the initial values of the model
 * This solver is based on sundials/KINSOL solver : solve f(u) = 0
 *
 */
#ifndef SOLVERS_SOLVERSUBMODEL_DYNSOLVERSUBMODEL_H_
#define SOLVERS_SOLVERSUBMODEL_DYNSOLVERSUBMODEL_H_

#include <sundials/sundials_nvector.h>
#include <sundials/sundials_sparse.h>

namespace DYN {
class SubModel;

class SolverSubModel {
 public:
  /**
   * @brief default constructor
   */
  SolverSubModel();

  /**
   * @brief destructor
   */
  ~SolverSubModel();

  /**
   * @brief initialize the solver
   *
   * @param subModel subModel to simulate (to solve the equations)
   * @param t0 time to use to solve the equations
   * @param yBuffer buffer of variables values
   * @param fBuffer buffer of residual functions values
   */
  void init(SubModel * subModel, const double t0, double* yBuffer, double* fBuffer);

  /**
   * @brief solve the equations of F(u) = 0 to find the new value of u
   */
  void solve();

  /**
   * @brief getter for the model currently simulated
   * @return the model currently simulated
   */
  inline SubModel* getSubModel() const {
    return subModel_;
  }
  /**
   * @brief getter for the current variables buffer
   * @return the current variable buffer
   */
  inline double* getYBuffer() const {
    return yBuffer_;
  }

  /**
   * @brief delete all internal structure allocated by init method
   */
  void clean();

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
   * @brief set the maximum number of iterations allowed for the KINSOL resolution
   * @param nbIterations maximum number of iterations allowed for the KINSOL resolution
   */
  void setNbMaxIterations(int nbIterations);

 private:
  /**
   * @brief compute F(y) for a given value of y
   *
   * @param yy current value of the vector y
   * @param rr output vector F(y)
   * @param data pointer to user data (instance of solver)
   *
   * @return 0 is successful, positive value otherwise
   */
  static int evalFInit_KIN(N_Vector yy, N_Vector rr, void *data);

  /**
   * @brief calculate the Jacobian associate to F(u): \f$( J=@F/@u)\f$
   * This method is used in case of resolution of F(u) = 0 for only algebraic equations
   *
   * @param yy current value of the variables to find
   * @param rr current value of the residual function F
   * @param JJ output jacobian
   * @param data pointer to user data (instance of solver)
   * @param tmp1 unused
   * @param tmp2 unused
   *
   * @return  0 is successful, positive value otherwise
   */
  static int evalJInit_KIN(N_Vector yy, N_Vector rr,
          SlsMat JJ, void * data, N_Vector tmp1, N_Vector tmp2);

  /**
   * @brief  processes error and warning messages from KINSOL solver
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
   * @param function  name of the function reporting the message
   * @param msg information message
   * @param eh_data unused
   */
  static void infoHandlerFn(const char *module, const char *function,
          char *msg, void *eh_data);

  /**
   * @brief  Analyse a flag return by the KINSOL solve
   *
   * @param flag flag to analyse
   */
  void analyseFlag(const int & flag);

  SubModel* subModel_;  ///< model currently simulated

  void* KINMem_;  ///< KINSOL internal memory structure
  N_Vector yy_;  ///< variables values stored in sundials structure
  N_Vector scaley_;  ///< scaling to use for y values (Y near 1.0 when F near 0)
  N_Vector scalef_;  ///< scaling to use for residual values (F have same magnitude when Y far from its solution)
  std::vector<double> vYy_;  ///< variables values (use to build the yy_ buffer in sundials structure)
  double* yBuffer_;  ///< variables values
  double* fBuffer_;  ///< values of residual functions
  unsigned int nbF_;  ///<  number of equations to solve
  double t0_;  ///< initial time to use
  bool firstIteration_;  ///< @b true if first iteration, @b false otherwise

  int* lastRowVals_;  ///< save of last jacobian structure, to force symbolic factorisation if structure change
};  ///< class Solver related to a SubModel

}  // namespace DYN

#endif  // SOLVERS_SOLVERSUBMODEL_DYNSOLVERSUBMODEL_H_

