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
 * @file  DYNSolverImpl.h
 *
 * @brief Dynawo solvers : header file
 *
 */
#ifndef SOLVERS_COMMON_DYNSOLVERIMPL_H_
#define SOLVERS_COMMON_DYNSOLVERIMPL_H_

#include <vector>
#include <string>
#include <map>
#include <boost/shared_ptr.hpp>
#include <boost/core/noncopyable.hpp>
#include <sundials/sundials_nvector.h>

#include "DYNSolver.h"
#include "DYNEnumUtils.h"
#include "DYNParameterSolver.h"

namespace parameters {
class ParametersSet;
}

namespace timeline {
class Timeline;
}

namespace DYN {


/**
 * @brief Structure for storing solver statistics
 */
typedef struct {
  long int nst_;  ///< number of steps
  long int nre_;  ///< number of residual evaluations
  long int nni_;  ///< number of nonlinear iterations
  long int nje_;  ///< number of Jacobian evaluations
  long int nreAlgebraic_;  ///< number of nonlinear iterations
  long int njeAlgebraic_;  ///< number of Jacobian evaluations
  long int nreAlgebraicPrim_;  ///< number of nonlinear iterations
  long int njeAlgebraicPrim_;  ///< number of Jacobian evaluations
  long int netf_;  ///< number of error test failures
  long int ncfn_;  ///< number of nonlinear convergence failures
  long int ngeInternal_;  ///< number of root function evaluations
  long int ngeSolver_;  ///< number of root function evaluations
  long int nze_;  ///< number of discrete variable evaluations
  long int nme_;  ///< number of mode evaluations
  long int nmeDiff_;  ///< number of mode evaluations
  long int nmeAlg_;  ///< number of mode evaluations
  long int nmeAlgJ_;  ///< number of mode evaluations
} stat_t;

class Message;
class MessageTimeline;
class Model;
class ParameterSolver;

/**
 * @class Solver::Impl
 * @brief Solver implemented class
 *
 * Implementation of Solver interface class
 */
class Solver::Impl : public Solver, private boost::noncopyable {
 public:
  /**
   * @brief Constructor
   */
  Impl();

  /**
   * @brief Destructor
   */
  virtual ~Impl();

  /**
   * @copydoc Solver::getState()
   */
  inline const BitMask& getState() const {
    return state_;
  }

  /**
   * @copydoc Solver::setParameters(const std::shared_ptr<parameters::ParametersSet> &params)
   */
  void setParameters(const std::shared_ptr<parameters::ParametersSet>& params);

  /**
   * @copydoc Solver::defineParameters()
   */
  void defineParameters();

  /**
   * @copydoc Solver::defineCommonParameters()
   */
  void defineCommonParameters();

  /**
   * @copydoc Solver::defineSpecificParameters()
   */
  virtual void defineSpecificParameters() = 0;

  /**
   * @copydoc Solver::solverType()
   */
  virtual std::string solverType() const = 0;

  /**
   * @copydoc Solver::hasParameter(const std::string &nameParameter)
   */
  bool hasParameter(const std::string &nameParameter);

  /**
   * @copydoc Solver::getParametersMap()
   */
  const std::map<std::string, ParameterSolver>& getParametersMap() const;

  /**
   * @copydoc Solver::checkUnusedParameters()
   */
  void checkUnusedParameters(const std::shared_ptr<parameters::ParametersSet>& params) const;

  /**
   * @copydoc Solver::findParameter(const std::string &name)
   */
  ParameterSolver& findParameter(const std::string& name);

  /**
   * @copydoc Solver::setParameterFromSet(const std::string& parName, const std::shared_ptr<parameters::ParametersSet>& parametersSet)
   */
  void setParameterFromSet(const std::string& parName, const std::shared_ptr<parameters::ParametersSet>& parametersSet);

  /**
   * @copydoc Solver::setParametersFromPARFile(const std::shared_ptr<parameters::ParametersSet>& params)
   */
  void setParametersFromPARFile(const std::shared_ptr<parameters::ParametersSet>& params);

  /**
   * @copydoc Solver::setSolverParameters()
   */
  void setSolverParameters();

