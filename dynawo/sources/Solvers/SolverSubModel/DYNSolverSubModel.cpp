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
 * @file  DYNSolverSubModel.cpp
 *
 * @brief Implementation of the solver used to calculate the initial values of the model
 *
 */
#include <kinsol/kinsol.h>
#include <sunlinsol/sunlinsol_klu.h>
#include <sundials/sundials_types.h>
#include <sundials/sundials_math.h>
#include <sundials/sundials_sparse.h>
#include <nvector/nvector_serial.h>
#include <cstring>
#include <vector>
#include <cmath>
#include <map>
#include <iomanip>

#include "DYNSolverSubModel.h"
#include "DYNSubModel.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNSparseMatrix.h"
#include "DYNSolverCommon.h"
#include "DYNTimer.h"

using std::vector;
using std::map;
using std::string;
using std::stringstream;
using boost::shared_ptr;

namespace DYN {

SolverSubModel::SolverSubModel() :
subModel_() {
  KINMem_ = NULL;
  yy_ = NULL;
  scaley_ = NULL;
  scalef_ = NULL;
  lastRowVals_ = NULL;
  LS_ = NULL;
  M_ = NULL;
  yBuffer_ = NULL;
  fBuffer_ = NULL;
  nbF_ = 0;
  t0_ = 0.;
  firstIteration_ = false;
}

SolverSubModel::~SolverSubModel() {
  clean();
}

void SolverSubModel::clean() {
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
    if (scaley_ != NULL) N_VDestroy_Serial(scaley_);
    if (scalef_ != NULL) N_VDestroy_Serial(scalef_);
  }
  if (lastRowVals_ != NULL) {
    free(lastRowVals_);
    lastRowVals_ = NULL;
  }
}

