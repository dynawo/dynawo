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
 * @file  DYNSolverSIM.h
 *
 * @brief Solver based on backward Euler integration method using KINSOL
 * to solve each step
 *
 */
#ifndef SOLVERS_SOLVERSIM_DYNSOLVERSIM_H_
#define SOLVERS_SOLVERSIM_DYNSOLVERSIM_H_

#include <vector>
#include <boost/shared_ptr.hpp>

#include "DYNSolverFactory.h"
#include "DYNSolverImpl.h"
#include "DYNEnumUtils.h"

namespace parameters {
class ParametersSet;
}

namespace DYN {
class SolverKINEuler;
class SolverKINAlgRestoration;

/**
 * @brief SolverSIM factory class
 *
 * Class for solver SIM creation
 */
class SolverSIMFactory : public SolverFactory {  ///< Simplified solver factory
 public:
  /**
   * @brief default constructor
   */
  SolverSIMFactory();

  /**
   * @brief destructor
   */
  ~SolverSIMFactory();

  /**
   * @brief Create an instance of solver
   * @return the new instance of solver created by the factory
   */
  Solver* create() const;

  /**
   * @brief SolverSIM destroy
   */
  void destroy(Solver*) const;
};

/**
 * @brief class Solver SIM : simplified solver
 */
class SolverSIM : public Solver::Impl {
 public:
  /**
   * @brief define returns value by the solver
   */
  typedef enum {
    CONV = 0,  ///< the algebraic solver finds a solution
    NON_CONV = 1,  ///< the algebraic solver doesn't find a solution
    ROOT = 2  ///< a root was found
  } SolverStatus_t;

 public:
  /**
   * @brief default constructor
   */
  SolverSIM();

  /**
   * @brief destructor
   */
  ~SolverSIM();

  /**
   * @copydoc Solver::Impl::defineSpecificParameters()
   */
  void defineSpecificParameters();

  /**
   * @copydoc Solver::Impl::setSolverSpecificParameters()
   */
  void setSolverSpecificParameters();

  /**
   * @copydoc Solver::Impl::solverType()
   */
  std::string solverType() const;

  /**
   * @copydoc Solver::init(const boost::shared_ptr<Model> & model, const double & t0, const double & tEnd)
   */
  void init(const boost::shared_ptr<Model> &model, const double & t0, const double & tEnd);

  /**
   * @copydoc Solver::reinit()
   */
  void reinit();

  /**
  * @brief compute YP prediction
  */
  virtual void computePrediction();

  /**
  * @copydoc Solver::computeYP()
  */
  virtual void computeYP(const double* yy);

  /**
   * @copydoc Solver::calculateIC()
   */
  void calculateIC();

  /**
   * @brief print solver specific introduction information
   *
   * @param ss stringstream to modify
   */
  void printHeaderSpecific(std::stringstream& ss) const;

  /**
   * @brief print specific info regarding the latest step made by the solver (i.e solution)
   *
   * @param msg stringstream to modify
   */
  void printSolveSpecific(std::stringstream& msg) const;

 private:
  /**
   * @brief save the initial values of y before the time step
   */
  void saveContinuousVariables();

  /**
   * @brief increment the counter of NR tries and stop the simulation if it is higher than a threshold
   * @param counter the current number of tries
   */
  void handleMaximumTries(int& counter);

  /**
   * @brief call the algebraic solver to find the solution of f(x) = 0
   *
   * @return the flag associated to the call to the algebraic solver
   */
  int callAlgebraicSolver();

  /**
   * @brief analyze and potentially retrieve the results obtained by the algebraic solver call
   * @param flag the flag obtained after the call to the algebraic solver
   * @return the current status of the solver
   */
  SolverStatus_t analyzeResult(int& flag);

  /**
   * @brief update the discrete variables values and the mode of the equations
   * @param status the current status of the solver before this process
   */
  void updateZAndMode(SolverStatus_t& status);

