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
 * @file  DYNSolverKINEuler.cpp
 *
 * @brief SolverEulerKin implementation
 *
 * SolverKINEuler is the implementation of a solver with euler method based on
 * kinsol solver.
 */

#include <cmath>
#include <cstring>
#include <vector>

#include <kinsol/kinsol.h>
#include <sundials/sundials_types.h>
#include <nvector/nvector_serial.h>

#include "DYNSparseMatrix.h"
#include "DYNSolverKINEuler.h"
#include "DYNModel.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNTimer.h"
#include "DYNSolverCommon.h"
#include "DYNSolver.h"

using std::vector;

namespace DYN {

SolverKINEuler::SolverKINEuler() :
SolverKINCommon(),
timeSchemeSolver_(NULL) { }

SolverKINEuler::~SolverKINEuler() {
  timeSchemeSolver_ = NULL;
}

void
SolverKINEuler::init(const std::shared_ptr<Model>& model, Solver* timeSchemeSolver, double fnormtol,
                     double initialaddtol, double scsteptol, double mxnewtstep, int msbset, int mxiter, int printfl, N_Vector sundialsVectorY) {
  clean();
  model_ = model;
  timeSchemeSolver_ = timeSchemeSolver;

  // Problem size
  // ----------------
  int sizeY = model_->sizeY();
  if (sizeY == 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverEmptyYVector);
  if (sizeY != model_->sizeF())
    throw DYNError(Error::SUNDIALS_ERROR, SolverYvsF, sizeY, model_->sizeF());
  vectorF_.resize(model_->sizeF());
  numF_ = model_->sizeF();

  initCommon(fnormtol, initialaddtol, scsteptol, mxnewtstep, msbset, mxiter, printfl, evalF_KIN, evalJ_KIN, sundialsVectorY);
}

int
SolverKINEuler::evalF_KIN(N_Vector yy, N_Vector rr, void* data) {
  SolverKINEuler* solver = reinterpret_cast<SolverKINEuler*> (data);
  Model& model = solver->getModel();
  Solver& timeSchemeSolver = solver->getTimeSchemeSolver();

  // evalF has already been called in the scaling part in SolverKINEuler::solve(...) method so it doesn't have to be called again for the first iteration
  realtype* irr = NV_DATA_S(rr);
  if (solver->getFirstIteration()) {
    solver->setFirstIteration(false);
    // copy of values in output vector
    memcpy(irr, &solver->vectorF_[0], solver->vectorF_.size() * sizeof(solver->vectorF_[0]));
  } else {  // update of F
    realtype* iyy = NV_DATA_S(yy);

    timeSchemeSolver.computeYP(iyy);

    try {
      model.evalF(solver->t0_ + timeSchemeSolver.getTimeStep(), iyy, &timeSchemeSolver.getCurrentYP()[0], irr);
    } catch (const DYN::Error& e) {
      if (e.type() == DYN::Error::NUMERICAL_ERROR) {
#ifdef _DEBUG_
       Trace::debug() << e.what() << Trace::endline;
#endif
        return (-1);
      } else {
        throw;
      }
    }
  }

#ifdef _DEBUG_
  // Print the current residual norms, the first one is used as a stopping criterion
  if (!solver->getFirstIteration()) {
    memcpy(&solver->vectorF_[0], irr, solver->vectorF_.size() * sizeof(solver->vectorF_[0]));
  }
  double weightedInfNorm = SolverCommon::weightedInfinityNorm(solver->vectorF_, solver->vectorFScale_);
  double wL2Norm = SolverCommon::weightedL2Norm(solver->vectorF_, solver->vectorFScale_);
  long int current_nni = 0;
  KINGetNumNonlinSolvIters(solver->KINMem_, &current_nni);
  Trace::debug() << DYNLog(SolverKINResidualNorm, current_nni, weightedInfNorm, wL2Norm) << Trace::endline;

  const int nbErr = 10;
  Trace::debug() << DYNLog(KinLargestErrors, nbErr) << Trace::endline;
  vector<std::pair<double, size_t> > fErr;
  for (size_t i = 0; i < solver->numF_; ++i)
    fErr.push_back(std::pair<double, size_t>(solver->vectorF_[i], i));
  SolverCommon::printLargestErrors(fErr, model, nbErr);
#endif

  return 0;
}

int
SolverKINEuler::evalJ_KIN(N_Vector /*yy*/, N_Vector /*rr*/,
        SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("SolverKINEuler::evalJ_KIN");
#endif

  SolverKINEuler* solver = reinterpret_cast<SolverKINEuler*> (data);
  Model& model = solver->getModel();

  // cj = 1/h
  const double h0 = solver->getTimeSchemeSolver().getTimeStep();
  const double cj = 1. / h0;

  // Sparse matrix version
  // ----------------------
  SparseMatrix smj;
  const int size = model.sizeY();
  smj.init(size, size);
  model.evalJt(solver->t0_ + h0, cj, smj);
  SolverCommon::propagateMatrixStructureChangeToKINSOL(smj, JJ, size, &solver->lastRowVals_, solver->linearSolver_, true);

  return 0;
}

int
SolverKINEuler::solve(bool noInitSetup, bool skipAlgebraicResidualsEvaluation) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("SolverKINEuler::solve");
#endif
  t0_ = timeSchemeSolver_->getTSolve();

  int flag = KINSetNoInitSetup(KINMem_, noInitSetup);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetNoInitSetup");

  const vector<double>& currentY = timeSchemeSolver_->getCurrentY();
  const vector<double>& currentYp = timeSchemeSolver_->getCurrentYP();
  timeSchemeSolver_->computeYP(&currentY[0]);
  firstIteration_ = true;
  if (skipAlgebraicResidualsEvaluation)
    model_->evalFDiff(t0_ + timeSchemeSolver_->getTimeStep(), &currentY[0], &currentYp[0], &vectorF_[0]);
  else
    model_->evalF(t0_ + timeSchemeSolver_->getTimeStep() , &currentY[0], &currentYp[0], &vectorF_[0]);

  vectorFScale_.assign(numF_, 1.);
  for (unsigned int i = 0; i < numF_; ++i) {
    if (std::abs(vectorF_[i]) > RCONST(1.))
      vectorFScale_[i] = 1. / std::abs(vectorF_[i]);
  }

  vectorYScale_.assign(numF_, 1.);
  for (unsigned int i = 0; i < numF_; ++i) {
    if (std::abs(currentY[i]) > RCONST(1.))
      vectorYScale_[i] = 1. / std::abs(currentY[i]);
  }

  flag = solveCommon();

  return flag;
}

}  // namespace DYN
