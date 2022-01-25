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
 * @file Solvers/AlgebraicSolvers/TestBasics.cpp
 * @brief Unit tests for AlgebraicSolvers
 *
 */

#include <fstream>
#include <cmath>

#include <boost/filesystem.hpp>
#include <boost/algorithm/string/classification.hpp>
#include <boost/algorithm/string/split.hpp>

#include <kinsol/kinsol.h>
#include <sunlinsol/sunlinsol_klu.h>
#include <sundials/sundials_types.h>
#include <sundials/sundials_math.h>
#include <sunmatrix/sunmatrix_sparse.h>
#include <nvector/nvector_serial.h>

#include "gtest_dynawo.h"
#include "DYNCommon.h"
#include "DYNSolverImpl.h"
#include "DYNSolverKINCommon.h"
#include "DYNSolverKINEuler.h"
#include "DYNSolverKINAlgRestoration.h"
#include "DYNModeler.h"
#include "DYNModel.h"
#include "DYNModelMulti.h"
#include "DYNCompiler.h"
#include "DYNDynamicData.h"
#include "DYNExecUtils.h"
#include "TLTimelineFactory.h"

INIT_XML_DYNAWO;

namespace DYN {

static boost::shared_ptr<Model> initModelFromDyd(std::string dydFileName) {
  // DYD
  boost::shared_ptr<DynamicData> dyd(new DynamicData());
  std::vector <std::string> fileNames;
  fileNames.push_back(dydFileName);
  dyd->initFromDydFiles(fileNames);

  bool preCompiledUseStandardModels = false;
  std::vector <UserDefinedDirectory> precompiledModelsDirsAbsolute;
  std::string preCompiledModelsExtension = sharedLibraryExtension();
  bool modelicaUseStandardModels = false;

  std::vector <UserDefinedDirectory> modelicaModelsDirsAbsolute;
  UserDefinedDirectory modelicaModel;
  modelicaModel.path = getEnvVar("PWD") +"/dyd/";
  modelicaModel.isRecursive = false;
  modelicaModelsDirsAbsolute.push_back(modelicaModel);
  std::string modelicaModelsExtension = ".mo";

  std::vector<std::string> additionalHeaderFiles;
  if (hasEnvVar("DYNAWO_HEADER_FILES_FOR_PREASSEMBLED")) {
    std::string headerFileList = getEnvVar("DYNAWO_HEADER_FILES_FOR_PREASSEMBLED");
    boost::split(additionalHeaderFiles, headerFileList, boost::is_any_of(" "), boost::token_compress_on);
  }

  const bool rmModels = true;
  boost::unordered_set<boost::filesystem::path> pathsToIgnore;
  Compiler cf = Compiler(dyd, preCompiledUseStandardModels,
            precompiledModelsDirsAbsolute,
            preCompiledModelsExtension,
            modelicaUseStandardModels,
            modelicaModelsDirsAbsolute,
            modelicaModelsExtension,
            pathsToIgnore,
            additionalHeaderFiles,
            rmModels,
            getEnvVar("PWD") +"/dyd");
  cf.compile();  // modelOnly = false, compilation and parameter linking
  cf.concatConnects();
  cf.concatRefs();

  // Model
  Modeler modeler;
  modeler.setDynamicData(dyd);
  modeler.initSystem();

  boost::shared_ptr<Model> model = modeler.getModel();
  model->initBuffers();
  model->setIsInitProcess(true);
  model->init(0);
  model->rotateBuffers();
  model->printMessages();
  model->setIsInitProcess(false);
  boost::shared_ptr<timeline::Timeline> timeline = timeline::TimelineFactory::newInstance("timeline");
  model->setTimeline(timeline);
  return model;
}

class SolverMock : public Solver::Impl {
 public:
  SolverMock() : Solver::Impl::Impl() {}

  ~SolverMock();

  void defineSpecificParameters() {}

  std::string solverType() const { return "Mock"; }

  void setSolverSpecificParameters() {}

