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
 * @file  DYNSolverKINSubModel.h
 *
 * @brief Class of the solver used to calculate the initial values of the model
 * This solver is based on sundials/KINSOL solver : solve f(u) = 0
 *
 */
#ifndef SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINSUBMODEL_H_
#define SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINSUBMODEL_H_

#include <boost/core/noncopyable.hpp>

#include <sundials/sundials_nvector.h>
#include <sundials/sundials_linearsolver.h>
#include "DYNSolverKINCommon.h"

namespace DYN {
class SubModel;

class SolverKINSubModel : public SolverKINCommon, private boost::noncopyable{
 public:
  /**
   * @brief default constructor
   */
  SolverKINSubModel();

  /**
   * @brief destructor
   */
  ~SolverKINSubModel();

  /**
   * @brief initialize the solver
   *
   * @param subModel subModel to simulate (to solve the equations)
   * @param t0 time to use to solve the equations
   * @param yBuffer buffer of variables values
   * @param fBuffer buffer of residual functions values
   * @param fnormtol stopping tolerance on L2-norm of function value
   * @param initialaddtol stopping tolerance at initialization
   * @param scsteptol scaled step length tolerance
   * @param mxnewtstep maximum allowable scaled step length
   * @param msbset maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine
   * @param mxiter maximum number of nonlinear iterations
   * @param printfl level of verbosity of output
   */
  void init(SubModel * subModel, const double t0, double* yBuffer, double* fBuffer, int mxiter = 30, double fnormtol = 1e-4,
      double initialaddtol = 0.1, double scsteptol = 1e-4, double mxnewtstep = 100000, int msbset = 0, int printfl = 0);

  /**
   * @brief solve the equations of F(u) = 0 to find the new value of u
   * @return the solver flag
   */
  int solve();

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
          SUNMatrix JJ, void * data, N_Vector tmp1, N_Vector tmp2);

  SubModel* subModel_;  ///< model currently simulated

  double* yBuffer_;  ///< variables values
  double* fBuffer_;  ///< values of residual functions
};  ///< class Solver related to a SubModel

}  // namespace DYN

#endif  // SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINSUBMODEL_H_
