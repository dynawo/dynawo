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

#include <vector>
#include <map>
#include <string>
#include <boost/shared_ptr.hpp>

#include "DYNBitMask.h"
#include "DYNEnumUtils.h"

namespace parameters {
class ParametersSet;
}

namespace timeline {
class Timeline;
}  // namespace timeline

namespace DYN {
static const int maxNumberUnstableRoots = 10;  ///< Maximum number of unstable roots for one time step
static const double minimalAcceptableStep = 1e-6;  ///< Minimum time step to consider that the solver is not blocked
static const int maximumNumberSlowStepIncrease = 10;  ///< Maximum number of consecutive time-steps with a time step lower than minimalAcceptableStep

/**
 * @brief Flags of the current numerical resolution
 */
typedef enum {
  NoChange = 0x00,
  ModeChange = 0x01,
  ZChange = 0x02,
  SilentZChange = 0x04
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

class Model;
class ParameterSolver;

/**
 * @class Solver
 * @brief Solver interface class
 *
 * Interface class for solver using ind Dynawo
 */
class Solver {
 public:
  /**
   * @brief destructor
   *
   */
  virtual ~Solver() { }

  /**
   * @brief get the current solver's state
   * @return solver state
   */
  virtual const BitMask& getState() const = 0;

  /**
   * @brief set the previous reinitialization status
   * @param previousReinit : new previous reinitialization status
   */
  virtual void setPreviousReinit(const PreviousReinit& previousReinit) = 0;

  /**
   * @brief get the previous reinitialization status
   * @return previous reinitialization status
   */
  virtual const PreviousReinit& getPreviousReinit() const = 0;

  /**
   * @brief set the solver's parameters
   *
   * @param params : parameter set used to set the solver's parameters
   */
  virtual void setParameters(const boost::shared_ptr<parameters::ParametersSet> &params) = 0;

  /**
   * @brief define each parameters of the solver
   */
  virtual void defineParameters() = 0;

  /**
   * @brief define common parameters for all solvers
   */
  virtual void defineCommonParameters() = 0;

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
  virtual bool hasParameter(const std::string &nameParameter) = 0;

  /**
   * @brief Getter for attribute parameters_
   *
   * @return solver attribute parameters_
   */
  virtual const std::map<std::string, ParameterSolver>& getParametersMap() const = 0;

  /**
   * @brief check whether parameters are used
   *
   * If a parameter is not used, add a debug trace
   *
   * @param params : parameter set to check
   */
  virtual void checkUnusedParameters(boost::shared_ptr<parameters::ParametersSet> params) = 0;

  /**
   * @brief search for a parameter with a given name
   *
   * @param name: name of the desired parameter
   * @return desired parameter
   */
  virtual ParameterSolver& findParameter(const std::string &name) = 0;

  /**
   * @brief set a parameter value from a parameters set
   *
   * @param parName: the name of the parameter to be set
   * @param parametersSet: the set to scan for a value
   */
  virtual void setParameterFromSet(const std::string &parName, const boost::shared_ptr<parameters::ParametersSet> parametersSet) = 0;

  /**
   * @brief set all parameters values from a parameters set (API PAR)
   *
   * @param params : parameter set to check
  */
  virtual void setParametersFromPARFile(const boost::shared_ptr<parameters::ParametersSet> &params) = 0;

  /**
   * @brief set the solver parameters value
  */
  virtual void setSolverParameters() = 0;

  /**
   * @brief set the solver common parameters value
   */
  virtual void setSolverCommonParameters() = 0;

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
  virtual void solve(double tAim, double &tNxt) = 0;

  /**
   * @brief Restore the equations after an algebraic mode - reinitialize the DAE problem (new initial point)
   */
  virtual void reinit() = 0;

  /**
   * @brief print the latest step made by the solver (i.e solution)
   */
  virtual void printSolve() const = 0;

  /**
   * @brief print specific info regarding the latest step made by the solver (i.e solution)
   *
   * @param msg stringstream to modify
   */
  virtual void printSolveSpecific(std::stringstream& msg) const = 0;

  /**
   * @brief print introduction information about the solver
   */
  virtual void printHeader() const = 0;

  /**
   * @brief print solver specific introduction information
   *
   * @param ss stringstream to modify
   */
  virtual void printHeaderSpecific(std::stringstream& ss) const = 0;

  /**
   * @brief print a summary of the execution statistics of the solver
   */
  virtual void printEnd() const = 0;

  /**
   * @brief Print all parameters values
   */
  virtual void printParameterValues() const = 0;

  /**
   * @brief getter for the current value of variables' derivatives
   * @return the current value of variables' derivatives
   */
  virtual const std::vector<double>& getCurrentYP() = 0;

  /**
   * @brief getter for the current value of continuous variables
   * @return the current value of continuous derivatives
   */
  virtual const std::vector<double>& getCurrentY() = 0;

  /**
   * @brief getter for the current internal time of the solver
   * @return current internal time of the solver
   */
  virtual double getTSolve() const = 0;

  /**
   * @brief set the timeline to use during the simulation (where events should be added/removed)
   *
   * @param timeline timeline to use
   */
  virtual void setTimeline(const boost::shared_ptr<timeline::Timeline> &timeline) = 0;

  /**
   * @brief initialize the algebraic restoration solver with the good settings
   *
   * @param modeChangeType type of mode change
   * @return @b true if a Jacobian evaluation is not needed at the next time-domain time-step
   */
  virtual bool initAlgRestoration(modeChangeType_t modeChangeType) = 0;

  /**
   * @brief update the statistics
   */
  virtual void updateStatistics() = 0;

  class Impl;
};

}  // end of namespace DYN

#endif  // SOLVERS_COMMON_DYNSOLVER_H_
