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
#include "DYNFileSystemUtils.h"
#include "gtest_dynawo.h"

namespace DYN {

TEST(Models, TestBuildCheckSum) {
  std::string pythonCmd = "python";
  if (hasEnvVar("DYNAWO_PYTHON_COMMAND"))
    pythonCmd = getEnvVar("DYNAWO_PYTHON_COMMAND");
  std::string cmd = pythonCmd + " validateDictionaries.py";
  std::stringstream ssPython;
  executeCommand(cmd, ssPython);
  std::string result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : "+cmd+"Usage:  usage: validateDictionaries.py "
      "--inputDir=<directories> --outputDir=<directory> [--namespace=<namespace>] [--modelicaDir=<directory> --modelicaPackage=<packageName>]    "
      "Script generates keys.h and keys.cpp of inputDir files in outputDir    Generates keys.mo files in modelicaDir    "
      "If everything is ok, generates header associated with all kind of dictionary    validateDictionaries.py: "
      "error: Input directory should be informed");
  ssPython.str(std::string());

  cmd = pythonCmd + " validateDictionaries.py --inputDir dic/";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : "+cmd+"Usage:  usage: validateDictionaries.py "
      "--inputDir=<directories> --outputDir=<directory> [--namespace=<namespace>] [--modelicaDir=<directory> --modelicaPackage=<packageName>]    "
      "Script generates keys.h and keys.cpp of inputDir files in outputDir    Generates keys.mo files in modelicaDir    "
      "If everything is ok, generates header associated with all kind of dictionary    validateDictionaries.py: "
      "error: Output directory should be informed");
  ssPython.str(std::string());

  cmd = pythonCmd + " validateDictionaries.py --inputDir dic/ --outputDir dic/ --modelicaDir dic/ --modelicaPackage myPackage --namespace MyNS";
  executeCommand(cmd, ssPython);
  ssPython.str(std::string());
  ASSERT_TRUE(exists("dic/MyDic_keys.cpp"));
  ASSERT_TRUE(exists("dic/MyDic_keys.h"));
  ASSERT_TRUE(exists("dic/icKeys.mo"));
  std::stringstream ssDiff;
  executeCommand("diff dic/MyDic_keys.cpp dic/MyDic_keys_ref.cpp", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff dic/MyDic_keys.cpp dic/MyDic_keys_ref.cpp\n");
  ssDiff.str(std::string());
  executeCommand("diff dic/MyDic_keys.h dic/MyDic_keys_ref.h", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff dic/MyDic_keys.h dic/MyDic_keys_ref.h\n");
  ssDiff.str(std::string());
  executeCommand("diff dic/icKeys.mo dic/icKeys_ref.mo", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff dic/icKeys.mo dic/icKeys_ref.mo\n");
  ssDiff.str(std::string());
}


}  // namespace DYN
