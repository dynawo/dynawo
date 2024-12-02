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
 * @file Solvers/FixedTimeStep/SolverTRAP/TestBasics.cpp
 * @brief Unit tests for Solver TRAP
 *
 */

#include <fstream>
#include <cmath>
#include <iostream>
#include <iomanip>
#include <sstream>

#include <boost/filesystem.hpp>
#include <boost/algorithm/string/classification.hpp>
#include <boost/algorithm/string/split.hpp>

#include "gtest_dynawo.h"
#include "DYNDataInterfaceIIDM.h"
#include "DYNFileSystemUtils.h"
#include "DYNExecUtils.h"
#include "DYNSolver.h"
#include "DYNModeler.h"
#include "DYNModel.h"
#include "DYNModelMulti.h"
#include "DYNCompiler.h"
#include "DYNSolverFactory.h"
#include "DYNDynamicData.h"
#include "DYNParameterSolver.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"
#include "PARParameterFactory.h"
#include "TLTimelineFactory.h"
#include "DYNTrace.h"

INIT_XML_DYNAWO;

namespace DYN {

static SolverFactory::SolverPtr initSolver(bool optimizeAlgebraicResidualsEvaluations, bool skipNR, bool enableSilentZ) {
  // Solver
  SolverFactory::SolverPtr solver = SolverFactory::createSolverFromLib("../dynawo_SolverTRAP" + std::string(sharedLibraryExtension()));

  std::shared_ptr<parameters::ParametersSet> params = parameters::ParametersSetFactory::newParametersSet("MySolverParam");
  params->addParameter(parameters::ParameterFactory::newParameter("hMin", 0.000001));
  params->addParameter(parameters::ParameterFactory::newParameter("hMax", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("kReduceStep", 0.5));
  params->addParameter(parameters::ParameterFactory::newParameter("maxNewtonTry", 10));
  params->addParameter(parameters::ParameterFactory::newParameter("optimizeAlgebraicResidualsEvaluations", optimizeAlgebraicResidualsEvaluations));
  params->addParameter(parameters::ParameterFactory::newParameter("skipNRIfInitialGuessOK", skipNR));
  params->addParameter(parameters::ParameterFactory::newParameter("enableSilentZ", enableSilentZ));
  solver->setParameters(params);

  return solver;
}

static void compile(boost::shared_ptr<DynamicData> dyd) {
  bool preCompiledUseStandardModels = false;
  std::vector <UserDefinedDirectory> precompiledModelsDirsAbsolute;
  std::string preCompiledModelsExtension = sharedLibraryExtension();
  bool modelicaUseStandardModels = false;

  std::vector <UserDefinedDirectory> modelicaModelsDirsAbsolute;
  UserDefinedDirectory modelicaModel;
  if (!hasEnvVar("PWD"))
    throw DYNError(Error::GENERAL, MissingEnvironmentVariable, "PWD");
  modelicaModel.path = getEnvVar("PWD") +"/jobs/";
  modelicaModel.isRecursive = false;
  modelicaModelsDirsAbsolute.push_back(modelicaModel);
  std::string modelicaModelsExtension = ".mo";

  std::vector<std::string> additionalHeaderFiles;
  if (hasEnvVar("DYNAWO_HEADER_FILES_FOR_PREASSEMBLED")) {
    std::string headerFileList = getEnvVar("DYNAWO_HEADER_FILES_FOR_PREASSEMBLED");
    boost::split(additionalHeaderFiles, headerFileList, boost::is_any_of(" "), boost::token_compress_on);
  }

  const bool rmModels = true;
  std::unordered_set<boost::filesystem::path, PathHash> pathsToIgnore;
  Compiler cf = Compiler(dyd, preCompiledUseStandardModels,
            precompiledModelsDirsAbsolute,
            preCompiledModelsExtension,
            modelicaUseStandardModels,
            modelicaModelsDirsAbsolute,
            modelicaModelsExtension,
            pathsToIgnore,
            additionalHeaderFiles,
            rmModels,
            getEnvVar("PWD") +"/jobs");
  cf.compile();  // modelOnly = false, compilation and parameter linking
  cf.concatConnects();
  cf.concatRefs();
}

static boost::shared_ptr<Model> initModel(const double& tStart, Modeler modeler, bool silentZenabled = true) {
  boost::shared_ptr<Model> model = modeler.getModel();
  model->initBuffers();
  model->initSilentZ(silentZenabled);
  model->setIsInitProcess(true);
  model->init(tStart);
  model->rotateBuffers();
  model->printMessages();
  model->setIsInitProcess(false);
  boost::shared_ptr<timeline::Timeline> timeline = timeline::TimelineFactory::newInstance("timeline");
  model->setTimeline(timeline);
  return model;
}

static std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > initSolverAndModelWithDyd(std::string dydFileName,
 const double& tStart, const double& tStop, bool optimizeAlgebraicResidualsEvaluations = true, bool skipNR = true, bool enableSilentZ = true) {
  SolverFactory::SolverPtr solver = initSolver(optimizeAlgebraicResidualsEvaluations, skipNR, enableSilentZ);
  // DYD
  boost::shared_ptr<DynamicData> dyd(new DynamicData());
  std::vector <std::string> fileNames;
  fileNames.push_back(dydFileName);
  dyd->initFromDydFiles(fileNames);

  compile(dyd);

  // Model
  Modeler modeler;
  // modeler.setDataInterface(data);
  modeler.setDynamicData(dyd);
  modeler.initSystem();

  boost::shared_ptr<Model> model = initModel(tStart, modeler, enableSilentZ);

  solver->init(model, tStart, tStop);

  return std::make_pair(std::move(solver), model);
}

TEST(SimulationTest, testSolverTRAPTestAlpha) {
  const double tStart = 0.;
  const double tStop = 5.;
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestAlpha.dyd", tStart, tStop);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeY(), 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeF(), 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeG(), 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeZ(), 0);
  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y0[0], -2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y0[1], -1);
  // At the initialization step, only the algebraic equations are considered - yp() = 0.
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp0[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp0[1], 0);

  double tCurrent = tStart;
  std::vector<double> y(y0);
  std::vector<double> yp(yp0);
  std::vector<double> z(z0);
  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  ASSERT_EQ(solver->getState().noFlagSet(), true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], -1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[1], -1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[1], 0);

  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  ASSERT_EQ(solver->getState().noFlagSet(), true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[1], -1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[1], 0);

  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  ASSERT_EQ(solver->getState().noFlagSet(), false);
  ASSERT_EQ(solver->getState().getFlags(ModeChange), true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[1], -1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[1], 0);
  solver->reinit();
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  ASSERT_EQ(solver->getState().noFlagSet(), true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[1], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[1], 0);

