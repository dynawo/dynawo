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
 * @file  DYNSolver.h
 *
 * @brief Dynawo solvers : interface file
 *
 */
#ifndef SOLVERS_COMMON_DYNSOLVER_H_
#define SOLVERS_COMMON_DYNSOLVER_H_

#include "DYNBitMask.h"
#include "DYNEnumUtils.h"
#include "DYNModel.h"
#include "DYNParameterSolver.h"
#include "DYNSolver.h"
#include "PARParametersSet.h"
#include "TLTimeline.h"

#include <boost/core/noncopyable.hpp>
#include <boost/shared_ptr.hpp>
#include <map>
#include <string>
#include <sundials/sundials_nvector.h>
#include <vector>

namespace DYN {
static const int maxNumberUnstableRoots = 10;  ///< Maximum number of unstable roots for one time step

/**
 * @brief Flags of the current numerical resolution
 */
typedef enum {
  NoChange = 0x00,
  ModeChange = 0x01,
  NotSilentZChange = 0x02,
  SilentZNotUsedInDiscreteEqChange = 0x04,
  SilentZNotUsedInContinuousEqChange = 0x08
} StateFlags;

/**
 * @brief Status of the previous reinitialization scheme
 */
typedef enum {
  None = 0,
  Algebraic,
  AlgebraicWithJUpdate
} PreviousReinit;

/**
 * @brief Identifier of the current solver used
 */
typedef enum {
  SolverSimplifie = 0,
  SolverSundials1 = 1,
  SolverSundials2 = 2
} SolverType;

/**
 * @class Solver
 * @brief Solver interface class
 *
 * Interface class for solver using ind Dynawo
 */
class Solver {
 public:
  /**
   * @brief Constructor
   */
  Solver();

  /**
   * @brief Destructor
   */
  virtual ~Solver();

  /**
   * @brief get the current solver's state
   * @return solver state
   */
  inline const BitMask& getState()  const {
    return state_;
  }

  /**
   * @brief set the previous reinitialization status
   * @param previousReinit : new previous reinitialization status
   */
  inline void setPreviousReinit(const PreviousReinit& previousReinit) {
    previousReinit_ = previousReinit;
  }
  /**
   * @brief get the previous reinitialization status
   * @return previous reinitialization status
   */
  inline const PreviousReinit& getPreviousReinit() const {
    return previousReinit_;
  }

  /**
   * @brief set the solver's parameters
   *
   * @param params : parameter set used to set the solver's parameters
   */
  void setParameters(const boost::shared_ptr<parameters::ParametersSet> &params);

  /**
   * @brief define each parameters of the solver
   */
  void defineParameters();

  /**
   * @brief define common parameters for all solvers
   */
  void defineCommonParameters();

  /**
   * @brief define parameters specific to each solver
   */
  virtual void defineSpecificParameters() = 0;

  /**
   * @brief get the type of the solver
   * @return the type of the solver
   */
  virtual std::string solverType() const = 0;

  /**
   * @brief check whether the parameter is available within the solver
   *
   * @param nameParameter name of the parameter
   * @return @b true if the parameter exists inside the solver
   */
  bool hasParameter(const std::string &nameParameter);

  /**
   * @brief Getter for attribute parameters_
   *
   * @return solver attribute parameters_
   */
  const std::map<std::string, ParameterSolver>& getParametersMap() const;

  /**
   * @brief check whether parameters are used
   *
   * If a parameter is not used, add a debug trace
   *
   * @param params : parameter set to check
   */
  void checkUnusedParameters(boost::shared_ptr<parameters::ParametersSet> params);

  /**
   * @brief search for a parameter with a given name
   *
   * @param name: name of the desired parameter
   * @return desired parameter
   */
  ParameterSolver& findParameter(const std::string &name);

  /**
   * @brief set a parameter value from a parameters set
   *
   * @param parName: the name of the parameter to be set
   * @param parametersSet: the set to scan for a value
   */
  void setParameterFromSet(const std::string &parName, const boost::shared_ptr<parameters::ParametersSet> parametersSet);

  /**
   * @brief set all parameters values from a parameters set (API PAR)
   *
   * @param params : parameter set to check
  */
  void setParametersFromPARFile(const boost::shared_ptr<parameters::ParametersSet> &params);

  /**
   * @brief set the solver parameters value
  */
  void setSolverParameters();

  /**
   * @brief set the solver common parameters value
   */
  void setSolverCommonParameters();

  /**
   * @brief set the solver specific parameters value
   */
  virtual void setSolverSpecificParameters() = 0;


  /**
   * @brief initialize the solver
   *
   * @param model the model to simulate
   * @param t0 start time of the simulation
   * @param tEnd end time of the simulation
   */
  virtual void init(const boost::shared_ptr<Model> &model, const double &t0, const double &tEnd) = 0;

  /**
   * @brief Calculate the intial condition of the DAE
   */
  virtual void calculateIC() = 0;

  /**
   * @brief Integrate the DAE over an interval in t
   *
   * @param tAim the next time at which a computed solution is desired
   * @param tNxt the time reached by the solver
   */
  void solve(double tAim, double &tNxt);

  /**
   * @brief Restore the equations after an algebraic mode - reinitialize the DAE problem (new initial point)
   */
  virtual void reinit() = 0;

  /**
   * @brief print the latest step made by the solver (i.e solution)
   */
  void printSolve() const;

  /**
   * @brief print specific info regarding the latest step made by the solver (i.e solution)
   *
   * @param msg stringstream to modify
   */
  virtual void printSolveSpecific(std::stringstream& msg) const = 0;

  /**
   * @brief print introduction information about the solver
   */
  void printHeader() const;

