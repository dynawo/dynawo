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
 * @file  DYNSolverTRAP.cpp
 *
 * @brief Trapezoidal solver implementation
 *
 * Trapezoidal solver is based on Trapezoidal Method that is nearly the same as Back Euler one.
 *
 */

#include "DYNSolverTRAP.h"

#include <cmath>
#include <iostream>
#include <iomanip>
#include <vector>

#include "PARParametersSet.h"
#include "PARParameter.h"

#include "DYNMacrosMessage.h"
#include "DYNSolverKINEuler.h"
#include "DYNSolverKINAlgRestoration.h"
#include "DYNTrace.h"
#include "DYNModel.h"


/**
 * @brief SolverTRAPFactory getter
 * @return A pointer to a new instance of SolverTRAPFactory
 */
extern "C" DYN::SolverFactory* getFactory() {
  return (new DYN::SolverTRAPFactory());
}

/**
 * @brief SolverTRAPFactory destroy method
 */
extern "C" void deleteFactory(DYN::SolverFactory* factory) {
  delete factory;
}

/**
 * @brief SolverTRAP getter
 * @return A pointer to a new instance of SolverTRAP
 */
extern "C" DYN::Solver* DYN::SolverTRAPFactory::create() const {
  DYN::Solver* solver(new DYN::SolverTRAP());
  return solver;
}

/**
 * @brief SolverTRAP destroy method
 */
extern "C" void DYN::SolverTRAPFactory::destroy(DYN::Solver* solver) const {
  delete solver;
}

namespace DYN {

std::string
SolverTRAP::solverType() const {
  return "TrapezoidalSolver";
}

void
SolverTRAP::init(const std::shared_ptr<Model>& model, const double t0, const double tEnd) {
  initCommon(model, t0, tEnd);

  solverKINYPrimInit_.reset(new SolverKINAlgRestoration(false));
  solverKINYPrimInit_->init(model_, SolverKINAlgRestoration::KIN_DERIVATIVES);
}

void
SolverTRAP::calculateIC(double /*tEnd*/) {
  calculateICCommon();
  setDifferentialVariablesIndices();

  vectorYpSave_.assign(vectorYp_.begin(), vectorYp_.end());
  solverKINYPrimInit_->setupNewAlgebraicRestoration(fnormtolAlg_, initialaddtolAlg_, scsteptolAlg_, mxnewtstepAlg_, msbsetAlg_,
                                                mxiterAlg_, printflAlg_);

#if _DEBUG_
  solverKINAlgRestoration_->setCheckJacobian(true);
#endif

  int counter = 0;
  bool change = true;
  // Loop as long as there is a z or a mode change
  do {
    Trace::debug() << DYNLog(CalculateICIteration, counter) << Trace::endline;

    // Global initialization - continuous part
    solverKINAlgRestoration_->setInitialValues(tSolve_, vectorY_, vectorYp_);
    solverKINAlgRestoration_->solve();
    solverKINAlgRestoration_->getValues(vectorY_, vectorYp_);

    // Velocity initialization with solverKINYPrim_
    solverKINYPrimInit_->setInitialValues(tSolve_, vectorY_, vectorYp_);
    bool noInitSetup = false;
    bool evaluateOnlyMode = false;
    solverKINYPrimInit_->solve(noInitSetup, evaluateOnlyMode);
    solverKINYPrimInit_->getValues(vectorY_, vectorYp_);
    vectorYpSave_.assign(vectorYp_.begin(), vectorYp_.end());

    if (calculateICCommonModeChange(counter, change)) {
      break;
    }
  } while (change);

  Trace::debug() << DYNLog(EndCalculateIC) << Trace::endline;
#if _DEBUG_
  solverKINAlgRestoration_->setCheckJacobian(false);
#endif
}

void
SolverTRAP::defineSpecificParameters() {
  defineSpecificParametersCommon();
}

void
SolverTRAP::setSolverSpecificParameters() {
  setSolverSpecificParametersCommon();
}

void SolverTRAP::solveStep(double tAim, double& tNxt) {
  solveStepCommon(tAim, tNxt);

  // Velocity recalculated after each time step.
  if (!skipNextNR_)
    updateVelocity();
}

void
SolverTRAP::computeYP(const double* yy) {
  assert(h_ > 0.);
  // Velocity_n[i] = 2(y[i] - yprev[i])/h - velocity_n[i]
  for (unsigned int i = 0; i < differentialVariablesIndices_.size(); ++i) {
    vectorYp_[differentialVariablesIndices_[i]] =
        (2. / h_) * (yy[differentialVariablesIndices_[i]] - vectorYSave_[differentialVariablesIndices_[i]]) - vectorYpSave_[differentialVariablesIndices_[i]];
  }
}

void
SolverTRAP::updateVelocity() {
  computeYP(&vectorY_[0]);
}

void
SolverTRAP::saveContinuousVariables() {
  vectorYSave_.assign(vectorY_.begin(), vectorY_.end());
  vectorYpSave_.assign(vectorYp_.begin(), vectorYp_.end());
}

void
SolverTRAP::restoreContinuousVariables() {
  vectorY_.assign(vectorYSave_.begin(), vectorYSave_.end());
  vectorYp_.assign(vectorYpSave_.begin(), vectorYpSave_.end());
}

}  // end namespace DYN
