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
 * @file  DYNSolverKINCommon.cpp
 *
 * @brief Implementation of solver based on sundials/KINSOL solver
 *
 */

#include <kinsol/kinsol.h>
#include <sundials/sundials_linearsolver.h>
#include <sundials/sundials_matrix.h>
#include <sunlinsol/sunlinsol_klu.h>
#include <sunmatrix/sunmatrix_sparse.h>
#include <nvector/nvector_serial.h>

#include <sstream>

#include "DYNSolverKINCommon.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNSolverCommon.h"

using std::stringstream;

namespace DYN {

SolverKINCommon::SolverKINCommon() :
KINMem_(NULL),
linearSolver_(NULL),
sundialsMatrix_(NULL),
sundialsVectorY_(NULL),
numF_(0),
t0_(0.),
firstIteration_(false),
sundialsVectorFScale_(NULL),
sundialsVectorYScale_(NULL) {
  if (SUNContext_Create(NULL, &sundialsContext_) != 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverContextCreationError);
}

SolverKINCommon::~SolverKINCommon() {
  clean();
  // This vector is not allocated by this class so no need to release the memory
  if (sundialsVectorY_ != NULL)
    sundialsVectorY_ = NULL;
  SUNContext_Free(&sundialsContext_);
}

void SolverKINCommon::clean() {
  if (sundialsMatrix_ != NULL) {
    SolverCommon::cleanSUNMatrix(sundialsMatrix_);
    SUNMatDestroy(sundialsMatrix_);
    sundialsMatrix_ = NULL;
  }
  if (linearSolver_ != NULL) {
    SUNLinSolFree(linearSolver_);
    linearSolver_ = NULL;
  }
  if (KINMem_ != NULL) {
    KINFree(&KINMem_);
    KINMem_ = NULL;
  }

  if (sundialsVectorFScale_ != NULL) {
    N_VDestroy_Serial(sundialsVectorFScale_);
    sundialsVectorFScale_ = NULL;
  }
  if (sundialsVectorYScale_ != NULL) {
    N_VDestroy_Serial(sundialsVectorYScale_);
    sundialsVectorYScale_ = NULL;
  }
}

void
SolverKINCommon::initCommon(double fnormtol, double initialaddtol, double scsteptol,
                     double mxnewtstep, int msbset, int mxiter, int printfl, KINSysFn evalF, KINLsJacFn evalJ, N_Vector sundialsVectorY) {
  sundialsVectorY_ = sundialsVectorY;

  // (1) Problem size
  // ----------------
  if (numF_ == 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverEmptyYVector);

  // (2) Creation of Kinsol internal memory
  // --------------------------------------
  KINMem_ = KINCreate(sundialsContext_);
  if (KINMem_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINCreate");

  // (3) Kinsol initialization
  // -------------------------
  int flag = KINInit(KINMem_, evalF, sundialsVectorY_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINInit");

  // (5) Specify tolerance of Kinsol
  // -------------------------------
  flag = KINSetFuncNormTol(KINMem_, fnormtol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetFuncNormTol");

  flag = KINSetInitialAdditionalTolerance(KINMem_, initialaddtol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetInitialAdditionalTolerance");

  flag = KINSetScaledStepTol(KINMem_, scsteptol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetScaledStepTol");

  // (7) Kinsol options
  // ------------------
  // Specify user memory to use in all function (instance of solver)
  flag = KINSetUserData(KINMem_, this);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetUserdata");

  // (6) Linear Solver choice
  // -------------------
  // Passing CSR_MAT indicates that we solve A'x = B - linear system using the matrix transpose -
  // and not Ax = B (see sunlinsol_klu.c:149)
  const int nnz = 0;  // This value will be adjusted later on in the process
  sundialsMatrix_ = SUNSparseMatrix(numF_, numF_, nnz, CSR_MAT, sundialsContext_);
  if (sundialsMatrix_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "SUNSparseMatrix");
  // We release any memory allocated by Sundials as underlying arrays will never be used
  SolverCommon::freeSUNMatrix(sundialsMatrix_);
  linearSolver_ = SUNLinSol_KLU(sundialsVectorY_, sundialsMatrix_, sundialsContext_);
  if (linearSolver_ == NULL)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "SUNLinSol_KLU");
  flag = KINSetLinearSolver(KINMem_, linearSolver_, sundialsMatrix_);
  if (flag < 0)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINKLU");

  // Specify method to use to print error message
  flag = KINSetErrHandlerFn(KINMem_, errHandlerFn, NULL);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetErrHandlerFn");

  // Specify the maximum number of nonlinear iterations allowed
  flag = KINSetNumMaxIters(KINMem_, mxiter);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetNumMaxIters");

  // Specify the maximum number of iteration without pre-conditionner call
  // Passing 0 means default i.e. 10 iterations
  // Passing 1 means exact Newton
  flag = KINSetMaxSetupCalls(KINMem_, msbset);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetMaxSetupCalls");

  // Specify the maximum allowable scaled length of Newton step
  flag = KINSetMaxNewtonStep(KINMem_, mxnewtstep);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetMaxNewtonStep");

  // Specify the jacobian function to use
  flag = KINSetJacFn(KINMem_, evalJ);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSlsSetSparseJacFn");

  // Options for error/infos messages
  flag = KINSetPrintLevel(KINMem_, printfl);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetPrintLevel");

  vectorFScale_.resize(numF_);
  vectorYScale_.resize(numF_);
  sundialsVectorFScale_ = N_VMake_Serial(numF_, &vectorFScale_[0], sundialsContext_);
  sundialsVectorYScale_ = N_VMake_Serial(numF_, &vectorYScale_[0], sundialsContext_);
}

int
SolverKINCommon::solveCommon(int strategy) {
  int flag = KINSol(KINMem_, sundialsVectorY_, strategy, sundialsVectorYScale_, sundialsVectorFScale_);
  analyseFlag(flag);

  return flag;
}

void
SolverKINCommon::analyseFlag(const int flag) {
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
    case KIN_MEM_FAIL:
      msg << DYNLog(KinMemFail);
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
    case KIN_VECTOROP_ERR:
      msg << DYNLog(KinVectoropErr);
      break;
    default:
#ifdef _DEBUG_
      Trace::error() << DYNLog(SolverKINUnknownError) << Trace::endline;
#endif
      throw DYNError(Error::SUNDIALS_ERROR, SolverSolveErrorKINSOL);
  }

  if (flag < 0)
    Trace::warn() << msg.str() << Trace::endline;
}

void
SolverKINCommon::errHandlerFn(int /*error_code*/, const char* /*module*/, const char* /*function*/,
        char* /*msg*/, void* /*eh_data*/) {
  // error messages are analysed by analyseFlag method, no need to print error message
}

void
SolverKINCommon::infoHandlerFn(const char* module, const char* function,
        char* msg, void* /*eh_data*/) {
  Trace::info() << module << " " << function << " :" << msg << Trace::endline;
}

void
SolverKINCommon::updateStatistics(long int& nni, long int& nre, long int& nje) {
  if (KINMem_ == NULL)
    return;

  int flag = KINGetNumNonlinSolvIters(KINMem_, &nni);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINGetNumNonlinSolvIters");

  flag = KINGetNumFuncEvals(KINMem_, &nre);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINGetNumFuncEvals");

  flag = KINGetNumJacEvals(KINMem_, &nje);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINGetNumJacEvals");
}

}  // namespace DYN
