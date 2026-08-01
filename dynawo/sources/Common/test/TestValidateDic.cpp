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
  std::string cmd = pythonCmd + " validateDictionaries.py";
  std::stringstream ssPython;
  executeCommand(cmd, ssPython);
  std::string result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd + "Usage: validateDictionaries.py "
    "--inputDir=<directories> [--outputDir=<directory> [--namespace=<namespace>] [--existingKeysDir=<directories>]] "
    "[--modelicaDir=<directory> --modelicaPackage=<packageName>]"
    "    Script checks integrity of all dictionaries in inputDir."
    "    If check is ok, it generates keys.h and keys.cpp files in outputDir and keys.mo files in modelicaDir."
    "validateDictionaries.py: error: Input directories should be informed.");
  ssPython.str(std::string());

  cmd = pythonCmd + " validateDictionaries.py --inputDir dic/noSeparator/";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd +
    "Error: File: dic/noSeparator/NoSeparator.dic "
    "line: 'MyLabel  Separator is missing !' is not well defined, no separator '=' between the key and the value.");
  ssPython.str(std::string());

  cmd = pythonCmd + " validateDictionaries.py --inputDir dic/capitalInLog/";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd +
    "Error: File: dic/capitalInLog/CapitalInLog.dic "
    "line: 'MyLabel = First word begins with a capital letter !', the value definition should not begin with a capital letter.");
  ssPython.str(std::string());

  cmd = pythonCmd + " validateDictionaries.py --inputDir dic/differentKeys/";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd +
    "Error: ['dic/differentKeys/DifferentKeys_en_GB.dic'] and "
    "['dic/differentKeys/DifferentKeys_fr_FR.dic'] have not the same entries.Missing entries:  Key2");
  ssPython.str(std::string());

  cmd = pythonCmd + " validateDictionaries.py --inputDir dic/argsCount/";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd +
    "Error: Messages of key 'Hello' for dictionary ['dic/argsCount/ArgsCount_en_GB.dic'] and "
    "['dic/argsCount/ArgsCount_fr_FR.dic'] have not the same number of arguments.");
  ssPython.str(std::string());

  cmd = pythonCmd + " validateDictionaries.py --inputDir dic/timelinePriorityLocale/";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd +
    "Error: MyTimelinePriority dictionary should be present only once and without a locale.");
  ssPython.str(std::string());

  cmd = pythonCmd + " validateDictionaries.py --inputDir dic/noTimeline/";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd +
    "Error: MyTimeline dictionary not present in input directories while "
    "['dic/noTimeline/MyTimelinePriority.dic'] is.");
  ssPython.str(std::string());

  cmd = pythonCmd + " validateDictionaries.py --inputDir dic/ --modelicaDir dic/";
  executeCommand(cmd, ssPython);
  result = ssPython.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : " + cmd + "Usage: validateDictionaries.py "
    "--inputDir=<directories> [--outputDir=<directory> [--namespace=<namespace>] [--existingKeysDir=<directories>]] "
    "[--modelicaDir=<directory> --modelicaPackage=<packageName>]"
    "    Script checks integrity of all dictionaries in inputDir."
    "    If check is ok, it generates keys.h and keys.cpp files in outputDir and keys.mo files in modelicaDir."
    "validateDictionaries.py: error: Parent package of modelica keys files should be informed.");
  ssPython.str(std::string());

  cmd = pythonCmd + " validateDictionaries.py --inputDir dic/allInOne/,dic/allInOne/otherDir/share/ "
                    "--outputDir dic/allInOne/ --namespace AIO --existingKeysDir dic/allInOne/otherDir/include/";
  remove("dic/allInOne/AIOMyLog_keys.cpp");
  remove("dic/allInOne/AIOMyLog_keys.h");
  remove("dic/allInOne/AIOMyTimeline_keys.cpp");
  remove("dic/allInOne/AIOMyTimeline_keys.h");
  executeCommand(cmd, ssPython);
  ssPython.str(std::string());
  ASSERT_FALSE(exists("dic/allInOne/AIOMyDic_keys.cpp"));
  ASSERT_FALSE(exists("dic/allInOne/AIOMyDic_keys.h"));
  ASSERT_TRUE(exists("dic/allInOne/AIOMyLog_keys.cpp"));
  ASSERT_TRUE(exists("dic/allInOne/AIOMyLog_keys.h"));
  ASSERT_TRUE(exists("dic/allInOne/AIOMyTimeline_keys.cpp"));
  ASSERT_TRUE(exists("dic/allInOne/AIOMyTimeline_keys.h"));
  std::stringstream ssDiff;
  executeCommand("diff dic/allInOne/AIOMyLog_keys.cpp dic/allInOne/AIOMyLog_keys_ref.cpp", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff dic/allInOne/AIOMyLog_keys.cpp dic/allInOne/AIOMyLog_keys_ref.cpp\n");
  ssDiff.str(std::string());
  executeCommand("diff dic/allInOne/AIOMyLog_keys.h dic/allInOne/AIOMyLog_keys_ref.h", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff dic/allInOne/AIOMyLog_keys.h dic/allInOne/AIOMyLog_keys_ref.h\n");
  ssDiff.str(std::string());
  executeCommand("diff dic/allInOne/AIOMyTimeline_keys.cpp dic/allInOne/AIOMyTimeline_keys_ref.cpp", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff dic/allInOne/AIOMyTimeline_keys.cpp dic/allInOne/AIOMyTimeline_keys_ref.cpp\n");
  ssDiff.str(std::string());
  executeCommand("diff dic/allInOne/AIOMyTimeline_keys.h dic/allInOne/AIOMyTimeline_keys_ref.h", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff dic/allInOne/AIOMyTimeline_keys.h dic/allInOne/AIOMyTimeline_keys_ref.h\n");
  ssDiff.str(std::string());

  cmd = pythonCmd + " validateDictionaries.py --inputDir dic/ --outputDir dic/ --modelicaDir dic/ --modelicaPackage myPackage --namespace MyNS";
  remove("dic/MyDic_keys.cpp");
  remove("dic/MyDic_keys.h");
  remove("dic/icKeys.mo");
  executeCommand(cmd, ssPython);
  ssPython.str(std::string());
  ASSERT_TRUE(exists("dic/MyDic_keys.cpp"));
  ASSERT_TRUE(exists("dic/MyDic_keys.h"));
  ASSERT_TRUE(exists("dic/icKeys.mo"));
  ssDiff.str(std::string());
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

  cmd = pythonCmd + " validateDictionaries.py --inputDir dicMapping/,dicMapping/folder --outputDir dicMapping/ --modelicaDir dicMapping/ "
      "--modelicaPackage myPackage --namespace MyNS";
  remove("dicMapping/dico_keys.cpp");
  remove("dicMapping/dico_keys.h");
  remove("dicMapping/oKeys.mo");
  executeCommand(cmd, ssPython);
  ssPython.str(std::string());
  ssDiff.str(std::string());
  ASSERT_TRUE(exists("dicMapping/dico_keys.cpp"));
  ASSERT_TRUE(exists("dicMapping/dico_keys.h"));
  ASSERT_TRUE(exists("dicMapping/oKeys.mo"));
  executeCommand("diff dicMapping/dico_keys.cpp dicMapping/dico_keys_ref.cpp", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff dicMapping/dico_keys.cpp dicMapping/dico_keys_ref.cpp\n");
  ssDiff.str(std::string());
  executeCommand("diff dicMapping/dico_keys.h dicMapping/dico_keys_ref.h", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff dicMapping/dico_keys.h dicMapping/dico_keys_ref.h\n");
  ssDiff.str(std::string());
  executeCommand("diff dicMapping/oKeys.mo dicMapping/oKeys_ref.mo", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff dicMapping/oKeys.mo dicMapping/oKeys_ref.mo\n");
  ssDiff.str(std::string());
}


}  // namespace DYN