  /**
   * @copydoc Solver::setSolverCommonParameters()
   */
  void setSolverCommonParameters();


  /**
   * @copydoc Solver::silentZEnabled() const
   */
  bool silentZEnabled() const {
    return enableSilentZ_;
  }

  /**
   * @copydoc Solver::setSolverSpecificParameters()
   */
  virtual void setSolverSpecificParameters() = 0;

  /**
   * @copydoc Solver::init(const std::shared_ptr<Model>& model, double t0, double tEnd)
   */
  virtual void init(const std::shared_ptr<Model>& model, double t0, double tEnd) = 0;

  /**
   * @copydoc Solver::calculateIC()
   */
  virtual void calculateIC(double tEnd) = 0;

  /**
   * @copydoc Solver::solve(double tAim, double &tNxt)
   */
  void solve(double tAim, double& tNxt);

  /**
   * @copydoc Solver::reinit()
   */
  virtual void reinit() = 0;

  /**
  * @brief compute time scheme related derivatives
  */
  virtual void computeYP(const double* /*yy*/) { /* not needed */ }

  /**
   * @copydoc Solver::printSolve() const
   */
  void printSolve() const;

  /**
   * @copydoc Solver::printHeader() const
   */
  void printHeader() const;

  /**
   * @copydoc Solver::printEnd()
   */
  void printEnd() const;

  /**
  * @copydoc Solver::printEndConsole()
  */
  void printEndConsole() const;

 /**
   * @copydoc Solver::printParameterValues()
   */
  void printParameterValues() const;

  /**
   * @copydoc Solver::getCurrentY()
   */
  inline const std::vector<double>& getCurrentY() const {
    return vectorY_;
  }

  /**
   * @copydoc Solver::getCurrentYP()
   */
  inline const std::vector<double>& getCurrentYP() const {
    return vectorYp_;
  }

  /**
   * @copydoc Solver::getTSolve()
   */
  inline double getTSolve() const {
    return tSolve_;
  }

  /**
   * @copydoc Solver::setTimeline(const boost::shared_ptr<timeline::Timeline> &timeline)
   */
  void setTimeline(const boost::shared_ptr<timeline::Timeline>& timeline);

 protected:
  /**
   * @brief set a given parameter value
   *
   * @param parameter the desired parameter
   * @param value the value to set
   */
  template <typename T> void setParameterValue(ParameterSolver& parameter, const T& value);

  /**
   * @brief initialize all internal structure of the solver
   * @param t0 initial time of the simulation
   * @param model model to simulate, gives the size of all internal structure
   */
  void init(double t0, const std::shared_ptr<Model>& model);

  /**
   * @brief delete all internal structure allocated by init method
   */
  void clean();

  /**
   * @brief getter for the model currently simulated
   * @return the model currently simulated
   */
  inline Model& getModel() const {
    assert(!(!model_));
    return *model_;
  }

  /**
   * @brief reset the execution statistics of the solver
   */
  void resetStats();

  /**
   * @brief evaluate discrete variables values and values of zero crossing functions
   * @param G0 previous value of zero crossing functions
   * @param G1 new value of zero crossing functions
   * @param time time to use to evaluate these values
   *
   * @return @b true zero crossing functions or discrete variables have changed
   */
  bool evalZMode(std::vector<state_g>& G0, std::vector<state_g>& G1, double time);

  /**
   * @brief print the unstable roots
   *
   * @param t current time
   * @param G0 previous value of zero crossing functions
   * @param G1 new value of zero crossing functions
   */
  void printUnstableRoot(double t, const std::vector<state_g>& G0, const std::vector<state_g>& G1) const;

  /**
  * @brief get updated values of root functions
  *
  * @return the vector of root functions
  */
  std::vector<state_g>& getG1() {
    return g1_;
  }

  /**
  * @brief set start from dump
  *
  * @param startFromDump is starting from dump
  */
  void setStartFromDump(bool startFromDump) {
    startFromDump_ = startFromDump;
  }

  /**
  * @brief is solver starting from dump
  *
  * @return is solver starting from dump
  */
  virtual bool startFromDump() const {
    return startFromDump_;
  }

