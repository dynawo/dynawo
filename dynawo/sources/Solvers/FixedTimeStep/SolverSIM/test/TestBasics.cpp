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
 * @file Solvers/FixedTimeStep/SolverSIM/TestBasics.cpp
 * @brief Unit tests for Solver SIM
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
#include "DYNSolverSIM.h"
#include "DYNDynamicData.h"
#include "DYNParameterSolver.h"
#include "PARParametersSet.h"
#include "PARParameterFactory.h"
#include "TLTimelineFactory.h"
#include "DYNTrace.h"

INIT_XML_DYNAWO;

namespace DYN {

static SolverFactory::SolverPtr initSolver(bool optimizeAlgebraicResidualsEvaluations, bool skipNR, bool enableSilentZ) {
  // Solver
  SolverFactory::SolverPtr solver = SolverFactory::createSolverFromLib("../dynawo_SolverSIM" + std::string(sharedLibraryExtension()));

  boost::shared_ptr<parameters::ParametersSet> params = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("MySolverParam"));
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

static SolverFactory::SolverPtr initSolverPrediction(bool order1Prediction) {
  // Solver
  SolverFactory::SolverPtr solver = SolverFactory::createSolverFromLib("../dynawo_SolverSIM" + std::string(sharedLibraryExtension()));

  boost::shared_ptr<parameters::ParametersSet> params = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("MySolverParam"));
  params->addParameter(parameters::ParameterFactory::newParameter("hMin", 0.001));
  params->addParameter(parameters::ParameterFactory::newParameter("hMax", 0.01));
  params->addParameter(parameters::ParameterFactory::newParameter("kReduceStep", 0.5));
  params->addParameter(parameters::ParameterFactory::newParameter("maxNewtonTry", 10));
  params->addParameter(parameters::ParameterFactory::newParameter("order1Prediction", order1Prediction));
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

static std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > initSolverAndModel(std::string dydFileName, std::string iidmFileName,
 std::string parFileName, const double& tStart, const double& tStop, bool optimizeAlgebraicResidualsEvaluations = true, bool skipNR = true) {
  SolverFactory::SolverPtr solver = initSolver(optimizeAlgebraicResidualsEvaluations, skipNR, true);

  // DYD
  boost::shared_ptr<DynamicData> dyd(new DynamicData());
  auto networkIIDM = boost::make_shared<powsybl::iidm::Network>(powsybl::iidm::Network::readXml(boost::filesystem::path(iidmFileName)));
  boost::shared_ptr<DataInterface> data(new DataInterfaceIIDM(networkIIDM));

  boost::dynamic_pointer_cast<DataInterfaceIIDM>(data)->initFromIIDM();
  dyd->setDataInterface(data);
  if (!hasEnvVar("PWD"))
    throw DYNError(Error::GENERAL, MissingEnvironmentVariable, "PWD");
  dyd->setRootDirectory(getEnvVar("PWD"));
  dyd->getNetworkParameters(parFileName, "0");

  std::vector <std::string> fileNames;
  fileNames.push_back(dydFileName);
  dyd->initFromDydFiles(fileNames);

  compile(dyd);

  data->mapConnections();

  std::string ddb_dir = getEnvVar("PWD") + "/../../../../../M/CPP/ModelNetwork/";
#ifndef _MSC_VER
  setenv("DYNAWO_DDB_DIR", ddb_dir.c_str(), 0);
#else
  _putenv_s("DYNAWO_DDB_DIR", ddb_dir.c_str());
#endif  // Model
  Modeler modeler;
  modeler.setDataInterface(data);
  modeler.setDynamicData(dyd);
  modeler.initSystem();

  boost::shared_ptr<Model> model = initModel(tStart, modeler);

  solver->init(model, tStart, tStop);

  return std::make_pair(std::move(solver), model);
}

static boost::shared_ptr<Model> initModelWithDyd(std::string dydFileName, const double& tStart, bool enableSilentZ = true) {
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

  return model;
}

static std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > initSolverAndModelWithDyd(std::string dydFileName,
 const double& tStart, const double& tStop, bool optimizeAlgebraicResidualsEvaluations = true, bool skipNR = true, bool enableSilentZ = true) {
  SolverFactory::SolverPtr solver = initSolver(optimizeAlgebraicResidualsEvaluations, skipNR, enableSilentZ);

  boost::shared_ptr<Model> model = initModelWithDyd(dydFileName, tStart, enableSilentZ);

  solver->init(model, tStart, tStop);

  return std::make_pair(std::move(solver), model);
}

static std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > initSolverAndModelWithDydOrder1Prediction(std::string dydFileName,
 const double& tStart, const double& tStop, bool order1Prediction) {
  SolverFactory::SolverPtr solver = initSolverPrediction(order1Prediction);

  boost::shared_ptr<Model> model = initModelWithDyd(dydFileName, tStart);

  solver->init(model, tStart, tStop);

  return std::make_pair(std::move(solver), model);
}

TEST(SimulationTest, testSolverSIMTestAlpha) {
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
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp0[0], 0);
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

