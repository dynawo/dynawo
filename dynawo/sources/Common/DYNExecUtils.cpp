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

/**
 * @file  DYNExecUtils.cpp
 *
 * @brief implementation of utility function
 */
#include <stdlib.h>

#include <cstring>
#include <sstream>

#include "DYNExecUtils.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNFileSystemUtils.h"

#include <boost/filesystem.hpp>
#include <boost/process.hpp>
namespace ps = boost::process;

using std::string;
using std::stringstream;

namespace fs = boost::filesystem;

string
prettyPath(const std::string& path) {
  string prettyPath = "";
  try {
    // only works if the file or the path exists !!!
    prettyPath = canonical(path);
  } catch (const fs::filesystem_error& ex) {
    DYN::Trace::warn() << ex.what() << DYN::Trace::endline;
  }
  return prettyPath;
}


static std::string
getOptionPrefix() {
#ifdef _WIN32
  std::string prefix = "/";
#else
  std::string prefix = "-";
#endif
  return prefix;
}

static std::string
getShellTool() {
#ifdef _WIN32
  std::string tool = "cmd";
#else
  std::string tool = "sh";
#endif
  return tool;
}

int
executeCommand(const std::string& command, std::stringstream & ss, const std::string& startDir) {
  ss << "Executing command : " << command << std::endl;

  const std::string prefix = getOptionPrefix();
  std::string tool = getShellTool();
  std::vector<std::string> args { prefix + "c", command };
  ps::ipstream ips;
  ps::child child(ps::search_path(tool), args, ps::shell, ps::start_dir(startDir.empty() ? "." : startDir), (ps::std_out & ps::std_err) > ips);

  string line;
  while (ips && std::getline(ips, line))
    ss << line << std::endl;

  child.wait();
  return child.exit_code();
}

bool hasEnvVar(std::string const& key) {
  char const* val = getenv(key.c_str());
  return (val != NULL);
}

std::string getEnvVar(const std::string& key) {
  char const* val = getenv(key.c_str());
  return val == NULL ? std::string() : std::string(val);
}

std::string getMandatoryEnvVar(const std::string& key) {
  if (!hasEnvVar(key))
    throw DYNError(DYN::Error::GENERAL, MissingEnvironmentVariable, key);
  return getEnvVar(key);
}
