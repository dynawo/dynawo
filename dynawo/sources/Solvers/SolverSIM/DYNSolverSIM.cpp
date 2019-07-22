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
 * @file  DYNSolverSIM.cpp
 *
 * @brief Simplified solver implementation
 *
 * Simplified solver is based on Backward Euler Method
 *
 */

#include "DYNSolverSIM.h"

#include <cmath>
#include <fstream>
#include <iostream>
#include <iomanip>
#include <set>
#include <sstream>
#include <vector>
#include <algorithm>

#include <boost/shared_ptr.hpp>

#include <nvector/nvector_serial.h>
#include <sundials/sundials_types.h>
#include <sundials/sundials_math.h>

#include "PARParametersSet.h"
#include "PARParameter.h"
#include "TLTimeline.h"

#include "DYNMacrosMessage.h"
#include "DYNSparseMatrix.h"
#include "DYNSolverEulerKIN.h"
#include "DYNSolverKIN.h"
#include "DYNTrace.h"
#include "DYNModel.h"

using boost::shared_ptr;
using std::endl;
using std::max;
using std::min;
using std::ofstream;
using std::stringstream;
using std::set;
using std::setw;
using std::setfill;
using std::vector;
using std::map;
using std::string;
using std::make_pair;

using parameters::ParametersSet;
using timeline::Timeline;

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

SolverSIMFactory::SolverSIMFactory() {
}

SolverSIMFactory::~SolverSIMFactory() {
}

SolverSIM::SolverSIM() {
  solverKIN_.reset(new SolverKIN());
}

SolverSIM::~SolverSIM() {
}

void
SolverSIM::defineParameters() {
  parameters_.insert(make_pair("hMin", ParameterSolver("hMin", VAR_TYPE_DOUBLE)));
  parameters_.insert(make_pair("hMax", ParameterSolver("hMax", VAR_TYPE_DOUBLE)));
  parameters_.insert(make_pair("kReduceStep", ParameterSolver("kReduceStep", VAR_TYPE_DOUBLE)));
  parameters_.insert(make_pair("nEff", ParameterSolver("nEff", VAR_TYPE_INT)));
  parameters_.insert(make_pair("nDeadband", ParameterSolver("nDeadband", VAR_TYPE_INT)));
  parameters_.insert(make_pair("maxRootRestart", ParameterSolver("maxRootRestart", VAR_TYPE_INT)));
  parameters_.insert(make_pair("maxNewtonTry", ParameterSolver("maxNewtonTry", VAR_TYPE_INT)));
  parameters_.insert(make_pair("linearSolverName", ParameterSolver("linearSolverName", VAR_TYPE_STRING)));
  parameters_.insert(make_pair("recalculateStep", ParameterSolver("recalculateStep", VAR_TYPE_BOOL)));
}

void
SolverSIM::setSolverParameters() {
  hMin_ = findParameter("hMin").getValue<double>();
  hMax_ = findParameter("hMax").getValue<double>();
  kReduceStep_ = findParameter("kReduceStep").getValue<double>();
  nEff_ = findParameter("nEff").getValue<int>();
  nDeadband_ = findParameter("nDeadband").getValue<int>();
  maxRootRestart_ = findParameter("maxRootRestart").getValue<int>();
  maxNewtonTry_ =  findParameter("maxNewtonTry").getValue<int>();
  linearSolverName_ = findParameter("linearSolverName").getValue<std::string>();
  recalculateStep_ = findParameter("recalculateStep").getValue<bool>();
}

std::string
SolverSIM::solverType() const {
  return "SimplifiedSolver";
}

void
SolverSIM::init(const shared_ptr<Model> &model, const double & t0, const double & tEnd) {
  tSolve_ = t0;
  tEnd_ = tEnd;
  h_ = hMax_;
  hNew_ = hMax_;
  nNewt_ = 0;
  countRestart_ = 0;
  factorizationForced_ = false;

  if (model->sizeY() != 0) {
    solverEulerKIN_.reset(new SolverEulerKIN());
    solverEulerKIN_->init(model, linearSolverName_);
    solverEulerKIN_->setIdVars();
  }

  Solver::Impl::init(t0, model);
  Solver::Impl::resetStats();
  g0_.assign(model_->sizeG(), NO_ROOT);
  g1_.assign(model_->sizeG(), NO_ROOT);
#ifdef _DEBUG_
  Trace::debug() << DYNLog(SolverSIMInitOK) << Trace::endline;
#endif
}