  ASSERT_EQ(solver->solverType(), "SimplifiedSolver");
  ASSERT_NE(solver->solverType(), "IDA");
  solver->printHeader();
  solver->printSolve();
  solver->printEnd();
}

TEST(SimulationTest, testSolverSIMTestBeta) {
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
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp0[0], 0);
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

TEST(SimulationTest, testSolverSIMTestBetaUnstableRoot) {
  const double tStart = 0.;
  const double tStop = 5.;
  // Here the maximum root restart is artificially set at zero to test the maximum root restart detection in the simplified solver strategy.
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestBeta.dyd", tStart, tStop);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);

  double tCurrent = tStart;
  std::vector<double> y(y0);
  std::vector<double> yp(yp0);
  std::vector<double> z(z0);
  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();

  // Max root restart hit at t = 2s. Accept the time step in the current strategy.
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

  ASSERT_DOUBLE_EQUALS_DYNAWO(tCurrent, 2);
  solver->solve(tStop, tCurrent);
}

TEST(SimulationTest, testSolverSIMAlgebraicMode) {
  const double tStart = 0.;
  const double tStop = 3.;
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModel("jobs/solverTestDelta.dyd",
  "jobs/solverTestDelta.iidm", "jobs/solverTestDelta.par", tStart, tStop, true, 3);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);

  double tCurrent = tStart;
  std::vector<double> y(y0);
  std::vector<double> yp(yp0);
  std::vector<double> z(z0);

  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  ASSERT_EQ(solver->getState().noFlagSet(), true);
  // Checking the voltage values at extreme nodes - Infinite node and F21 bus
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[2], 0.94766640118361411549);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[3], -0.09225375878818535547);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[10], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[11], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tCurrent, 1.);
  for (size_t i = 0; i < z.size(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(z[i], z0[i]);
  }
  model->getCurrentZ(z);
  for (size_t i = 0; i < z.size(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(z[i], z0[i]);
  }

  // Here we detect the algebraic mode change that occurs at t=2.
  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  ASSERT_EQ(solver->getState().getFlags(NotSilentZChange), true);
  ASSERT_EQ(solver->getState().getFlags(ModeChange), true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[2], 0.94766640118361411549);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[3], -0.09225375878818535547);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[10], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[11], 1);
  ASSERT_EQ(model->getModeChangeType(), ALGEBRAIC_J_UPDATE_MODE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tCurrent, 2.);
  for (size_t i = 0; i < z.size(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(z[i], z0[i]);
  }
  model->getCurrentZ(z);
  for (size_t i = 0; i < z.size(); ++i) {
    if (i == 12 || i == 16) {
      ASSERT_DOUBLE_EQUALS_DYNAWO(z[i], 1);  // bus state == OPEN
    } else {
      ASSERT_DOUBLE_EQUALS_DYNAWO(z[i], z0[i]);
    }
  }

  solver->reinit();
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[2], 0.92684239292330972138);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[3], -0.12083482860045165197);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[10], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[11], 1);
  ASSERT_EQ(model->getModeChangeType(), NO_MODE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tCurrent, 2.);
  model->getCurrentZ(z);
  for (size_t i = 0; i < z.size(); ++i) {
    if (i == 12 || i == 16) {
      ASSERT_DOUBLE_EQUALS_DYNAWO(z[i], 1);  // bus state == OPEN
    } else {
      ASSERT_DOUBLE_EQUALS_DYNAWO(z[i], z0[i]);
    }
  }

  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  ASSERT_EQ(solver->getState().noFlagSet(), true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[2], 0.92684239292330972138);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[3], -0.12083482860045165197);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[10], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[11], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tCurrent, 3.);
  for (size_t i = 0; i < z.size(); ++i) {
    if (i == 12 || i == 16) {
      ASSERT_DOUBLE_EQUALS_DYNAWO(z[i], 1);  // bus state == OPEN
    } else {
      ASSERT_DOUBLE_EQUALS_DYNAWO(z[i], z0[i]);
    }
  }
  model->getCurrentZ(z);
  for (size_t i = 0; i < z.size(); ++i) {
    if (i == 12 || i == 16) {
      ASSERT_DOUBLE_EQUALS_DYNAWO(z[i], 1);  // bus state == OPEN
    } else {
      ASSERT_DOUBLE_EQUALS_DYNAWO(z[i], z0[i]);
    }
  }
}

