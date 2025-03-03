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
 * @file  DYNSolverKINAlgRestoration.h
 *
 * @brief Solver based on sundials/KINSOL solver : solve f(u) = 0. Used for algebraic equations restoration and initialization.
 *
 */
#ifndef SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINALGRESTORATION_H_
#define SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINALGRESTORATION_H_

#include <boost/core/noncopyable.hpp>
#include <unordered_set>
#include <string>
#include <vector>

#include <sundials/sundials_nvector.h>
#include <sundials/sundials_matrix.h>

#include "DYNSolverKINCommon.h"
#include "DYNSparseMatrix.h"

namespace DYN {
class Model;

/**
 * @brief class Solver KINSOL for algebraic equations restoration and initialization
 * Generic class for KINSOL solver
 */
class SolverKINAlgRestoration : public SolverKINCommon, private boost::noncopyable {
 public:
  /**
   * @brief default constructor
   */
  SolverKINAlgRestoration();

  /**
   * @brief destructor
   */
  ~SolverKINAlgRestoration();

  /**
   * @brief define the type of the problem to solve : only algebraic equations
   * or only solve the new value of the derivative of differential variables
   */
  typedef enum {
    KIN_ALGEBRAIC,  ///< solve only algebraic equations
    KIN_DERIVATIVES  ///< solve the new value of the derivative of differential variables
  } modeKin_t;

  /**
   * @brief get string from mode type
   *
   * @param mode algebraic mode restoration
   *
   * @return the mode of the algebraic restoration
   */
  static std::string stringFromMode(modeKin_t mode);

  /**
   * @brief initialize the solver
   *
   * @param model the model to simulate
   * @param mode mode of the solver (i.e. algebraic equations or derivative)
   */
  void init(const std::shared_ptr<Model>& model, modeKin_t mode);

  /**
  * @brief initialize a new algebraic restoration
  *
  * @param fnormtol stopping tolerance on L2-norm of function value
  * @param initialaddtol stopping tolerance at initialization
  * @param scsteptol scaled step length tolerance
  * @param mxnewtstep maximum allowable scaled step length
  * @param msbset maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine
  * @param mxiter maximum number of nonlinear iterations
  * @param printfl level of verbosity of output
  */
  void setupNewAlgebraicRestoration(double fnormtol, double initialaddtol, double scsteptol, double mxnewtstep,
                            int msbset, int mxiter, int printfl);

  /**
   * @brief solve the equations of F(u) = 0 to find the new value of u
   *
   * @return the flag value
   * @param noInitSetup indicates if the J should be evaluated or not at the first iteration
   * @param evaluateOnlyModeAtFirstIter indicates if only residuals of models with mode change should be evaluated
   * @param multipleStrategiesForAlgebraicRestoration indicates if we try to use mutliple strategies for restoration
   */
  int solve(bool noInitSetup = true, bool evaluateOnlyModeAtFirstIter = false, bool multipleStrategiesForAlgebraicRestoration = false);

  /**
   * @brief getter for the model currently simulated
   * @return the model currently simulated
   */
  inline Model& getModel() const {
    assert(!(!model_));
    return *model_;
  }

  /**
   * @brief return the new values calculated by the restoration
   *
   * @param y value of variables
   * @param yp value of derivatives of variables
   */
  void getValues(std::vector<double>& y, std::vector<double>& yp) const;

  /**
   * @brief set the initial conditions of the equations to solve
   *
   * @param t time to use in equations
   * @param y value of variables
   * @param yp value of derivatives of variables
   */
  void setInitialValues(double t, const std::vector<double>& y, const std::vector<double>& yp);

  /**
   * @brief set the initial conditions of the equations to solve
   *
   * @param kinsolStategy time to use in equations
   * @param noInitSetup indicates if the J should be evaluated or not at the first iteration
  * @param evaluateOnlyModeAtFirstIter indicates if only residuals of models with mode change should be evaluated
  * @return the flag value
  */
  int solveStrategy(bool noInitSetup, bool evaluateOnlyModeAtFirstIter, int kinsolStategy);

// #if _DEBUG_
  /**
   * @brief set check jacobian during evalF
   * @param checkJacobian enable or disable the jacobian sanity check
   */
  void setCheckJacobian(const bool checkJacobian) {
    checkJacobian_ = checkJacobian;
  }
// #endif

