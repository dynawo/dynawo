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
 * @file  DYNSolverKIN.h
 *
 * @brief Solver based on sundials/KINSOL solver : solve f(u) = 0
 *
 */
#ifndef SOLVERS_SOLVERKINSOL_DYNSOLVERKIN_H_
#define SOLVERS_SOLVERKINSOL_DYNSOLVERKIN_H_

#include <boost/shared_ptr.hpp>
#include <boost/core/noncopyable.hpp>
#include <boost/unordered_set.hpp>
#include <sundials/sundials_nvector.h>
#include "DYNEnumUtils.h"

namespace DYN {
class Model;

/**
 * @brief class Solver KINSOL
 * Generic class for Kinsol solver
 */
class SolverKIN : private boost::noncopyable{
 public:
  /**
   * @brief default constructor
   */
  SolverKIN();

  /**
   * @brief destructor
   */
  ~SolverKIN();

  /**
   * @brief define the type of the problem to solve : only algebraic equations
   * or only solve the new value of the derivative of differential variables
   */
  typedef enum {
    KIN_NORMAL,  ///< solve only algebraic equations
    KIN_YPRIM  ///< solve the new value of the derivative of differential variables
  } modeKin_t;

  /**
   * @brief initialize the solver
   *
   * @param model the model to simulate
   * @param mode mode of the solver (i.e algebraic equations or derivative)
   * @param scsteptol scaled step length tolerance
   * @param fnormtol stopping tolerance on L2-norm of function value
   * @param mxiter maximum number of nonlinear iterations
   * @param nnz maximum number of nonlinear iterations that may be performed between updating the Jacobian
   * @param msbset maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine
   * @param mxnstepin maximum allowable scaled step length
   * @param printfl level of verbosity of output
   */
  void init(const boost::shared_ptr<Model>& model, modeKin_t mode, double scsteptol, double fnormtol,
            int mxiter, int nnz, int msbset, int mxnstepin, int printfl);

  /**
   * @brief modify the solver settings
   *
   * @param scsteptol scaled step length tolerance
   * @param fnormtol stopping tolerance on L2-norm of function value
   * @param mxiter maximum number of nonlinear iterations
   * @param msbset maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine
   * @param mxnstepin maximum allowable scaled step length
   * @param printfl level of verbosity of output
   */
  void modifySettings(double scsteptol, double fnormtol,
            int mxiter, int msbset, int mxnstepin, int printfl);

  /**
   * @brief solve the equations of F(u) = 0 to find the new value of u
   *
   * @param noInitSetup indicates if the J should be evaluated or not at the first iteration
   */
  void solve(bool noInitSetup = true);

  /**
   * @brief getter for the model currently simulated
   * @return the model currently simulated
   */
  inline boost::shared_ptr<Model> getModel() const {
    return model_;
  }

  /**
   * @brief delete all internal structure allocated by init method
   */
  void clean();

  /**
   * @brief return the new values calculated by the solver
   *
   * @param y value of variables
   * @param yp value of derivatives of variables
   */
  void getValues(std::vector<double> & y, std::vector<double> &yp);

  /**
   * @brief set the initial conditions of the equations to solve
   *
   * @param t time to use in equations
   * @param y value of variables
   * @param yp value of derivatives of variables
   */
  void setInitialValues(const double& t, const std::vector<double> & y, const std::vector<double> &yp);

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
  static int evalF_KIN(N_Vector yy, N_Vector rr, void *data);

  /**
   * @brief calculate the Jacobian associate to F(u): \f$( J=@F/@u)\f$
   * This method is used in case of resolution of F(u) = 0 for only algebraic equations
   *
   * @param yy current value of the variables to find
   * @param rr current value of the residual function F
   * @param JJ output Jacobian
   * @param data pointer to user data (instance of solver)
   * @param tmp1 unused
   * @param tmp2 unused
   *
   * @return 0 is successful, positive value otherwise
   */
  static int evalJ_KIN(N_Vector yy, N_Vector rr,
          SUNMatrix JJ, void * data, N_Vector tmp1, N_Vector tmp2);

  /**
   * @brief calculate the Jacobian associate to F(u): \f$( J=@F/@u)\f$
   * This method is used in case of resolution of F(u) = 0 for only
   * derivatives of differential variables
   *
   * @param yy current value of the variables to find
   * @param rr current value of the residual function F
   * @param JJ output Jacobian
   * @param data pointer to user data (instance of solver)
   * @param tmp1 unused
   * @param tmp2 unused
   *
   * @return 0 is successful, positive value otherwise
   */
  static int evalJPrim_KIN(N_Vector yy, N_Vector rr,
          SUNMatrix JJ, void * data, N_Vector tmp1, N_Vector tmp2);

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
   * @brief  Analyze a flag return by the KINSOL solve
   *
   * @param flag flag to analyze
   */
  void analyseFlag(const int & flag);

 private:
  boost::shared_ptr<Model> model_;  ///< model currently simulated

  void* KINMem_;  ///< KINSOL internal memory structure
  SUNLinearSolver LS_;  ///< Linear Solver pointer
  SUNMatrix M_;  ///< sparse SUNMatrix
  N_Vector yy_;  ///< variables values stored in Sundials structure
  std::vector<double> vYy_;  ///< variables values
  std::vector<double> y0_;  ///< initial variables values
  std::vector<double> yp0_;  ///< initial values of derivative variables
  std::vector<DYN::propertyContinuousVar_t> vId_;  ///< property of variables (algebraic/differential)
  std::vector<DYN::propertyF_t> fType_;  ///< property of equations (algebraic /differential)
  boost::unordered_set<int> ignoreF_;  ///< equations to erase from the initial set of equations
  boost::unordered_set<int> ignoreY_;  ///< variables to erase form the initial set of variables
  std::vector<int> indexF_;  ///< equations to keep from the initial set of equations
  std::vector<int> indexY_;  ///< variables to keep form the initial set of variables
  std::vector<double> F_;  ///< current values of residual function
  unsigned int nbF_;  ///< number of equations to solve
  double t0_;  ///< initial time to use
  modeKin_t mode_;  ///< mode of the solver (i.e algebraic equations or derivative)
  sunindextype* lastRowVals_;  ///< save of last Jacobian structure, to force symbolic factorization if structure change
  std::vector<double> fScaling_;  ///< scaling vector for residual function, for KINSOL norm evaluation
  std::vector<double> yScaling_;  ///< scaling vector for solution, for KINSOL norm evaluation
};

}  // end of namespace DYN

#endif  // SOLVERS_SOLVERKINSOL_DYNSOLVERKIN_H_
