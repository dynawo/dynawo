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
 * @file  DYNSolverIDA.cpp
 *
 * @brief Solver implementation based on sundials/IDA solver
 */

#include <cmath>
#include <iostream>
#include <iomanip>
#include <vector>
#include <cstring>

#include <ida/ida.h>
#include <nvector/nvector_serial.h>
#include <sundials/sundials_types.h>
#include <sunmatrix/sunmatrix_sparse.h>
#include <sunlinsol/sunlinsol_klu.h>

#include "PARParametersSet.h"
#include "PARParameter.h"

#include "DYNModel.h"
#include "DYNMacrosMessage.h"
#include "DYNSparseMatrix.h"
#include "DYNSolverIDA.h"
#include "DYNSolverKINAlgRestoration.h"
#include "DYNTrace.h"
#include "DYNTimer.h"
#include "DYNSolverCommon.h"

using std::make_pair;
using std::setw;
using std::string;
using std::stringstream;
using std::vector;

using parameters::ParametersSet;

/**
 * @brief SolverIDAFactory getter
 * @return A pointer to a new instance of SolverIDAFactory
 */
extern "C" DYN::SolverFactory * getFactory() {
  return (new DYN::SolverIDAFactory());
}

/**
 * @brief SolverIDAFactory destroy method
 */
extern "C" void deleteFactory(DYN::SolverFactory* factory) {
  delete factory;
}

/**
 * @brief SolverIDA getter
 * @return A pointer to a new instance of SolverIDA
 */
extern "C" DYN::Solver* DYN::SolverIDAFactory::create() const {
  DYN::Solver* solver(new DYN::SolverIDA());
  return solver;
}

/**
 * @brief SolverIDA destroy method
 */
extern "C" void DYN::SolverIDAFactory::destroy(DYN::Solver* solver) const {
  delete solver;
}

