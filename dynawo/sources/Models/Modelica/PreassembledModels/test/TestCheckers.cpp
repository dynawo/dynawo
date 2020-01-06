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

#include "DYNExecUtils.h"
#include "gtest_dynawo.h"

namespace DYN {

TEST(ModelsModelicaPreassembled, TestBuildChecker) {
  std::string pythonCmd = "python";
  if (hasEnvVar("DYNAWO_PYTHON_COMMAND"))
    pythonCmd = getEnvVar("DYNAWO_PYTHON_COMMAND");
  std::string cmd = pythonCmd + " buildChecker.py";
  std::stringstream ssPython;
  executeCommand(cmd, ssPython);
  ASSERT_EQ(ssPython.str(), "Executing command : "+cmd+"\nUsage:  Usage: buildChecker.py <preassembled-model>\n\n    Script checking if the preassembled-model fils is well built.\n    Some implicit rules must be verify before launching the built of the\n    preassembled model\n\n    Return an error if theses rules are not verified\n    \n\nbuildChecker.py: error: Incorrect args number\n\n");
  ssPython.str(std::string());

  cmd = pythonCmd + " buildChecker.py res/preassembled_ok.xml";
  executeCommand(cmd, ssPython);
  ASSERT_EQ(ssPython.str(), "Executing command : " + cmd + "\n");
  ssPython.str(std::string());

  cmd = pythonCmd + " buildChecker.py res/preassembled_ko.xml";
  executeCommand(cmd, ssPython);
  ASSERT_EQ(ssPython.str(), "Executing command : "+ cmd+ "\nERROR : res/preassembled_ko.xml is not well build\n         file name and preassembled model id must be equal\n         file name =preassembled_ko\n         preassembled model id =preassembled_ok\n\n");
}


}  // namespace DYN
