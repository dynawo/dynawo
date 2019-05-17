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
 * @file  DYNSolverKIN.cpp
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

#include "DYNSolverKIN.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNModel.h"
#include "DYNSparseMatrix.h"
#include "DYNSolverCommon.h"

using std::vector;
using std::map;
using std::string;
using std::stringstream;
using boost::shared_ptr;

namespace DYN {

SolverKIN::SolverKIN() :
model_(),
mode_(KIN_NORMAL) {
  KINMem_ = NULL;
  yy_ = NULL;
  lastRowVals_ = NULL;
  LS_ = NULL;
  M_ = NULL;
  nbF_ = 0;
  t0_ = 0.;
}

SolverKIN::~SolverKIN() {
  clean();
}

void SolverKIN::clean() {
  if (M_ != NULL) {
    SUNMatDestroy(M_);
    M_ = NULL;
  }
  if (LS_ != NULL) {
    SUNLinSolFree(LS_);
    LS_ = NULL;
  }
  if (KINMem_ != NULL) {
    KINFree(&KINMem_);
    KINMem_ = NULL;
    if (yy_ != NULL) N_VDestroy_Serial(yy_);
  }
  if (lastRowVals_ != NULL) {
    free(lastRowVals_);
    lastRowVals_ = NULL;
  }
}

void
SolverKIN::init(const shared_ptr<Model>& model, modeKin_t mode, double scsteptol, double fnormtol,
                int mxiter, int nnz, int msbset, int mxnstepin, int printfl) {
  // (1) Arguments
  // --------------
  clean();

  model_ = model;
  mode_ = mode;

  // (2) Size of the problem
  // -------------------------------
  fType_.resize(model->sizeF());
  std::copy(model_->getFType(), model_->getFType() + model->sizeF(), fType_.begin());

  vId_.resize(model->sizeF());
  std::copy(model_->getYType(), model_->getYType() + model->sizeF(), vId_.begin());
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

  vYy_.resize(nbF_);
  yy_ = N_VMake_Serial(nbF_, &(vYy_[0]));
  if (yy_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYY);
  F_.resize(model_->sizeF());

  // (4) KIN CREATE
  // --------------------
  // Create internal memory of KINSOL
  KINMem_ = KINCreate();
  if (KINMem_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateKINSOL);

  // (5) KINInit
  // -----------
  int flag = KINInit(KINMem_, evalF_KIN, yy_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverInitKINSOL);

  // (6) KINtolerances
  // -------------------
  flag = KINSetFuncNormTol(KINMem_, fnormtol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetFuncNormTol");

  flag = KINSetScaledStepTol(KINMem_, scsteptol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetScaledStepTol");

  // (7) KINSet
  // ----------
  // Specify user memory to use in all function (instance of solver)
  flag = KINSetUserData(KINMem_, this);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetUserdata");

  // Specify method to use to print error message
  flag = KINSetErrHandlerFn(KINMem_, errHandlerFn, NULL);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetErrHandlerFn");

  // Specify the maximum number of nonlinear iterations allowed
  flag = KINSetNumMaxIters(KINMem_, mxiter);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetNumMaxIters");

  // Specify the maximum number of iteration without preconditionner call (passing 0 means keeping the KINSOL default value, currently 10)
  flag = KINSetMaxSetupCalls(KINMem_, msbset);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetMaxSetupCalls");

  // Specify the maximum allowable scaled step length
  flag = KINSetMaxNewtonStep(KINMem_, mxnstepin);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetMaxNewtonStep");

  // (8) Solver choice
  // -------------------
  M_ = SUNSparseMatrix(nbF_, nbF_, nnz, CSR_MAT);
  if (M_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "SUNSparseMatrix");

  LS_ = SUNLinSol_KLU(yy_, M_);
  if (LS_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "SUNLinSol_KLU");

  flag = KINSetLinearSolver(KINMem_, LS_, M_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetLinearSolver");

  // (9) Solver options
  // -------------------
  switch (mode) {
    case KIN_NORMAL:
      flag = KINSetJacFn(KINMem_, evalJ_KIN);
      break;
    case KIN_YPRIM:
      flag = KINSetJacFn(KINMem_, evalJPrim_KIN);
      break;
  }

  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetJacFn");

  // (10) Options for error/infos messages
  // -------------------------------------
  flag = KINSetPrintLevel(KINMem_, printfl);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetPrintLevel");

  // To avoid any printing at all
  flag = KINSetInfoHandlerFn(KINMem_, infoHandlerFn, NULL);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetInfoHandlerFn");

  // analyse variables to find differential variables and differential equation
  // depending of the kind of the problem to solve, keep differential variables/equation or algebraic variables/equation
  ignoreY_.clear();  // variables to ignore
  ignoreF_.clear();  // equations to ignore
  indexY_.clear();  // variables to keep
  indexF_.clear();  // equations to keep

  // small improve here : size of F and Y should be equal by construction, consenquently we merged 2 for loops in one
  switch (mode_) {
    case KIN_NORMAL: {
      for (int i = 0; i < model_->sizeF(); ++i) {
        if (fType_[i] > 0)
          ignoreF_.push_back(i);
        else
          indexF_.push_back(i);

        if (vId_[i] > 0)
          ignoreY_.push_back(i);
        else
          indexY_.push_back(i);
      }
      break;
    }
    case KIN_YPRIM: {
      for (int i = 0; i < model_->sizeF(); ++i) {
        if (fType_[i] < 0)
          ignoreF_.push_back(i);
        else
          indexF_.push_back(i);

        if (vId_[i] < 0)
          ignoreY_.push_back(i);
        else
          indexY_.push_back(i);
      }
      break;
    }
  }
  assert(ignoreF_.size() == ignoreY_.size());  // Jacobian should be square
  assert(indexF_.size() == indexY_.size());
}

int
SolverKIN::evalF_KIN(N_Vector yy, N_Vector rr, void *data) {
  SolverKIN * solv = reinterpret_cast<SolverKIN*> (data);
  shared_ptr<Model> model = solv->getModel();

  double *irr = NV_DATA_S(rr);
  double *iyy = NV_DATA_S(yy);

  vector<double> Y(solv->y0_.begin(), solv->y0_.end());
  vector<double> YP(model->sizeY(), 0.);

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

  for (unsigned int i = 0; i < solv->indexF_.size(); ++i) {
    irr[i] = solv->F_[solv->indexF_[i]];
  }

#ifdef _DEBUG_
  // Print the current residual norms, the first one is used as a stopping criterion
  double weightedInfNorm = weightedInfinityNorm(solv->F_, solv->indexF_, solv->fScaling_);
  double wL2Norm = weightedL2Norm(solv->F_, solv->indexF_, solv->fScaling_);
  int64_t current_nni = 0;
  KINGetNumNonlinSolvIters(solv->KINMem_, &current_nni);
  Trace::debug() << DYNLog(SolverKINResidualNorm, current_nni, weightedInfNorm, wL2Norm) << Trace::endline;
#endif
  return (0);
}

int
SolverKIN::evalJ_KIN(N_Vector yy, N_Vector /*rr*/,
         SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
  SolverKIN* solv = reinterpret_cast<SolverKIN*> (data);
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
  model->evalJt(solv->t0_, &Y[0], &solv->yp0_[0], cj, smj);

  // Erase useless values in the jacobian
  SparseMatrix smjKin;
  int size = solv->indexY_.size();
  smjKin.reserve(size);
  smj.erase(solv->ignoreY_, solv->ignoreF_, smjKin);

  bool matrixStructChange = copySparseToKINSOL(smjKin, JJ, size, solv->lastRowVals_);

  if (matrixStructChange) {
    Trace::debug() << DYNLog(MatrixStructureChange) << Trace::endline;
    SUNLinSol_KLUReInit(solv->LS_, JJ, SM_NNZ_S(JJ), 2);  // reinit symbolic factorisation
    if (solv->lastRowVals_ != NULL) {
      free(solv->lastRowVals_);
    }
    solv->lastRowVals_ = reinterpret_cast<sunindextype*> (malloc(sizeof (sunindextype)*SM_NNZ_S(JJ)));
    memcpy(solv->lastRowVals_, SM_INDEXVALS_S(JJ), sizeof (sunindextype)*SM_NNZ_S(JJ));
  }
  return (0);
}

int
SolverKIN::evalJPrim_KIN(N_Vector yy, N_Vector /*rr*/,
        SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
  SolverKIN* solv = reinterpret_cast<SolverKIN*> (data);
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
  model->evalJtPrim(solv->t0_, &solv->y0_[0], &YP[0], cj, smj);

  // Erase useless values in the jacobian
  SparseMatrix smjKin;
  int size = solv->indexY_.size();
  smjKin.reserve(size);
  smj.erase(solv->ignoreY_, solv->ignoreF_, smjKin);

  bool matrixStructChange = copySparseToKINSOL(smjKin, JJ, size, solv->lastRowVals_);

  if (matrixStructChange) {
    SUNLinSol_KLUReInit(solv->LS_, JJ, SM_NNZ_S(JJ), 2);  // reinit symbolic factorisation
    if (solv->lastRowVals_ != NULL) {
      free(solv->lastRowVals_);
    }
    solv->lastRowVals_ = reinterpret_cast<sunindextype*> (malloc(sizeof (sunindextype)*SM_NNZ_S(JJ)));
    memcpy(solv->lastRowVals_, SM_INDEXVALS_S(JJ), sizeof (sunindextype)*SM_NNZ_S(JJ));
  }

  return (0);
}

void
SolverKIN::analyseFlag(const int & flag) {
  stringstream msg;
  switch (flag) {
    case KIN_SUCCESS:
      msg << DYNLog(KinsolSucceeded);
      break;
    case KIN_INITIAL_GUESS_OK:
      msg << DYNLog(KinInitialGuessOk);
      break;
    case KIN_STEP_LT_STPTOL:
      msg << DYNLog(KinStepLtStpTol);
      break;
    case KIN_MEM_NULL:
      msg << DYNLog(KinMemNull);
      break;
    case KIN_ILL_INPUT:
      msg << DYNLog(KinIllInput);
      break;
    case KIN_NO_MALLOC:
      msg << DYNLog(KinNoMalloc);
      break;
    case KIN_LINESEARCH_NONCONV:
      msg << DYNLog(KinLineSearchNonConv);
      break;
    case KIN_MAXITER_REACHED:
      msg << DYNLog(KinMaxIterReached);
      break;
    case KIN_MXNEWT_5X_EXCEEDED:
      msg << DYNLog(KinMxNewt5xExceeded);
      break;
    case KIN_LINESEARCH_BCFAIL:
      msg << DYNLog(KinLineSearchBcFail);
      break;
    case KIN_LINSOLV_NO_RECOVERY:
      msg << DYNLog(KinLinsolvNoRecovery);
      break;
    case KIN_LINIT_FAIL:
      msg << DYNLog(KinLinitFail);
      break;
    case KIN_LSETUP_FAIL:
      msg << DYNLog(KinLsetupFail);
      break;
    case KIN_LSOLVE_FAIL:
      msg << DYNLog(KinLsolveFail);
      break;
    case KIN_SYSFUNC_FAIL:
      msg << DYNLog(KinSysFuncFail);
      break;
    case KIN_FIRST_SYSFUNC_ERR:
      msg << DYNLog(KinFirstSysFuncErr);
      break;
    case KIN_REPTD_SYSFUNC_ERR:
      msg << DYNLog(KinReptdSysfuncErr);
      break;
    default:
#ifdef _DEBUG_
      Trace::debug() << DYNLog(SolverKINUnknownError) << Trace::endline;
#endif
      throw DYNError(Error::SUNDIALS_ERROR, SolverSolveErrorKINSOL);
  }

  if (flag < 0) {
#ifdef _DEBUG_
    Trace::debug() << msg.str() << Trace::endline;
#endif
    throw DYNError(Error::SUNDIALS_ERROR, SolverSolveErrorKINSOL);
  }
}

void
SolverKIN::solve() {
  if (nbF_ == 0)
    return;

  // first evaluation of F in order to fill the scaling vector
  model_->evalF(t0_, &y0_[0], &yp0_[0], &F_[0]);

  // yScaling
  yScaling_.resize(indexY_.size(), 1.0);
  if (mode_ == KIN_NORMAL) {  // variables = YAlg
    for (unsigned int i = 0; i < indexY_.size(); ++i) {
      if (std::abs(y0_[indexY_[i]]) > RCONST(1.0)) {
        yScaling_[i] = 1. / std::abs(y0_[indexY_[i]]);
      }
    }
  } else if (mode_ == KIN_YPRIM) {  // variables = YP
    for (unsigned int i = 0; i < indexY_.size(); ++i) {
      if (std::abs(yp0_[indexY_[i]]) > RCONST(1.0)) {
        yScaling_[i] = 1. / std::abs(yp0_[indexY_[i]]);
      }
    }
  }

  // fScaling
  fScaling_.resize(indexF_.size(), 1.0);
  if (mode_ == KIN_NORMAL) {
    for (unsigned int i = 0; i < indexF_.size(); ++i) {
      if ( std::abs(F_[indexF_[i]]) > RCONST(1.0))
        fScaling_[i] = 1. / std::abs(F_[indexF_[i]]);
    }
  } else if (mode_ == KIN_YPRIM) {
    for (unsigned int i = 0; i < indexF_.size(); ++i) {
      if ( std::abs(F_[indexF_[i]]) > RCONST(1.0))
        fScaling_[i] = 1. / std::abs(F_[indexF_[i]]);
    }
  }

  N_Vector scalef = N_VMake_Serial(fScaling_.size(), &(fScaling_[0]));
  if (scalef == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverScalingErrorKINSOL);

  N_Vector scaley = N_VMake_Serial(yScaling_.size(), &(yScaling_[0]));
  if (scaley == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverScalingErrorKINSOL);

  int flag = KINSol(KINMem_, yy_, KIN_NONE, scaley, scalef);

#ifdef _DEBUG_
  // Printing the largest residuals at the end of the iteration
  double tolerance = 1e-04;
  int nbErr = 10;
  // Filling and sorting the vector
  vector<std::pair<double, int> > fErr;
  for (unsigned int i = 0; i < indexF_.size(); ++i) {
    if (fabs(F_[indexF_[i]]) > tolerance) {
      fErr.push_back(std::pair<double, int>(F_[indexF_[i]], i));
    }
  }
  std::sort(fErr.begin(), fErr.end(), mapcompabs());

  if (fErr.size() > 0) {
    Trace::debug() << DYNLog(SolverKINLargestErrors, nbErr) << Trace::endline;
    printLargestErrors(fErr, model_, nbErr, tolerance);
  }
#endif

  if (scaley != NULL) N_VDestroy_Serial(scaley);
  if (scalef != NULL) N_VDestroy_Serial(scalef);

  analyseFlag(flag);
  int64_t nfevals;
  int flag1 = KINGetNumFuncEvals(KINMem_, &nfevals);
  if (flag1 < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINGetNumFuncEvals");
}

void
SolverKIN::setInitialValues(const double& t, const vector<double>& y, const vector<double>& yp) {
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
SolverKIN::getValues(vector<double>& y, vector<double>& yp) {
  switch (mode_) {
    case KIN_NORMAL: {
      for (unsigned int i = 0; i < indexY_.size(); ++i) {
        y0_[indexY_[i]] = vYy_[i];
      }
      y.assign(y0_.begin(), y0_.end());
      yp.assign(yp0_.begin(), yp0_.end());
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

void
SolverKIN::errHandlerFn(int /*error_code*/, const char* /*module*/, const char* /*function*/,
        char* /*msg*/, void* /*eh_data*/) {
  // error messages are analysed by  analyseFlag method, no need to print error message
}

void
SolverKIN::infoHandlerFn(const char* module, const char* function,
        char* msg, void* /*eh_data*/) {
  Trace::info() << module << " " << function << " :" << msg << Trace::endline;
}

}  // namespace DYN
