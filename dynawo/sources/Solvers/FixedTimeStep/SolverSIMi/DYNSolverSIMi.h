//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  DYNSolverSIMi.h
 *
 * @brief Interractive solver based on backward Euler integration method using KINSOL
 * to solve each step
 *
 */
#ifndef SOLVERS_FIXEDTIMESTEP_SOLVERSIM_DYNSOLVERSIM_SOLVERSIM_DYNSOLVERSIMI_H_
#define SOLVERS_FIXEDTIMESTEP_SOLVERSIM_DYNSOLVERSIM_SOLVERSIM_DYNSOLVERSIMI_H_

#include <vector>
#include <boost/shared_ptr.hpp>
#include <sundials/sundials_nvector.h>

#include "DYNSolverFactory.h"
#include "DYNSolverImpl.h"
#include "DYNEnumUtils.h"
#include "DYNSolverSIM.h"

namespace parameters {
class ParametersSet;
}

namespace DYN {
class SolverKINEuler;
class SolverKINAlgRestoration;

/**
 * @brief SolverSIMi factory class
 *
 */
class SolverSIMiFactory : public SolverFactory {
 public:
  /**
   * @brief Create an instance of solver
   * @return the new instance of solver created by the factory
   */
  Solver* create() const;

  /**
   * @brief SolverSIMi destroy
   */
  void destroy(Solver*) const;
};

/**
 * @brief class Solver SIMi : simplified solver
 */
class SolverSIMi : public SolverSIM {
 public:
  /**
   * @brief default constructor
   */
  SolverSIMi();

  /**
   * @copydoc Solver::Impl::solverType()
   */
  std::string solverType() const;

  /**
   * @copydoc Solver::init(const boost::shared_ptr<Model>& model, const double t0, const double tEnd)
   */
  void init(const boost::shared_ptr<Model>& model, const double t0, const double tEnd);

  /**
   * @copydoc Solver::Impl::defineSpecificParameters()
   */
  void defineSpecificParameters();

  /**
   * @copydoc Solver::Impl::setSolverSpecificParameters()
   */
  void setSolverSpecificParameters();

  /**
   * @copydoc Solver::calculateIC()
   */
  void calculateIC(double tEnd);

  /**
   * @brief save the initial values of y before the time step
   */
  void saveContinuousVariables();


  /**
   * @brief restore y to their initial values
   */
  void restoreContinuousVariables();

  /**
  * @brief SIM version of computePrediction. We just fill
  * Yp with 0.
  */
  void computePrediction();

  /**
  * @copydoc SolverCommonFixedTimeStep::hasPrediction()
  */
  bool hasPrediction() const;

  /**
  * @copydoc Solver::computeYP()
  */
  void computeYP(const double* yy);

  /**
  * @brief name of the solver
  * @return name of the solver
  */
  inline std::string getName() {
    static std::string name = "SIMi";
    return name;
  }

/**
  * @brief update the derivatives values.
  */
  void updateVelocity();

 private:
  /**
   * @copydoc Solver::getTimeStep()
   */
  double getTimeStep() const {
    return h_;
  }

  /**
   * @copydoc Solver::Impl::solveStep(double tAim, double &tNxt)
   */
  void solveStep(double tAim, double &tNxt);

  bool order1Prediction_;  ///< enable to use order 1 prediction
};

}  // end of namespace DYN

#endif  // SOLVERS_FIXEDTIMESTEP_SOLVERSIM_DYNSOLVERSIM_SOLVERSIM_DYNSOLVERSIMI_H_