void
SolverSIM::calculateIC() {
  Trace::debug() << DYNLog(CalculateIC) << Trace::endline;
  // Root evaluation before the initialization
  // --------------------------------
  ySave_.assign(vYy_.begin(), vYy_.end());
  int counter = 0;
  bool change = true;

  // Updating discrete variable values and mode
  model_->evalG(tSolve_, vYy_, vYp_, vYz_, g0_);
  evalZMode(g0_, g1_, tSolve_);

  model_->rotateBuffers();

  solverKIN_->init(model_, SolverKIN::KIN_NORMAL, 1e-5, 1e-5, 200, 10, 0, 0, 0);

  do {
    Trace::debug() << DYNLog(CalculateICIteration, counter) << Trace::endline;

    // Global initialization
    solverKIN_->setInitialValues(tSolve_, vYy_, vYp_);
    solverKIN_->solve();
    solverKIN_->getValues(vYy_, vYp_);

    change = false;
    model_->evalG(tSolve_, vYy_, vYp_, vYz_, g1_);
    bool rootFound = !(std::equal(g0_.begin(), g0_.end(), g1_.begin()));
    if (rootFound) {
      g0_.assign(g1_.begin(), g1_.end());
      change = evalZMode(g0_, g1_, tSolve_);
    }

    ++counter;
    if (counter >= 100)
      throw DYNError(Error::SOLVER_ALGO, SolverSIMUnstableRoots);

    model_->rotateBuffers();
  } while (change);

  Trace::debug() << DYNLog(EndCalculateIC) << Trace::endline;

  model_->setModeChangeType(NO_MODE);
  solverKIN_->clean();
}

void SolverSIM::solve(double /*tAim*/, double& tNxt) {
  if (recalculateStep_)
    solveWithStepRecalculation(tNxt);
  else
    solveWithoutStepRecalculation(tNxt);
}

void SolverSIM::solveWithoutStepRecalculation(double& tNxt) {
  int counter = 0;
  saveInitialValues();
  bool redoStep = false;

  do {
    // If we have more than maxNewtonTry consecutive divergence or root changes, the simulation is stopped
    ++counter;
    if (counter >= maxNewtonTry_)
      throw DYNError(Error::SOLVER_ALGO, SolverSIMConvFail, maxNewtonTry_);

    // New time step value
    h_ = hNew_;

    // Call the Newton-Raphson solver and analyze the root evolution
    SolverStatus_t status = solve();

    switch (status) {
      /* NON_CONV: the Newton-Raphson algorithm fails to converge
       *   => The time step is decreased
       *   => The LU decomposition is forced for the next time steps
       *   => The initial point for the next time step (h = h/2) is the initial point from the previous accepted time step
      */
      case NON_CONV: {
        if (doubleEquals(h_, hMin_)) {
          throw DYNError(Error::SOLVER_ALGO, SolverSIMConvFailMin);   // Divergence or unstable root at minimum step length, fail to resolve problem
        }
        factorizationForced_ = true;
        redoStep = true;
        updateStepDivergence();
        restoreInitialValues(true, true);
        break;
      }
      /*
       * CONV: the Newton-Rapshon algorithm converges and there is no discrete value or mode change
       * => The time step is increased (if possible)
       * => The LU decomposition is avoided for the next time steps (we have come back to a stabilized situation)
      */
      case CONV: {
        factorizationForced_ = false;
        redoStep = false;
        updateStepConvergence();
        break;
      }
      /*
       * ROOT_ALG: algebraic change
       * => a restoration of the algebraic variables will be called by the simulation
       * => The current time step is accepted.
       * => The next time step will be done with the current time step (neither increase nor decrease)
      */
      case ROOT_ALG: {
        factorizationForced_ = true;
        redoStep = false;
        break;
      }
      /*
       * ROOT: a root has been detected (discrete variable change at the moment)
       * => The current time step is not recalculated
       * => The LU decomposition status is kept constant or not (depending on the overall strategy - recalculateStep parameter)
       * => The next time step will be done with the current time step (neither increase nor decrease)
      */
      case ROOT: {
        redoStep = false;
        factorizationForced_ = false;
        break;
      }
    }
  } while (redoStep);

    // Limitation to end up the simulation at tEnd
    hNew_ = min(hNew_, tEnd_ - (tSolve_ + hNew_));
    tNxt = tSolve_ + h_;
    ++stats_.nst_;
  }