  void init(const boost::shared_ptr<Model>& /*model*/, double /*t0*/, double /*tEnd*/) {}

  void calculateIC() {}

  void reinit() {}

  void printSolveSpecific(std::stringstream& /*msg*/) const {}

  void printHeaderSpecific(std::stringstream& /*ss*/) const {}

  bool setupNewAlgRestoration(modeChangeType_t /*modeChangeType*/) { return false; }

  void updateStatistics() {}

  double getTimeStep() const { return 0.; }

  void solveStep(double /*tAim*/, double& /*tNxt*/) {}
};

SolverMock::~SolverMock() {}

TEST(AlgebraicSolvers, testInit) {
  boost::shared_ptr<SolverKINCommon> solver(new SolverKINCommon());
  ASSERT_THROW_DYNAWO(solver->initCommon("KLU", 1, 1, 1, 1, 1, 1, 1, NULL, NULL, NULL), Error::SUNDIALS_ERROR,
                      KeyError_t::SolverEmptyYVector);

  boost::shared_ptr<Model> model = initModelFromDyd("dyd/solverTestAlpha.dyd");
  boost::shared_ptr<SolverKINEuler> solverEuler(new SolverKINEuler());
  Solver* timeSchemeSolver = new SolverMock();
  N_Vector sundialsVectorY = N_VNew_Serial(model->sizeY());
  // KINSetFuncNormTol
  ASSERT_THROW_DYNAWO(solverEuler->init(model, timeSchemeSolver, "KLU", -1, 1, 1, 1, 1, 1, 1, sundialsVectorY), Error::SUNDIALS_ERROR,
                      KeyError_t::SolverFuncErrorKINSOL);
  // KINSetInitialAdditionalTolerance
  ASSERT_THROW_DYNAWO(solverEuler->init(model, timeSchemeSolver, "KLU", 1, -1, 1, 1, 1, 1, 1, sundialsVectorY), Error::SUNDIALS_ERROR,
                      KeyError_t::SolverFuncErrorKINSOL);
  // KINSetScaledStepTol
  ASSERT_THROW_DYNAWO(solverEuler->init(model, timeSchemeSolver, "KLU", 1, 1, -1, 1, 1, 1, 1, sundialsVectorY), Error::SUNDIALS_ERROR,
                      KeyError_t::SolverFuncErrorKINSOL);
  // KINSetMaxNewtonStep
  ASSERT_THROW_DYNAWO(solverEuler->init(model, timeSchemeSolver, "KLU", 1, 1, 1, -1, 1, 1, 1, sundialsVectorY), Error::SUNDIALS_ERROR,
                      KeyError_t::SolverFuncErrorKINSOL);
  // KINSetMaxSetupCalls
  ASSERT_THROW_DYNAWO(solverEuler->init(model, timeSchemeSolver, "KLU", 1, 1, 1, 1, -1, 1, 1, sundialsVectorY), Error::SUNDIALS_ERROR,
                      KeyError_t::SolverFuncErrorKINSOL);
  // KINSetNumMaxIters
  ASSERT_THROW_DYNAWO(solverEuler->init(model, timeSchemeSolver, "KLU", 1, 1, 1, 1, 1, -1, 1, sundialsVectorY), Error::SUNDIALS_ERROR,
                      KeyError_t::SolverFuncErrorKINSOL);
  // KINSetPrintLevel
  ASSERT_THROW_DYNAWO(solverEuler->init(model, timeSchemeSolver, "KLU", 1, 1, 1, 1, 1, 1, -1, sundialsVectorY), Error::SUNDIALS_ERROR,
                      KeyError_t::SolverFuncErrorKINSOL);
  ASSERT_NO_THROW(solverEuler->init(model, timeSchemeSolver, "KLU", 1, 1, 1, 1, 1, 1, 1, sundialsVectorY));
  if (sundialsVectorY != NULL) {
    N_VDestroy_Serial(sundialsVectorY);
    sundialsVectorY = NULL;
  }
  delete timeSchemeSolver;
}

TEST(AlgebraicSolvers, testModifySettings) {
  boost::shared_ptr<Model> model = initModelFromDyd("dyd/solverTestAlpha.dyd");
  boost::shared_ptr<SolverKINAlgRestoration> solver(new SolverKINAlgRestoration());
  ASSERT_NO_THROW(solver->init(model, SolverKINAlgRestoration::KIN_ALGEBRAIC));
  ASSERT_NO_THROW(solver->setupNewAlgebraicRestoration(1e-4, 0.1, 1e-4, 1000, 0, 15, 0));

  std::vector<double> vectorY(model->sizeY());
  vectorY[0] = -4.;
  vectorY[1] = -2.;
  std::vector<double> vectorYp(model->sizeY());
  vectorYp[0] = 0.;
  vectorYp[1] = 0.;

  solver->setInitialValues(0., vectorY, vectorYp);

  vectorY[1] = 1.;

  solver->getValues(vectorY, vectorYp);

  ASSERT_EQ(vectorY[0], -4.);
  ASSERT_EQ(vectorY[1], -2.);

  // Initialize properly the model, if not some if (x <= 0) is not well handled
  model->copyContinuousVariables(&vectorY[0], &vectorYp[0]);
  std::vector<state_g> g0;
  g0.assign(model->sizeG(), NO_ROOT);
  model->evalG(0., g0);
  model->evalZ(0.);
  model->evalMode(0.);
  model->rotateBuffers();

  bool noInitSetup = false;
  bool evaluateOnlyModeAtFirstIter = false;
  solver->setCheckJacobian(true);
  ASSERT_NO_THROW(solver->solve(noInitSetup, evaluateOnlyModeAtFirstIter));

  solver->getValues(vectorY, vectorYp);

  ASSERT_EQ(vectorY[0], -4.);
  ASSERT_EQ(vectorY[1], -1.);
  ASSERT_EQ(vectorYp[0], 0.);
  ASSERT_EQ(vectorYp[1], 0.);

  vectorY[0] = -4.;
  vectorY[1] = -2.;
  vectorYp[0] = 0.;
  vectorYp[1] = 0.;

  solver->setInitialValues(0., vectorY, vectorYp);

  solver->resetAlgebraicRestoration();
  ASSERT_NO_THROW(solver->setupNewAlgebraicRestoration(1e-4, 0.1, 1e-4, 1000, 0, 15, 0));

  solver->setCheckJacobian(false);
  ASSERT_NO_THROW(solver->solve(noInitSetup, evaluateOnlyModeAtFirstIter));

  solver->getValues(vectorY, vectorYp);

  ASSERT_EQ(vectorY[0], -4.);
  ASSERT_EQ(vectorY[1], -1.);
  ASSERT_EQ(vectorYp[0], 0.);
  ASSERT_EQ(vectorYp[1], 0.);

  boost::shared_ptr<SolverKINAlgRestoration> solver2(new SolverKINAlgRestoration());
  ASSERT_NO_THROW(solver2->init(model, SolverKINAlgRestoration::KIN_DERIVATIVES));
  ASSERT_NO_THROW(solver2->setupNewAlgebraicRestoration(1e-4, 0.1, 1e-4, 1000, 0, 15, 0));

  vectorY[0] = -4.;
  vectorY[1] = -2.;
  vectorYp[0] = 0.;
  vectorYp[1] = 0.;

  solver2->setInitialValues(0., vectorY, vectorYp);

  ASSERT_NO_THROW(solver2->solve(noInitSetup, evaluateOnlyModeAtFirstIter));

  solver2->getValues(vectorY, vectorYp);

  ASSERT_EQ(vectorY[0], -4.);
  ASSERT_EQ(vectorY[1], -2.);
  ASSERT_EQ(vectorYp[0], 1.);
  ASSERT_EQ(vectorYp[1], 0.);

  // KINSetFuncNormTol
  ASSERT_THROW_DYNAWO(solver->setupNewAlgebraicRestoration(-1, 1, 1, 1, 1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetInitialAdditionalTolerance
  ASSERT_THROW_DYNAWO(solver->setupNewAlgebraicRestoration(1, -1, 1, 1, 1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetScaledStepTol
  ASSERT_THROW_DYNAWO(solver->setupNewAlgebraicRestoration(1, 1, -1, 1, 1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetMaxNewtonStep
  ASSERT_THROW_DYNAWO(solver->setupNewAlgebraicRestoration(1, 1, 1, -1, 1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetMaxSetupCalls
  ASSERT_THROW_DYNAWO(solver->setupNewAlgebraicRestoration(1, 1, 1, 1, -1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetNumMaxIters
  ASSERT_THROW_DYNAWO(solver->setupNewAlgebraicRestoration(1, 1, 1, 1, 1, -1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetPrintLevel
  ASSERT_THROW_DYNAWO(solver->setupNewAlgebraicRestoration(1, 1, 1, 1, 1, 1, -1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);

  ASSERT_EQ(SolverKINAlgRestoration::stringFromMode(SolverKINAlgRestoration::KIN_ALGEBRAIC), "algebraic");
  ASSERT_EQ(SolverKINAlgRestoration::stringFromMode(SolverKINAlgRestoration::KIN_DERIVATIVES), "derivatives");
}

TEST(AlgebraicSolvers, testAnalyseFlag) {
  boost::shared_ptr<SolverKINCommon> solver(new SolverKINCommon());

  // KIN_SUCCESS
  ASSERT_NO_THROW(solver->analyseFlag(0));
  // KIN_INITIAL_GUESS_OK
  ASSERT_NO_THROW(solver->analyseFlag(1));
  // KIN_STEP_LT_STPTOL
  ASSERT_NO_THROW(solver->analyseFlag(2));
  // Positive number not corresponding to any expected message
  ASSERT_THROW_DYNAWO(solver->analyseFlag(3), Error::SUNDIALS_ERROR, KeyError_t::SolverSolveErrorKINSOL);
  // KIN_MEM_NULL
  ASSERT_NO_THROW(solver->analyseFlag(-1));
  // KIN_ILL_INPUT
  ASSERT_NO_THROW(solver->analyseFlag(-2));
  // KIN_NO_MALLOC
  ASSERT_NO_THROW(solver->analyseFlag(-3));
  // KIN_MEM_FAIL
  ASSERT_NO_THROW(solver->analyseFlag(-4));
  // KIN_LINESEARCH_NONCONV
  ASSERT_NO_THROW(solver->analyseFlag(-5));
  // KIN_MAXITER_REACHED
  ASSERT_NO_THROW(solver->analyseFlag(-6));
  // KIN_MXNEWT_5X_EXCEEDED
  ASSERT_NO_THROW(solver->analyseFlag(-7));
  // KIN_LINESEARCH_BCFAIL
  ASSERT_NO_THROW(solver->analyseFlag(-8));
  // KIN_LINSOLV_NO_RECOVERY
  ASSERT_NO_THROW(solver->analyseFlag(-9));
  // KIN_LINIT_FAIL
  ASSERT_NO_THROW(solver->analyseFlag(-10));
  // KIN_LSETUP_FAIL
  ASSERT_NO_THROW(solver->analyseFlag(-11));
  // KIN_LSOLVE_FAIL
  ASSERT_NO_THROW(solver->analyseFlag(-12));
  // KIN_SYSFUNC_FAIL
  ASSERT_NO_THROW(solver->analyseFlag(-13));
  // KIN_FIRST_SYSFUNC_ERR
  ASSERT_NO_THROW(solver->analyseFlag(-14));
  // KIN_REPTD_SYSFUNC_ERR
  ASSERT_NO_THROW(solver->analyseFlag(-15));
  // KIN_VECTOROP_ERR
  ASSERT_NO_THROW(solver->analyseFlag(-16));
  // Negative number not corresponding to any expected message
  ASSERT_THROW_DYNAWO(solver->analyseFlag(-17), Error::SUNDIALS_ERROR, KeyError_t::SolverSolveErrorKINSOL);
}

}  // namespace DYN