void
SolverSubModel::init(SubModel* subModel, const double t0, double* yBuffer, double *fBuffer) {
  // (1) Attributes
  // --------------
  clean();

  subModel_ = subModel;
  t0_ = t0;
  yBuffer_ = yBuffer;
  fBuffer_ = fBuffer;

  // (2) Size of the problem to solve
  // --------------------------------
  nbF_ = subModel_->sizeF();  // All the equations

  if (nbF_ == 0)
    return;
  vYy_.assign(yBuffer, yBuffer + nbF_);  // to keep, even if no used in this code, usefull for sundials
  yy_ = N_VMake_Serial(nbF_, &vYy_[0]);
  if (yy_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYY);

  // (4) KIN CREATE
  // --------------------
  // create internal memory for KINSOL solver
  KINMem_ = KINCreate();
  if (KINMem_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateKINSOL);

  // (5) KINInit
  // -----------
  int flag = -1;
  flag = KINInit(KINMem_, evalFInit_KIN, yy_);

  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverInitKINSOL);

  // (6) KINtolerances
  // -------------------
  double scsteptol = 1e-5;
  double fnormtol = 1e-5;
  flag = KINSetFuncNormTol(KINMem_, fnormtol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetFuncNormTol");

  flag = KINSetScaledStepTol(KINMem_, scsteptol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetScaledStepTol");

  // (7) KINSet
  // ----------
  // initialize data pointer (used in KINResFn)
  flag = KINSetUserData(KINMem_, this);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetUserdata");

  // indicates to the solver which functions used to print error message
  flag = KINSetErrHandlerFn(KINMem_, errHandlerFn, NULL);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetErrHandlerFn");

  // set the newton step
  flag = KINSetMaxNewtonStep(KINMem_, 30);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetMaxNewtonStep");

  flag = KINSetMaxSetupCalls(KINMem_, 1);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetMaxSetupCalls");

  // (8) Choose the library used to perform the LU factorisation
  // -----------------------------------------------------------
  M_ = SUNSparseMatrix(subModel->sizeY(), subModel->sizeY(), 10, CSR_MAT);
  if (M_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "Matrix Initialization");
  LS_ = SUNLinSol_KLU(yy_, M_);
  if (LS_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KLU solver object");
  flag = KINSetLinearSolver(KINMem_, LS_, M_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINKLU");

  // (9) Solver options
  // ------------------
  flag = KINSetJacFn(KINMem_, evalJInit_KIN);

  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSlsSetSparseJacFn");

  // (10) Log options
  // ----------------
  flag = KINSetPrintLevel(KINMem_, 0);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetPrintLevel");

  flag = KINSetInfoHandlerFn(KINMem_, infoHandlerFn, NULL);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetInfoHandlerFn");
}

int
SolverSubModel::evalFInit_KIN(N_Vector yy, N_Vector rr, void *data) {
  SolverSubModel * solv = reinterpret_cast<SolverSubModel*> (data);
  SubModel* subModel = solv->getSubModel();

  if (solv->getFirstIteration()) {
    solv->setFirstIteration(false);
  } else {  // update of F
    realtype *iyy = NV_DATA_S(yy);
    int yL = NV_LENGTH_S(yy);
    std::copy(iyy, iyy+yL, solv->yBuffer_);
    subModel->evalF(solv->t0_);
  }

  // copy of values in output vector
  realtype *irr = NV_DATA_S(rr);
  memcpy(irr, solv->fBuffer_, solv->nbF_ * sizeof(solv->fBuffer_[0]));

#ifdef _DEBUG_
  double tolerance = 1e-04;
  int nbErr = 10;

  Trace::debug("MODELER") << " =================================================================" << Trace::endline;
  vector<std::pair<double, int> > fErr;
  for (unsigned int i = 0; i < solv->nbF_; ++i) {
    if (fabs(irr[i]) > tolerance) {
      fErr.push_back(std::pair<double, int>(irr[i], i));
    }
  }

  std::sort(fErr.begin(), fErr.end(), mapcompabs());

  if (fErr.size() > 0) {
    vector<std::pair<double, int> >::iterator it;
    int i = 0;
    for (it = fErr.begin(); it != fErr.end(); ++it) {
      Trace::debug("MODELER") << DYNLog(SolveParametersError, tolerance, it->second, irr[it->second],
                                 subModel->getFequationByLocalIndex(it->second)) << Trace::endline;

      if (i >= nbErr) {
        Trace::debug("MODELER") << " =================================================================" << Trace::endline;
        break;
      }
      ++i;
    }
  }
#endif

  return (0);
}

int
SolverSubModel::evalJInit_KIN(N_Vector yy, N_Vector /*rr*/,
        SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
  SolverSubModel* solv = reinterpret_cast<SolverSubModel*> (data);
  SubModel* subModel = solv->getSubModel();

  realtype *iyy = NV_DATA_S(yy);
  int yL = NV_LENGTH_S(yy);
  std::copy(iyy, iyy+yL, solv->yBuffer_);

  // Sparse matrix
  // -------------
  SparseMatrix smj;
  int size = subModel->sizeY();
  smj.init(size, size);

  // valeurs arbitraires pour cj
  double cj = 1;
  subModel->evalJt(solv->t0_, cj, smj, 0);

  bool matrixStructChange = copySparseToKINSOL(smj, JJ, size, solv->lastRowVals_);

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
SolverSubModel::analyseFlag(const int& flag) {
  switch (flag) {
    case KIN_SUCCESS:
      Trace::debug() << DYNLog(KinsolSucceeded) << Trace::endline;
      break;
    case KIN_INITIAL_GUESS_OK:
      Trace::debug() << DYNLog(KinInitialGuessOk) << Trace::endline;
      break;
    case KIN_STEP_LT_STPTOL:
      Trace::debug() << DYNLog(KinStepLtStpTol) << Trace::endline;
      break;
    case KIN_MEM_NULL:
      Trace::debug() << DYNLog(KinMemNull) << Trace::endline;
      break;
    case KIN_ILL_INPUT:
      Trace::debug() << DYNLog(KinIllInput) << Trace::endline;
      break;
    case KIN_NO_MALLOC:
      Trace::debug() << DYNLog(KinNoMalloc) << Trace::endline;
      break;
    case KIN_LINESEARCH_NONCONV:
      Trace::debug() << DYNLog(KinLineSearchNonConv) << Trace::endline;
      break;
    case KIN_MAXITER_REACHED:
      Trace::debug() << DYNLog(KinMaxIterReached) << Trace::endline;
      break;
    case KIN_MXNEWT_5X_EXCEEDED:
      Trace::debug() << DYNLog(KinMxNewt5xExceeded) << Trace::endline;
      break;
    case KIN_LINESEARCH_BCFAIL:
      Trace::debug() << DYNLog(KinLineSearchBcFail) << Trace::endline;
      break;
    case KIN_LINSOLV_NO_RECOVERY:
      Trace::debug() << DYNLog(KinLinsolvNoRecovery) << Trace::endline;
      break;
    case KIN_LINIT_FAIL:
      Trace::debug() << DYNLog(KinLinitFail) << Trace::endline;
      break;
    case KIN_LSETUP_FAIL:
      Trace::debug() << DYNLog(KinLsetupFail) << Trace::endline;
      break;
    case KIN_LSOLVE_FAIL:
      Trace::debug() << DYNLog(KinLsolveFail) << Trace::endline;
      break;
    case KIN_SYSFUNC_FAIL:
      Trace::debug() << DYNLog(KinSysFuncFail) << Trace::endline;
      break;
    case KIN_FIRST_SYSFUNC_ERR:
      Trace::debug() << DYNLog(KinFirstSysFuncErr) << Trace::endline;
      break;
    case KIN_REPTD_SYSFUNC_ERR:
      Trace::debug() << DYNLog(KinReptdSysfuncErr) << Trace::endline;
      break;
  }
}

void
SolverSubModel::setNbMaxIterations(int nbIterations) {
  int flag = KINSetNumMaxIters(KINMem_, nbIterations);

  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetNumMaxIters");
}

void
SolverSubModel::solve() {
  Timer timer("SolverSubModel::solve");
  if (nbF_ == 0)
    return;

  firstIteration_ = true;

  SubModel* subModel = getSubModel();
  scaley_ = N_VNew_Serial(subModel->sizeY());

  if (scaley_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverScalingErrorKINSOL);
  N_VConst_Serial(1.0, scaley_);

  vector<double> fScale;
  fScale.assign(subModel->sizeF(), 1.0);

  subModel->evalF(t0_);
  for (unsigned int i = 0; i < nbF_; ++i) {
    if (std::abs(fBuffer_[i])  > 1.)
      fScale[i] = 1 / std::abs(fBuffer_[i]);
  }

  scalef_ = N_VMake_Serial(subModel->sizeF(), &(fScale[0]));
  if (scalef_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverScalingErrorKINSOL);

  // fin test
  int flag = KINSol(KINMem_,  // KINSOL Memory
          yy_,  // Current values
          KIN_NONE,  // strategy used by the newton
          scaley_,  // scaling vector for the variable cc
          scalef_);  // scaling vector for fvalue;

  if (flag < 0) {
    analyseFlag(flag);
    throw DYNError(Error::SUNDIALS_ERROR, SolverSolveErrorKINSOL);
  }
  long int nfevals;
  int flag1 = KINGetNumFuncEvals(KINMem_, &nfevals);
  if (flag1 < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINGetNumFuncEvals");
}

void
SolverSubModel::errHandlerFn(int error_code, const char* module, const char* function,
        char* msg, void* /*eh_data*/) {
  if (error_code == KIN_WARNING) {
    Trace::warn() << module << " " << function << " :" << msg << Trace::endline;
  } else {
    Trace::error() << module << " " << function << " :" << msg << Trace::endline;
  }
}

void
SolverSubModel::infoHandlerFn(const char* module, const char* function,
        char* msg, void* /*eh_data*/) {
  Trace::info() << module << " " << function << " :" << msg << Trace::endline;
}

}  // namespace DYN