void SolverSIM::solveWithStepRecalculation(double& tNxt) {
  int counter = 0;
  saveInitialValues();
  bool redoStep = false;
  // Save the initial number of events in the timeline in case we need to come back in the past
  int initialEventsSize = 0;
  int finalEventsSize = 0;
  if (timeline_)
    initialEventsSize = timeline_->getSizeEvents();

  do {
    // If we have more than maxNewtonTry consecutive divergence or root changes, the simulation is stopped
    ++counter;
    if (counter >= maxNewtonTry_)
      throw DYNError(Error::SOLVER_ALGO, SolverSIMConvFail, maxNewtonTry_);

    // New time step value
    h_ = hNew_;

    // Call the Newton-Raphson solver and analyze the root evolution
    SolverStatus_t status = solve();

    switch (status) {
      /* NON_CONV: the Newton-Raphson algorithm fails to converge
       *   => The time step is decreased
       *   => The LU decomposition is forced for the next time steps
       *   => The initial point for the next time step (h = h/2) is the initial point from the previous accepted time step
       *   => In case we use the recalculateStep strategy, timeline events must be deleted.
      */
      case NON_CONV: {
        if (doubleEquals(h_, hMin_)) {
          throw DYNError(Error::SOLVER_ALGO, SolverSIMConvFailMin);   // Divergence or unstable root at minimum step length, fail to resolve problem
        }
        countRestart_ = 0;
        factorizationForced_ = true;
        redoStep = true;
        updateStepDivergence();
        restoreInitialValues(true, true);

        // Erase timeline messages that could have been added between the previous accepted time step and the non convergence
        if (timeline_) {
          finalEventsSize = timeline_->getSizeEvents();
          if (finalEventsSize != initialEventsSize)
            timeline_->eraseEvents(finalEventsSize - initialEventsSize, timeline_->cendEvent());
        }
        break;
      }
      /*
       * CONV: the Newton-Rapshon algorithm converges and there is no discrete value or mode change
       * => The time step is increased (if possible)
       * => The LU decomposition is avoided for the next time steps (we have come back to a stabilized situation)
       */
      case CONV: {
        countRestart_ = 0;
        factorizationForced_ = false;
        redoStep = false;
        updateStepConvergence();
        break;
      }
      /*
       * ROOT_ALG: algebraic change
       * => a restoration of the algebraic variables will be called by the simulation
       * => The current time step is accepted.
       * => The next time step will be done with the current time step (neither increase nor decrease)
       */
      case ROOT_ALG: {
        countRestart_ = 0;
        factorizationForced_ = true;
        redoStep = false;
        break;
      }
      /*
       * ROOT: a root has been detected (discrete variable change at the moment)
       * => The current time step is recalculated
       * => The LU decomposition status is kept constant or not (depending on the overall strategy - recalculateStep parameter)
       * => The next time step will be done with the current time step (neither increase nor decrease)
       */
      case ROOT: {
          // Number of discrete variable values / mode change greater than maxRootRestart
          if (countRestart_ >= maxRootRestart_) {
            countRestart_ = 0;
            factorizationForced_ = true;
            redoStep = false;
          } else {
            countRestart_++;
            redoStep = true;
            restoreInitialValues(false, false);
          }
        break;
      }
    }
  } while (redoStep);

  // Limitation to end up the simulation at tEnd
  hNew_ = min(hNew_, tEnd_ - (tSolve_ + hNew_));

  tNxt = tSolve_ + h_;
  ++stats_.nst_;
}

