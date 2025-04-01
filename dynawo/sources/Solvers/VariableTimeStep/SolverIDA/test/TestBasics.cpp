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
 * @file Solvers/SolverIDA/TestBasics.cpp
 * @brief Unit tests for IDA Solver
 *
 */

#include <fstream>
#include <cmath>

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
#include "PARParametersSet.h"
#include "PARParameterFactory.h"
#include "DYNTrace.h"
#include "TLTimelineFactory.h"
#include "DYNMacrosMessage.h"

INIT_XML_DYNAWO;

namespace DYN {

static boost::shared_ptr<Solver> initSolver(bool enableSilentZ = true) {
  // Solver
  boost::shared_ptr<Solver> solver = SolverFactory::createSolverFromLib("../dynawo_SolverIDA" + std::string(sharedLibraryExtension()));

  boost::shared_ptr<parameters::ParametersSet> params = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("MySolverParam"));
  params->addParameter(parameters::ParameterFactory::newParameter("order", 2));
  params->addParameter(parameters::ParameterFactory::newParameter("initStep", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("minStep", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("maxStep", 10.));
  params->addParameter(parameters::ParameterFactory::newParameter("absAccuracy", 1e-4));
  params->addParameter(parameters::ParameterFactory::newParameter("relAccuracy", 1e-4));
  params->addParameter(parameters::ParameterFactory::newParameter("fnormtolAlg", 1e-4));
  params->addParameter(parameters::ParameterFactory::newParameter("scsteptolAlg", 1e-4));
  params->addParameter(parameters::ParameterFactory::newParameter("mxnewtstepAlg", 100000.));
  params->addParameter(parameters::ParameterFactory::newParameter("msbsetAlg", 5));
  params->addParameter(parameters::ParameterFactory::newParameter("mxiterAlg", 30));
  params->addParameter(parameters::ParameterFactory::newParameter("printflAlg", 0));
  params->addParameter(parameters::ParameterFactory::newParameter("fnormtolAlgJ", 1e-4));
  params->addParameter(parameters::ParameterFactory::newParameter("scsteptolAlgJ", 1e-4));
  params->addParameter(parameters::ParameterFactory::newParameter("mxnewtstepAlgJ", 100000.));
  params->addParameter(parameters::ParameterFactory::newParameter("msbsetAlgJ", 1));
  params->addParameter(parameters::ParameterFactory::newParameter("mxiterAlgJ", 50));
  params->addParameter(parameters::ParameterFactory::newParameter("printflAlgJ", 0));
  params->addParameter(parameters::ParameterFactory::newParameter("minimalAcceptableStep", 10e-6));
  params->addParameter(parameters::ParameterFactory::newParameter("maximumNumberSlowStepIncrease", 10));
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
  modelicaModel.path = getMandatoryEnvVar("PWD") +"/jobs/";
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
            getEnvVar("PWD") +"/jobs");
  cf.compile();  // modelOnly = false, compilation and parameter linking
  cf.concatConnects();
  cf.concatRefs();
}

static boost::shared_ptr<Model> initModel(Modeler modeler, const double& tStart = 0, bool enableSilentZ = true) {
  boost::shared_ptr<Model> model = modeler.getModel();
  model->initBuffers();
  model->initSilentZ(enableSilentZ);
  model->setIsInitProcess(true);
  model->init(tStart);
  model->rotateBuffers();
  model->printMessages();
  model->setIsInitProcess(false);
  boost::shared_ptr<timeline::Timeline> timeline = timeline::TimelineFactory::newInstance("timeline");
  model->setTimeline(timeline);
  return model;
}


static std::pair<boost::shared_ptr<Solver>, boost::shared_ptr<Model> > initSolverAndModel(std::string dydFileName, std::string iidmFileName,
 std::string parFileName, const double& tStart, const double& tStop) {
  boost::shared_ptr<Solver> solver = initSolver();

  // DYD
  boost::shared_ptr<DynamicData> dyd(new DynamicData());
  auto networkIIDM = boost::make_shared<powsybl::iidm::Network>(powsybl::iidm::Network::readXml(boost::filesystem::path(iidmFileName)));
  boost::shared_ptr<DataInterface> data(new DataInterfaceIIDM(networkIIDM));
  boost::dynamic_pointer_cast<DataInterfaceIIDM>(data)->initFromIIDM();
  dyd->setDataInterface(data);
  dyd->setRootDirectory(getMandatoryEnvVar("PWD"));
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
#endif
  // Model
  Modeler modeler;
  modeler.setDataInterface(data);
  modeler.setDynamicData(dyd);
  modeler.initSystem();

  boost::shared_ptr<Model> model = initModel(modeler, tStart);

  solver->init(model, tStart, tStop);

  return std::make_pair(solver, model);
}

static boost::shared_ptr<Model> initModelFromDyd(std::string dydFileName, bool enableSilentZ = true) {
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

  boost::shared_ptr<Model> model = initModel(modeler, 0, enableSilentZ);
  return model;
}

static std::pair<boost::shared_ptr<Solver>, boost::shared_ptr<Model> > initSolverAndModelWithDyd(std::string dydFileName,
 const double& tStart, const double& tStop, bool enableSilentZ = true) {
  boost::shared_ptr<Solver> solver = initSolver(enableSilentZ);
  boost::shared_ptr<Model> model = initModelFromDyd(dydFileName, enableSilentZ);
  solver->init(model, tStart, tStop);

  return std::make_pair(solver, model);
}

TEST(SimulationTest, testSolverIDATestAlpha) {
  const double tStart = 0.;
  const double tStop = 5.;
  std::pair<boost::shared_ptr<Solver>, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestAlpha.dyd", tStart, tStop);
  boost::shared_ptr<Solver> solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  ASSERT_EQ(model->sizeY(), 2);
  ASSERT_EQ(model->sizeF(), 2);
  ASSERT_EQ(model->sizeG(), 1);
  ASSERT_EQ(model->sizeZ(), 0);
  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y0[0], -2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y0[1], -1);
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
  // The event in the model is written as if (x <= 0) which means that the root is detected just after t = 2 (2 + epsilon).
  // IDA will thus stop just after t = 2 and is reinitialized (thus the next time step will be t = 3)
  ASSERT_NO_THROW(solver->reinit());
  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();

