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
  Compiler cf = Compiler(dyd, preCompiledUseStandardModels,
            precompiledModelsDirsAbsolute,
            preCompiledModelsExtension,
            modelicaUseStandardModels,
            modelicaModelsDirsAbsolute,
            modelicaModelsExtension,
            additionalHeaderFiles,
            rmModels,
            getEnvVar("PWD"));
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
  std::string ddb_dir = getEnvVar("DYNAWO_HOME") + "/dynawo/sources/Models/Modelica/Dynawo";
  setenv("DYNAWO_DDB_DIR", ddb_dir.c_str(), 0);

  std::vector <UserDefinedDirectory> modelicaModelsDirsAbsolute;
  std::string modelicaModelsExtension = ".mo";
  std::vector<std::string> additionalHeaderFiles;

  const bool rmModels = true;
  Compiler cf = Compiler(dyd, preCompiledUseStandardModels,
            precompiledModelsDirsAbsolute,
            preCompiledModelsExtension,
            modelicaUseStandardModels,
            modelicaModelsDirsAbsolute,
            modelicaModelsExtension,
            additionalHeaderFiles,
            rmModels,
            getEnvVar("PWD"));
  ASSERT_NO_THROW(cf.compile());
  cf.concatConnects();


  // Model
  Modeler modeler;
  modeler.setDynamicData(dyd);
  ASSERT_THROW_DYNAWO(modeler.initSystem(), Error::MODELER, KeyError_t::FlowConnectionMixedSystemAndInternal);
}

}  // namespace DYN