 protected:
  /**
   * @brief Integrate the DAE over an interval in t
   *
   * @param tAim the next time at which a computed solution is desired
   * @param tNxt the time reached by the solver
   */
  virtual void solveStep(double tAim, double& tNxt) = 0;

  /**
   * @copydoc Solver::setupNewAlgRestoration(modeChangeType_t modeChangeType)
   */
  virtual bool setupNewAlgRestoration(modeChangeType_t modeChangeType) = 0;

  std::map<std::string, ParameterSolver> parameters_;  ///< map between parameters and parameters' names
  std::shared_ptr<Model> model_;  ///< model currently simulated
  boost::shared_ptr<timeline::Timeline> timeline_;  ///< timeline where event messages should be added or removed

  std::vector<state_g> g0_;  ///< previous values of root functions
  std::vector<state_g> g1_;  ///< updated values of root functions

  SUNContext sundialsContext_;  ///< context of sundials structure
  N_Vector sundialsVectorY_;  ///< continuous variables values stored in sundials structure
  N_Vector sundialsVectorYp_;  ///<  derivative of variables stored in sundials structure
  std::vector<double> vectorY_;  ///< continuous variables values
  std::vector<double> vectorYp_;  ///< derivative of variables

  // Parameters for the algebraic restoration
  double fnormtolAlg_;  ///< stopping tolerance on L2-norm of residual function
  double fnormtolAlgInit_;  ///< stopping tolerance on L2-norm of residual function at init
  double initialaddtolAlg_;  ///< stopping tolerance at initialization
  double initialaddtolAlgInit_;  ///< stopping tolerance at initialization at init
  double scsteptolAlg_;  ///< scaled step length tolerance
  double scsteptolAlgInit_;  ///< scaled step length tolerance at init
  double mxnewtstepAlg_;  ///< maximum allowable scaled step length
  double mxnewtstepAlgInit_;  ///< maximum allowable scaled step length at init
  int msbsetAlg_;  ///< maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine
  int msbsetAlgInit_;  ///< maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine at init
  int mxiterAlg_;  ///< maximum number of nonlinear iterations
  int mxiterAlgInit_;  ///< maximum number of nonlinear iterations at init
  int printflAlg_;  ///< level of verbosity of output
  int printflAlgInit_;  ///< level of verbosity of output at init

  // Parameters for the algebraic restoration with J recalculation
  double fnormtolAlgJ_;  ///< stopping tolerance on L2-norm of residual function
  double initialaddtolAlgJ_;  ///< stopping tolerance at initialization
  double scsteptolAlgJ_;  ///< scaled step length tolerance
  double mxnewtstepAlgJ_;  ///< maximum allowable scaled step length
  int msbsetAlgJ_;  ///< maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine
  int mxiterAlgJ_;  ///< maximum number of nonlinear iterations
  int printflAlgJ_;  ///< level of verbosity of output

  // Time step evolution parameters
  double minimalAcceptableStep_;  ///< minimum time step to consider that the solver is not blocked
  int maximumNumberSlowStepIncrease_;  ///< maximum number of consecutive time-steps with a time step lower than minimalAcceptableStep

  // Performance optimization parameters
  bool enableSilentZ_;  ///< enable the possibility to break discrete variable propagation loop if only silent z are modified
  bool optimizeReinitAlgebraicResidualsEvaluations_;  ///< enable or disable the optimization of the number of algebraic residuals evals during reinit
  modeChangeType_t minimumModeChangeTypeForAlgebraicRestoration_;  ///< parameter to set the minimum mode level at which algebraic restoration will occur
  modeChangeType_t minimumModeChangeTypeForAlgebraicRestorationInit_;  ///< parameter to set the minimum mode level
                                                                       ///< at which algebraic restoration will occur at init

  stat_t stats_;  ///< execution statistics of the solver
  double tSolve_;  ///< current internal time of the solver
  BitMask state_;  ///< current state value of the solver

  bool startFromDump_;  ///< is solver starting from dump
};

}  // end of namespace DYN

#include "DYNSolverImpl.hpp"

#endif  // SOLVERS_COMMON_DYNSOLVERIMPL_H_
