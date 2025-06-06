//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNSolverTRAP.h
 *
 * @brief Solver based on trapezoidal method integration method using KINSOL
 * to solve each step
 *
 */
#ifndef SOLVERS_FIXEDTIMESTEP_SOLVERTRAP_DYNSOLVERTRAP_H_
#define SOLVERS_FIXEDTIMESTEP_SOLVERTRAP_DYNSOLVERTRAP_H_

#include <vector>
#include <boost/shared_ptr.hpp>
#include <sundials/sundials_nvector.h>

#include "DYNSolverFactory.h"
#include "DYNSolverImpl.h"
#include "DYNEnumUtils.h"
#include "DYNSolverCommonFixedTimeStep.h"

namespace parameters {
class ParametersSet;
}

namespace DYN {
class SolverKINEuler;
class SolverKINAlgRestoration;

/**
 * @brief SolverTRAP factory class
 *
 */
class SolverTRAPFactory : public SolverFactory {
 public:
  /**
   * @brief Create an instance of solver
   * @return the new instance of solver created by the factory
   */
  Solver* create() const override;

  /**
   * @brief SolverTRAP destroy
   */
  void destroy(Solver*) const override;
};

/**
 * @brief class Solver TRAP : trapezoidal solver
 */
class SolverTRAP : public SolverCommonFixedTimeStep {
 public:
  /**
   * @copydoc Solver::Impl::solverType()
   */
  const std::string& solverType() const override;

  /**
   * @copydoc Solver::init(const std::shared_ptr<Model>& model, const double t0, const double tEnd)
  */
  void init(const std::shared_ptr<Model>& model, double t0, double tEnd) override;

  /**
   * @copydoc Solver::Impl::defineSpecificParameters()
   */
  void defineSpecificParameters() override;

  /**
   * @copydoc Solver::Impl::setSolverSpecificParameters()
   */
  void setSolverSpecificParameters() override;

  /**
   * @copydoc Solver::calculateIC()
  */
  void calculateIC(double tEnd) override;

  /**
  * @copydoc Solver::computeYP()
  */
  void computeYP(const double* yy) override;

  /**
   * @brief update the derivatives values.
  */
  void updateVelocity();

  /**
  * @brief TRAP version of computePrediction. We just compute the
  * first Yp.
  */
  void computePrediction() override {
    // do nothing
  }

  /**
  * @copydoc SolverCommonFixedTimeStep::hasPrediction()
  */
  bool hasPrediction() const override { return false; }

  /**
  * @brief name of the solver
  * @return name of the solver
  */
  inline const std::string& getName() override {
    static std::string name = "TRAP";
    return name;
  }

 private:
  /**
   * @copydoc Solver::getTimeStep()
   */
  double getTimeStep() const override {
    return h_ / 2.;
  }

  /**
   * @copydoc Solver::Impl::solveStep(double tAim, double &tNxt)
   */
  void solveStep(double tAim, double &tNxt) override;

  /**
  * @copydoc SolverCommonFixedTimeStep::saveContinuousVariables()
  */
  void saveContinuousVariables() override;

  /**
  * @copydoc SolverCommonFixedTimeStep::restoreContinuousVariables()
  */
  void restoreContinuousVariables() override;

 private:
  boost::shared_ptr<SolverKINAlgRestoration> solverKINYPrimInit_;  ///< Newton-Raphson solver for the derivatives of the differential variables restoration
};

}  // end of namespace DYN

#endif  // SOLVERS_FIXEDTIMESTEP_SOLVERTRAP_DYNSOLVERTRAP_H_
