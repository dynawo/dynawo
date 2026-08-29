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

TEST(SolversUtil, TestDumpSolver) {
  std::string cmd = "../dumpSolver";
  std::stringstream ss;
  executeCommand(cmd, ss);
  std::string result = ss.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : ../dumpSolver Solver dump main Solver file is required  -h [ --help ]             "
      "produce help message  -m [ --solver-file ] arg REQUIRED: set solver file (path)  -o [ --output-file ] arg set output file (path)");
  ss.str(std::string());

  cmd = "../dumpSolver -m blah";
  executeCommand(cmd, ss);
  result = ss.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : ../dumpSolver -m blah Solver dump main Default output file used : ./dumpSolver.desc.xml  -h [ --help ]             "
      "produce help message  -m [ --solver-file ] arg REQUIRED: set solver file (path)  -o [ --output-file ] arg set output file (path)blah does not exist ");
  ss.str(std::string());

  remove("dumpSolver.desc.xml");
  cmd = "../dumpSolver -m ../../FixedTimeStep/SolverSIM/dynawo_SolverSIM"+std::string(sharedLibraryExtension());
  executeCommand(cmd, ss);
  result = ss.str();
  boost::erase_all(result, "\n");
  ASSERT_EQ(result, "Executing command : ../dumpSolver -m ../../FixedTimeStep/SolverSIM/dynawo_SolverSIM"
                    +std::string(sharedLibraryExtension())+" Solver dump main Default output file used : ./dumpSolver.desc.xml  -h [ --help ]             "
      "produce help message  -m [ --solver-file ] arg REQUIRED: set solver file (path)  -o [ --output-file ] arg set output file (path)");
  ss.str(std::string());
  ASSERT_TRUE(exists("dumpSolver.desc.xml"));
  std::stringstream ssDiff;
  executeCommand("diff dumpSolver.desc.xml res/dumpSolver.desc.xml", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff dumpSolver.desc.xml res/dumpSolver.desc.xml\n");
}


}  // namespace DYN