  /**
  * @brief clean sundials structures to force a new algebraic restoration setup
  */
  void resetAlgebraicRestoration();

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
  static int evalF_KIN(N_Vector yy, N_Vector rr, void* data);

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
          SUNMatrix JJ, void* data, N_Vector tmp1, N_Vector tmp2);

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
          SUNMatrix JJ, void* data, N_Vector tmp1, N_Vector tmp2);

  /**
   * @brief computes and collects the equations and variables' types
   *
   * @return number of F
   */
  unsigned int initVarAndEqTypes();

  /**
  * @brief modify the solver settings
  *
  * @param fnormtol stopping tolerance on L2-norm of function value
  * @param initialaddtol stopping tolerance at initialization
  * @param scsteptol scaled step length tolerance
  * @param mxnewtstep maximum allowable scaled step length
  * @param msbset maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine
  * @param mxiter maximum number of nonlinear iterations
  * @param printfl level of verbosity of output
  */
  void updateKINSOLSettings(double fnormtol, double initialaddtol, double scsteptol, double mxnewtstep,
                            int msbset, int mxiter, int printfl) const;

// #if _DEBUG_
  /**
   * @brief Check jacobian
   *
   * @throw exceptions if jacobian is incorrect
   *
   * @param smj the jacobian to check
   * @param model the model currelty used
   */
  static void checkJacobian(const SparseMatrix& smj, Model& model);
// #endif

  /**
  * @brief save state before performing algebraic restoration
  */
  void saveState();

  /**
  * @brief restore state before performing algebraic restoration to use a new strategy
  */
  void restoreState();

  /**
  * @brief get mode
  *
  * @return the mode of the restoration
  */
  modeKin_t getMode() const { return mode_; }

  /**
  * @brief clean sundials vectors allocated by this class
  */
  void cleanAlgebraicVectors();

  /**
  * @brief get Complete Jacobian matrix
  *
  * @return the Complete Jacobian matrix
  */
  inline SparseMatrix& getMatrix() {
    return smj_;
  }

  /**
  * @brief get Jacobian matrix only on algebraic variables
  *
  * @return the Jacobian matrix only on algebraic variables
  */
  inline SparseMatrix& getMatrixAlgebraic() {
    return smjKin_;
  }

 private:
  std::shared_ptr<Model> model_;  ///< model currently simulated

  std::vector<double> vectorYOrYpSolution_;  ///< Solution of the restoration after the call of the solver
  std::vector<double> vectorYForRestoration_;  ///< variables values during call of the solver
  std::vector<double> vectorYpForRestoration_;  ///< derivative variables during call of the solver
  std::vector<double> vectorYOrYpSolutionSave_;  ///< Solution of the restoration after the call of the solver
  std::vector<double> vectorYForRestorationSave_;  ///< variables values during call of the solver
  std::vector<double> vectorYpForRestorationSave_;  ///< derivative variables during call of the solver
  std::vector<double> vectorFSave_;  ///< derivative variables during call of the solver
  std::unordered_set<int> ignoreF_;  ///< equations to erase from the initial set of equations
  std::unordered_set<int> ignoreY_;  ///< variables to erase form the initial set of variables
  std::vector<int> indexF_;  ///< equations to keep from the initial set of equations
  std::vector<int> indexY_;  ///< variables to keep form the initial set of variables
  modeKin_t mode_;  ///< mode of the solver (i.e. algebraic equations or derivative)

  SparseMatrix smj_;  ///< Complete Jacobian matrix
  SparseMatrix smjKin_;  ///< Jacobian matrix only on algebraic variables

// #if _DEBUG_
  bool checkJacobian_;  ///< Check jacobian
// #endif
};

}  // end of namespace DYN

#endif  // SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINALGRESTORATION_H_
