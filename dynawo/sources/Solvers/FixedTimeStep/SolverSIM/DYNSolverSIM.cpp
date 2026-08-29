//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNSolverSIM.cpp
 *
 * @brief Simplified solver implementation
 *
 * Simplified solver is based on Backward Euler Method
 *
 */

#include "DYNSolverSIM.h"

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

using std::make_pair;

/**
 * @brief SolverSIMFactory getter
 * @return A pointer to a new instance of SolverSIMFactory
 */
extern "C" DYN::SolverFactory* getFactory() {
  return (new DYN::SolverSIMFactory());
}

/**
 * @brief SolverSIMFactory destroy method
 */
extern "C" void deleteFactory(DYN::SolverFactory* factory) {
  delete factory;
}

/**
 * @brief SolverSIM getter
 * @return A pointer to a new instance of SolverSIM
 */
extern "C" DYN::Solver* DYN::SolverSIMFactory::create() const {
  DYN::Solver* solver(new DYN::SolverSIM());
  return solver;
}

/**
 * @brief SolverSIM destroy method
 */
extern "C" void DYN::SolverSIMFactory::destroy(DYN::Solver* solver) const {
  delete solver;
}

namespace DYN {

SolverSIM::SolverSIM() :
SolverCommonFixedTimeStep(),
order1Prediction_(false) {}

const std::string&
SolverSIM::solverType() const {
  static std::string solverType = "SimplifiedSolver";
  return solverType;
}

void
SolverSIM::init(const std::shared_ptr<Model>& model, const double t0, const double tEnd) {
  initCommon(model, t0, tEnd);
}

void
SolverSIM::defineSpecificParameters() {
  defineSpecificParametersCommon();

  const bool optional = false;  // name of the parameter indicates its purpose not its value
  parameters_.insert(make_pair("order1Prediction", ParameterSolver("order1Prediction", VAR_TYPE_BOOL, optional)));
}

void
SolverSIM::setSolverSpecificParameters() {
  setSolverSpecificParametersCommon();

  const ParameterSolver& order1Prediction = findParameter("order1Prediction");
  if (order1Prediction.hasValue())
    order1Prediction_ = order1Prediction.getValue<bool>();
}

void
SolverSIM::calculateIC(double /*tEnd*/) {
  calculateICCommon();
  setDifferentialVariablesIndices();

  if (hasPrediction()) {
    getSolverKINYPrim().setupNewAlgebraicRestoration(fnormtolAlg_, initialaddtolAlg_, scsteptolAlg_, mxnewtstepAlg_, msbsetAlg_,
                                                     mxiterAlg_, printflAlg_);
  }
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

    if (hasPrediction()) {
      SolverKINAlgRestoration& solverKINYPrim = getSolverKINYPrim();

      // Velocity initialization with solverKINYPrim_
      solverKINYPrim.setInitialValues(tSolve_, vectorY_, vectorYp_);
      const bool noInitSetup = false;
      const bool evaluateOnlyMode = false;
      solverKINYPrim.solve(noInitSetup, evaluateOnlyMode);
      solverKINYPrim.getValues(vectorY_, vectorYp_);
    }

    if (calculateICCommonModeChange(counter, change)) {
      break;
    }
  } while (change);

  Trace::debug() << DYNLog(EndCalculateIC) << Trace::endline;
#if _DEBUG_
  solverKINAlgRestoration_->setCheckJacobian(false);
#endif
}

bool SolverSIM::hasPrediction() const {
  return order1Prediction_;
}

void
SolverSIM::solveStep(double tAim, double &tNxt) {
  solveStepCommon(tAim, tNxt);

  // Velocity recalculated after each time step.
  if (!skipNextNR_ && hasPrediction())
    updateVelocity();
}

void
SolverSIM::computeYP(const double* yy) {
  // YP[i] = (y[i]-yprec[i])/h for each differential variable
  assert(h_ > 0.);
  for (unsigned int i = 0; i < differentialVariablesIndices_.size(); ++i) {
    vectorYp_[differentialVariablesIndices_[i]] = (yy[differentialVariablesIndices_[i]] - vectorYSave_[differentialVariablesIndices_[i]]) / h_;
  }
}

void
SolverSIM::updateVelocity() {
  computeYP(&vectorY_[0]);
}

void
SolverSIM::computePrediction() {
  if (hasPrediction()) {
    // order-1 prediction - Y0_{n+1} = Y_n + h * Yp_n
    for (unsigned int i = 0; i < differentialVariablesIndices_.size(); ++i) {
      vectorY_[differentialVariablesIndices_[i]] += h_ * vectorYp_[differentialVariablesIndices_[i]];
    }
  } else {
    // order-0 prediction - YP = 0
    // and Y0_{n+1} = Y_n (natively true so nothing to do)
    std::fill(vectorYp_.begin(), vectorYp_.end(), 0.);
  }
}

void
SolverSIM::saveContinuousVariables() {
  vectorYSave_.assign(vectorY_.begin(), vectorY_.end());
  if (hasPrediction())
    vectorYpSave_.assign(vectorYp_.begin(), vectorYp_.end());
}

void
SolverSIM::restoreContinuousVariables() {
  vectorY_.assign(vectorYSave_.begin(), vectorYSave_.end());
  if (hasPrediction())
    vectorYp_.assign(vectorYpSave_.begin(), vectorYpSave_.end());
}

}  // end namespace DYN
