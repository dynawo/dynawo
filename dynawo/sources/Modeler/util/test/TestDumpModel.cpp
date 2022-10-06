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

#include "DYNCommon.h"
#include "DYNExecUtils.h"
#include "DYNFileSystemUtils.h"
#include "gtest_dynawo.h"

namespace DYN {

TEST(ModelerUtil, TestDumpModel) {
  std::string cmd = "../dumpModel";
  std::stringstream ss;
  executeCommand(cmd, ss);
  std::string result = ss.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : ../dumpModel Model file is required  -h [ --help ]             "
      "produce help message  -m [ --model-file ] arg  REQUIRED: set model file (path)  -o [ --output-file ] arg set output file (path)");
  ss.str(std::string());

  cmd = "../dumpModel -m blah";
  executeCommand(cmd, ss);
  result = ss.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : ../dumpModel -m blah Default output file used : ./dumpModel.desc.xml  -h [ --help ]             "
      "produce help message  -m [ --model-file ] arg  REQUIRED: set model file (path)  -o [ --output-file ] arg set output file (path)blah does not exist ");
  ss.str(std::string());

  remove("dumpModel.desc.xml");
  cmd = "../dumpModel -m ../../../../M/CPP/ModelFrequency/ModelOmegaRef/DYNModelOmegaRef"+std::string(sharedLibraryExtension());
  executeCommand(cmd, ss);
  result = ss.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : ../dumpModel -m ../../../../M/CPP/ModelFrequency/ModelOmegaRef/DYNModelOmegaRef"
   +std::string(sharedLibraryExtension())+" Default output file used : ./dumpModel.desc.xml  -h [ --help ]             "
      "produce help message  -m [ --model-file ] arg  REQUIRED: set model file (path)  -o [ --output-file ] arg set output file (path)");
  ss.str(std::string());
  ASSERT_TRUE(exists("dumpModel.desc.xml"));
  std::stringstream ssDiff;
  executeCommand("diff dumpModel.desc.xml res/dumpModel.desc.xml", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff dumpModel.desc.xml res/dumpModel.desc.xml\n");
}


}  // namespace DYN