TEST(SimulationTest, testSolverSkipNR) {
  const double tStart = 0.;
  const double tStop = 10.;
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestSkipNR.dyd",
                                                                                                tStart, tStop, false);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);

  double tCurrent = tStart;
  std::vector<double> y(y0);
  std::vector<double> yp(yp0);
  std::vector<double> z(z0);

  // Statistics to ensure that nothing is done in the NR
  // Solve at t = 1 -> Should force skipNextNR_ = true
  solver->solve(tStop, tCurrent);
  // Solve at t = 2
  solver->solve(tStop, tCurrent);
  std::stringstream msg;
  msg << "| " << std::setw(8) << 2 << " "
          << std::setw(16) << 0 << " "
          << std::setw(10) << 0 << " "
          << std::setw(18) << 1 << " ";
  std::stringstream msgRef;
  solver->printSolveSpecific(msgRef);
  ASSERT_EQ(msgRef.str(), msg.str());

  // Solve at t = 3
  solver->solve(tStop, tCurrent);
  // Solve at t = 4 -> skipNextNR_ = false
  solver->solve(tStop, tCurrent);
  msg.str(std::string());
  msg << "| " << std::setw(8) << 4 << " "
          << std::setw(16) << 0 << " "
          << std::setw(10) << 0 << " "
          << std::setw(18) << 1 << " ";
  msgRef.str(std::string());
  solver->printSolveSpecific(msgRef);
  ASSERT_NE(msgRef.str(), msg.str());

  // Solve at t = 5 -> skipNextNR_ = true
  solver->solve(tStop, tCurrent);
  // Solve at t = 6
  solver->solve(tStop, tCurrent);
  msg.str(std::string());
  msg << "| " << std::setw(8) << 6 << " "
          << std::setw(16) << 1 << " "
          << std::setw(10) << 2 << " "
          << std::setw(18) << 1 << " ";
  msgRef.str(std::string());
  solver->printSolveSpecific(msgRef);
  ASSERT_EQ(msgRef.str(), msg.str());

  // Solve at t = 7
  solver->solve(tStop, tCurrent);
  msg.str(std::string());
  msg << "| " << std::setw(8) << 7 << " "
          << std::setw(16) << 1 << " "
          << std::setw(10) << 1 << " "
          << std::setw(18) << 1 << " ";
  msgRef.str(std::string());
  solver->printSolveSpecific(msgRef);
  ASSERT_NE(msgRef.str(), msg.str());
}

