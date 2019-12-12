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
#include <sundials/sundials_sparse.h>
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
model_() {
  SolverKINCommon();
  h0_ = 0.;
}

SolverKINEuler::~SolverKINEuler() {
  clean();
}

void
SolverKINEuler::init(const shared_ptr<Model>& model, const std::string& linearSolverName, double fnormtol, double scsteptol,
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

  initCommon(linearSolverName, fnormtol, scsteptol, mxnewtstep, msbset, mxiter, printfl, evalF_KIN, evalJ_KIN);
}

int
SolverKINEuler::evalF_KIN(N_Vector yy, N_Vector rr, void* data) {
  SolverKINEuler* solv = reinterpret_cast<SolverKINEuler*> (data);
  shared_ptr<Model> mod = solv->getModel();

  realtype *irr = NV_DATA_S(rr);
  if (solv->getFirstIteration()) {
    solv->setFirstIteration(false);
    // copy of values in output vector
    memcpy(irr, &solv->F_[0], solv->F_.size() * sizeof(solv->F_[0]));
  } else {  // update of F
    realtype *iyy = NV_DATA_S(yy);
    vector<int> diffVar = solv->differentialVars_;

    // YP[i] = (y[i]-yprec[i])/h for each differential variable
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
#endif

  return (0);
}

int
SolverKINEuler::evalJ_KIN(N_Vector yy, N_Vector /*rr*/,
        SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
  Timer timer("SolverKINEuler::evalJ_KIN");
  SolverKINEuler* solv = reinterpret_cast<SolverKINEuler*> (data);
  shared_ptr<Model> model = solv->getModel();

  realtype* iyy = NV_DATA_S(yy);
  vector<int> diffVar = solv->differentialVars_;

  // YP[i] = (y[i]-yprec[i])/h for each differential variable
  for (unsigned int i = 0; i < diffVar.size(); ++i) {
    solv->YP_[diffVar[i]] = (iyy[diffVar[i]] - solv->y0_[diffVar[i]]) / solv->h0_;
  }

  // cj = 1/h
  double cj = 1 / solv->h0_;

  // Sparse matrix version
  // ----------------------
  SparseMatrix smj;
  int size = model->sizeY();
  smj.init(size, size);
  model->evalJt(solv->t0_ + solv->h0_, iyy, &solv->YP_[0], cj, smj);

  bool matrixStructChange = SolverCommon::copySparseToKINSOL(smj, JJ, size, solv->lastRowVals_);

  if (matrixStructChange) {
    Trace::debug() << DYNLog(MatrixStructureChange) << Trace::endline;
    if (solv->getLinearSolverName() == "KLU") {
      SUNLinSol_KLUReInit(solv->LS_, JJ, SM_NNZ_S(JJ), 2);  // reinit symbolic factorisation
#ifdef WITH_NICSLU
    } else if (solv->getLinearSolverName() == "NICSLU") {
      SUNLinSol_NICSLUReInit(solv->LS_, JJ, SM_NNZ_S(JJ), 2);  // reinit symbolic factorisation
    }
#else
  }
#endif
    if (solv->lastRowVals_ != NULL) {
      free(solv->lastRowVals_);
    }
    solv->lastRowVals_ = reinterpret_cast<sunindextype*> (malloc(sizeof (sunindextype)*SM_NNZ_S(JJ)));
    memcpy(solv->lastRowVals_, SM_INDEXVALS_S(JJ), sizeof (sunindextype)*SM_NNZ_S(JJ));
  }

  return (0);
}

int
SolverKINEuler::solve(bool noInitSetup) {
  Timer timer("SolverKINEuler::solve");
  int flag = KINSetNoInitSetup(KINMem_, noInitSetup);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetNoInitSetup");

  firstIteration_ = true;

  Timer* scaling = new Timer("SolverKINEuler::scaling");
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
  delete scaling;

  flag = solveCommon();

  return flag;
}

void
SolverKINEuler::setInitialValues(const double& t, const double& h, const vector<double>& y) {
  t0_ = t;
  h0_ = h;
  std::copy(y.begin(), y.end(), y0_.begin());
  std::copy(y.begin(), y.end(), vYy_.begin());
  // order-0 prediction - YP = 0
  std::fill(YP_.begin(), YP_.end(), 0);
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