  ASSERT_EQ(solver->getState().noFlagSet(), true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[1], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[1], 0);

  ASSERT_EQ(solver->solverType(), "IDASolver");
  solver->printHeader();
  solver->printSolve();
  solver->printEnd();
}

TEST(SimulationTest, testSolverIDATestBeta) {
  const double tStart = 0.;
  const double tStop = 5.;
  std::pair<boost::shared_ptr<Solver>, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestBeta.dyd", tStart, tStop);
  boost::shared_ptr<Solver> solver = p.first;
  boost::shared_ptr<Model> model = p.second;

  solver->calculateIC(tStop);

  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeY(), 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeF(), 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeG(), 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(model->sizeZ(), 1);
  std::vector<double> y0(model->sizeY());
  std::vector<double> yp0(model->sizeY());
  std::vector<double> z0(model->sizeZ());
  model->getY0(tStart, y0, yp0);
  model->getCurrentZ(z0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y0[0], -2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp0[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z0[0], -1);

  double tCurrent = tStart;
  std::vector<double> y(y0);
  std::vector<double> yp(yp0);
  std::vector<double> z(z0);
  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  model->getCurrentZ(z);
  ASSERT_EQ(solver->getState().noFlagSet(), true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], -1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], -1);

  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  model->getCurrentZ(z);
  ASSERT_EQ(solver->getState().noFlagSet(), true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], -1);

  solver->solve(tStop, tCurrent);
  // The event in the model is written as when (x <= 0) which means that the root is detected just after t = 2 (2 + epsilon).
  // IDA will thus stop just after t = 2 but is no reinitialized thus the time step goes increasing and the next time step is at t = 4 s.
  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  model->getCurrentZ(z);
  ASSERT_EQ(solver->getState().noFlagSet(), true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 2.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 1);
}