SolverSIM::SolverStatus_t
SolverSIM::solve() {
  /*
   * Call the Newton-Raphson solver for the time step
   * Returns y and yp updated values
   */

  int flag = 0;
  if (model_->sizeY() != 0)
    flag = SIMCorrection();

  if (flag != 0) {
    stats_.ncfn_++;
    return (NON_CONV);
  } else {
    // Dealing with discrete variable value and mode changes

    // Evaluate root values after the time step (using updated y and yp)
    model_->evalG(tSolve_ + h_, vYy_, vYp_, vYz_, g1_);
    ++stats_.nge_;

    // Check if there has been any root change
    bool rootFound = !(std::equal(g0_.begin(), g0_.end(), g1_.begin()));

    // No root change -> no discrete variable change and no mode change
    if (!rootFound) {
      return (CONV);
    } else {
      // A root change has occurred - Dealing with propagation and algebraic mode detection

#ifdef _DEBUG_
      for (int i = 0; i < model_->sizeG(); ++i) {
        if (g0_[i] != g1_[i]) {
          Trace::debug() << "SolverSIM: rootsfound -> g[" << i << "] =" << g1_[i] << Trace::endline;

          std::string subModelName("");
          int localGIndex(0);
          std::string gEquation("");
          model_->getGInfos(i, subModelName, localGIndex, gEquation);
          Trace::debug() << DYNLog(RootGeq, i, subModelName, gEquation) << Trace::endline;
        }
      }
#endif
      /* Save the new values of the root in g0 for comparison after the evalZMode
       * Calculate the propagation of discrete variable value changes and mode changes
       */
      g0_.assign(g1_.begin(), g1_.end());
      bool modelChange = evalZMode(g0_, g1_, tSolve_ + h_);

      // Algebraic mode change
      modeChangeType_t modeChangeType = model_->getModeChangeType();
      if (modeChangeType == ALGEBRAIC_MODE || modeChangeType == ALGEBRAIC_J_UPDATE_MODE) {
        return (ROOT_ALG);
      } else if (modelChange) {  // Z change
        return (ROOT);
      } else {  // Root change without any z change
        /* At the moment, there isn't a proper detection of mode changes (evalMode always returns false).
         * Thus it is necessary to potentially recalculate the step even when the root change could have been without any effect on the problem to solve
         * (for example Secondary Voltage Control timer in steady state)
         * Further development on the modeling side should enable to avoid this and so to speed up performances for strategies in which the current state is recalculated
         * following zero crossing detections.
         */
        return (ROOT);
      }
    }
  }
}

int
SolverSIM::SIMCorrection() {
  int flag = callSolverEulerKIN();
  return flag;
}

int
SolverSIM::callSolverEulerKIN() {
  // Step initialization
  solverEulerKIN_->setInitialValues(tSolve_, h_, vYy_);

  // Forcing the Jacobian calculation for the next Newton-Raphson resolution
  bool noInitSetup = true;
  if (stats_.nst_ == 0 || factorizationForced_)
    noInitSetup = false;

  // Call the solving method in Backward Euler method (Newton-Raphson resolution)
  int flag = solverEulerKIN_->solve(noInitSetup);

  // Get updated y and yp values
  if (flag >= 0)
    solverEulerKIN_->getValues(vYy_, vYp_);

  // Update statistics
  long int nre;
  long int nje;
  solverEulerKIN_->updateStatistics(nNewt_, nre, nje);

  stats_.nre_ += nre;
  stats_.nni_ += nNewt_;
  stats_.nje_ += nje;
  return flag;
}

void
SolverSIM::updateStepConvergence() {
  if (doubleNotEquals(h_, hMax_)) {
    if (nNewt_ > nEff_ - nDeadband_ && nNewt_ < nEff_ + nDeadband_) {
      hNew_ = h_;
    } else {
      hNew_ = min(h_ * nEff_ / nNewt_, hMax_);
    }
  } else {
    hNew_ = h_;
  }

  // Limitation to end up the simulation at tEnd
  hNew_ = min(hNew_, tEnd_ - (tSolve_ + h_));
}

void
SolverSIM::updateStepDivergence() {
  hNew_ = max(h_*kReduceStep_, hMin_);
}

void
SolverSIM::saveInitialValues() {
  gSave_.assign(g0_.begin(), g0_.end());
  ySave_.assign(vYy_.begin(), vYy_.end());
  zSave_.assign(vYz_.begin(), vYz_.end());

  // At the moment, the Simplified solver uses an order 0 prediction in which the NR resolution begins with vYp_ = 0
  // ypSave_.assign(vYp_.begin(), vYp_.end());
}