  /**
   * @brief update the solver attributes and strategy following a divergence
   * @param redoStep indicates if the step has to be recalculated or not
   */
  void handleDivergence(bool& redoStep);

  /**
   * @brief calculate the new step to use after divergence
   */
  void decreaseStep();

  /**
   * @brief restore y to their initial values
   */
  void restoreContinuousVariables();

  /**
   * @brief update the solver attributes and strategy following a convergence
   * @param redoStep indicates if the step has to be recalculated or not
   */
  void handleConvergence(bool& redoStep);

  /**
   * @brief calculate the new step to use after convergence or root detection (except for algebraic root with J update)
   */
  void increaseStep();

  /**
   * @brief update the solver attributes and strategy following a root detection
   * @param redoStep indicates if the step has to be recalculated or not
   */
  void handleRoot(bool& redoStep);

  /**
   * @brief update the time step at the end of the current step
   * @param tNxt current time step calculated
   */
  void updateTimeStep(double& tNxt);

  /**
   * @copydoc Solver::getTimeStep()
   */
  double getTimeStep() const {
    return h_;
  }

 protected:
  /**
   * @copydoc Solver::Impl::solveStep(double tAim, double &tNxt)
   */
  void solveStep(double tAim, double &tNxt);

  /**
   * @copydoc Solver::setupNewAlgRestoration(modeChangeType_t modeChangeType)
   */
  bool setupNewAlgRestoration(modeChangeType_t modeChangeType);

  /**
   * @copydoc Solver::updateStatistics()
   */
  void updateStatistics();

  /**
  * @brief set the index of each differential variables
  */
  void setDifferentialVariablesIndices();

 private:
  boost::shared_ptr<SolverKINEuler> solverKINEuler_;  ///< Backward Euler solver
  boost::shared_ptr<SolverKINAlgRestoration> solverKINAlgRestoration_;  ///< Newton Raphson solver for the algebraic variables restoration

  // Generic and alterable parameters
  double hMin_;  ///< minimum time-step
  double hMax_;  ///< maximum time-step
  double kReduceStep_;  ///< factor to reduce (and increase) the time-step
  int maxNewtonTry_;  ///< maximum number of Newton resolutions for one time-step

  double tEnd_;  ///< simulation end time
  double h_;  ///< current time step
  double hNew_;  ///< next time-step
  long int nNewt_;  ///< number of Newton iterations since the beginning of the simulation
  int countRestart_;  ///< current number of consecutive Newton resolutions leading to root changes
  bool factorizationForced_;  ///< force the Jacobian calculation due to an algebraic mode or a non convergence of the previous NR

  // Parameters for the algebraic resolution at each time step
  std::string linearSolverName_;  ///< name of the linear solver (KLU or NICSLU at the moment)
  double fnormtol_;  ///< stopping tolerance on L2-norm of residual function
  double initialaddtol_;  ///< stopping tolerance at initialization of residual function
  double scsteptol_;  ///< scaled step length tolerance
  double mxnewtstep_;  ///< maximum allowable scaled step length
  int msbset_;  ///< maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine
  int mxiter_;  ///< maximum number of nonlinear iterations
  int printfl_;  ///< level of verbosity of output

  bool skipNextNR_;  ///< indicates if the next algebraic resolution could be skipped

  std::vector<double> ySave_;  ///< values of state variables before step
  std::vector<int> differentialVariablesIndices_;  ///< index of each differential variables
  bool skipAlgebraicResidualsEvaluation_;  ///< flag used to skip algebraic residuals evaluation after a convergence or a mode
  bool optimizeAlgebraicResidualsEvaluations_;  ///< enable or disable the optimization of the number of algebraic residuals evals
  bool skipNRIfInitialGuessOK_;  ///< enable the possibility to skip next iterations if the simulation is stable
  int nbLastTimeSimulated_;  ///< nb times of simulation of the latest time
};

}  // end of namespace DYN

#endif  // SOLVERS_SOLVERSIM_DYNSOLVERSIM_H_