TEST(SimulationTest, testSolverIDAAlgebraicMode) {
  const double tStart = 0.;
  const double tStop = 3.;
  std::pair<boost::shared_ptr<Solver>, boost::shared_ptr<Model> > p = initSolverAndModel("jobs/solverTestDelta.dyd",
  "jobs/solverTestDelta.iidm", "jobs/solverTestDelta.par", tStart, tStop);
  boost::shared_ptr<Solver> solver = p.first;
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
  model->getCurrentZ(z);
  ASSERT_EQ(solver->getState().noFlagSet(), true);
  // Checking the voltage values at extreme nodes - Infinite node and F21 bus
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[2], 0.94766640118361411549);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[3], -0.09225375878818535547);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[12], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[13], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[9], 0.95214618832553821193);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tCurrent, 1.);
  for (size_t i = 0; i < z.size(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(z[i], z0[i]);
  }
  model->getCurrentZ(z);
  for (size_t i = 0; i < z.size(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(z[i], z0[i]);
  }

  // Algebraic mode detection - line opening in the network
  solver->solve(tStop, tCurrent);
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  ASSERT_EQ(solver->getState().getFlags(NotSilentZChange), true);
  ASSERT_EQ(solver->getState().getFlags(ModeChange), true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[2], 0.94766640118361411549);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[3], -0.09225375878818535547);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[12], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[13], 1);
  ASSERT_EQ(model->getModeChangeType(), ALGEBRAIC_J_UPDATE_MODE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[9], 0.95214618832553821193);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tCurrent, 1.0000002);
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

  // Algebraic equations restoration
  solver->reinit();
  y = solver->getCurrentY();
  yp = solver->getCurrentYP();
  model->getCurrentZ(z);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[2], 0.92684239292330972138);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[3], -0.12083482860045162421);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[12], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[13], 1);
  ASSERT_EQ(model->getModeChangeType(), NO_MODE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[9], 0.93468597466729808065);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tCurrent, 1.0000002);
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
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[2], 0.92684239374639887377);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[3], -0.12083482837234209295);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[12], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[13], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[9], 0.93468597860101021446);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tCurrent, 2.);
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

TEST(SimulationTest, testSolverIDASilentZ) {
  const double tStart = 0.;
  const double tStop = 10.;
  std::pair<boost::shared_ptr<Solver>, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestSilentZ.dyd",
                                                                                                tStart, tStop);
  boost::shared_ptr<Solver> solver = p.first;
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
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_TRUE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  // Solve at t = 5 -> z1 and z2 are modified
  solver->solve(tStop, tCurrent);
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_TRUE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
}

TEST(SimulationTest, testSolverIDASilentZDisabled) {
  const double tStart = 0.;
  const double tStop = 10.;
  std::pair<boost::shared_ptr<Solver>, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestSilentZ.dyd",
                                                                                                tStart, tStop, false);
  boost::shared_ptr<Solver> solver = p.first;
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
  // Solve at t = 2 => z1 is modified
  solver->solve(tStop, tCurrent);
  ASSERT_TRUE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  // Solve at t = 3
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  // Solve at t = 4 -> z2 is modified
  solver->solve(tStop, tCurrent);
  ASSERT_TRUE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  // Solve at t = 4
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
  // Solve at t = 5 -> z1 and z2 are modified
  solver->solve(tStop, tCurrent);
  ASSERT_TRUE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
}

TEST(SimulationTest, testSolverIDASilentZNotUsedInContinuous) {
  const double tStart = 0.;
  const double tStop = 10.;
  std::pair<boost::shared_ptr<Solver>, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestSilentZNotUsedInContinuous.dyd",
                                                                                                tStart, tStop);
  boost::shared_ptr<Solver> solver = p.first;
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
  // Solve at t = 4 => zNotUsedInContinuous and zNotUsedInDiscrete are modified
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_TRUE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_TRUE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
}

TEST(SimulationTest, testSolverIDASilentZNotUsedInContinuousDisabled) {
  const double tStart = 0.;
  const double tStop = 10.;
  std::pair<boost::shared_ptr<Solver>, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestSilentZNotUsedInContinuous.dyd",
                                                                                                tStart, tStop, false);
  boost::shared_ptr<Solver> solver = p.first;
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
  // Solve at t = 4 => zNotUsedInContinuous and zNotUsedInDiscrete are modified
  solver->solve(tStop, tCurrent);
  ASSERT_TRUE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
}

