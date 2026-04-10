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

#include "DYNExecUtils.h"
#include "DYNFileSystemUtils.h"
#include "gtest_dynawo.h"

namespace DYN {

TEST(Models, TestBuildCheckSum) {
  std::string pythonCmd = "python";
  if (hasEnvVar("DYNAWO_PYTHON_COMMAND"))
    pythonCmd = getEnvVar("DYNAWO_PYTHON_COMMAND");
  std::string cmd = pythonCmd + " checkSum_ModelsCPP.py";
  std::stringstream ssPython;
  executeCommand(cmd, ssPython);
  std::string result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : "+cmd+"Usage: checkSum_ModelsCPP.py [options]checkSum_ModelsCPP.py: error: Model name is not given");
  ssPython.str(std::string());

  cmd = pythonCmd + " checkSum_ModelsCPP.py --model res/MyModelMissingFile";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd + "Error : res/MyModelMissingFile.h does not exist");
  ssPython.str(std::string());

  remove("res/MyModelOK.hpp");
  cmd = pythonCmd + " checkSum_ModelsCPP.py --model res/MyModelOK";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd + "");
  ssPython.str(std::string());
  ASSERT_TRUE(exists("res/MyModelOK.hpp"));
  std::stringstream ssDiff;
  executeCommand("diff res/MyModelOK.hpp.ref res/MyModelOK.hpp", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff res/MyModelOK.hpp.ref res/MyModelOK.hpp\n");
  ssDiff.str(std::string());

  cmd = pythonCmd + " checkSum_ModelsCPP.py --model res/MyModelKO";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd + "Error : res/MyModelKO.hpp.in is not well-formatted, '_CHECKSUM_' is not in file");
  ssPython.str(std::string());

  cmd = pythonCmd + " checkSum_ModelsCPP.py --model res/MyModelOKHppAlreadyExist";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd + "File res/MyModelOKHppAlreadyExist.hpp already exist. It will not be regenerated.");
  ssPython.str(std::string());
  executeCommand("diff res/MyModelOKHppAlreadyExist.hpp.ref res/MyModelOKHppAlreadyExist.hpp", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff res/MyModelOKHppAlreadyExist.hpp.ref res/MyModelOKHppAlreadyExist.hpp\n");
  ssDiff.str(std::string());

  cmd = pythonCmd + " checkSum_ModelsCPP.py --model res/MyModelKOHppBadlyFormed";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd + "");
  ssPython.str(std::string());
  executeCommand("diff res/MyModelOK.hpp.ref res/MyModelKOHppBadlyFormed.hpp", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff res/MyModelOK.hpp.ref res/MyModelKOHppBadlyFormed.hpp\n");
  ssDiff.str(std::string());
}


}  // namespace DYN