  /**
   * @brief print solver specific introduction information
   *
   * @param ss stringstream to modify
   */
  virtual void printHeaderSpecific(std::stringstream& ss) const = 0;

  /**
   * @brief print a summary of the execution statistics of the solver
   */
  void printEnd() const;

  /**
   * @brief Print all parameters values
   */
  void printParameterValues() const;

  /**
   * @brief getter for the current value of variables' derivatives
   * @return the current value of variables' derivatives
   */
  inline const std::vector<double>& getCurrentYP() {
    return vYp_;
  }

  /**
   * @brief getter for the current value of continuous variables
   * @return the current value of continuous derivatives
   */
  inline const std::vector<double>& getCurrentY() {
    return vYy_;
  }

  /**
   * @brief getter for the current internal time of the solver
   * @return current internal time of the solver
   */
  inline double getTSolve() const {
    return tSolve_;
  }

  /**
   * @brief set the timeline to use during the simulation (where events should be added/removed)
   *
   * @param timeline timeline to use
   */
  void setTimeline(const boost::shared_ptr<timeline::Timeline> &timeline);

  /**
   * @brief update the statistics
   */
  virtual void updateStatistics() = 0;

 protected:
  /**
   * @brief set a given parameter value
   *
   * @param parameter: the desired parameter
   * @param value : the value to set
   */
  template <typename T> void setParameterValue(ParameterSolver &parameter, const T &value);

  /**
   * @brief initialize all internal structure of the solver
   * @param t0 : initial time of the simulation
   * @param model : model to simulate, gives the size of all internal structure
   */
  void init(const double& t0, const boost::shared_ptr<Model> &model);

  /**
   * @brief delete all internal structure allocated by init method
   */
  void clean();

  /**
   * @brief getter for the model currently simulated
   * @return the model currently simulated
   */
  inline boost::shared_ptr<Model> getModel() const {
    return model_;
  }

  /**
   * @brief reset the execution statistics of the solver
   */
  void resetStats();

  /**
   * @brief evaluate discretes variables values and values of zero crossing functions
   * @param G0 previous value of zero crossing functions
   * @param G1 new value of zero crossing functions
   * @param time time to use to evaluate these values
   *
   * @return @b true zero crossing functions or discretes variables have changed
   */
  bool evalZMode(std::vector<state_g> &G0, std::vector<state_g> &G1, const double &time);
  /**
   * @brief print the unstable roots
   *
   * @param t current time
   * @param G0 previous value of zero crossing functions
   * @param G1 new value of zero crossing functions
   */
  void printUnstableRoot(double t, const std::vector<state_g>& G0, const std::vector<state_g>& G1) const;

 protected:
  /**
   * @brief Structure for storing solver statistics
   */
  typedef struct {
    long int nst_;  ///< number of steps
    long int nre_;  ///< number of residual evaluations
    long int nni_;  ///< number of nonlinear iterations
    long int nje_;  ///< number of Jacobian evaluations
    long int netf_;  ///< number of error test failures
    long int ncfn_;  ///< number of nonlinear convergence failures
    long int nge_;  ///< number of root function evaluations
    long int nze_;  ///< number of discrete variable evaluations
    long int nme_;  ///< number of mode evaluations
  } stat_t;

  /**
   * @brief Integrate the DAE over an interval in t
   *
   * @param tAim the next time at which a computed solution is desired
   * @param tNxt the time reached by the solver
   */
  virtual void solveStep(double tAim, double &tNxt) = 0;

  /**
   * @brief initialize the algebraic restoration solver with the good settings
   *
   * @param modeChangeType type of mode change
   * @return @b true if a Jacobian evaluation is not needed at the next time-domain time-step
   */
  virtual bool initAlgRestoration(modeChangeType_t modeChangeType) = 0;

  std::map<std::string, ParameterSolver> parameters_;  ///< map between parameters and parameters' names
  boost::shared_ptr<Model> model_;  ///< model currently simulated
  boost::shared_ptr<timeline::Timeline> timeline_;  ///< timeline where event messages should be added or removed

  std::vector<state_g> g0_;  ///< previous values of root functions
  std::vector<state_g> g1_;  ///< updated values of root functions

  N_Vector yy_;  ///< continuous variables values stored in sundials structure
  N_Vector yp_;  ///<  derivative of variables stored in sundials structure
  N_Vector yId_;  ///< property of variables (algebraic/differential) stored in sundials structure
  std::vector<double> vYy_;  ///< continuous variables values
  std::vector<double> vYp_;  ///< derivative of variables
  std::vector<DYN::propertyContinuousVar_t> vYId_;  ///< property of variables (algebraic/differential)

  // Parameters for the algebraic restoration
  double fnormtolAlg_;  ///< stopping tolerance on L2-norm of residual function
  double initialaddtolAlg_;  ///< stopping tolerance at initialization
  double scsteptolAlg_;  ///< scaled step length tolerance
  double mxnewtstepAlg_;  ///< maximum allowable scaled step length
  int msbsetAlg_;  ///< maximum number of nonlinear iterations that may be performed between calls to the linear solver setup routine
  int mxiterAlg_;  ///< maximum number of nonlinear iterations
  int printflAlg_;  ///< level of verbosity of output

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

  stat_t stats_;  ///< execution statistics of the solver
  double tSolve_;  ///< current internal time of the solver
  BitMask state_;  ///< current state value of the solver
  PreviousReinit previousReinit_;  ///< previous reinitialization status of the solver
};

}  // end of namespace DYN

#include "DYNSolver.hpp"

#endif  // SOLVERS_COMMON_DYNSOLVER_H_
