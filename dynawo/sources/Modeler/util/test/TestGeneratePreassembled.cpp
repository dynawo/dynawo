//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

#include <boost/algorithm/string.hpp>

#include "DYNCommon.h"
#include "DYNExecUtils.h"
#include "DYNFileSystemUtils.h"
#include "gtest_dynawo.h"

namespace DYN {

TEST(ModelerUtil, TestGeneratePreassembled) {
  std::string cmd = "../generate-preassembled";
  std::stringstream ss;
  executeCommand(cmd, ss);
  std::string result = ss.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : ../generate-preassembled Default BDD Models Directory is used. "
      "You need to give a model list.  -h [ --help ]                         "
      "produce help message  --model-list arg                      "
      "set model list file (required)  --use-standard-precompiled-models arg use standard precompiled models                                         "
      "(default true)  --recursive-precompiled-models-dir arg                                        "
      "set precompiled models directory                                         "
      "(default DYNAWO_DDB_DIR)  --non-recursive-precompiled-models-dir arg                                        "
      "set precompiled models directory                                         "
      "(default DYNAWO_DDB_DIR)  --use-standard-modelica-models arg    use standard Modelica models (default                                         "
      "true)  --recursive-modelica-models-dir arg   set Modelica models directory (default                                         "
      "DYNAWO_DDB_DIR)  --non-recursive-modelica-models-dir arg                                        "
      "set Modelica models directory (default                                         DYNAWO_DDB_DIR)  --modelica-models-extension arg       "
      "set Modelica models file extension                                         (default .mo)  --output-dir arg                      "
      "set output directory (default: current                                         directory)  --remove-model-files arg              "
      "if true the .mo input files will be                                         deleted (default: false)  --additional-header-files arg         "
      "list of headers that should be included                                        in the dynamic model files");

  remove("Test/Test"+std::string(sharedLibraryExtension()));
  remove("Test/Test.extvar");
  cmd = "../generate-preassembled --model-list res/Test.xml";
  executeCommand(cmd, ss);
  ASSERT_TRUE(exists("Test/Test"+std::string(sharedLibraryExtension())));
  ASSERT_TRUE(exists("Test/Test.extvar"));
  std::stringstream ssDiff;
  executeCommand("diff res/Test.extvar res/Test.extvar", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff res/Test.extvar res/Test.extvar\n");
  ss.str(std::string());
}


}  // namespace DYN
