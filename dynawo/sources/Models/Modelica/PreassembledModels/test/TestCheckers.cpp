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

#include <boost/algorithm/string.hpp>

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
  std::string result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : "+cmd+"Usage:  Usage: buildChecker.py <preassembled-model>    Script checking if the preassembled-model file is well built.    Some implicit rules must be verified before launching the build of the    preassembled model    Return an error if theses rules are not verified    buildChecker.py: error: Incorrect args number");
  ssPython.str(std::string());

  cmd = pythonCmd + " buildChecker.py res/preassembled_ok.xml";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd + "");
  ssPython.str(std::string());

  cmd = pythonCmd + " buildChecker.py res/preassembled_ko.xml";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : "+ cmd+ "ERROR : res/preassembled_ko.xml is not well built         file name and preassembled model id must be equal         file name =preassembled_ko         preassembled model id =preassembled_ok");
}


}  // namespace DYN
