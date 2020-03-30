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
 * @file API/JOB/test/TestXmlImporter.cpp
 * @brief Unit tests for API_JOB/JOBXmlImporterclass
 *
 */

#include "gtest_dynawo.h"
#include "JOBXmlImporter.h"
#include "JOBJobsCollection.h"
#include "JOBJobEntry.h"
#include "JOBIterators.h"
#include "JOBSolverEntry.h"
#include "JOBModelerEntry.h"
#include "JOBNetworkEntry.h"
#include "JOBInitialStateEntry.h"
#include "JOBDynModelsEntry.h"
#include "JOBSimulationEntry.h"
#include "JOBOutputsEntry.h"
#include "JOBInitValuesEntry.h"
#include "JOBConstraintsEntry.h"
#include "JOBTimelineEntry.h"
#include "JOBFinalStateEntry.h"
#include "JOBCurvesEntry.h"
#include "JOBLogsEntry.h"
#include "JOBAppenderEntry.h"
#include "JOBModelsDirEntry.h"

namespace job {

TEST(APIJOBTest, testXmlImporterMissingFile) {
  XmlImporter importer;
  boost::shared_ptr<JobsCollection> jobs;
  ASSERT_THROW_DYNAWO(jobs = importer.importFromFile("res/dummmyFile.jobs"), DYN::Error::API, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

TEST(APIJOBTest, testXmlWrongFile) {
  XmlImporter importer;
  boost::shared_ptr<JobsCollection> jobs;
  ASSERT_THROW_DYNAWO(jobs = importer.importFromFile("res/wrongFile.jobs"), DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
}

TEST(APIJOBTest, testXmlWrongStream) {
  XmlImporter importer;
  std::istringstream badInputStream("hello");
  std::istream badStream(badInputStream.rdbuf());
  ASSERT_THROW_DYNAWO(importer.importFromStream(badStream), DYN::Error::API, DYN::KeyError_t::XmlParsingError);
}

TEST(APIJOBTest, testXmlStreamImporter) {
  XmlImporter importer;
  std::istringstream goodInputStream(
    "<?xml version='1.0' encoding='UTF-8'?>"
    "<dyn:jobs xmlns:dyn=\"http://www.rte-france.com/dynawo\">"
    "<dyn:job name=\"100 nodes with final dump\">"
    "<!-- Simulation using simplified solver - final dump-->"
    "<dyn:solver lib=\"libdynawo_SolverSIM\" parFile=\"../solvers.par\" parId=\"3\"/>"
    "<dyn:modeler compileDir=\"outputs/dump/compilation\">"
    "<dyn:network iidmFile=\"../baseCase/100n.iidm\" parFile=\"../BDD/DYNModelNetwork.par\" parId=\"1\"/>"
    "<dyn:dynModels dydFile=\"dydFile_dump.dyd\"/>"
    "<dyn:dynModels dydFile=\"../../DDB/Generators.dyd\"/>"
    "<dyn:initialState file=\"outputs/dump/finalState/outputState.dmp\"/>"
    "<dyn:precompiledModels useStandardModels=\"true\">"
    "<dyn:directory path=\".\" recursive=\"false\"/>"
    "<dyn:directory path=\"/tmp/\" recursive=\"true\"/>"
    "</dyn:precompiledModels>"
    "<dyn:modelicaModels useStandardModels=\"true\" modelExtension=\".mo\">"
    "<dyn:directory path=\"/tmp1/\" recursive=\"false\"/>"
    "<dyn:directory path=\"/tmp2/\" recursive=\"true\"/>"
    "</dyn:modelicaModels>"
    "</dyn:modeler>"
    "<dyn:simulation startTime=\"10\" stopTime=\"200\"/>"
    "<dyn:outputs directory=\"outputs/dump\">"
    "<dyn:finalState exportDumpFile=\"true\" exportIIDMFile=\"true\"/>"
    "<dyn:curves inputFile=\"curves_dump.crv\" exportMode=\"CSV\"/>"
    "<dyn:timeline exportMode=\"TXT\"/>"
    "<dyn:constraints exportMode=\"XML\"/>"
    "<dyn:dumpInitValues local=\"true\" global=\"false\"/>"
    "<dyn:logs>"
    "<dyn:appender tag=\"\" file=\"dynawo.log\" lvlFilter=\"DEBUG\" separator=\"-\" showLevelTag=\"false\" timeStampFormat=\"%H:%M:%S\"/>"
    "<dyn:appender tag=\"COMPILE\" file=\"dynawoCompiler.log\" lvlFilter=\"INFO\"/>"
    "<dyn:appender tag=\"NETWORK\" file=\"dynawoNetwork.log\" lvlFilter=\"DEBUG\"/>"
    "<dyn:appender tag=\"MODELER\" file=\"dynawoModeler.log\" lvlFilter=\"ERROR\"/>"
    "</dyn:logs>"
    "</dyn:outputs>"
    "</dyn:job>"
    "</dyn:jobs>");
  std::istream goodStream(goodInputStream.rdbuf());
  ASSERT_NO_THROW(importer.importFromStream(goodStream));
}

TEST(APIJOBTest, testXmlImporter) {
  XmlImporter importer;
  boost::shared_ptr<JobsCollection> jobsCollection;
  jobsCollection = importer.importFromFile("res/jobsExample.jobs");

  // check read data
  int nbJobs = 0;
  boost::shared_ptr<JobEntry> job1;
  boost::shared_ptr<JobEntry> job2;
  for (job_const_iterator itJob = jobsCollection->cbegin();
          itJob != jobsCollection->cend();
          ++itJob) {
    ++nbJobs;
    if (nbJobs == 1)
      job1 = (*itJob);
    else
      job2 = (*itJob);
  }
  ASSERT_EQ(nbJobs, 2);

  // check name of each job to see if the two jobs are correctly read
  ASSERT_EQ(job1->getName(), "Job 1");
  ASSERT_EQ(job2->getName(), "Job 2");

  // check each input of the first job (most complete job)

  // ===== SolverEntry =====
  ASSERT_NE(job1->getSolverEntry(), boost::shared_ptr<SolverEntry>());
  boost::shared_ptr<SolverEntry> solver =  job1->getSolverEntry();
  ASSERT_EQ(solver->getLib(), "libdynawo_SolverSIM");
  ASSERT_EQ(solver->getParametersFile(), "solvers.par");
  ASSERT_EQ(solver->getParametersId(), "3");

  // ===== ModelerEntry =====
  ASSERT_NE(job1->getModelerEntry(), boost::shared_ptr<ModelerEntry>());
  boost::shared_ptr<ModelerEntry> modeler = job1->getModelerEntry();
  ASSERT_EQ(modeler->getCompileDir(), "outputs1");

  ASSERT_NE(modeler->getPreCompiledModelsDirEntry(), boost::shared_ptr<ModelsDirEntry>());
  boost::shared_ptr<ModelsDirEntry> preCompiledModelsDirEntry = modeler->getPreCompiledModelsDirEntry();
  ASSERT_EQ(preCompiledModelsDirEntry->getUseStandardModels(), true);
  ASSERT_EQ(preCompiledModelsDirEntry->getDirectories().size(), 2);
  std::vector <UserDefinedDirectory> precompiledModelsDirs = preCompiledModelsDirEntry->getDirectories();
  ASSERT_EQ(precompiledModelsDirs[0].path, ".");
  ASSERT_EQ(precompiledModelsDirs[0].isRecursive, false);
  ASSERT_EQ(precompiledModelsDirs[1].path, "/tmp/");
  ASSERT_EQ(precompiledModelsDirs[1].isRecursive, true);

  ASSERT_NE(modeler->getModelicaModelsDirEntry(), boost::shared_ptr<ModelsDirEntry>());
  boost::shared_ptr<ModelsDirEntry> modelicaModelsDirEntry = modeler->getModelicaModelsDirEntry();
  ASSERT_EQ(modelicaModelsDirEntry->getUseStandardModels(), true);
  ASSERT_EQ(modelicaModelsDirEntry->getDirectories().size(), 2);
  std::vector <UserDefinedDirectory> modelicaModelsDirs = modelicaModelsDirEntry->getDirectories();
  ASSERT_EQ(modelicaModelsDirs[0].path, "/tmp1/");
  ASSERT_EQ(modelicaModelsDirs[0].isRecursive, false);
  ASSERT_EQ(modelicaModelsDirs[1].path, "/tmp2/");
  ASSERT_EQ(modelicaModelsDirs[1].isRecursive, true);
  ASSERT_EQ(modelicaModelsDirEntry->getModelExtension(), ".mo");

  ASSERT_NE(modeler->getNetworkEntry(), boost::shared_ptr<NetworkEntry>());
  boost::shared_ptr<NetworkEntry> network = modeler->getNetworkEntry();
  ASSERT_EQ(network->getIidmFile(), "myIIDM.iidm");
  ASSERT_EQ(network->getNetworkParFile(), "myPAR.par");
  ASSERT_EQ(network->getNetworkParId(), "1");

  ASSERT_NE(modeler->getInitialStateEntry(), boost::shared_ptr<InitialStateEntry>());
  boost::shared_ptr<InitialStateEntry> initialState = modeler->getInitialStateEntry();
  ASSERT_EQ(initialState->getInitialStateFile(), "outputs1/finalState/outputState.dmp");

  ASSERT_EQ(modeler->getDynModelsEntries().size(), 2);
  std::vector<boost::shared_ptr<DynModelsEntry> > dynModelsEntries = modeler->getDynModelsEntries();
  ASSERT_EQ(dynModelsEntries[0]->getDydFile(), "myDYD.dyd");
  ASSERT_EQ(dynModelsEntries[1]->getDydFile(), "myDYD2.dyd");

  // ===== SimulationEntry =====
  ASSERT_NE(job1->getSimulationEntry(), boost::shared_ptr<SimulationEntry>());
  boost::shared_ptr<SimulationEntry> simulation =  job1->getSimulationEntry();
  ASSERT_EQ(simulation->getStartTime(), 10);
  ASSERT_EQ(simulation->getStopTime(), 200);
  ASSERT_EQ(simulation->getCriteriaFiles().size(), 2);
  ASSERT_TRUE(std::find(simulation->getCriteriaFiles().begin(),
      simulation->getCriteriaFiles().end(), "myCriteriaFile.crt") != simulation->getCriteriaFiles().end());
  ASSERT_TRUE(std::find(simulation->getCriteriaFiles().begin(),
      simulation->getCriteriaFiles().end(), "myCriteriaFile2.crt") != simulation->getCriteriaFiles().end());
  ASSERT_EQ(simulation->getCriteriaStep(), 5);

  // ===== OutputsEntry =====
  ASSERT_NE(job1->getOutputsEntry(), boost::shared_ptr<OutputsEntry>());
  boost::shared_ptr<OutputsEntry> outputs =  job1->getOutputsEntry();
  ASSERT_EQ(outputs->getOutputsDirectory(), "outputs1");

  // ===== InitValuesEntry =====
  ASSERT_NE(outputs->getInitValuesEntry(), boost::shared_ptr<InitValuesEntry>());
  boost::shared_ptr<InitValuesEntry> initValues = outputs->getInitValuesEntry();
  ASSERT_EQ(initValues->getDumpLocalInitValues(), true);
  ASSERT_EQ(initValues->getDumpGlobalInitValues(), false);

  // ===== ConstraintsEntry =====
  ASSERT_NE(outputs->getConstraintsEntry(), boost::shared_ptr<ConstraintsEntry>());
  boost::shared_ptr<ConstraintsEntry> constraints = outputs->getConstraintsEntry();
  ASSERT_EQ(constraints->getExportMode(), "XML");

  // ===== TimelineEntry =====
  ASSERT_NE(outputs->getTimelineEntry(), boost::shared_ptr<TimelineEntry>());
  boost::shared_ptr<TimelineEntry> timeline = outputs->getTimelineEntry();
  ASSERT_EQ(timeline->getExportMode(), "TXT");

  // ===== FinalStateEntry =====
  ASSERT_NE(outputs->getFinalStateEntry(), boost::shared_ptr<FinalStateEntry>());
  boost::shared_ptr<FinalStateEntry> finalState = outputs->getFinalStateEntry();
  ASSERT_EQ(finalState->getExportIIDMFile(), true);
  ASSERT_EQ(finalState->getExportDumpFile(), true);

  // ===== CurvesEntry =====
  ASSERT_NE(outputs->getCurvesEntry(), boost::shared_ptr<CurvesEntry>());
  boost::shared_ptr<CurvesEntry> curves = outputs->getCurvesEntry();
  ASSERT_EQ(curves->getExportMode(), "CSV");
  ASSERT_EQ(curves->getInputFile(), "curves.crv");

  // ===== LogsEntry =====
  ASSERT_NE(outputs->getLogsEntry(), boost::shared_ptr<LogsEntry>());
  boost::shared_ptr<LogsEntry> logs = outputs->getLogsEntry();
  ASSERT_EQ(logs->getAppenderEntries().size(), 4);
  std::vector<boost::shared_ptr<AppenderEntry> > appenders = logs->getAppenderEntries();

  ASSERT_EQ(appenders[0]->getShowLevelTag(), false);
  ASSERT_EQ(appenders[0]->getSeparator(), "-");
  ASSERT_EQ(appenders[0]->getTimeStampFormat(), "%H:%M:%S");
  ASSERT_EQ(appenders[0]->getTag(), "");
  ASSERT_EQ(appenders[0]->getLvlFilter(), "DEBUG");
  ASSERT_EQ(appenders[0]->getFilePath(), "dynawo.log");

  ASSERT_EQ(appenders[1]->getShowLevelTag(), true);
  ASSERT_EQ(appenders[1]->getSeparator(), " | ");
  ASSERT_EQ(appenders[1]->getTimeStampFormat(), "%Y-%m-%d %H:%M:%S");
  ASSERT_EQ(appenders[1]->getTag(), "COMPILE");
  ASSERT_EQ(appenders[1]->getLvlFilter(), "INFO");
  ASSERT_EQ(appenders[1]->getFilePath(), "dynawoCompiler.log");

  ASSERT_EQ(appenders[2]->getShowLevelTag(), true);
  ASSERT_EQ(appenders[2]->getSeparator(), " | ");
  ASSERT_EQ(appenders[2]->getTimeStampFormat(), "%Y-%m-%d %H:%M:%S");
  ASSERT_EQ(appenders[2]->getTag(), "NETWORK");
  ASSERT_EQ(appenders[2]->getLvlFilter(), "DEBUG");
  ASSERT_EQ(appenders[2]->getFilePath(), "dynawoNetwork.log");

  ASSERT_EQ(appenders[3]->getShowLevelTag(), true);
  ASSERT_EQ(appenders[3]->getSeparator(), " | ");
  ASSERT_EQ(appenders[3]->getTimeStampFormat(), "%Y-%m-%d %H:%M:%S");
  ASSERT_EQ(appenders[3]->getTag(), "MODELER");
  ASSERT_EQ(appenders[3]->getLvlFilter(), "ERROR");
  ASSERT_EQ(appenders[3]->getFilePath(), "dynawoModeler.log");
}

}  // namespace job
