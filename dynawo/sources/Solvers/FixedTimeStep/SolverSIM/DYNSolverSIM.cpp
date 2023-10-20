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

#include <boost/shared_ptr.hpp>

#include "PARParametersSet.h"
#include "PARParameter.h"

#include "DYNMacrosMessage.h"
#include "DYNSolverKINEuler.h"
#include "DYNSolverKINAlgRestoration.h"
#include "DYNTrace.h"
#include "DYNModel.h"

using boost::shared_ptr;

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

std::string
SolverSIM::solverType() const {
  return "SimplifiedSolver";
}

void
SolverSIM::init(const boost::shared_ptr<Model>& model, const double t0, const double tEnd) {
  initCommon(model, t0, tEnd);
}

void
SolverSIM::calculateIC(double /*tEnd*/) {
  calculateICCommon();
  setDifferentialVariablesIndices();
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
SolverSIM::solveStep(double tAim, double &tNxt) {
  solveStepCommon(tAim, tNxt);
}

void
SolverSIM::computeYP(const double* yy) {
  // YP[i] = (y[i]-yprec[i])/h for each differential variable
  assert(h_ > 0.);
  for (unsigned int i = 0; i < differentialVariablesIndices_.size(); ++i) {
    vectorYp_[differentialVariablesIndices_[i]] = (yy[differentialVariablesIndices_[i]] - ySave_[differentialVariablesIndices_[i]]) / h_;
  }
}

void
SolverSIM::computePrediction() {
  // order-0 prediction - YP = 0
  // and Y0_{n+1} = Y_n (natively true so nothing to do)
  std::fill(vectorYp_.begin(), vectorYp_.end(), 0.);
}

}  // end namespace DYN