namespace DYN {

SolverIDA::SolverIDA() :
IDAMem_(NULL),
linearSolver_(NULL),
sundialsMatrix_(NULL),
sundialsVectorYType_(NULL),
order_(0),
initStep_(0.),
minStep_(0.),
maxStep_(0.),
absAccuracy_(0.),
relAccuracy_(0.),
deltacj_(0.25),
uround_(false),
newReinit_(false),
solveTask_("ONE_STEP"),
maxnef_(10),
maxcor_(4),
maxncf_(10),
nlscoef_(0.33),
restorationYPrim_(true),
flagInit_(false),
nbLastTimeSimulated_(0),
allLogs_(false) {
}

void
SolverIDA::cleanIDA() {
  if (sundialsMatrix_ != NULL) {
    SolverCommon::cleanSUNMatrix(sundialsMatrix_);
    SUNMatDestroy(sundialsMatrix_);
    sundialsMatrix_ = NULL;
  }
  if (linearSolver_ != NULL) {
    SUNLinSolFree(linearSolver_);
    linearSolver_ = NULL;
  }
  if (IDAMem_ != NULL) {
    IDAFree(&IDAMem_);
    IDAMem_ = NULL;
  }
  if (sundialsVectorYType_ != NULL) {
    N_VDestroy_Serial(sundialsVectorYType_);
    sundialsVectorYType_ = NULL;
  }
}

SolverIDA::~SolverIDA() {
  cleanIDA();
}

void
SolverIDA::defineSpecificParameters() {
  const bool mandatory = true;
  const bool notMandatory = false;
  // Time-domain part parameters
  parameters_.insert(make_pair("order", ParameterSolver("order", VAR_TYPE_INT, mandatory)));
  parameters_.insert(make_pair("initStep", ParameterSolver("initStep", VAR_TYPE_DOUBLE, mandatory)));
  parameters_.insert(make_pair("minStep", ParameterSolver("minStep", VAR_TYPE_DOUBLE, mandatory)));
  parameters_.insert(make_pair("maxStep", ParameterSolver("maxStep", VAR_TYPE_DOUBLE, mandatory)));
  parameters_.insert(make_pair("absAccuracy", ParameterSolver("absAccuracy", VAR_TYPE_DOUBLE, mandatory)));
  parameters_.insert(make_pair("relAccuracy", ParameterSolver("relAccuracy", VAR_TYPE_DOUBLE, mandatory)));
  parameters_.insert(make_pair("deltacj", ParameterSolver("deltacj", VAR_TYPE_DOUBLE, notMandatory)));
  parameters_.insert(make_pair("uround", ParameterSolver("uround", VAR_TYPE_BOOL, notMandatory)));
  parameters_.insert(make_pair("newReinit", ParameterSolver("newReinit", VAR_TYPE_BOOL, notMandatory)));
  parameters_.insert(make_pair("solveTask", ParameterSolver("solveTask", VAR_TYPE_STRING, notMandatory)));
  parameters_.insert(make_pair("maxnef", ParameterSolver("maxnef", VAR_TYPE_INT, notMandatory)));
  parameters_.insert(make_pair("maxcor", ParameterSolver("maxcor", VAR_TYPE_INT, notMandatory)));
  parameters_.insert(make_pair("maxncf", ParameterSolver("maxncf", VAR_TYPE_INT, notMandatory)));
  parameters_.insert(make_pair("nlscoef", ParameterSolver("nlscoef", VAR_TYPE_DOUBLE, notMandatory)));
  parameters_.insert(make_pair("allLogs", ParameterSolver("allLogs", VAR_TYPE_BOOL, notMandatory)));
  parameters_.insert(make_pair("restorationYPrim", ParameterSolver("restorationYPrim", VAR_TYPE_BOOL, notMandatory)));
}

void
SolverIDA::setSolverSpecificParameters() {
  order_ = findParameter("order").getValue<int>();
  initStep_ = findParameter("initStep").getValue<double>();
  minStep_ = findParameter("minStep").getValue<double>();
  maxStep_ = findParameter("maxStep").getValue<double>();
  absAccuracy_ = findParameter("absAccuracy").getValue<double>();
  relAccuracy_ = findParameter("relAccuracy").getValue<double>();
  const ParameterSolver& deltacj = findParameter("deltacj");
  if (deltacj.hasValue())
    deltacj_ = deltacj.getValue<double>();
  const ParameterSolver& uround = findParameter("uround");
  if (uround.hasValue())
    uround_ = uround.getValue<bool>();
  const ParameterSolver& newReinit = findParameter("newReinit");
  if (newReinit.hasValue())
    newReinit_ = newReinit.getValue<bool>();
  const ParameterSolver& solveTask = findParameter("solveTask");
  if (solveTask.hasValue())
    solveTask_ = solveTask.getValue<string>();
  const ParameterSolver& maxnef = findParameter("maxnef");
  if (maxnef.hasValue())
    maxnef_ = maxnef.getValue<int>();
  const ParameterSolver& maxcor = findParameter("maxcor");
  if (maxcor.hasValue())
    maxcor_ = maxcor.getValue<int>();
  const ParameterSolver& maxncf = findParameter("maxncf");
  if (maxncf.hasValue())
    maxncf_ = maxncf.getValue<int>();
  const ParameterSolver& nlscoef = findParameter("nlscoef");
  if (nlscoef.hasValue())
    nlscoef_ = nlscoef.getValue<double>();
  const ParameterSolver& allLogs = findParameter("allLogs");
  if (allLogs.hasValue())
    allLogs_ = allLogs.getValue<bool>();
  const ParameterSolver& restorationYPrim = findParameter("restorationYPrim");
  if (restorationYPrim.hasValue())
    restorationYPrim_ = restorationYPrim.getValue<bool>();
}

std::string
SolverIDA::solverType() const {
  return "IDASolver";
}

void
SolverIDA::init(const std::shared_ptr<Model>& model, const double t0, const double tEnd) {
  // test if there is continuous variable in the simulated problem.
  if (model->sizeY() == 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverIDANoContinuousVars);

  // (1) Arguments
  // -------------
  tSolve_ = t0;

  // (2) Problem sizing
  // -------------------------------
  Solver::Impl::init(t0, model);

  // (4) IDACreate
  // -------------
  // Creation of IDA solver's intern memory space
  IDAMem_ = IDACreate(sundialsContext_);
  if (IDAMem_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDACreate");

  // (5) IDAInit
  // -----------
  int flag = IDAInit(IDAMem_, evalF, t0, sundialsVectorY_, sundialsVectorYp_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAInit");

  // (6) IDASVtolerances
  // -------------------
  std::vector<double> vYAcc;
  vYAcc.assign(model->sizeY(), absAccuracy_);

  N_Vector yAcc = N_VMake_Serial(model->sizeY(), &(vYAcc[0]), sundialsContext_);
  if (yAcc == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateAcc);

  flag = IDASVtolerances(IDAMem_, relAccuracy_, yAcc);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASVtolerances");

  if (yAcc != NULL) N_VDestroy_Serial(yAcc);

  // (7) IDASet
  // ----------

  // initialization of the user's data pointer for IDAResFn
  flag = IDASetUserData(IDAMem_, this);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetUserdata");

  // the solver is given the simulation end time
  flag = IDASetStopTime(IDAMem_, tEnd);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetStopTime");

  // minimum time step
  if (!doubleIsZero(minStep_)) {
    flag = IDASetMinStep(IDAMem_, minStep_);
    if (flag < 0)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetMinStep");
  }

  // maximum time step
  if (!doubleIsZero(maxStep_)) {
    flag = IDASetMaxStep(IDAMem_, maxStep_);
    if (flag < 0)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetMaxStep");
  }

  // sdebug
  flag = IDASetMaxOrd(IDAMem_, order_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetMaxOrd");

  // no initial time
  if (!doubleIsZero(initStep_)) {
    flag = IDASetInitStep(IDAMem_, initStep_);
    if (flag < 0)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetInitStep");
  }

  // Algebraic or differential variable indicator (vector<int>)
  sundialsVectorYType_ = N_VNew_Serial(model->sizeY(), sundialsContext_);
  if (sundialsVectorYType_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateID);

  setDifferentialVariablesIndices();

  flag = IDASetId(IDAMem_, sundialsVectorYType_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetId");

  // algebraic variables are ignored in the error computation (prefered for an order>=2 algorithm)
  flag = IDASetSuppressAlg(IDAMem_, SUNTRUE);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetSuppressAlg");

  // (8) Solver choice
  // -------------------
  sundialsMatrix_ = SUNSparseMatrix(model->sizeY(), model->sizeY(), 0, CSR_MAT, sundialsContext_);
  if (sundialsMatrix_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "SUNSparseMatrix");
  SolverCommon::freeSUNMatrix(sundialsMatrix_);
  smj_.init(model->sizeY(), model->sizeY());
  SolverCommon::copySparseMatrixToSUNMatrix(smj_, sundialsMatrix_);
  /* Create KLU SUNLinearSolver object */
  linearSolver_ = SUNLinSol_KLU(sundialsVectorY_, sundialsMatrix_, sundialsContext_);
  if (linearSolver_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "SUNLinSol_KLU");

  /* Attach the matrix and linear solver */
  flag = IDASetLinearSolver(IDAMem_, linearSolver_, sundialsMatrix_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAKLU");

  // (9) Solver options
  // ---------------------
  flag = IDASetJacFn(IDAMem_, evalJ);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASlsSetSparseJacFn");

  // the solver is given which functions to use to throw error messages
  flag = IDASetErrHandlerFn(IDAMem_, errHandlerFn, NULL);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetErrHandlerFn");

  // (11) IDARootInit
  // ----------------

  // the solver is given which are the discontinuity functions
  flag = IDARootInit(IDAMem_, model_->sizeG(), evalG);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDARootInit");

  // the solver is made not to throw warnings coming from the rootfinding
  flag = IDASetNoInactiveRootWarn(IDAMem_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetNoInactiveRootWarn");

  flag = IDASetDeltaCjLSetup(IDAMem_, deltacj_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetDeltaCjLSetup");

  if (uround_) {
    flag = IDASetURound(IDAMem_, getCurrentPrecision() / (100. * minStep_));
    if (flag < 0)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetURound");
  }

  Solver::Impl::resetStats();
  g0_.assign(model_->sizeG(), ROOT_DOWN);
  g1_.assign(model_->sizeG(), ROOT_DOWN);

  Trace::debug() << DYNLog(SolverIDAInitOk) << Trace::endline;

  flag = IDASetStepToleranceIC(IDAMem_, 0.01);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetStepToleranceIC");

  flag = IDASetNonlinConvCoefIC(IDAMem_, 0.0033);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetNonlinConvCoefIC");

  flag = IDASetLineSearchOffIC(IDAMem_, false);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetLineSearchOffIC");

  flag = IDASetMaxNumStepsIC(IDAMem_, 10);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetMaxNumStepIC");

  flag = IDASetMaxNumItersIC(IDAMem_, 20);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetMaxNumItersIC");

  flag = IDASetMaxNumJacsIC(IDAMem_, 100);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetMaxNumJacsIC");

  flag = IDASetMaxErrTestFails(IDAMem_, maxnef_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetMaxErrTestFails");

  flag = IDASetMaxNonlinIters(IDAMem_, maxcor_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetMaxNonlinIters");

  flag = IDASetMaxConvFails(IDAMem_, maxncf_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetMaxConvFails");

  flag = IDASetNonlinConvCoef(IDAMem_, nlscoef_);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetNonlinConvCoef");

  // KINSOL solver Init
  //-----------------------
  solverKINNormal_.reset(new SolverKINAlgRestoration());
  solverKINNormal_->init(model_, SolverKINAlgRestoration::KIN_ALGEBRAIC);
  if (restorationYPrim_) {
    solverKINYPrim_.reset(new SolverKINAlgRestoration());
    solverKINYPrim_->init(model_, SolverKINAlgRestoration::KIN_DERIVATIVES);
  }
}

void
SolverIDA::calculateIC(double /*tEnd*/) {
#ifdef _DEBUG_
  vector<double> y0;
  y0.assign(vectorY_.begin(), vectorY_.end());

  const std::vector<propertyContinuousVar_t>& modelYType = model_->getYType();
  Trace::debug(Trace::solver()) << DYNLog(SolverIDAStartCalculateIC) << Trace::endline;
  for (int i = 0; i < model_->sizeY(); ++i) {
    Trace::debug(Trace::solver()) << "Y[" << std::setw(3) << i << "] = "
                   << std::setw(15) << vectorY_[i]
                   << " Yp[" << std::setw(2) << i << "] = "
                   << std::setw(15) << vectorYp_[i]
                   << " ID[" << std::setw(2) << i << "] = "
                   << std::setw(15) << propertyVar2Str(modelYType[i]) << Trace::endline;
  }

  // root assessing before init
  // --------------------------------
  vector<double> ySave;
  ySave.assign(vectorY_.begin(), vectorY_.end());
#endif

  // Updating discrete variable values and mode
  Trace::debug() << "Updating discrete variable values and mode" << Trace::endline;
  model_->copyContinuousVariables(&vectorY_[0], &vectorYp_[0]);
  Trace::debug() << "Updating evalG" << Trace::endline;
  model_->evalG(tSolve_, g1_);
  ++stats_.ngeInternal_;
  Trace::debug() << "Updating evalZMode" << Trace::endline;
  evalZMode(g0_, g1_, tSolve_);
  Trace::debug() << "End Updating discrete variable values and mode" << Trace::endline;

  model_->rotateBuffers();
  state_.reset();
  model_->reinitMode();

  // loops until a stable state is found
  bool change(true);
  int counter = 0;

  solverKINNormal_->setupNewAlgebraicRestoration(fnormtolAlgInit_, initialaddtolAlgInit_, scsteptolAlgInit_, mxnewtstepAlgInit_,
                                                  msbsetAlgInit_, mxiterAlgInit_, printflAlgInit_);

  setDifferentialVariablesIndices();
  if (restorationYPrim_) {
    solverKINYPrim_->setupNewAlgebraicRestoration(fnormtolAlgInit_, initialaddtolAlgInit_, scsteptolAlgInit_, mxnewtstepAlgInit_,
                                              msbsetAlgInit_, mxiterAlgInit_, printflAlgInit_);
  }

#if _DEBUG_
  solverKINNormal_->setCheckJacobian(true);
#endif
  do {
    Trace::debug() << "Start algebraic restoration" << Trace::endline;
    // call to solver KIN in order to find the new (adequate) algebraic variables' values
    solverKINNormal_->setInitialValues(tSolve_, vectorY_, vectorYp_);
    solverKINNormal_->solve();
    solverKINNormal_->getValues(vectorY_, vectorYp_);

    if (restorationYPrim_) {
      solverKINYPrim_->setInitialValues(tSolve_, vectorY_, vectorYp_);
      solverKINYPrim_->solve();
      solverKINYPrim_->getValues(vectorY_, vectorYp_);
    }

    updateAlgebraicRestorationStatistics();
    updateStatistics();

    Trace::debug() << "End algebraic restoration" << Trace::endline;

    // Reinitialization (forced to start over with a small time step)
    // -------------------------------------------------------
    int flag0 = IDAReInit(IDAMem_, tSolve_, sundialsVectorY_, sundialsVectorYp_);
    if (flag0 < 0)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAReinit");
#ifdef _DEBUG_
    Trace::debug(Trace::solver()) << DYNLog(SolverIDABeforeCalcIC) << Trace::endline;
    for (int i = 0; i < model_->sizeY(); ++i) {
      Trace::debug(Trace::solver()) << "Y[" << std::setw(3) << i << "] = " << std::setw(15) << vectorY_[i] << " Yp[" << std::setw(3) << i << "] = "
      << std::setw(15) << vectorYp_[i] << " diffY[" << std::setw(3) << i << "] = " << vectorY_[i] - ySave[i] << Trace::endline;
    }
#endif
    flagInit_ = true;
    Trace::debug() << "Start IDACalcIC" << Trace::endline;
    int flag = IDACalcIC(IDAMem_, IDA_YA_YDP_INIT, initStep_);
    analyseFlag(flag);
    Trace::debug() << "End IDACalcIC" << Trace::endline;

    // gathering of values computed by IDACalcIC
    flag = IDAGetConsistentIC(IDAMem_, sundialsVectorY_, sundialsVectorYp_);
    if (flag < 0)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAGetConsistentIC");
#ifdef _DEBUG_
    Trace::debug(Trace::solver()) << DYNLog(SolverIDAAfterInit) << Trace::endline;
    double maxDiff = 0;
    int indice = -1;
    for (int i = 0; i < model_->sizeY(); ++i) {
      Trace::debug(Trace::solver()) << "Y[" << std::setw(3) << i << "] = " << std::setw(15) << vectorY_[i] << " Yp[" << std::setw(3) << i << "] = "
      << std::setw(15) << vectorYp_[i] << " diff =" << std::setw(15) << y0[i] - vectorY_[i] << Trace::endline;
      if (std::abs(y0[i] - vectorY_[i]) > maxDiff) {
        maxDiff = std::abs(y0[i] - vectorY_[i]);
        indice = i;
      }
    }
    Trace::debug(Trace::solver()) << DYNLog(SolverIDAMaxDiff, maxDiff, indice) << Trace::endline;
#endif
    // Root stabilization
    change = false;
    model_->copyContinuousVariables(&vectorY_[0], &vectorYp_[0]);
    Trace::debug() << "Start calculateIC evalG" << Trace::endline;
    model_->evalG(tSolve_, g1_);
    ++stats_.ngeInternal_;
    Trace::debug() << "End calculateIC evalG" << Trace::endline;
    if (!(std::equal(g0_.begin(), g0_.end(), g1_.begin()))) {
#ifdef _DEBUG_
        printUnstableRoot(tSolve_, g0_, g1_);
#endif
      g0_.assign(g1_.begin(), g1_.end());
      Trace::debug() << "Start calculateIC evalZMode" << Trace::endline;
      change = evalZMode(g0_, g1_, tSolve_);
      Trace::debug() << "End calculateIC evalZMode" << Trace::endline;
    }

    model_->rotateBuffers();
    state_.reset();
    model_->reinitMode();

    ++counter;
    if (counter >= maxNumberUnstableRoots)
      throw DYNError(Error::SOLVER_ALGO, SolverIDAUnstableRoots);
  } while (change);

  updateStatistics();

  printEnd();
  printEndConsole();

  int flag0 = IDAReInit(IDAMem_, tSolve_, sundialsVectorY_, sundialsVectorYp_);  // required to relaunch the simulation
  if (flag0 < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAReinit");

  Solver::Impl::resetStats();

  // reinit output
  flagInit_ = false;
#if _DEBUG_
  solverKINNormal_->setCheckJacobian(false);
#endif
}

void
SolverIDA::analyseFlag(const int & flag) {
  stringstream msg;
  switch (flag) {
    case IDA_SUCCESS:
      msg << DYNLog(IdaSuccess);
      break;
    case IDA_MEM_NULL:
      msg << DYNLog(IdaMemNull);
      break;
    case IDA_NO_MALLOC:
      msg << DYNLog(IdaNoMalloc);
      break;
    case IDA_ILL_INPUT:
      msg << DYNLog(IdaIllInput);
      break;
    case IDA_LSETUP_FAIL:
      msg << DYNLog(IdalsetupFail);
      break;
    case IDA_LINIT_FAIL:
      msg << DYNLog(IdaLinitFail);
      break;
    case IDA_LSOLVE_FAIL:
      msg << DYNLog(IdaLsolveFail);
      break;
    case IDA_BAD_EWT:
      msg << DYNLog(IdaBadEwt);
      break;
    case IDA_FIRST_RES_FAIL:
      msg << DYNLog(IdaFirstResFail);
      break;
    case IDA_RES_FAIL:
      msg << DYNLog(IdaResFail);
      break;
    case IDA_NO_RECOVERY:
      msg << DYNLog(IdaNoRecovery);
      break;
    case IDA_CONSTR_FAIL:
      msg << DYNLog(IdaConstrFail);
      break;
    case IDA_LINESEARCH_FAIL:
      msg << DYNLog(IdaLinesearchFail);
      break;
    case IDA_CONV_FAIL:
      msg << DYNLog(IdaConvFail);
      break;
    default:
#ifdef _DEBUG_
      Trace::error() << DYNLog(SolverIDAUnknownError) << Trace::endline;
#endif
      throw DYNError(Error::SUNDIALS_ERROR, SolverIDAError);
  }

  if (flag < 0) {
#ifdef _DEBUG_
    Trace::error() << msg.str() << Trace::endline;
#endif
    throw DYNError(Error::SUNDIALS_ERROR, SolverIDAError);
  }
}

int
SolverIDA::evalF(realtype tres, N_Vector yy, N_Vector yp,
        N_Vector rr, void* data) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("SolverIDA::evalF");
#endif
  SolverIDA* solver = reinterpret_cast<SolverIDA*> (data);
  Model& model = solver->getModel();

  realtype* iyy = NV_DATA_S(yy);
  realtype* iyp = NV_DATA_S(yp);
  realtype* irr = NV_DATA_S(rr);
  model.evalF(tres, iyy, iyp, irr);
#ifdef _DEBUG_
  if (solver->flagInit()) {
    Trace::debug(Trace::solver()) << "===== " << DYNLog(SolverIDADebugResidual) << " =====" << Trace::endline;
    for (int i = 0; i < model.sizeF(); ++i) {
      if (std::abs(irr[i]) > 1e-04) {
        Trace::debug(Trace::solver()) << "  f[" << i << "]=" << irr[i] << Trace::endline;
      }
    }
  }
#endif
return 0;
}

int
SolverIDA::evalG(realtype tres, N_Vector yy, N_Vector yp, realtype* gout,
        void* data) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("SolverIDA::evalG");
#endif
  SolverIDA* solver = reinterpret_cast<SolverIDA*> (data);
  Model& model = solver->getModel();
  realtype* iyy = NV_DATA_S(yy);
  realtype* iyp = NV_DATA_S(yp);

  std::vector<state_g>& g1 = solver->getG1();

  model.copyContinuousVariables(iyy, iyp);
  model.evalG(tres, g1);

  for (unsigned int i = 0 ; i < g1.size(); ++i) {
    gout[i] = g1[i];
  }

  return 0;
}

int
SolverIDA::evalJ(realtype tt, realtype cj,
        N_Vector yy, N_Vector yp, N_Vector /*rr*/,
        SUNMatrix JJ, void* data,
        N_Vector /*tmp1*/, N_Vector /*tmp2*/, N_Vector /*tmp3*/) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("SolverIDA::evalJ");
#endif
  SolverIDA* solver = reinterpret_cast<SolverIDA*> (data);
  Model& model = solver->getModel();
  SparseMatrix& smj = solver->getMatrix();

  realtype* iyy = NV_DATA_S(yy);
  realtype* iyp = NV_DATA_S(yp);

  const int size = model.sizeY();
  smj.init(size, size);
  model.copyContinuousVariables(iyy, iyp);
  model.evalJt(tt, cj, smj);
  SolverCommon::propagateMatrixStructureChangeToKINSOL(smj, JJ, solver->lastRowVals_, solver->linearSolver_, true);

  return 0;
}

void
SolverIDA::solveStep(double tAim, double& tNxt) {
  int flag = IDASolve(IDAMem_, tAim, &tNxt, sundialsVectorY_, sundialsVectorYp_, solveTaskToInt());
  if (uround_) {
    int flag1 = IDASetURound(IDAMem_, getCurrentPrecision() / (100. * (getTimeStep() + tNxt)));
    // std::cout << "uround " << getCurrentPrecision() / (100. * (getTimeStep() + tNxt)) << std::endl;
    if (flag1 < 0)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASetURound");
  }

  string msg;
  switch (flag) {
    case IDA_SUCCESS:
      msg = "IDA_SUCCESS";
      break;
    case IDA_ROOT_RETURN:
      msg = "IDA_ROOT_RETURN";
      model_->copyContinuousVariables(&vectorY_[0], &vectorYp_[0]);
      model_->evalG(tNxt, g1_);
      ++stats_.ngeInternal_;
      evalZMode(g0_, g1_, tNxt);
      break;
    case IDA_TSTOP_RETURN:
      msg = "IDA_TSTOP_RETURN";
      // updateStatistics();
      break;
    default:
      analyseFlag(flag);
  }

  if (std::abs(tSolve_ - tNxt) < minimalAcceptableStep_) {
    ++nbLastTimeSimulated_;
    if (nbLastTimeSimulated_ > maximumNumberSlowStepIncrease_)
      throw DYNError(Error::SOLVER_ALGO, SlowStepIncrease, maximumNumberSlowStepIncrease_, minimalAcceptableStep_);
  } else {
    nbLastTimeSimulated_ = 0;
  }

if (allLogs_) {
    // A root has been found at tNxt
  if (flag == IDA_ROOT_RETURN) {
    vector<state_g> rootsFound = getRootsFound();
    int numRoots = 0;
    for (const auto root : rootsFound) {
      if (std::fabs(root) > 0) {
        ++numRoots;
      }
    }
    Trace::debug() << "SolverIDA: numRoots rootsfound " << numRoots << Trace::endline;
    for (unsigned int i = 0; i < rootsFound.size(); i++) {
      if (rootsFound[i] != NO_ROOT) {
        Trace::debug() << "SolverIDA: rootsfound ->  g[" << i << "]=" << rootsFound[i] << Trace::endline;
        std::string subModelName("");
        int localGIndex(0);
        std::string gEquation("");
        model_->getGInfos(i, subModelName, localGIndex, gEquation);
        Trace::debug() << DYNLog(RootGeq, i, subModelName, gEquation) << Trace::endline;
      }
    }
  }

  /* The convergence criterion in IDA is associated to the weighted RMS norm of the delta between two Newton iterations.
   * Indeed, the correction step is successful if sqrt(Sum(w*(y(k+1)-y(k))^2)/n) < tolerance where k is the kth Newton iteration and n the number of variables
   * The weights (w) used are inversely proportional to the relative accuracy multiplied by the value variable and the absolute accuracy.
   * The local errors are the sum of the differences between y before and after the Newton iteration (errors += y(k+1) - y(k)).
   * => Therefore the errors multiplied by the weights are a good indicator of the variables that evolve the more during the Newton iterations.
   */
  int nbY = model_->sizeY();
  int nbErr = 10;
  double thresholdErr = 1;

  if (nbErr > nbY)
    nbErr = nbY;

  // Defining necessary data structure and retrieving information from IDA
  N_Vector nvWeights = N_VNew_Serial(nbY, sundialsContext_);
  N_Vector nvErrors = N_VNew_Serial(nbY, sundialsContext_);
  if (IDAGetErrWeights(IDAMem_, nvWeights) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAGetErrWeights");

  if (IDAGetEstLocalErrors(IDAMem_, nvErrors) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAGetEstLocalErrors");

  double* weights = NV_DATA_S(nvWeights);
  double* errors = NV_DATA_S(nvErrors);
  std::vector<double> weightedErrors(nbY);

  for (int i = 0; i < nbY; ++i)
    weightedErrors[i] = fabs(weights[i] * errors[i]);

  // Filling and sorting the vector
  vector<std::pair<double, int> > yErr;
  for (int i = 0; i < nbY; ++i) {
    // Tolerances (RTOL and ATOL) are 1e-04 by default so weights are around 1e4 therefore 1 is a relatively small value
    if (weightedErrors[i] > thresholdErr) {
      yErr.push_back(std::pair<double, int>(weightedErrors[i], i));
    }
  }
  std::sort(yErr.begin(), yErr.end(), mapcompabs());

  if (!yErr.empty()) {
    Trace::debug() << DYNLog(SolverIDALargestErrors, nbErr) << Trace::endline;
    int i = 0;
    for (vector<std::pair<double, int> >::iterator it = yErr.begin(); it != yErr.end() && i < nbErr; ++it, ++i)
      Trace::debug() << DYNLog(SolverIDAErrorValue, thresholdErr, it->second, it->first) << Trace::endline;
  }

  // Destroying the specific data structures
  N_VDestroy_Serial(nvWeights);
  N_VDestroy_Serial(nvErrors);
}
}

bool SolverIDA::setupNewAlgRestoration(modeChangeType_t modeChangeType) {
  if (modeChangeType == ALGEBRAIC_MODE) {
    solverKINNormal_->setupNewAlgebraicRestoration(fnormtolAlg_, initialaddtolAlg_, scsteptolAlg_, mxnewtstepAlg_, msbsetAlg_, mxiterAlg_, printflAlg_);
    setDifferentialVariablesIndices();
    if (restorationYPrim_) {
      solverKINYPrim_->setupNewAlgebraicRestoration(fnormtolAlg_, initialaddtolAlg_, scsteptolAlg_, mxnewtstepAlg_, msbsetAlg_, mxiterAlg_, printflAlg_);
    }
    return false;  // no J factorization
  } else if (modeChangeType == ALGEBRAIC_J_UPDATE_MODE) {
    solverKINNormal_->setupNewAlgebraicRestoration(fnormtolAlgJ_, initialaddtolAlgJ_, scsteptolAlgJ_, mxnewtstepAlgJ_, msbsetAlgJ_, mxiterAlgJ_,
                                                   printflAlgJ_);
    setDifferentialVariablesIndices();
    if (restorationYPrim_) {
      solverKINYPrim_->setupNewAlgebraicRestoration(fnormtolAlgJ_, initialaddtolAlgJ_, scsteptolAlgJ_, mxnewtstepAlgJ_, msbsetAlgJ_, mxiterAlgJ_, printflAlgJ_);
    }
    return true;  // new J factorization
  }
  return false;  // no J factorization
}

void SolverIDA::updateAlgebraicRestorationStatistics() {
  long int nNewt = 0;
  long int nre = 0;
  long int nje = 0;
  solverKINNormal_->updateStatistics(nNewt, nre, nje);
  stats_.nreAlgebraic_ += nre;
  stats_.njeAlgebraic_ += nje;

  if (restorationYPrim_) {
    solverKINYPrim_->updateStatistics(nNewt, nre, nje);
    stats_.nreAlgebraicPrim_ += nre;
    stats_.njeAlgebraicPrim_ += nje;
  }
}

/*
 * This routine deals with the possible actions due to a mode change.
 * In IDA, in case of a mode change, depending on the types of mode, either there is an algebraic equation restoration or just
 * a simple reinitialization of the solver.
 */
void
SolverIDA::reinit() {
  int counter = 0;
  modeChangeType_t modeChangeType = model_->getModeChangeType();
  if (modeChangeType == NO_MODE) return;

  if (modeChangeType == DIFFERENTIAL_MODE) {
    ++stats_.nmeDiff_;
  } else if (modeChangeType == ALGEBRAIC_MODE) {
    ++stats_.nmeAlg_;
  } else if (modeChangeType == ALGEBRAIC_J_UPDATE_MODE) {
    ++stats_.nmeAlgJ_;
  }

  const bool evaluateOnlyMode = optimizeReinitAlgebraicResidualsEvaluations_;
  if (modeChangeType >= minimumModeChangeTypeForAlgebraicRestoration_) {
    Trace::info() << DYNLog(NewStartPoint) << Trace::endline;
    do {
      model_->rotateBuffers();
      state_.reset();

      // During the algebraic equation restoration, the system could have moved a lot from its previous state.
      // J updates and preconditioner calls must be done on a regular basis.
      bool noInitSetup = !setupNewAlgRestoration(modeChangeType);

      // Call to solver KIN to find new algebraic variables' values
      const std::vector<propertyContinuousVar_t>& modelYType = model_->getYType();
      for (unsigned int i = 0; i < modelYType.size(); i++)
        if (modelYType[i] != DYN::DIFFERENTIAL)
          vectorYp_[i] = 0;

      solverKINNormal_->setInitialValues(tSolve_, vectorY_, vectorYp_);
      solverKINNormal_->solve(noInitSetup, evaluateOnlyMode);
      solverKINNormal_->getValues(vectorY_, vectorYp_);

      if (restorationYPrim_) {
        // Recomputation of differential variables' values
        for (unsigned int i = 0; i < modelYType.size(); i++)
          if (modelYType[i] != DYN::DIFFERENTIAL)
            vectorYp_[i] = 0;

        solverKINYPrim_->setInitialValues(tSolve_, vectorY_, vectorYp_);
        solverKINYPrim_->solve(noInitSetup, evaluateOnlyMode);
        solverKINYPrim_->getValues(vectorY_, vectorYp_);
      }

      model_->reinitMode();

      // Update statistics
      updateAlgebraicRestorationStatistics();

      // Root stabilization
      model_->evalG(tSolve_, g1_);
      ++stats_.ngeInternal_;
      if (std::equal(g0_.begin(), g0_.end(), g1_.begin())) {
        break;
      } else {
// #ifdef _DEBUG_
        if (allLogs_)
          printUnstableRoot(tSolve_, g0_, g1_);
// #endif
        g0_.assign(g1_.begin(), g1_.end());
        evalZMode(g0_, g1_, tSolve_);
        modeChangeType = model_->getModeChangeType();
      }

      counter++;
      if (counter >= maxNumberUnstableRoots)
        throw DYNError(Error::SOLVER_ALGO, SolverIDAUnstableRoots);
    } while (modeChangeType >= minimumModeChangeTypeForAlgebraicRestoration_);

    if (newReinit_) {
      updateStatistics();

      int flag0 = IDAReInit(IDAMem_, tSolve_, sundialsVectorY_, sundialsVectorYp_);  // required to relaunch the simulation
      if (flag0 < 0)
        throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAReinit");
    }
  }

  if (!newReinit_) {
    updateStatistics();

    int flag0 = IDAReInit(IDAMem_, tSolve_, sundialsVectorY_, sundialsVectorYp_);  // required to relaunch the simulation
    if (flag0 < 0)
      throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAReinit");
  }
}

// #ifdef _DEBUG_
vector<state_g>
SolverIDA::getRootsFound() const {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("SolverIDA::getRootsFound()");
#endif
  vector<state_g> rootsFound(model_->sizeG(), NO_ROOT);

  if (IDAGetRootInfo(IDAMem_, &rootsFound[0]) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAGetRootInfo");

  return rootsFound;
}
// #endif

double SolverIDA::getTimeStep() const {
  double hused = 0.;
  int flag = IDAGetLastStep(IDAMem_, &hused);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAGetLastStep");
  return hused;
}

void
SolverIDA::printHeaderSpecific(std::stringstream& ss) const {
  ss << "| iter num   order (k)      time step (h)";
}

void
SolverIDA::getLastConf(long int& nst, int& kused, double& hused) const {
  // number of used intern iterations
  if (IDAGetNumSteps(IDAMem_, &nst) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAGetNumSteps");

  if (IDAGetLastOrder(IDAMem_, &kused) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAGetLastOrder");

  // value of last used intern time step
  hused = getTimeStep();
}

void
SolverIDA::printSolveSpecific(std::stringstream& msg) const {
  long int nst = 0;
  int kused = 0;
  double hused = 0.;
  getLastConf(nst, kused, hused);
  msg << "| " << setw(8) << nst << " "
          << setw(11) << kused << " "
          << setw(18) << hused << " ";
}

void
SolverIDA::updateStatistics() {
  if (IDAMem_ == NULL)
    return;
  // statistics gathering
  long int nst = 0;
  if (IDAGetNumSteps(IDAMem_, &nst) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAGetNumSteps");

  long int nre = 0;
  if (IDAGetNumResEvals(IDAMem_, &nre) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAGetNumResEvals");

  long int nje = 0;
  if (IDAGetNumJacEvals(IDAMem_, &nje) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDASlsGetNumJacEvals");

  long int nni = 0;
  if (IDAGetNumNonlinSolvIters(IDAMem_, &nni) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAGetNumNonlinSolvIters");

  long int netf = 0;
  if (IDAGetNumErrTestFails(IDAMem_, &netf) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAGetNumErrTestFails");

  long int ncfn = 0;
  if (IDAGetNumNonlinSolvConvFails(IDAMem_, &ncfn) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAGetNumNonlinSolvConvFails");

  long int nge = 0;
  if (IDAGetNumGEvals(IDAMem_, &nge) < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorIDA, "IDAGetNumGEvals");

  // update solver's counters
  stats_.nst_ += nst;
  stats_.nre_ += nre;
  stats_.nje_ += nje;
  stats_.nni_ += nni;
  stats_.netf_ += netf;
  stats_.ncfn_ += ncfn;
  stats_.ngeSolver_ += nge;
}

void
SolverIDA::errHandlerFn(int error_code, const char* module, const char* function,
        char* msg, void* /*eh_data*/) {
  if (error_code == IDA_WARNING) {
    Trace::warn() << module << " " << function << " :" << msg << Trace::endline;
  } else {
    Trace::error() << module << " " << function << " :" << msg << Trace::endline;
  }
}

void
SolverIDA::setDifferentialVariablesIndices() {
  const std::vector<propertyContinuousVar_t>& modelYType = model_->getYType();

  double* idx = NV_DATA_S(sundialsVectorYType_);
  for (int ieq = 0; ieq < model_->sizeY(); ++ieq) {
    idx[ieq] = RCONST(1.);
    if (modelYType[ieq] != DYN::DIFFERENTIAL)  // Algebraic or external variable
      idx[ieq] = RCONST(0.);
  }
}

int SolverIDA::solveTaskToInt() {
  if (solveTask_ == "NORMAL") {
    return IDA_NORMAL;
  } else if (solveTask_ == "ONE_STEP") {
    return IDA_ONE_STEP;
  }
  return IDA_ONE_STEP;
}

}  // end namespace DYN