TEST(SimulationTest, testSolverOptimizeAlgebraicResidualsEvaluations) {
  const double tStart = 0.;
  const double tStop = 10.;
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestSkipNR.dyd",
                                                                                                tStart, tStop, true, false);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);

  double tCurrent = tStart;
  std::vector<double> y(y0);
  std::vector<double> yp(yp0);
  std::vector<double> z(z0);

  // Statistics to ensure that nothing is done in the NR
  // Solve at t = 1 -> Should force optimizeAlgebraicResidualsEvaluations = true
  solver->solve(tStop, tCurrent);
  ASSERT_EQ(solver->getCurrentY()[0], 1);
  // Solve at t = 2
  solver->solve(tStop, tCurrent);
  std::stringstream msg;
  msg << "| " << std::setw(8) << 2 << " "
          << std::setw(16) << 0 << " "
          << std::setw(10) << 0 << " "
          << std::setw(18) << 1 << " ";
  std::stringstream msgRef;
  solver->printSolveSpecific(msgRef);
  ASSERT_EQ(msgRef.str(), msg.str());
  ASSERT_EQ(solver->getCurrentY()[0], 1);

  // Solve at t = 3
  solver->solve(tStop, tCurrent);
  solver->reinit();
  ASSERT_EQ(solver->getCurrentY()[0], 2);
  // Solve at t = 4 -> optimizeAlgebraicResidualsEvaluations = true
  solver->solve(tStop, tCurrent);
  msg.str(std::string());
  msg << "| " << std::setw(8) << 4 << " "
          << std::setw(16) << 1 << " "
          << std::setw(10) << 1 << " "
          << std::setw(18) << 1 << " ";
  msgRef.str(std::string());
  solver->printSolveSpecific(msgRef);
  ASSERT_EQ(msgRef.str(), msg.str());
  ASSERT_EQ(solver->getCurrentY()[0], 2);

  // Solve at t = 5 -> optimizeAlgebraicResidualsEvaluations = true
  solver->solve(tStop, tCurrent);
  ASSERT_EQ(solver->getCurrentY()[0], 2);
  // Solve at t = 6-> optimizeAlgebraicResidualsEvaluations = false
  solver->solve(tStop, tCurrent);
  solver->reinit();
  msg.str(std::string());
  msg << "| " << std::setw(8) << 6 << " "
          << std::setw(16) << 2 << " "
          << std::setw(10) << 1 << " "
          << std::setw(18) << 1 << " ";
  msgRef.str(std::string());
  solver->printSolveSpecific(msgRef);
  ASSERT_EQ(msgRef.str(), msg.str());
  ASSERT_EQ(solver->getCurrentY()[0], 4);

  // Solve at t = 7
  solver->solve(tStop, tCurrent);
  msg.str(std::string());
  msg << "| " << std::setw(8) << 7 << " "
          << std::setw(16) << 1 << " "
          << std::setw(10) << 1 << " "
          << std::setw(18) << 1 << " ";
  msgRef.str(std::string());
  solver->printSolveSpecific(msgRef);
  ASSERT_NE(msgRef.str(), msg.str());
  ASSERT_EQ(solver->getCurrentY()[0], 4);
}

