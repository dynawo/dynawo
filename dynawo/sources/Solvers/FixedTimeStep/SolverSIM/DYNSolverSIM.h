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
 * @file  DYNSolverSIM.h
 *
 * @brief Solver based on backward Euler integration method using KINSOL
 * to solve each step
 *
 */
#ifndef SOLVERS_FIXEDTIMESTEP_SOLVERSIM_DYNSOLVERSIM_H_
#define SOLVERS_FIXEDTIMESTEP_SOLVERSIM_DYNSOLVERSIM_H_

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
 * @brief SolverSIM factory class
 *
 */
class SolverSIMFactory : public SolverFactory {
 public:
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
class SolverSIM : public SolverCommonFixedTimeStep {
 public:
  /**
   * @copydoc Solver::Impl::solverType()
   */
  std::string solverType() const;

  /**
   * @copydoc Solver::init(const boost::shared_ptr<Model>& model, const double t0, const double tEnd)
   */
  void init(const boost::shared_ptr<Model>& model, const double t0, const double tEnd);

  /**
   * @copydoc Solver::calculateIC()
   */
  void calculateIC(double tEnd);

  /**
  * @brief SIM version of computePrediction. We just fill
  * Yp with 0.
  */
  void computePrediction();

  /**
  * @copydoc Solver::computeYP()
  */
  void computeYP(const double* yy);

  /**
  * @brief name of the solver
  * @return name of the solver
  */
  inline std::string getName() {
    static std::string name = "SIM";
    return name;
  }

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
};

}  // end of namespace DYN

#endif  // SOLVERS_FIXEDTIMESTEP_SOLVERSIM_DYNSOLVERSIM_H_