  ASSERT_EQ(solver->solverType(), "TrapezoidalSolver");
  ASSERT_NE(solver->solverType(), "IDA");
  solver->printHeader();
  solver->printSolve();
  solver->printEnd();
}

TEST(SimulationTest, testSolverTRAPTestBeta) {
  const double tStart = 0.;
  const double tStop = 5.;
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestBeta.dyd", tStart, tStop);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  ASSERT_EQ(model->sizeY(), 1);
  ASSERT_EQ(model->sizeF(), 1);
  ASSERT_EQ(model->sizeG(), 2);
  ASSERT_EQ(model->sizeZ(), 1);
  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y0[0], -2);
  // At the initialization step, only the algebraic equations are considered - yp() = 0.
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp0[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z0[0], -1);


  double tCurrent = tStart;
  std::vector<double> y(y0);
  std::vector<double> yp(yp0);
  std::vector<double> z(z0);
  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  ASSERT_EQ(solver->getState().noFlagSet(), true);
  model->getCurrentZ(z);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], -1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], -1);

  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  ASSERT_EQ(solver->getState().getFlags(ModeChange | SilentZNotUsedInDiscreteEqChange), true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], -1);
  model->getCurrentZ(z);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 1);

  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  ASSERT_EQ(solver->getState().noFlagSet(), true);
  model->getCurrentZ(z);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 1);
}

}  // namespace DYN
