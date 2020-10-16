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
#include "DYNSolverKINEuler.h"
#include "DYNSolverKINAlgRestoration.h"
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

SolverSIM::SolverSIM() :
hMin_(0),
hMax_(0),
kReduceStep_(0),
nEff_(0),
nDeadband_(0),
maxRootRestart_(0),
maxNewtonTry_(0),
recalculateStep_(false),
tEnd_(0.),
h_(0.),
hNew_(0.),
nNewt_(0),
countRestart_(0),
factorizationForced_(false),
fnormtol_(1e-4),
initialaddtol_(0.1),
scsteptol_(1e-4),
mxnewtstep_(100000),
msbset_(0),
mxiter_(15),
printfl_(0),
skipNextNR_(false),
skipAlgebraicResidualsEvaluation_(false),
optimizeAlgebraicResidualsEvaluations_(true),
skipNRIfInitialGuessOK_(true) {
  solverKINAlgRestoration_.reset(new SolverKINAlgRestoration());
}

SolverSIM::~SolverSIM() {
}

void
SolverSIM::defineSpecificParameters() {
  const bool mandatory = true;
  const bool optional = false;
  // Time-domain part parameters
  parameters_.insert(make_pair("hMin", ParameterSolver("hMin", VAR_TYPE_DOUBLE, mandatory)));
  parameters_.insert(make_pair("hMax", ParameterSolver("hMax", VAR_TYPE_DOUBLE, mandatory)));
  parameters_.insert(make_pair("kReduceStep", ParameterSolver("kReduceStep", VAR_TYPE_DOUBLE, mandatory)));
  parameters_.insert(make_pair("nEff", ParameterSolver("nEff", VAR_TYPE_INT, mandatory)));
  parameters_.insert(make_pair("nDeadband", ParameterSolver("nDeadband", VAR_TYPE_INT, mandatory)));
  parameters_.insert(make_pair("maxRootRestart", ParameterSolver("maxRootRestart", VAR_TYPE_INT, mandatory)));
  parameters_.insert(make_pair("maxNewtonTry", ParameterSolver("maxNewtonTry", VAR_TYPE_INT, mandatory)));
  parameters_.insert(make_pair("recalculateStep", ParameterSolver("recalculateStep", VAR_TYPE_BOOL, mandatory)));

  // Parameters for the algebraic resolution at each time step
  parameters_.insert(make_pair("linearSolverName", ParameterSolver("linearSolverName", VAR_TYPE_STRING, mandatory)));
  parameters_.insert(make_pair("fnormtol", ParameterSolver("fnormtol", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("initialaddtol", ParameterSolver("initialaddtol", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("scsteptol", ParameterSolver("scsteptol", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("mxnewtstep", ParameterSolver("mxnewtstep", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("msbset", ParameterSolver("msbset", VAR_TYPE_INT, optional)));
  parameters_.insert(make_pair("mxiter", ParameterSolver("mxiter", VAR_TYPE_INT, optional)));
  parameters_.insert(make_pair("printfl", ParameterSolver("printfl", VAR_TYPE_INT, optional)));
  parameters_.insert(make_pair("optimizeAlgebraicResidualsEvaluations", ParameterSolver("optimizeAlgebraicResidualsEvaluations", VAR_TYPE_BOOL, optional)));
  parameters_.insert(make_pair("skipNRIfInitialGuessOK", ParameterSolver("skipNRIfInitialGuessOK", VAR_TYPE_BOOL, optional)));
}

void
SolverSIM::setSolverSpecificParameters() {
  hMin_ = findParameter("hMin").getValue<double>();
  hMax_ = findParameter("hMax").getValue<double>();
  kReduceStep_ = findParameter("kReduceStep").getValue<double>();
  nEff_ = findParameter("nEff").getValue<int>();
  nDeadband_ = findParameter("nDeadband").getValue<int>();
  maxRootRestart_ = findParameter("maxRootRestart").getValue<int>();
  maxNewtonTry_ =  findParameter("maxNewtonTry").getValue<int>();
  recalculateStep_ = findParameter("recalculateStep").getValue<bool>();

  linearSolverName_ = findParameter("linearSolverName").getValue<std::string>();
  if (findParameter("fnormtol").hasValue())
    fnormtol_ = findParameter("fnormtol").getValue<double>();
  if (findParameter("initialaddtol").hasValue())
    initialaddtol_ = findParameter("initialaddtol").getValue<double>();
  if (findParameter("scsteptol").hasValue())
    scsteptol_ = findParameter("scsteptol").getValue<double>();
  if (findParameter("mxnewtstep").hasValue())
    mxnewtstep_ = findParameter("mxnewtstep").getValue<double>();
  if (findParameter("msbset").hasValue())
    msbset_ = findParameter("msbset").getValue<int>();
  if (findParameter("mxiter").hasValue())
    mxiter_ = findParameter("mxiter").getValue<int>();
  if (findParameter("printfl").hasValue())
    printfl_ = findParameter("printfl").getValue<int>();
  if (findParameter("optimizeAlgebraicResidualsEvaluations").hasValue())
    optimizeAlgebraicResidualsEvaluations_ = findParameter("optimizeAlgebraicResidualsEvaluations").getValue<bool>();
  if (findParameter("skipNRIfInitialGuessOK").hasValue())
    skipNRIfInitialGuessOK_ = findParameter("skipNRIfInitialGuessOK").getValue<bool>();
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
  previousReinit_ = None;

  if (model->sizeY() != 0) {
    solverKINEuler_.reset(new SolverKINEuler());
    solverKINEuler_->init(model, linearSolverName_, fnormtol_, initialaddtol_, scsteptol_, mxnewtstep_, msbset_, mxiter_, printfl_);
    solverKINEuler_->setIdVars();
  }

  Solver::Impl::init(t0, model);
  Solver::Impl::resetStats();
  g0_.assign(model_->sizeG(), NO_ROOT);
  g1_.assign(model_->sizeG(), NO_ROOT);
  Trace::debug() << DYNLog(SolverSIMInitOK) << Trace::endline;
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
  model_->copyContinuousVariables(&vYy_[0], &vYp_[0]);
  model_->evalG(tSolve_, g0_);
  evalZMode(g0_, g1_, tSolve_);
  model_->rotateBuffers();
  state_.reset();
  model_->reinitMode();

  // KINSOL initialization
  solverKINAlgRestoration_->init(model_, SolverKINAlgRestoration::KIN_NORMAL, fnormtolAlg_,
      initialaddtolAlg_, scsteptolAlg_, mxnewtstepAlg_, msbsetAlg_, mxiterAlg_, printflAlg_);

  // Loop as long as there is a z or a mode change
  do {
    Trace::debug() << DYNLog(CalculateICIteration, counter) << Trace::endline;

    // Global initialization - continuous part
    solverKINAlgRestoration_->setInitialValues(tSolve_, vYy_, vYp_);
    solverKINAlgRestoration_->solve();
    solverKINAlgRestoration_->getValues(vYy_, vYp_);

    // Updating discrete variable values and mode
    model_->evalG(tSolve_, g1_);
    if (std::equal(g0_.begin(), g0_.end(), g1_.begin())) {
      break;
    } else {
      g0_.assign(g1_.begin(), g1_.end());
      change = evalZMode(g0_, g1_, tSolve_);
    }

    model_->rotateBuffers();
    state_.reset();
    model_->reinitMode();

    // Maximum number of initialization calculation
    ++counter;
    if (counter >= maxNumberUnstableRoots)
      throw DYNError(Error::SOLVER_ALGO, SolverSIMUnstableRoots);
  } while (change);

  Trace::debug() << DYNLog(EndCalculateIC) << Trace::endline;
  solverKINAlgRestoration_->clean();
}

void SolverSIM::solveStep(double /*tAim*/, double& tNxt) {
  if (recalculateStep_)
    solveWithStepRecalculation(tNxt);
  else
    solveWithoutStepRecalculation(tNxt);
}

void SolverSIM::solveWithStepRecalculation(double& tNxt) {
  int counter = 0;
  bool redoStep = false;
  saveInitialValues();

  // Save the initial number of events in the timeline in case we need to come back in the past
  int initialEventsSize = 0;
  int finalEventsSize = 0;
  if (timeline_)
    initialEventsSize = timeline_->getSizeEvents();

  do {
    // If we have more than maxNewtonTry consecutive divergence or root changes, the simulation is stopped
    handleMaximumTries(counter);

    // New time step value
    h_ = hNew_;

    // Call the Newton-Raphson solver and analyze the root evolution
    SolverStatus_t status = solve();
    skipAlgebraicResidualsEvaluation_ = false;

    switch (status) {
      /* NON_CONV: the Newton-Raphson algorithm fails to converge
       *   => The time step is decreased
       *   => The LU decomposition is forced for the next time steps
       *   => The initial point for the next time step (h = h/2) is the initial point from the previous accepted time step
       *   => In case we use the recalculateStep strategy, timeline events must be deleted.
      */
      case NON_CONV: {
        handleDivergence(redoStep);
        restoreInitialValues();
        countRestart_ = 0;
        // Erase timeline messages that could have been added between the previous accepted time step and the non convergence
        if (timeline_) {
          finalEventsSize = timeline_->getSizeEvents();
          if (finalEventsSize != initialEventsSize)
            timeline_->eraseEvents(finalEventsSize - initialEventsSize);
        }
        break;
      }
      /*
       * CONV: the Newton-Rapshon algorithm converges and there is no discrete value or mode change
       * => The time step is increased (if possible)
       * => The LU decomposition is avoided for the next time steps (we have come back to a stabilized situation)
       */
      case CONV: {
        handleConvergence(redoStep);
        skipAlgebraicResidualsEvaluation_ = optimizeAlgebraicResidualsEvaluations_;
        countRestart_ = 0;
        break;
      }
      /*
       * ROOT_ALG: algebraic change
       * => a restoration of the algebraic variables will be called by the simulation
       * => The current time step is accepted.
       * => The next time step will be done with the current time step (neither increase nor decrease)
       */
      case ROOT_ALG: {
        handleAlgebraicRoot(redoStep);
        skipAlgebraicResidualsEvaluation_ = optimizeAlgebraicResidualsEvaluations_;
        countRestart_ = 0;
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
            restoreContinuousVariables();
            state_.reset();
            model_->reinitMode();
          }
        break;
      }
    }
  } while (redoStep);

  // Limitation to end up the simulation at tEnd
  updateTimeStep(tNxt);
  ++stats_.nst_;
}

void SolverSIM::solveWithoutStepRecalculation(double& tNxt) {
  int counter = 0;
  bool redoStep = false;
  saveContinuousVariables();

  do {
    // If we have more than maxNewtonTry consecutive divergence or root changes, the simulation is stopped
    handleMaximumTries(counter);

    // New time step value
    h_ = hNew_;

    // Call the Newton-Raphson solver and analyze the root evolution
    SolverStatus_t status = solve();
    skipAlgebraicResidualsEvaluation_ = false;

    switch (status) {
      /* NON_CONV: the Newton-Raphson algorithm fails to converge
       *   => The time step is decreased
       *   => The LU decomposition is forced for the next time steps
       *   => The initial point for the next time step (h = h/2) is the initial point from the previous accepted time step
      */
      case NON_CONV: {
        handleDivergence(redoStep);
        restoreContinuousVariables();
        break;
      }
      /*
       * CONV: the Newton-Rapshon algorithm converges and there is no discrete value or mode change
       * => The time step is increased (if possible)
       * => The LU decomposition is avoided for the next time steps (we have come back to a stabilized situation)
      */
      case CONV: {
        handleConvergence(redoStep);
        skipAlgebraicResidualsEvaluation_ = optimizeAlgebraicResidualsEvaluations_;
        break;
      }
      /*
       * ROOT_ALG: algebraic change
       * => a restoration of the algebraic variables will be called by the simulation
       * => The current time step is accepted.
       * => The next time step will be done with the current time step (neither increase nor decrease)
      */
      case ROOT_ALG: {
        handleAlgebraicRoot(redoStep);
        skipAlgebraicResidualsEvaluation_ = optimizeAlgebraicResidualsEvaluations_;
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

  updateTimeStep(tNxt);
  ++stats_.nst_;
}

void
SolverSIM::saveInitialValues() {
  saveContinuousVariables();
  gSave_.assign(g0_.begin(), g0_.end());
  model_->getCurrentZ(zSave_);
}

void
SolverSIM::saveContinuousVariables() {
  ySave_.assign(vYy_.begin(), vYy_.end());
}

void SolverSIM::handleMaximumTries(int& counter) {
  ++counter;
  if (counter >= maxNewtonTry_)
    throw DYNError(Error::SOLVER_ALGO, SolverSIMConvFail, maxNewtonTry_);
}

SolverSIM::SolverStatus_t
SolverSIM::solve() {
  /*
   * Call the Newton-Raphson solver for the time step
   * Returns y and yp updated values
   */
  int flag = 0;
  if (!skipNextNR_ && model_->sizeY() != 0)
    flag = callSolverKINEuler();

  // Analyze the return value and do further treatments if necessary
  if (flag < 0) {
    stats_.ncfn_++;
    return NON_CONV;
  } else {
    // Evaluate root values after the time step (using updated y and yp)
    model_->evalG(tSolve_ + h_, g1_);
    ++stats_.nge_;

    // No root change -> no discrete variable change neither mode change
    if (std::equal(g0_.begin(), g0_.end(), g1_.begin())) {
      if (flag == KIN_INITIAL_GUESS_OK) {
        skipNextNR_ = skipNRIfInitialGuessOK_;
        if (skipNextNR_)
          Trace::info() << DYNLog(SolverSIMInitGuessOK) << Trace::endline;
      }
      return CONV;
    } else {
      // A root change has occurred - Dealing with propagation and algebraic mode detection
#ifdef _DEBUG_
      printUnstableRoot(g0_, g1_);
#endif
      /* Save the new values of the root in g0 for comparison after the evalZMode
       * Calculate the propagation of discrete variable value changes and mode changes
       */
      g0_.assign(g1_.begin(), g1_.end());
      evalZMode(g0_, g1_, tSolve_ + h_);

      if (getState().getFlags(ModeChange)) {
        skipNextNR_ = false;
        if (model_->getModeChangeType() != DIFFERENTIAL_MODE)
          return ROOT_ALG;
        else if (getState().getFlags(ZChange) || getState().getFlags(SilentZChange))
          return ROOT;
        return CONV;
      } else if (getState().getFlags(ZChange) || getState().getFlags(SilentZChange)) {  // Z change
        skipNextNR_ = false;
        return ROOT;
      } else {  // Root change without any z or mode change
        if (flag == KIN_INITIAL_GUESS_OK) {
          skipNextNR_ = skipNRIfInitialGuessOK_;
          if (skipNextNR_)
            Trace::info() << DYNLog(SolverSIMInitGuessOK) << Trace::endline;
        }
        return CONV;
      }
    }
  }
}

int
SolverSIM::callSolverKINEuler() {
  // Step initialization
  solverKINEuler_->setInitialValues(tSolve_, h_, vYy_);

  // Forcing the Jacobian calculation for the next Newton-Raphson resolution
  bool noInitSetup = true;
  if (stats_.nst_ == 0 || factorizationForced_)
    noInitSetup = false;

  // Call the solving method in Backward Euler method (Newton-Raphson resolution)
  int flag = solverKINEuler_->solve(noInitSetup, skipAlgebraicResidualsEvaluation_);

  // Get updated y and yp values plus set the skipNextNR indicator
  if (flag >= 0)
    solverKINEuler_->getValues(vYy_, vYp_);

  // Update statistics
  updateStatistics();

  return flag;
}

void
SolverSIM::updateStatistics() {
  long int nre = 0;
  long int nje = 0;
  solverKINEuler_->updateStatistics(nNewt_, nre, nje);
  stats_.nre_ += nre;
  stats_.nni_ += nNewt_;
  stats_.nje_ += nje;
}

void SolverSIM::handleDivergence(bool& redoStep) {
  if (doubleEquals(h_, hMin_)) {
    throw DYNError(Error::SOLVER_ALGO, SolverSIMConvFailMin);   // Divergence or unstable root at minimum step length, fail to resolve problem
  }
  factorizationForced_ = true;
  redoStep = true;
  updateStepDivergence();
}

void
SolverSIM::updateStepDivergence() {
  hNew_ = max(h_*kReduceStep_, hMin_);
}

void
SolverSIM::restoreContinuousVariables() {
  vYy_.assign(ySave_.begin(), ySave_.end());
}

void
SolverSIM::restoreInitialValues() {
  restoreContinuousVariables();
  model_->setCurrentZ(zSave_);
  g0_.assign(gSave_.begin(), gSave_.end());
}

void SolverSIM::handleConvergence(bool& redoStep) {
  factorizationForced_ = false;
  redoStep = false;
  updateStepConvergence();
}

void
SolverSIM::updateStepConvergence() {
  if (doubleNotEquals(h_, hMax_)) {
    if (nNewt_ <= nEff_ - nDeadband_ || nNewt_ >= nEff_ + nDeadband_) {
      hNew_ = min(h_ * nEff_ / nNewt_, hMax_);
    } else {
      hNew_ = h_;
    }
  } else {
    hNew_ = h_;
  }

  // Limitation to end up the simulation at tEnd
  hNew_ = min(hNew_, tEnd_ - (tSolve_ + h_));
}

void SolverSIM::handleAlgebraicRoot(bool& redoStep) {
  if (model_->getModeChangeType() == ALGEBRAIC_J_UPDATE_MODE)
    factorizationForced_ = true;
  redoStep = false;
}

void SolverSIM::updateTimeStep(double& tNxt) {
  hNew_ = min(hNew_, tEnd_ - (tSolve_ + hNew_));
  // tNxt is the initial time step value (corresponding to the current time step done)
  tNxt = tSolve_ + h_;
}

bool SolverSIM::initAlgRestoration(modeChangeType_t modeChangeType) {
  if (modeChangeType == ALGEBRAIC_MODE) {
    if (previousReinit_ == None) {
      solverKINAlgRestoration_->init(model_, SolverKINAlgRestoration::KIN_NORMAL, fnormtolAlg_,
            initialaddtolAlg_, scsteptolAlg_, mxnewtstepAlg_, msbsetAlg_, mxiterAlg_, printflAlg_);
      previousReinit_ = Algebraic;
      return true;
    } else if (previousReinit_ == AlgebraicWithJUpdate) {
      solverKINAlgRestoration_->modifySettings(fnormtolAlg_, initialaddtolAlg_, scsteptolAlg_, mxnewtstepAlg_, msbsetAlg_, mxiterAlg_, printflAlg_);
      previousReinit_ = Algebraic;
      return true;
    }
    return true;
  } else {
    if (previousReinit_ == None) {
      solverKINAlgRestoration_->init(model_, SolverKINAlgRestoration::KIN_NORMAL, fnormtolAlgJ_,
            initialaddtolAlgJ_, scsteptolAlgJ_, mxnewtstepAlgJ_, msbsetAlgJ_, mxiterAlgJ_, printflAlgJ_);
      previousReinit_ = AlgebraicWithJUpdate;
      return false;
    } else if (previousReinit_ == Algebraic) {
      solverKINAlgRestoration_->modifySettings(fnormtolAlgJ_, initialaddtolAlgJ_,
            scsteptolAlgJ_, mxnewtstepAlgJ_, msbsetAlgJ_, mxiterAlgJ_, printflAlgJ_);
      previousReinit_ = AlgebraicWithJUpdate;
      return false;
    }
    return false;
  }
}

/*
 * This routine deals with the possible actions due to a mode change.
 * In the simplified solver, in case of a mode change, depending on the types of mode, either there is an algebraic equation restoration or nothing is done.
 */
void
SolverSIM::reinit() {
  int counter = 0;
  modeChangeType_t modeChangeType = model_->getModeChangeType();

  if (modeChangeType < minimumModeChangeTypeForAlgebraicRestoration_)
    return;

  const bool evaluateOnlyMode = optimizeReinitAlgebraicResidualsEvaluations_;
  do {
    model_->rotateBuffers();
    state_.reset();

    // During the algebraic equation restoration, the system could have moved a lot from its previous state.
    // J updates and preconditioner calls must be done on a regular basis.
    bool noInitSetup = initAlgRestoration(modeChangeType);

    solverKINAlgRestoration_->setInitialValues(tSolve_, vYy_, vYp_);
    int flag = solverKINAlgRestoration_->solve(noInitSetup, evaluateOnlyMode);
    model_->reinitMode();

    // Update statistics
    long int nre = 0;
    long int nje = 0;
    solverKINAlgRestoration_->updateStatistics(nNewt_, nre, nje);
    stats_.nre_ += nre;
    stats_.nni_ += nNewt_;
    stats_.nje_ += nje;

    // If the initial guess is fine, nor the variables neither the time would have changed so we can return here and skip following treatments
    if (flag == KIN_INITIAL_GUESS_OK)
      return;
    solverKINAlgRestoration_->getValues(vYy_, vYp_);

    // Root stabilization - tSolve_ has been updated in the solve method to the current time
    model_->evalG(tSolve_, g1_);
    ++stats_.nge_;
    if (std::equal(g0_.begin(), g0_.end(), g1_.begin())) {
      break;
    } else {
      g0_.assign(g1_.begin(), g1_.end());
      evalZMode(g0_, g1_, tSolve_);
      modeChangeType = model_->getModeChangeType();
    }

    counter++;
    if (counter >= maxNumberUnstableRoots)
      throw DYNError(Error::SOLVER_ALGO, SolverSIMUnstableRoots);
  } while (modeChangeType == ALGEBRAIC_MODE || modeChangeType == ALGEBRAIC_J_UPDATE_MODE);
}

void
SolverSIM::printHeaderSpecific(std::stringstream& ss) const {
  ss << "| iter num   Nonlinear iter   jac eval      time step (h)";
}

void
SolverSIM::printSolveSpecific(std::stringstream& msg) const {
  msg << "| " << setw(8) << stats_.nst_ << " "
          << setw(16) << stats_.nni_ << " "
          << setw(10) << stats_.nje_ << " "
          << setw(18) << h_ << " ";
}

}  // end namespace DYN
