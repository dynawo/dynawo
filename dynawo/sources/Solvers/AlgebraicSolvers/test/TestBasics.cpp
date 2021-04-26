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

testing::Environment* initXmlEnvironment();

namespace DYN {
testing::Environment* const env = initXmlEnvironment();

boost::shared_ptr<Model> initModelFromDyd(std::string dydFileName) {
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

TEST(AlgebraicSolvers, testInit) {
  boost::shared_ptr<SolverKINCommon> solver(new SolverKINCommon());
  ASSERT_THROW_DYNAWO(solver->initCommon("KLU", 1, 1, 1, 1, 1, 1, 1, NULL, NULL), Error::SUNDIALS_ERROR, KeyError_t::SolverEmptyYVector);

  boost::shared_ptr<Model> model = initModelFromDyd("dyd/solverTestAlpha.dyd");
  boost::shared_ptr<SolverKINEuler> solverEuler(new SolverKINEuler());
  // KINSetFuncNormTol
  ASSERT_THROW_DYNAWO(solverEuler->init(model, "KLU", -1, 1, 1, 1, 1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetInitialAdditionalTolerance
  ASSERT_THROW_DYNAWO(solverEuler->init(model, "KLU", 1, -1, 1, 1, 1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetScaledStepTol
  ASSERT_THROW_DYNAWO(solverEuler->init(model, "KLU", 1, 1, -1, 1, 1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetMaxNewtonStep
  ASSERT_THROW_DYNAWO(solverEuler->init(model, "KLU", 1, 1, 1, -1, 1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetMaxSetupCalls
  ASSERT_THROW_DYNAWO(solverEuler->init(model, "KLU", 1, 1, 1, 1, -1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetNumMaxIters
  ASSERT_THROW_DYNAWO(solverEuler->init(model, "KLU", 1, 1, 1, 1, 1, -1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetPrintLevel
  ASSERT_THROW_DYNAWO(solverEuler->init(model, "KLU", 1, 1, 1, 1, 1, 1, -1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  ASSERT_NO_THROW(solverEuler->init(model, "KLU", 1, 1, 1, 1, 1, 1, 1));
}

TEST(AlgebraicSolvers, testModifySettings) {
  boost::shared_ptr<Model> model = initModelFromDyd("dyd/solverTestAlpha.dyd");
  boost::shared_ptr<SolverKINAlgRestoration> solver(new SolverKINAlgRestoration());
  ASSERT_NO_THROW(solver->init(model, SolverKINAlgRestoration::KIN_NORMAL, 1, 1, 1, 1, 1, 1, 1));

  // KINSetFuncNormTol
  ASSERT_THROW_DYNAWO(solver->modifySettings(-1, 1, 1, 1, 1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetInitialAdditionalTolerance
  ASSERT_THROW_DYNAWO(solver->modifySettings(1, -1, 1, 1, 1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetScaledStepTol
  ASSERT_THROW_DYNAWO(solver->modifySettings(1, 1, -1, 1, 1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetMaxNewtonStep
  ASSERT_THROW_DYNAWO(solver->modifySettings(1, 1, 1, -1, 1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetMaxSetupCalls
  ASSERT_THROW_DYNAWO(solver->modifySettings(1, 1, 1, 1, -1, 1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetNumMaxIters
  ASSERT_THROW_DYNAWO(solver->modifySettings(1, 1, 1, 1, 1, -1, 1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  // KINSetPrintLevel
  ASSERT_THROW_DYNAWO(solver->modifySettings(1, 1, 1, 1, 1, 1, -1), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorKINSOL);
  ASSERT_NO_THROW(solver->modifySettings(1, 1, 1, 1, 1, 1, 1));
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