TEST(SimulationTest, testSolverIDASilentZNotUsedInContinuous2) {
  const double tStart = 0.;
  const double tStop = 10.;
  std::pair<boost::shared_ptr<Solver>, boost::shared_ptr<Model> > p = initSolverAndModelWithDyd("jobs/solverTestSilentZNotUsedInContinuous2.dyd",
                                                                                                tStart, tStop);
  boost::shared_ptr<Solver> solver = p.first;
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
  // Solve at t = 2
  solver->solve(tStop, tCurrent);
  ASSERT_FALSE(solver->getState().getFlags(NotSilentZChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInDiscreteEqChange));
  ASSERT_FALSE(solver->getState().getFlags(SilentZNotUsedInContinuousEqChange));
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

TEST(SimulationTest, testSolverIDAInit) {
  boost::shared_ptr<Solver> solver = SolverFactory::createSolverFromLib("../dynawo_SolverIDA" + std::string(sharedLibraryExtension()));
  boost::shared_ptr<Model> model = initModelFromDyd("jobs/solverTestAlpha.dyd");

  // IDASVtolerances
  boost::shared_ptr<parameters::ParametersSet> params = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("MySolverParam"));
  params->addParameter(parameters::ParameterFactory::newParameter("order", 2));
  params->addParameter(parameters::ParameterFactory::newParameter("initStep", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("minStep", 1.));
  params->addParameter(parameters::ParameterFactory::newParameter("maxStep", 10.));
  params->addParameter(parameters::ParameterFactory::newParameter("absAccuracy", 1e-4));
  params->addParameter(parameters::ParameterFactory::newParameter("relAccuracy", -1.));
  solver->setParameters(params);
  ASSERT_THROW_DYNAWO(solver->init(model, 0, 0), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorIDA);

  // IDASetMinStep
  boost::shared_ptr<parameters::ParametersSet> params2 = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("MySolverParam"));
  params2->addParameter(parameters::ParameterFactory::newParameter("order", 2));
  params2->addParameter(parameters::ParameterFactory::newParameter("initStep", 1.));
  params2->addParameter(parameters::ParameterFactory::newParameter("minStep", -1.));
  params2->addParameter(parameters::ParameterFactory::newParameter("maxStep", 10.));
  params2->addParameter(parameters::ParameterFactory::newParameter("absAccuracy", 1e-4));
  params2->addParameter(parameters::ParameterFactory::newParameter("relAccuracy", 1.));
  solver->setParameters(params2);
  ASSERT_THROW_DYNAWO(solver->init(model, 0, 0), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorIDA);

  // IDASetMaxStep
  boost::shared_ptr<parameters::ParametersSet> params3 = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("MySolverParam"));
  params3->addParameter(parameters::ParameterFactory::newParameter("order", 2));
  params3->addParameter(parameters::ParameterFactory::newParameter("initStep", 1.));
  params3->addParameter(parameters::ParameterFactory::newParameter("minStep", 1.));
  params3->addParameter(parameters::ParameterFactory::newParameter("maxStep", -10.));
  params3->addParameter(parameters::ParameterFactory::newParameter("absAccuracy", 1e-4));
  params3->addParameter(parameters::ParameterFactory::newParameter("relAccuracy", 1.));
  solver->setParameters(params3);
  ASSERT_THROW_DYNAWO(solver->init(model, 0, 0), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorIDA);

  // IDASetMaxOrder
  boost::shared_ptr<parameters::ParametersSet> params4 = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("MySolverParam"));
  params4->addParameter(parameters::ParameterFactory::newParameter("order", -2));
  params4->addParameter(parameters::ParameterFactory::newParameter("initStep", 1.));
  params4->addParameter(parameters::ParameterFactory::newParameter("minStep", 1.));
  params4->addParameter(parameters::ParameterFactory::newParameter("maxStep", 10.));
  params4->addParameter(parameters::ParameterFactory::newParameter("absAccuracy", 1e-4));
  params4->addParameter(parameters::ParameterFactory::newParameter("relAccuracy", 1.));
  solver->setParameters(params4);
  ASSERT_THROW_DYNAWO(solver->init(model, 0, 0), Error::SUNDIALS_ERROR, KeyError_t::SolverFuncErrorIDA);
}

}  // namespace DYN