TEST(SimulationTest, testSolverOptimizeAlgebraicResidualsEvaluationsAndSkipNR) {
  const double tStart = 0.;
  const double tStop = 10.;
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestSkipNR.dyd",
                                                                                                tStart, tStop);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);

  double tCurrent = tStart;
  std::vector<double> y(y0);
  std::vector<double> yp(yp0);
  std::vector<double> z(z0);

  // Statistics to ensure that nothing is done in the NR
  // Solve at t = 1 -> Should force skipNextNR_ = true
  // optimizeAlgebraicResidualsEvaluations = true
  solver->solve(tStop, tCurrent);
  ASSERT_EQ(solver->getCurrentY()[0], 1);
  // Solve at t = 2
  solver->solve(tStop, tCurrent);
  std::stringstream msg;
  msg << "| " << std::setw(8) << 2 << " "
          << std::setw(16) << 0 << " "
          << std::setw(10) << 0 << " "
          << std::setw(18) << 1 << " ";
  std::stringstream msgRef;
  solver->printSolveSpecific(msgRef);
  ASSERT_EQ(msgRef.str(), msg.str());
  ASSERT_EQ(solver->getCurrentY()[0], 1);

  // Solve at t = 3
  solver->solve(tStop, tCurrent);
  solver->reinit();
  ASSERT_EQ(solver->getCurrentY()[0], 2);
  // Solve at t = 4 -> skipNextNR_ = false
  // and optimizeAlgebraicResidualsEvaluations = true
  solver->solve(tStop, tCurrent);
  msg.str(std::string());
  msg << "| " << std::setw(8) << 4 << " "
          << std::setw(16) << 1 << " "
          << std::setw(10) << 1 << " "
          << std::setw(18) << 1 << " ";
  msgRef.str(std::string());
  solver->printSolveSpecific(msgRef);
  ASSERT_EQ(msgRef.str(), msg.str());
  ASSERT_EQ(solver->getCurrentY()[0], 2);

  // Solve at t = 5 -> skipNextNR_ = true
  // optimizeAlgebraicResidualsEvaluations = true
  solver->solve(tStop, tCurrent);
  ASSERT_EQ(solver->getCurrentY()[0], 2);
  // Solve at t = 6
  solver->solve(tStop, tCurrent);
  solver->reinit();
  msg.str(std::string());
  msg << "| " << std::setw(8) << 6 << " "
          << std::setw(16) << 2 << " "
          << std::setw(10) << 1 << " "
          << std::setw(18) << 1 << " ";
  msgRef.str(std::string());
  solver->printSolveSpecific(msgRef);
  ASSERT_EQ(msgRef.str(), msg.str());
  ASSERT_EQ(solver->getCurrentY()[0], 4);

  // Solve at t = 7
  solver->solve(tStop, tCurrent);
  msg.str(std::string());
  msg << "| " << std::setw(8) << 7 << " "
          << std::setw(16) << 1 << " "
          << std::setw(10) << 1 << " "
          << std::setw(18) << 1 << " ";
  msgRef.str(std::string());
  solver->printSolveSpecific(msgRef);
  ASSERT_NE(msgRef.str(), msg.str());
  ASSERT_EQ(solver->getCurrentY()[0], 4);
}

TEST(SimulationTest, testSolverSIMSilentZ) {
  const double tStart = 0.;
  const double tStop = 10.;
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestSilentZ.dyd",
                                                                                                tStart, tStop);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);

  double tCurrent = tStart;
  std::vector<double> y(y0);
  std::vector<double> yp(yp0);
  std::vector<double> z(z0);
  // Solve at t = 1
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  // Solve at t = 2 => z1 is modified
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_TRUE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));

  // Solve at t = 3
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  // Solve at t = 4 -> z2 is modified
  solver->solve(tStop, tCurrent);
  ASSERT_TRUE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  // Solve at t = 5 -> z1 and z2 are modified
  solver->solve(tStop, tCurrent);
  ASSERT_TRUE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
}

TEST(SimulationTest, testSolverSIMSilentZDisabled) {
  const double tStart = 0.;
  const double tStop = 10.;
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestSilentZ.dyd",
                                                                                                tStart, tStop, true, true, false);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);

  double tCurrent = tStart;
  std::vector<double> y(y0);
  std::vector<double> yp(yp0);
  std::vector<double> z(z0);
  // Solve at t = 1
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  // Solve at t = 2 => z1 is modified
  solver->solve(tStop, tCurrent);
  ASSERT_TRUE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));

  // Solve at t = 3
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  // Solve at t = 4 -> z2 is modified
  solver->solve(tStop, tCurrent);
  ASSERT_TRUE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  // Solve at t = 5 -> z1 and z2 are modified
  solver->solve(tStop, tCurrent);
  ASSERT_TRUE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
}