void
SolverSIM::restoreInitialValues(bool zRestoration, bool rootRestoration) {
  vYy_.assign(ySave_.begin(), ySave_.end());

  // At the moment, the Simplified solver uses an order 0 prediction in which the NR resolution begins with vYp_ = 0
  // vYp_.assign(ypSave_.begin(), ypSave_.end());

  if (zRestoration) {
    vYz_.assign(zSave_.begin(), zSave_.end());
    // Propagating the restoration to the model - z isn't copied from solver to model before evalF otherwise
    model_->copyZ(vYz_);
  }

  if (rootRestoration)
    g0_.assign(gSave_.begin(), gSave_.end());
}

/*
 * This routine deals with the possible actions due to a mode change.
 * In the simplified solver, in case of a mode change, depending on the types of mode, either there is an algebraic equation restoration or nothing is done.
 */
void
SolverSIM::reinit(std::vector<double> &yNxt, std::vector<double> &ypNxt) {
  int counter = 0;
  modeChangeType_t modeChangeType;

  if (model_->getModeChangeType() != DIFFERENTIAL_MODE) {
    do {
      model_->setModeChangeType(NO_MODE);
      model_->rotateBuffers();

      // Call to solver KIN to find new algebraic variables' values
      for (unsigned int i = 0; i < vYId_.size(); i++)
        if (vYId_[i] != DYN::DIFFERENTIAL)
          vYp_[i] = 0;

      // During the algebraic equation restoration, the system could have moved a lot from its previous state.
      // J updates and preconditioner calls must be done on a regular basis.
      solverKIN_->init(model_, SolverKIN::KIN_NORMAL, 1e-5, 1e-5, 30, 1, 1, 0, 0);
      solverKIN_->setInitialValues(tSolve_, vYy_, vYp_);
      solverKIN_->solve();
      solverKIN_->getValues(vYy_, vYp_);
      solverKIN_->clean();

      // Root stabilization - tSolve_ has been updated in the solve method to the current time
      model_->evalG(tSolve_, vYy_, vYp_, vYz_, g1_);
      ++stats_.nge_;

      bool rootFound = !(std::equal(g0_.begin(), g0_.end(), g1_.begin()));
      if (rootFound) {
        g0_.assign(g1_.begin(), g1_.end());
        evalZMode(g0_, g1_, tSolve_);
      }

      modeChangeType = model_->getModeChangeType();
      counter++;
      if (counter >= 10)
        throw DYNError(Error::SOLVER_ALGO, SolverSIMUnstableRoots);
    } while (modeChangeType == ALGEBRAIC_MODE || modeChangeType == ALGEBRAIC_J_UPDATE_MODE);
  }

  model_->setModeChangeType(NO_MODE);

  // saving the new step
  yNxt = vYy_;
  ypNxt = vYp_;
}

void
SolverSIM::getLastConf(long int& nst, int &kused, double & hused) {
  nst = stats_.nst_;
  kused = 1;
  hused = h_;
  return;
}

void
SolverSIM::printEnd() {
  // (1) Print on the standard output
  // -----------------------------------

  Trace::debug() << Trace::endline;
  Trace::debug() << DYNLog(SolverExecutionStats) << Trace::endline;
  Trace::debug() << Trace::endline;

  Trace::debug() << DYNLog(SolverNbIter, stats_.nst_) << Trace::endline;
  Trace::debug() << DYNLog(SolverNbResEval, stats_.nre_) << Trace::endline;
  Trace::debug() << DYNLog(SolverNbJacEval, stats_.nje_) << Trace::endline;
  Trace::debug() << DYNLog(SolverNbNonLinIter, stats_.nni_) << Trace::endline;
  Trace::debug() << DYNLog(SolverNbErrorTestFail, stats_.netf_) << Trace::endline;
  Trace::debug() << DYNLog(SolverNbNonLinConvFail, stats_.ncfn_) << Trace::endline;
  Trace::debug() << DYNLog(SolverNbRootFuncEval, stats_.nge_) << Trace::endline;
}

}  // end namespace DYN
