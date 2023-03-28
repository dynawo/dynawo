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

#include "gtest_dynawo.h"
#include "DYNCommon.h"
#include "DYNFileSystemUtils.h"
#include "DYNExecUtils.h"
#include "DYNCompiler.h"
#include "DYNModeler.h"
#include "DYNDynamicData.h"
#include "DYNMacrosMessage.h"

INIT_XML_DYNAWO;

namespace DYN {

TEST(CompilerTest, testMissingModelicaFile) {
  boost::shared_ptr<DynamicData> dyd(new DynamicData());
  std::vector <std::string> fileNames;
  fileNames.push_back("jobs/solverTestDelta.dyd");
  dyd->initFromDydFiles(fileNames);
  bool preCompiledUseStandardModels = false;
  std::vector <UserDefinedDirectory> precompiledModelsDirsAbsolute;
  std::string preCompiledModelsExtension = sharedLibraryExtension();
  bool modelicaUseStandardModels = false;

  std::vector <UserDefinedDirectory> modelicaModelsDirsAbsolute;
  std::string modelicaModelsExtension = ".mo";
  std::vector<std::string> additionalHeaderFiles;

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
            getMandatoryEnvVar("PWD"));
  ASSERT_THROW_DYNAWO(cf.compile(), Error::MODELER, KeyError_t::UnknownModelFile);
}

TEST(CompilerTest, testFlowConnectionWithinAndOutsideModelicaModel) {
  boost::shared_ptr<DynamicData> dyd(new DynamicData());
  std::vector <std::string> fileNames;
  fileNames.push_back("jobs/testFlowConnections.dyd");
  dyd->initFromDydFiles(fileNames);
  bool preCompiledUseStandardModels = true;
  std::vector <UserDefinedDirectory> precompiledModelsDirsAbsolute;
  std::string preCompiledModelsExtension = sharedLibraryExtension();
  bool modelicaUseStandardModels = true;
  std::string ddb_dir = getMandatoryEnvVar("DYNAWO_HOME") + "/dynawo/sources/Models/Modelica/Dynawo";
#ifndef _MSC_VER
  setenv("DYNAWO_DDB_DIR", ddb_dir.c_str(), 0);
#else
  _putenv_s("DYNAWO_DDB_DIR", ddb_dir.c_str());
#endif
  std::vector <UserDefinedDirectory> modelicaModelsDirsAbsolute;
  std::string modelicaModelsExtension = ".mo";
  std::vector<std::string> additionalHeaderFiles;

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
            getMandatoryEnvVar("PWD"));
  ASSERT_NO_THROW(cf.compile());
  cf.concatConnects();


  // Model
  Modeler modeler;
  modeler.setDynamicData(dyd);
  ASSERT_THROW_DYNAWO(modeler.initSystem(), Error::MODELER, KeyError_t::FlowConnectionMixedSystemAndInternal);
}

TEST(CompilerTest, testReferenceToAnotherReference) {
  std::vector<std::string> testFileNames = {"jobs/testReferenceToAnotherReference1.dyd",
                                              "jobs/testReferenceToAnotherReference2.dyd",
                                              "jobs/testReferenceToAnotherReference3.dyd"};
  for (std::string testFileName : testFileNames) {
    boost::shared_ptr<DynamicData> dyd(new DynamicData());
    std::vector <std::string> fileNames;
    fileNames.push_back(testFileName);
    ASSERT_THROW_DYNAWO(dyd->initFromDydFiles(fileNames), Error::API, KeyError_t::ReferenceToAnotherReference);
  }
}

}  // namespace DYN
