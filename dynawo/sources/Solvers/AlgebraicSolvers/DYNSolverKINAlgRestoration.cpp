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
 * @file  DYNSolverKINAlgRestoration.cpp
 *
 * @brief Implementation of solver based on sundials/KINSOL solver
 *
 */


#include <kinsol/kinsol.h>
#include <sunlinsol/sunlinsol_klu.h>
#include <sundials/sundials_types.h>
#include <sundials/sundials_math.h>
#include <sundials/sundials_sparse.h>
#include <nvector/nvector_serial.h>
#include <string.h>
#include <vector>
#include <cmath>
#include <map>
#include <algorithm>
#include <iomanip>

#include "DYNSolverKINAlgRestoration.h"
#include "DYNSolverCommon.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNModel.h"
#include "DYNSparseMatrix.h"

using std::vector;
using std::map;
using std::string;
using std::stringstream;
using boost::shared_ptr;

namespace DYN {

SolverKINAlgRestoration::SolverKINAlgRestoration() :
model_(),
mode_(KIN_NORMAL) {
  SolverKINCommon();
}

SolverKINAlgRestoration::~SolverKINAlgRestoration() {
  clean();
}

void
SolverKINAlgRestoration::init(const shared_ptr<Model>& model, modeKin_t mode, double fnormtol, double scsteptol,
                              double mxnewtstep, int msbset, int mxiter, int printfl) {
  // (1) Arguments
  // --------------
  clean();

  model_ = model;
  mode_ = mode;

  // (2) Size of the problem
  // -------------------------------
  fType_.resize(model->sizeF());
  std::copy(model_->getFType(), model_->getFType() + model->sizeF(), fType_.begin());

  vId_.resize(model->sizeY());
  std::copy(model_->getYType(), model_->getYType() + model->sizeY(), vId_.begin());
  switch (mode) {
    case KIN_NORMAL:
      nbF_ = count(fType_.begin(), fType_.end(), DYN::ALGEBRIC_EQ);  // Only algebraic equation
      break;
    case KIN_YPRIM:
      nbF_ = count(fType_.begin(), fType_.end(), DYN::DIFFERENTIAL_EQ);  // Only differential equation
      break;
  }

  if (nbF_ == 0)
    return;

  F_.resize(model_->sizeF());
  vYy_.assign(nbF_, 0);

  yy_ = N_VMake_Serial(nbF_, &(vYy_[0]));
  if (yy_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYY);

  switch (mode) {
    case KIN_NORMAL:
      initCommon("KLU", fnormtol, scsteptol, mxnewtstep, msbset, mxiter, printfl, evalF_KIN, evalJ_KIN);
      break;
    case KIN_YPRIM:
      initCommon("KLU", fnormtol, scsteptol, mxnewtstep, msbset, mxiter, printfl, evalF_KIN, evalJPrim_KIN);
      break;
  }

  // Analyze variables to find differential variables and differential equation
  // depending of the kind of the problem to solve, keep differential variables/equation or algebraic variables/equation
  ignoreY_.clear();  // variables to ignore
  ignoreF_.clear();  // equations to ignore
  indexY_.clear();  // variables to keep
  indexF_.clear();  // equations to keep

  // As sizeF and sizeY are equal, it is possible to fill F and Y vectors in the same loop
  switch (mode_) {
    case KIN_NORMAL: {
      for (int i = 0; i < model_->sizeF(); ++i) {
        if (fType_[i] > 0)
          ignoreF_.insert(i);
        else
          indexF_.push_back(i);

        if (vId_[i] > 0)
          ignoreY_.insert(i);
        else
          indexY_.push_back(i);
      }
      break;
    }
    case KIN_YPRIM: {
      for (int i = 0; i < model_->sizeF(); ++i) {
        if (fType_[i] < 0)
          ignoreF_.insert(i);
        else
          indexF_.push_back(i);

        if (vId_[i] < 0)
          ignoreY_.insert(i);
        else
          indexY_.push_back(i);
      }
      break;
    }
  }
  assert(ignoreF_.size() == ignoreY_.size());  // Jacobian should be square
  assert(indexF_.size() == indexY_.size());
}

void
SolverKINAlgRestoration::modifySettings(double fnormtol, double scsteptol, double mxnewtstep,
                  int msbset, int mxiter, int printfl) {
  if (nbF_ == 0)
    return;

  // Modify tolerances
  int flag = KINSetFuncNormTol(KINMem_, fnormtol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetFuncNormTol");

  flag = KINSetScaledStepTol(KINMem_, scsteptol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetScaledStepTol");

  // Modify the maximum allowable scaled step length
  flag = KINSetMaxNewtonStep(KINMem_, mxnewtstep);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetMaxNewtonStep");

  // Modify the maximum number of nonlinear iterations allowed
  flag = KINSetNumMaxIters(KINMem_, mxiter);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetNumMaxIters");

  // Modify the maximum number of iteration without preconditionner call (passing 0 means keeping the KINSOL default value, currently 10)
  flag = KINSetMaxSetupCalls(KINMem_, msbset);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetMaxSetupCalls");

  // Modify the options for error/info messages
  flag = KINSetPrintLevel(KINMem_, printfl);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetPrintLevel");
}

int
SolverKINAlgRestoration::evalF_KIN(N_Vector yy, N_Vector rr, void *data) {
  SolverKINAlgRestoration * solv = reinterpret_cast<SolverKINAlgRestoration*> (data);
  shared_ptr<Model> model = solv->getModel();

  double *irr = NV_DATA_S(rr);
  double *iyy = NV_DATA_S(yy);

  vector<double> Y(solv->y0_.begin(), solv->y0_.end());
  vector<double> YP(model->sizeY(), 0.);

  // evalF has already been called in the scaling part so it doesn't have to be called again for the first iteration
  if (solv->getFirstIteration()) {
    solv->setFirstIteration(false);
  } else {
    if (solv->mode_ == KIN_NORMAL) {
      // add current values of algebraic variables
      for (unsigned int i = 0; i < solv->indexY_.size(); ++i) {
        Y[solv->indexY_[i]] = iyy[i];
      }
      model->evalF(solv->t0_, &Y[0], &solv->yp0_[0], &solv->F_[0]);
    } else if (solv->mode_ == KIN_YPRIM) {
      for (unsigned int i = 0; i < solv->indexY_.size(); ++i) {
        YP[solv->indexY_[i]] = iyy[i];
      }
      model->evalF(solv->t0_, &solv->y0_[0], &YP[0], &solv->F_[0]);
    }
  }

  for (unsigned int i = 0; i < solv->indexF_.size(); ++i) {
    irr[i] = solv->F_[solv->indexF_[i]];
  }

#ifdef _DEBUG_
  // Print the current residual norms, the first one is used as a stopping criterion
  double weightedInfNorm = SolverCommon::weightedInfinityNorm(solv->F_, solv->indexF_, solv->fScale_);
  double wL2Norm = SolverCommon::weightedL2Norm(solv->F_, solv->indexF_, solv->fScale_);
  long int current_nni = 0;
  KINGetNumNonlinSolvIters(solv->KINMem_, &current_nni);
  Trace::debug() << DYNLog(SolverKINResidualNorm, current_nni, weightedInfNorm, wL2Norm) << Trace::endline;

  const int nbErr = 10;
  Trace::debug() << DYNLog(KinLargestErrors, nbErr) << Trace::endline;
  vector<std::pair<double, int> > fErr;
  for (unsigned int i = 0; i < solv->indexF_.size(); ++i)
    fErr.push_back(std::pair<double, int>(solv->F_[solv->indexF_[i]], i));
  SolverCommon::printLargestErrors(fErr, model, nbErr);
#endif
  return (0);
}

int
SolverKINAlgRestoration::evalJ_KIN(N_Vector yy, N_Vector /*rr*/,
         SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
  SolverKINAlgRestoration* solv = reinterpret_cast<SolverKINAlgRestoration*> (data);
  shared_ptr<Model> model = solv->getModel();

  double* iyy = NV_DATA_S(yy);

  vector<double> Y(solv->y0_.begin(), solv->y0_.end());

  // add current values of algebraic variables
  for (unsigned int i = 0; i < solv->indexY_.size(); ++i) {
    Y[solv->indexY_[i]] = iyy[i];
  }

  double cj = 1;

  SparseMatrix smj;
  smj.init(model->sizeY(), model->sizeY());
  model->copyContinuousVariables(&Y[0], &solv->yp0_[0]);
  model->evalJt(solv->t0_, cj, smj);

  // Erase useless values in the jacobian
  SparseMatrix smjKin;
  int size = solv->indexY_.size();
  smjKin.reserve(size);
  smj.erase(solv->ignoreY_, solv->ignoreF_, smjKin);
  SolverCommon::propagateMatrixStructureChangeToKINSOL(smjKin, JJ, size, solv->lastRowVals_, solv->LS_, solv->linearSolverName_, true);

  return (0);
}

int
SolverKINAlgRestoration::evalJPrim_KIN(N_Vector yy, N_Vector /*rr*/,
        SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
  SolverKINAlgRestoration* solv = reinterpret_cast<SolverKINAlgRestoration*> (data);
  shared_ptr<Model> model = solv->getModel();

  double* iyy = NV_DATA_S(yy);

  vector<double> YP(model->sizeY(), 0.);

  // add current values of the derivatives
  for (unsigned int i = 0; i < solv->indexY_.size(); ++i) {
    YP[solv->indexY_[i]] = iyy[i];
  }

  double cj = 1;

  SparseMatrix smj;
  smj.init(model->sizeY(), model->sizeY());
  model->copyContinuousVariables(&solv->y0_[0], &YP[0]);
  model->evalJtPrim(solv->t0_, cj, smj);

  // Erase useless values in the jacobian
  SparseMatrix smjKin;
  int size = solv->indexY_.size();
  smjKin.reserve(size);
  smj.erase(solv->ignoreY_, solv->ignoreF_, smjKin);
  SolverCommon::propagateMatrixStructureChangeToKINSOL(smjKin, JJ, size, solv->lastRowVals_, solv->LS_, solv->linearSolverName_, true);

  return (0);
}

void
SolverKINAlgRestoration::solve(bool noInitSetup) {
  if (nbF_ == 0)
    return;

  int flag = KINSetNoInitSetup(KINMem_, noInitSetup);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetNoInitSetup");

  // first evaluation of F in order to fill the scaling vector
  firstIteration_ = true;
  model_->evalF(t0_, &y0_[0], &yp0_[0], &F_[0]);

  // fScale
  fScale_.assign(indexF_.size(), 1.0);
  for (unsigned int i = 0; i < indexF_.size(); ++i) {
    if ( std::abs(F_[indexF_[i]]) > RCONST(1.0))
      fScale_[i] = 1. / std::abs(F_[indexF_[i]]);
  }

  // yScale
  yScale_.assign(indexY_.size(), 1.0);
  if (mode_ == KIN_NORMAL) {  // variables = YAlg
    for (unsigned int i = 0; i < indexY_.size(); ++i) {
      if (std::abs(y0_[indexY_[i]]) > RCONST(1.0)) {
        yScale_[i] = 1. / std::abs(y0_[indexY_[i]]);
      }
    }
  } else if (mode_ == KIN_YPRIM) {  // variables = YP
    for (unsigned int i = 0; i < indexY_.size(); ++i) {
      if (std::abs(yp0_[indexY_[i]]) > RCONST(1.0)) {
        yScale_[i] = 1. / std::abs(yp0_[indexY_[i]]);
      }
    }
  }

  flag = solveCommon();
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverSolveErrorKINSOL);
}

void
SolverKINAlgRestoration::setInitialValues(const double& t, const vector<double>& y, const vector<double>& yp) {
  t0_ = t;
  yp0_.assign(yp.begin(), yp.end());
  y0_.assign(y.begin(), y.end());

  switch (mode_) {
    case KIN_NORMAL: {
      for (unsigned int i = 0; i < indexY_.size(); ++i) {
        vYy_[i] = y0_[indexY_[i]];
      }
      break;
    }
    case KIN_YPRIM: {
      for (unsigned int i = 0; i < indexY_.size(); ++i) {
        vYy_[i] = yp0_[indexY_[i]];
      }
      break;
    }
  }
}

void
SolverKINAlgRestoration::getValues(vector<double>& y, vector<double>& yp) {
  switch (mode_) {
    case KIN_NORMAL: {
      yp.assign(yp0_.begin(), yp0_.end());
      for (unsigned int i = 0; i < indexY_.size(); ++i) {
        y0_[indexY_[i]] = vYy_[i];
      }
      y.assign(y0_.begin(), y0_.end());
      break;
    }
    case KIN_YPRIM: {
      y.assign(y0_.begin(), y0_.end());
      for (unsigned int i = 0; i < indexY_.size(); ++i) {
        yp0_[indexY_[i]] = vYy_[i];
      }
      yp.assign(yp0_.begin(), yp0_.end());
      break;
    }
  }
}

}  // namespace DYN
