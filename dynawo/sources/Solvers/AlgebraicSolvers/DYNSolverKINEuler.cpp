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
#include <string.h>
#include <map>
#include <algorithm>
#include <iomanip>
#include <sstream>

#include <kinsol/kinsol.h>
#include <sunlinsol/sunlinsol_klu.h>
#include <sundials/sundials_types.h>
#include <sundials/sundials_math.h>
#include <sunmatrix/sunmatrix_sparse.h>
#include <nvector/nvector_serial.h>

#ifdef WITH_NICSLU
#include <sunlinsol/sunlinsol_nicslu.h>
#endif

#include "DYNSparseMatrix.h"
#include "DYNSolverKINEuler.h"
#include "DYNModel.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNTimer.h"
#include "DYNSolverCommon.h"

using std::vector;
using std::map;
using std::string;
using std::stringstream;
using boost::shared_ptr;

namespace DYN {

SolverKINEuler::SolverKINEuler() :
SolverKINCommon(),
h0_(0.),
resetDerivatives_(false) { }

SolverKINEuler::~SolverKINEuler() {
  clean();
}

void
SolverKINEuler::init(const shared_ptr<Model>& model, const std::string& linearSolverName, double fnormtol, double initialaddtol, double scsteptol,
        double mxnewtstep, int msbset, int mxiter, int printfl) {
  clean();
  model_ = model;
  linearSolverName_ = linearSolverName;

  // Problem size
  // ----------------
  int sizeY = model_->sizeY();
  if (sizeY == 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverEmptyYVector);
  y0_.assign(sizeY, 0);
  F_.resize(model_->sizeF());
  YP_.assign(sizeY, 0);
  nbF_ = model_->sizeF();

  vYy_.assign(sizeY, 0);

  yy_ = N_VMake_Serial(sizeY, &(vYy_[0]));
  if (yy_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYY);

  initCommon(linearSolverName, fnormtol, initialaddtol, scsteptol, mxnewtstep, msbset, mxiter, printfl, evalF_KIN, evalJ_KIN);
}

int
SolverKINEuler::evalF_KIN(N_Vector yy, N_Vector rr, void* data) {
  SolverKINEuler* solv = reinterpret_cast<SolverKINEuler*> (data);
  shared_ptr<Model> mod = solv->getModel();

  // evalF has already been called in the scaling part in SolverKINEuler::solve(...) method so it doesn't have to be called again for the first iteration
  realtype *irr = NV_DATA_S(rr);
  if (solv->getFirstIteration()) {
    solv->setFirstIteration(false);
    // copy of values in output vector
    memcpy(irr, &solv->F_[0], solv->F_.size() * sizeof(solv->F_[0]));
  } else {  // update of F
    realtype *iyy = NV_DATA_S(yy);
    const vector<int>& diffVar = solv->differentialVars_;

    // YP[i] = (y[i]-yprec[i])/h for each differential variable
    assert(solv->h0_ > 0);
    for (unsigned int i = 0; i < diffVar.size(); ++i) {
      solv->YP_[diffVar[i]] = (iyy[diffVar[i]] - solv->y0_[diffVar[i]]) / solv->h0_;
    }

    try {
      mod->evalF(solv->t0_ + solv->h0_, iyy, &solv->YP_[0], irr);
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
  if (!solv->getFirstIteration()) {
    memcpy(&solv->F_[0], irr, solv->F_.size() * sizeof(solv->F_[0]));
  }
  double weightedInfNorm = SolverCommon::weightedInfinityNorm(solv->F_, solv->fScale_);
  double wL2Norm = SolverCommon::weightedL2Norm(solv->F_, solv->fScale_);
  long int current_nni = 0;
  KINGetNumNonlinSolvIters(solv->KINMem_, &current_nni);
  Trace::debug() << DYNLog(SolverKINResidualNorm, current_nni, weightedInfNorm, wL2Norm) << Trace::endline;

//  const int nbErr = 0;
//  Trace::debug() << DYNLog(KinLargestErrors, nbErr) << Trace::endline;
//  vector<std::pair<double, size_t> > fErr;
//  for (size_t i = 0; i < solv->nbF_; ++i)
//    fErr.push_back(std::pair<double, size_t>(solv->F_[i], i));
//  SolverCommon::printLargestErrors(fErr, mod, nbErr);
#endif

  return (0);
}

int
SolverKINEuler::evalJ_KIN(N_Vector /*yy*/, N_Vector /*rr*/,
        SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("SolverKINEuler::evalJ_KIN");
#endif

  Trace::debug() << DYNLog(EvalJ) << Trace::endline;

  SolverKINEuler* solv = reinterpret_cast<SolverKINEuler*> (data);
  shared_ptr<Model> model = solv->getModel();
  // static int counter = 0;
  // std::cout << counter << " evalJ_KIN" << std::endl;
  // counter++;

  // cj = 1/h
  double cj = 1 / solv->h0_;

  // Sparse matrix version
  // ----------------------
  SparseMatrix smj;
  int size = model->sizeY();
  smj.init(size, size);
  model->evalJt(solv->t0_ + solv->h0_, cj, smj);
  SolverCommon::propagateMatrixStructureChangeToKINSOL(smj, JJ, size, &solv->lastRowVals_, solv->LS_, solv->linearSolverName_, true);

  return (0);
}

int
SolverKINEuler::solve(bool noInitSetup, bool skipAlgebraicResidualsEvaluation) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("SolverKINEuler::solve");
#endif

  int flag = KINSetNoInitSetup(KINMem_, noInitSetup);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetNoInitSetup");

  firstIteration_ = true;
  if (skipAlgebraicResidualsEvaluation)
    model_->evalFDiff(t0_ + h0_ , &y0_[0], &YP_[0], &F_[0]);
  else
    model_->evalF(t0_ + h0_ , &y0_[0], &YP_[0], &F_[0]);

  fScale_.assign(nbF_, 1.0);
  for (unsigned int i = 0; i < nbF_; ++i) {
    if (std::abs(F_[i]) > RCONST(1.0))
      fScale_[i] = 1 / std::abs(F_[i]);
  }

  yScale_.assign(model_->sizeY(), 1.0);
  for (int i = 0; i < model_->sizeY(); ++i) {
    if (std::abs(y0_[i]) > RCONST(1.0))
      yScale_[i] = 1 / std::abs(y0_[i]);
  }

  flag = solveCommon();

  return flag;
}

void
SolverKINEuler::setInitialValues(const double& t, const double& h, const vector<double>& y) {
  // Compute velocity of last time step
  if (t > 0. && !resetDerivatives_) {
    for (unsigned int i = 0; i < differentialVars_.size(); ++i) {
      YP_[differentialVars_[i]] = (y[differentialVars_[i]] - y0_[differentialVars_[i]]) / h0_;
    }
  } else {
    std::fill(YP_.begin(), YP_.end(), 0.);
    resetDerivatives_ = false;
  }
  t0_ = t;
  h0_ = h;

  std::copy(y.begin(), y.end(), y0_.begin());
  std::copy(y.begin(), y.end(), vYy_.begin());
  if (t > 0.) {
    for (unsigned int i = 0; i < differentialVars_.size(); ++i) {
      vYy_[differentialVars_[i]] += h0_ * YP_[differentialVars_[i]];
    }
  }
  // order-0 prediction - YP = 0
  // std::fill(YP_.begin(), YP_.end(), 0);
}

void
SolverKINEuler::setIdVars() {
  DYN::propertyContinuousVar_t* vId = model_->getYType();

  differentialVars_.clear();

  for (int i = 0; i < model_->sizeY(); ++i) {
    if (vId[i] == DYN::DIFFERENTIAL) {
      differentialVars_.push_back(i);
    }
  }
}

}  // namespace DYN
