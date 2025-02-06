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

#include <boost/core/noncopyable.hpp>
#include <string>

#include <sundials/sundials_nvector.h>
#include <sundials/sundials_matrix.h>
#include "DYNSolverKINCommon.h"
#include "DYNSparseMatrix.h"

namespace DYN {
class Model;
class Solver;

/**
 * @class SolverKINEuler
 * @brief Solver euler class
 *
 * SolverKINEuler is the implementation of a solver with euler method based on
 * KINSOL solver.
 */
class SolverKINEuler : public SolverKINCommon, private boost::noncopyable {
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
   * @param timeSchemeSolver instance of time scheme solver calling for an algebraic resolution
   * @param fnormtol stopping tolerance on L2-norm of function value
   * @param initialaddtol stopping tolerance at initialization
   * @param scsteptol scaled step length tolerance
   * @param mxnewtstep maximum allowable scaled step length
   * @param msbset maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine
   * @param mxiter maximum number of nonlinear iterations
   * @param printfl level of verbosity of output
   * @param sundialsVectorY solution of the algebraic resolution
   */
  void init(const std::shared_ptr<Model>& model, Solver* timeSchemeSolver, double fnormtol,
            double initialaddtol, double scsteptol, double mxnewtstep, int msbset, int mxiter, int printfl, N_Vector sundialsVectorY);

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
  inline Model& getModel() const {
    assert(!(!model_));
    return *model_;
  }

  /**
   * @brief Time-scheme solver instance getter
   *
   * @return instance of the time-scheme solver
   */
  inline Solver& getTimeSchemeSolver() const {
    assert(!(!model_));
    return *timeSchemeSolver_;
  }

  /**
  * @brief get Complete Jacobian matrix
  *
  * @return the Complete Jacobian matrix
  */
  inline SparseMatrix& getMatrix() {
    return smj_;
  }

 private:
  std::shared_ptr<Model> model_;  ///< instance of model to interact with
  Solver* timeSchemeSolver_;  ///< instance of time-scheme solver to interact with
  SparseMatrix smj_;  ///< Jacobian matrix
};

}  // namespace DYN

#endif  // SOLVERS_ALGEBRAICSOLVERS_DYNSOLVERKINEULER_H_