TEST(SimulationTest, testSolverSIMSilentZNotUsedInContinuous) {
  const double tStart = 0.;
  const double tStop = 10.;
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestSilentZNotUsedInContinuous.dyd",
                                                                                                tStart, tStop);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);

  double tCurrent = tStart;
  std::vector<double> y(y0);
  std::vector<double> yp(yp0);
  std::vector<double> z(z0);
  // Solve at t = 1
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  // Solve at t = 2
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  // Solve at t = 3
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  // Solve at t = 4 => zNotUsedInContinuous and zNotUsedInDiscrete are modified
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_TRUE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_TRUE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
}

TEST(SimulationTest, testSolverSIMSilentZNotUsedInContinuousDisabled) {
  const double tStart = 0.;
  const double tStop = 10.;
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestSilentZNotUsedInContinuous.dyd",
                                                                                                tStart, tStop, true, true, false);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);

  double tCurrent = tStart;
  std::vector<double> y(y0);
  std::vector<double> yp(yp0);
  std::vector<double> z(z0);
  // Solve at t = 1
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  // Solve at t = 2
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  // Solve at t = 3
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  // Solve at t = 4 => zNotUsedInContinuous and zNotUsedInDiscrete are modified
  solver->solve(tStop, tCurrent);
  ASSERT_TRUE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
}

TEST(SimulationTest, testSolverSIMSilentZNotUsedInContinuous2) {
  const double tStart = 0.;
  const double tStop = 10.;
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestSilentZNotUsedInContinuous2.dyd",
                                                                                                tStart, tStop);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);

  double tCurrent = tStart;
  std::vector<double> y(y0);
  std::vector<double> yp(yp0);
  std::vector<double> z(z0);
  // Solve at t = 1
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  // Solve at t = 2 => zNotUsedInContinuous is modified
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_TRUE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  // Solve at t = 3 => zNotUsedInDiscrete is modified
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_TRUE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  // Solve at t = 4
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
}

