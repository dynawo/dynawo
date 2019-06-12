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
 * @file  DYNSolverEulerKIN.cpp
 *
 * @brief SolverEulerKin implementation
 *
 * SolverEulerKIN is the implementation of a solver with euler method based on
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
#include "DYNSolverEulerKIN.h"
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

SolverEulerKIN::SolverEulerKIN() :
model_() {
  KINMem_ = NULL;
  yy_ = NULL;
  yscale_ = NULL;
  fscale_ = NULL;
  lastRowVals_ = NULL;
  LS_ = NULL;
  M_ = NULL;
  firstIteration_ =  false;
  h0_ = 0.;
  t0_ = 0.;
}

SolverEulerKIN::~SolverEulerKIN() {
  clean();
}

void SolverEulerKIN::clean() {
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
    if (yscale_ != NULL) N_VDestroy_Serial(yscale_);
    if (fscale_ != NULL) N_VDestroy_Serial(fscale_);
  }
  if (lastRowVals_ != NULL) {
    free(lastRowVals_);
    lastRowVals_ = NULL;
  }
}

void
SolverEulerKIN::init(const shared_ptr<Model>& model, const std::string& linearSolverName) {
  clean();
  model_ = model;
  linearSolverName_ = linearSolverName;

  // (1) problem size
  // ----------------
  int sizeY = model_->sizeY();
  if (sizeY == 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverEmptyYVector);
  y0_.assign(sizeY, 0);
  vYy_.assign(sizeY, 0);
  F_.resize(model_->sizeF());
  YP_.assign(sizeY, 0);

  yy_ = N_VMake_Serial(sizeY, &(vYy_[0]));
  if (yy_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYY);


  // (2) Allocate scaling vectors
  //-----------------------------
  vFscale_.resize(model_->sizeF());
  fscale_ = N_VMake_Serial(sizeY, &(vFscale_[0]));
  if (fscale_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverScalingErrorKINSOL);

  vYscale_.resize(sizeY);
  yscale_ = N_VMake_Serial(sizeY, &(vYscale_[0]));
  if (yscale_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverScalingErrorKINSOL);

  // (3) creation of kinsol internal memory
  // --------------------------------------
  KINMem_ = KINCreate();
  if (KINMem_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINCreate");

  // (4) kinsol initialization
  // -------------------------
  int flag = KINInit(KINMem_, evalF_KIN, yy_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINInit");

  // (5) Specify torelance of kinsol
  // -------------------------------
  double fnormtol = 1e-4;
  flag = KINSetFuncNormTol(KINMem_, fnormtol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetFuncNormTol");

  double scsteptol = 1e-4;
  flag = KINSetScaledStepTol(KINMem_, scsteptol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetScaledStepTol");

  // (7) Kinsol options
  // ------------------
  // Specify user memory to use in all function (instance of solver)
  flag = KINSetUserData(KINMem_, this);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetUserdata");

  // (6) Solver choice
  // -------------------
  // Here CSR has nothing to do with how the matrix is stored but rather how to solve the linear system using the matrix (CSC_MAT) or its transpose (CSR_MAT)
  M_ = SUNSparseMatrix(sizeY, sizeY, 10., CSR_MAT);
  if (M_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "SUNSparseMatrix");
  if (linearSolverName_ == "KLU") {
    LS_ = SUNLinSol_KLU(yy_, M_);
    if (LS_ == NULL)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "SUNLinSol_KLU");
    flag = KINSetLinearSolver(KINMem_, LS_, M_);
    if (flag < 0)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINKLU");
#ifdef WITH_NICSLU
  } else if (linearSolverName_ == "NICSLU") {
    LS_ = SUNLinSol_NICSLU(yy_, M_);
    if (LS_ == NULL)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "SUNLinSol_NICSLU");
    flag = KINSetLinearSolver(KINMem_, LS_, M_);
    if (flag < 0)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "kinNICSLU");
#endif
  } else {
    throw DYNError(Error::SUNDIALS_ERROR, WrongLinearSolverChoice);
  }

  // Specify method to use to print error message
  flag = KINSetErrHandlerFn(KINMem_, errHandlerFn, NULL);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetErrHandlerFn");

  // Specify the maximum number of nonlinear iterations allowed
  flag = KINSetNumMaxIters(KINMem_, 30);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetNumMaxIters");

  // Specify the maximum number of iteration without preconditionner call
  // Passing 0 means default ie 10 iterations
  flag = KINSetMaxSetupCalls(KINMem_, 0);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetMaxSetupCalls");

  // Specify the jacobian function to use
  flag = KINSetJacFn(KINMem_, evalJ_KIN);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSlsSetSparseJacFn");

  // Specify the maximum allowable scaled length of newton step
  double mxstep = 100000;
  flag = KINSetMaxNewtonStep(KINMem_, mxstep);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetMaxNewtonStep");

  // Options for error/infos messages
  flag = KINSetPrintLevel(KINMem_, 0);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetPrintLevel");
}

int
SolverEulerKIN::evalF_KIN(N_Vector yy, N_Vector rr, void* data) {
  SolverEulerKIN* solv = reinterpret_cast<SolverEulerKIN*> (data);
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
  double weightedInfNorm = weightedInfinityNorm(solv->F_, solv->vFscale_);
  double wL2Norm = weightedL2Norm(solv->F_, solv->vFscale_);
  long int current_nni = 0;
  KINGetNumNonlinSolvIters(solv->KINMem_, &current_nni);
  Trace::debug() << DYNLog(SolverKINResidualNorm, current_nni, weightedInfNorm, wL2Norm) << Trace::endline;
#endif

  return (0);
}

int
SolverEulerKIN::evalJ_KIN(N_Vector yy, N_Vector /*rr*/,
        SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
  Timer timer("SolverEulerKIN::evalJ_KIN");
  SolverEulerKIN* solv = reinterpret_cast<SolverEulerKIN*> (data);
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

  bool matrixStructChange = copySparseToKINSOL(smj, JJ, size, solv->lastRowVals_);

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

void
SolverEulerKIN::errorTranslate(int flag) {
  std::stringstream msg;
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
  }
  if (flag != KIN_SUCCESS && flag != KIN_INITIAL_GUESS_OK && flag != KIN_STEP_LT_STPTOL)
    Trace::warn() << " KINSOL : " << msg.str() << Trace::endline;
}

int
SolverEulerKIN::solve(bool noInitSetup) {
  Timer timer("SolverEulerKIN::solve");
  int flag = KINSetNoInitSetup(KINMem_, noInitSetup);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetNoInitSetup");

  firstIteration_ = true;

  Timer* scaling = new Timer("SolverEulerKIN::scaling");
  model_->evalF(t0_ + h0_ , &y0_[0], &YP_[0], &F_[0]);

  std::fill(vYscale_.begin(), vYscale_.end(), 1.0);
  for (int i = 0; i < model_->sizeY(); ++i) {
    if (std::abs(y0_[i]) > RCONST(1.0))
      vYscale_[i] = 1 / std::abs(y0_[i]);
  }
  memcpy(NV_DATA_S(yscale_), &vYscale_[0], vYscale_.size() * sizeof (vYscale_[0]));

  std::fill(vFscale_.begin(), vFscale_.end(), 1.0);
  for (unsigned int i = 0; i < F_.size(); ++i) {
    if (std::abs(F_[i]) > RCONST(1.0))
      vFscale_[i] = 1 / std::abs(F_[i]);
  }
  memcpy(NV_DATA_S(fscale_), &vFscale_[0], vFscale_.size() * sizeof (vFscale_[0]));
  delete scaling;

  flag = KINSol(KINMem_, yy_, KIN_NONE, yscale_, fscale_);

#ifdef _DEBUG_
  /* The convergence criterion in Kinsol is based on the absolute value of the largest weighted residual that should be lower than the tolerance.
   * => Therefore the weighted residual larger than the tolerances at the end of the Newton iterations are a good indicator.
   */
  int nbF = model_->sizeF();
  int nbErr = 10;
  double tolerance = 1e-4;

  if (nbErr > nbF)
      nbErr = nbF;

  // Defining necessary data structure and retrieving information from Kinsol
  N_Vector nvWeights = N_VNew_Serial(nbF);
  N_Vector nvResiduals = N_VNew_Serial(nbF);
  if (KINGetWeights(KINMem_, nvWeights) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINGetWeights");

  if (KINGetResiduals(KINMem_, nvResiduals) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINGetResiduals");

  double* weights = NV_DATA_S(nvWeights);
  double* errors = NV_DATA_S(nvResiduals);

  for (int i = 0; i < nbF; ++i)
    errors[i] = fabs(weights[i] * errors[i]);

  // Filling and sorting the vector
  vector<std::pair<double, int> > fErr;
  for (int i = 0; i < nbF; ++i) {
    if (errors[i] > tolerance) {
      fErr.push_back(std::pair<double, int>(errors[i], i));
    }
  }
  if (fErr.size() > 0) {
    Trace::debug() << DYNLog(KinLargestErrors, nbErr, t0_ + h0_) << Trace::endline;
    printLargestErrors(fErr, model_, nbErr, tolerance);
  }

  // Destroying the specific data structures
  N_VDestroy_Serial(nvWeights);
  N_VDestroy_Serial(nvResiduals);
#endif

  if (flag < 0) {
    errorTranslate(flag);
  }
  if (flag == KIN_STEP_LT_STPTOL || flag == KIN_INITIAL_GUESS_OK)
    flag = KIN_SUCCESS;
  return flag;
}

void
SolverEulerKIN::setInitialValues(const double& t, const double& h, const vector<double>& y) {
  t0_ = t;
  h0_ = h;
  std::copy(y.begin(), y.end(), y0_.begin());
  std::copy(y.begin(), y.end(), vYy_.begin());
  // order-0 prediction - YP = 0
  std::fill(YP_.begin(), YP_.end(), 0);
}

void
SolverEulerKIN::setIdVars() {
  DYN::propertyContinuousVar_t* vId = model_->getYType();

  differentialVars_.clear();

  for (int i = 0; i < model_->sizeY(); ++i) {
    if (vId[i] == DYN::DIFFERENTIAL) {
      differentialVars_.push_back(i);
    }
  }
}

void
SolverEulerKIN::errHandlerFn(int /*error_code*/, const char* /*module*/, const char* /*function*/,
        char* /*msg*/, void* /*eh_data*/) {
  // error messages are analysed by  errorTranslate method, no need to print error message
}

void
SolverEulerKIN::updateStatistics(long int& nni, long int& nre, long int& nje) {
  KINGetNumNonlinSolvIters(KINMem_, &nni);
  KINGetNumFuncEvals(KINMem_, &nre);
  KINGetNumJacEvals(KINMem_, &nje);
}

}  // namespace DYN
