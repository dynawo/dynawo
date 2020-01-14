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

#include <boost/shared_ptr.hpp>
#include <boost/core/noncopyable.hpp>
#include <boost/unordered_set.hpp>
#include <sundials/sundials_nvector.h>
#include "DYNEnumUtils.h"
#include "DYNSolverKINCommon.h"

namespace DYN {
class Model;

/**
 * @brief class Solver KINSOL for algebraic equations restoration and initialization
 * Generic class for KINSOL solver
 */
class SolverKINAlgRestoration : public SolverKINCommon, private boost::noncopyable{
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
    KIN_NORMAL,  ///< solve only algebraic equations
    KIN_YPRIM  ///< solve the new value of the derivative of differential variables
  } modeKin_t;

  /**
   * @brief initialize the solver
   *
   * @param model the model to simulate
   * @param mode mode of the solver (i.e algebraic equations or derivative)
   * @param fnormtol stopping tolerance on L2-norm of function value
   * @param initialaddtol stopping tolerance at initialization
   * @param scsteptol scaled step length tolerance
   * @param mxnewtstep maximum allowable scaled step length
   * @param msbset maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine
   * @param mxiter maximum number of nonlinear iterations
   * @param printfl level of verbosity of output
   */
  void init(const boost::shared_ptr<Model>& model, modeKin_t mode, double fnormtol, double initialaddtol, double scsteptol,
            double mxnewtstep, int msbset, int mxiter, int printfl);

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
  void modifySettings(double fnormtol, double initialaddtol, double scsteptol, double mxnewtstep,
                      int msbset, int mxiter, int printfl);

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

 private:
  boost::shared_ptr<Model> model_;  ///< model currently simulated

  std::vector<double> y0_;  ///< initial variables values
  std::vector<double> yp0_;  ///< initial values of derivative variables
  std::vector<DYN::propertyContinuousVar_t> vId_;  ///< property of variables (algebraic/differential)
  std::vector<DYN::propertyF_t> fType_;  ///< property of equations (algebraic /differential)
  boost::unordered_set<int> ignoreF_;  ///< equations to erase from the initial set of equations
  boost::unordered_set<int> ignoreY_;  ///< variables to erase form the initial set of variables
  std::vector<int> indexF_;  ///< equations to keep from the initial set of equations
  std::vector<int> indexY_;  ///< variables to keep form the initial set of variables
  std::vector<double> F_;  ///< current values of residual function
  modeKin_t mode_;  ///< mode of the solver (i.e algebraic equations or derivative)
};

}  // end of namespace DYN

#endif  // SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINALGRESTORATION_H_