TEST(ParametersTest, testParameters) {
  const SolverFactory::SolverPtr solver = SolverFactory::createSolverFromLib("../dynawo_SolverSIM" + std::string(sharedLibraryExtension()));
  solver->defineParameters();
  // Throw if no PAR file
  boost::shared_ptr<parameters::ParametersSet> nullSet;
  ASSERT_THROW_DYNAWO(solver->setParametersFromPARFile(nullSet), Error::GENERAL, KeyError_t::ParameterNotReadFromOrigin);
  // Adding parameters from a PAR file
  boost::shared_ptr<parameters::ParametersSet> params = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("MySolverParam"));
  ASSERT_THROW_DYNAWO(solver->setParametersFromPARFile(params), Error::GENERAL, KeyError_t::SolverMissingParam);
  params->addParameter(parameters::ParameterFactory::newParameter("hMin", 0.000001));
  ASSERT_THROW_DYNAWO(solver->setParametersFromPARFile(params), Error::GENERAL, KeyError_t::SolverMissingParam);
  params->addParameter(parameters::ParameterFactory::newParameter("hMax", 1.));
  ASSERT_THROW_DYNAWO(solver->setParametersFromPARFile(params), Error::GENERAL, KeyError_t::SolverMissingParam);
  params->addParameter(parameters::ParameterFactory::newParameter("kReduceStep", 0.5));
  ASSERT_THROW_DYNAWO(solver->setParametersFromPARFile(params), Error::GENERAL, KeyError_t::SolverMissingParam);
  params->addParameter(parameters::ParameterFactory::newParameter("maxNewtonTry", 10));
  ASSERT_NO_THROW(solver->setParametersFromPARFile(params));
  ASSERT_NO_THROW(solver->setSolverParameters());

  // Check unused parameters
  params->addParameter(parameters::ParameterFactory::newParameter("falseParam", 0));
  ASSERT_NO_THROW(solver->setParametersFromPARFile(params));
  solver->checkUnusedParameters(params);

  // Find parameter
  ASSERT_THROW_DYNAWO(solver->findParameter("falseParam"), Error::GENERAL, KeyError_t::ParameterNotDefined);

  // Add optional parameters
  params->addParameter(parameters::ParameterFactory::newParameter("fnormtol", 0.01));
  params->addParameter(parameters::ParameterFactory::newParameter("initialaddtol", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("scsteptol", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("mxnewtstep", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("msbset", 10));
  params->addParameter(parameters::ParameterFactory::newParameter("mxiter", 2));
  params->addParameter(parameters::ParameterFactory::newParameter("printfl", 0));
  params->addParameter(parameters::ParameterFactory::newParameter("fnormtolAlg", 0.000001));
  params->addParameter(parameters::ParameterFactory::newParameter("scsteptolAlg", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("mxnewtstepAlg", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("msbsetAlg", 10));
  params->addParameter(parameters::ParameterFactory::newParameter("mxiterAlg", 2));
  params->addParameter(parameters::ParameterFactory::newParameter("printflAlg", 0));
  params->addParameter(parameters::ParameterFactory::newParameter("fnormtolAlgJ", 0.000001));
  params->addParameter(parameters::ParameterFactory::newParameter("scsteptolAlgJ", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("mxnewtstepAlgJ", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("msbsetAlgJ", 10));
  params->addParameter(parameters::ParameterFactory::newParameter("mxiterAlgJ", 2));
  params->addParameter(parameters::ParameterFactory::newParameter("printflAlgJ", 0));
  params->addParameter(parameters::ParameterFactory::newParameter("minimalAcceptableStep", 10e-6));
  params->addParameter(parameters::ParameterFactory::newParameter("maximumNumberSlowStepIncrease", 10));
  params->addParameter(parameters::ParameterFactory::newParameter("optimizeAlgebraicResidualsEvaluations", false));
  params->addParameter(parameters::ParameterFactory::newParameter("optimizeReinitAlgebraicResidualsEvaluations", false));
  params->addParameter(parameters::ParameterFactory::newParameter("skipNRIfInitialGuessOK", false));
  params->addParameter(parameters::ParameterFactory::newParameter("minimumModeChangeTypeForAlgebraicRestoration", std::string("ALGEBRAIC_J_UPDATE")));
  params->addParameter(parameters::ParameterFactory::newParameter("order1Prediction", false));
  ASSERT_NO_THROW(solver->setParametersFromPARFile(params));
  ASSERT_NO_THROW(solver->setSolverParameters());
  ASSERT_EQ(solver->getParametersMap().size(), 41);
}

TEST(ParametersTest, testParametersInit) {
  const SolverFactory::SolverPtr solver = SolverFactory::createSolverFromLib("../dynawo_SolverSIM" + std::string(sharedLibraryExtension()));
  solver->defineParameters();
  // Throw if no PAR file
  boost::shared_ptr<parameters::ParametersSet> nullSet;
  ASSERT_THROW_DYNAWO(solver->setParametersFromPARFile(nullSet), Error::GENERAL, KeyError_t::ParameterNotReadFromOrigin);
  // Adding parameters from a PAR file
  boost::shared_ptr<parameters::ParametersSet> params = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("MySolverParam"));
  ASSERT_THROW_DYNAWO(solver->setParametersFromPARFile(params), Error::GENERAL, KeyError_t::SolverMissingParam);
  params->addParameter(parameters::ParameterFactory::newParameter("hMin", 0.000001));
  ASSERT_THROW_DYNAWO(solver->setParametersFromPARFile(params), Error::GENERAL, KeyError_t::SolverMissingParam);
  params->addParameter(parameters::ParameterFactory::newParameter("hMax", 1.));
  ASSERT_THROW_DYNAWO(solver->setParametersFromPARFile(params), Error::GENERAL, KeyError_t::SolverMissingParam);
  params->addParameter(parameters::ParameterFactory::newParameter("kReduceStep", 0.5));
  ASSERT_THROW_DYNAWO(solver->setParametersFromPARFile(params), Error::GENERAL, KeyError_t::SolverMissingParam);
  params->addParameter(parameters::ParameterFactory::newParameter("maxNewtonTry", 10));
  ASSERT_NO_THROW(solver->setParametersFromPARFile(params));
  ASSERT_NO_THROW(solver->setSolverParameters());

  // Check unused parameters
  params->addParameter(parameters::ParameterFactory::newParameter("falseParam", 0));
  ASSERT_NO_THROW(solver->setParametersFromPARFile(params));
  solver->checkUnusedParameters(params);

  // Find parameter
  ASSERT_THROW_DYNAWO(solver->findParameter("falseParam"), Error::GENERAL, KeyError_t::ParameterNotDefined);

  // Add optional parameters
  params->addParameter(parameters::ParameterFactory::newParameter("fnormtolInit", 0.01));
  params->addParameter(parameters::ParameterFactory::newParameter("initialaddtolInit", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("scsteptolInit", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("mxnewtstepInit", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("msbsetInit", 10));
  params->addParameter(parameters::ParameterFactory::newParameter("mxiterInit", 2));
  params->addParameter(parameters::ParameterFactory::newParameter("printflInit", 0));
  params->addParameter(parameters::ParameterFactory::newParameter("fnormtolAlgInit", 0.000001));
  params->addParameter(parameters::ParameterFactory::newParameter("scsteptolAlgInit", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("mxnewtstepAlgInit", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("msbsetAlgInit", 10));
  params->addParameter(parameters::ParameterFactory::newParameter("mxiterAlgInit", 2));
  params->addParameter(parameters::ParameterFactory::newParameter("printflAlgInit", 0));
  params->addParameter(parameters::ParameterFactory::newParameter("minimumModeChangeTypeForAlgebraicRestorationInit", std::string("ALGEBRAIC_J_UPDATE")));
  ASSERT_NO_THROW(solver->setParametersFromPARFile(params));
  ASSERT_NO_THROW(solver->setSolverParameters());
  ASSERT_EQ(solver->getParametersMap().size(), 41);
}

TEST(SimulationTest, testSolverSIMTestPredictionOrder1) {
  const double tStart = 0.;
  const double tStop = 0.02;
  bool order1Prediction = true;
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModelWithDydOrder1Prediction("jobs/solverTestPrediction.dyd", tStart,
    tStop, order1Prediction);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  auto& solverSIM = reinterpret_cast<SolverSIM&>(*solver);

  solver->calculateIC(tStop);

  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeY(), 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeF(), 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeG(), 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeZ(), 0);
  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y0[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp0[0], -1);

  ASSERT_TRUE(solverSIM.hasPrediction());

  solverSIM.computePrediction();

  const std::vector<double>& y = solver->getCurrentY();
  const std::vector<double>& yp = solver->getCurrentYP();

  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 0.99);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], -1);

  double tCurrent = tStart;
  solver->solve(tStop, tCurrent);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 0.980198);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], -0.980198);

  solver->solve(tStop, tCurrent);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 0.970493);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], -0.970493);
}

TEST(SimulationTest, testSolverSIMTestPredictionOrder0) {
  const double tStart = 0.;
  const double tStop = 0.02;
  bool order1Prediction = false;
  std::pair<SolverFactory::SolverPtr, boost::shared_ptr<Model> > p = initSolverAndModelWithDydOrder1Prediction("jobs/solverTestPrediction.dyd", tStart,
    tStop, order1Prediction);
  const SolverFactory::SolverPtr& solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  auto& solverSIM = reinterpret_cast<SolverSIM&>(*solver);

  solver->calculateIC(tStop);

  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeY(), 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeF(), 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeG(), 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeZ(), 0);
  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y0[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp0[0], 0);

  ASSERT_FALSE(solverSIM.hasPrediction());

  solverSIM.computePrediction();

  const std::vector<double>& y = solver->getCurrentY();
  const std::vector<double>& yp = solver->getCurrentYP();

  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], 0);

  double tCurrent = tStart;
  solver->solve(tStop, tCurrent);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 0.990099);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], -0.990099);

  solver->solve(tStop, tCurrent);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 0.980296);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], -0.980296);
}

}  // namespace DYN
