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

/**
 * @file  DYNExecUtils.cpp
 *
 * @brief implementation of utility function
 */
#include <stdlib.h>

#ifndef LANG_CXX11
#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>   // waitpid
#include <unistd.h>
#include <fcntl.h>
#include <cerrno>
#endif

#include <cstring>
#include <sstream>

#include "DYNExecUtils.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNFileSystemUtils.h"

#include <boost/filesystem.hpp>
#ifdef LANG_CXX11
#include <boost/process.hpp>
namespace ps = boost::process;
#endif

using std::string;
using std::stringstream;

namespace fs = boost::filesystem;

string
prettyPath(const std::string & path) {
  string prettyPath = "";
  try {
    // only works if the file or the path exists !!!
    prettyPath = canonical(path);
  } catch (const fs::filesystem_error& ex) {
    DYN::Trace::warn() << ex.what() << DYN::Trace::endline;
  }
  return prettyPath;
}

#ifndef LANG_CXX11
static void parentProcess(int fd[2], std::stringstream & ss) {
  char buferr[256];
  struct timeval tv;
  char buf[BUFSIZ];
  string strbuf;
  // Trace recovery
  // from stdin piped to stdout
  bool fin = false;
  while (!fin) {
    // Watch fd[0] waiting for data -> traces
    // Timeout of 1 second associated with the select
    // WARNING: in Linux reset at each call
    tv.tv_sec = 1;
    tv.tv_usec = 0;
    fd_set rfds;
    FD_ZERO(&rfds);
    FD_SET(fd[0], &rfds);
    int retsel = select(fd[0] + 1, &rfds, NULL, NULL, &tv);

    if (retsel == -1) {  // error
      throw DYNError(DYN::Error::GENERAL, SystemCallFailed, "select", strerror_r(errno, buferr, sizeof (buferr)));
    } else if (retsel> 0) {  // some data may be available
      int retread;
      while ((retread = read(fd[0], buf, BUFSIZ)) > 0) {
        strbuf += string(buf, retread);
      }

      if (retread == 0) {  // no more data (eof)
        fin = true;
      } else if (retread == -1 && errno != EAGAIN) {  // error
        throw DYNError(DYN::Error::GENERAL, SystemCallFailed, "read", strerror_r(errno, buferr, sizeof (buferr)));
      }
    }
  }
  if (strbuf.size() != 0)
    ss << strbuf << std::endl;
}
#endif

#ifdef LANG_CXX11
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
#endif

void
executeCommand(const std::string & command, std::stringstream & ss, const std::string & start_dir) {
  ss << "Executing command : " << command << std::endl;

#ifdef LANG_CXX11
  std::string prefix = getOptionPrefix();
  std::string tool = getShellTool();
  std::vector<std::string> args { prefix+"c", command };
  ps::ipstream ips;
  ps::child child(ps::search_path(tool), args, ps::shell, ps::start_dir(start_dir == "" ? "." : start_dir), (ps::std_out & ps::std_err) > ips);

  string line;
  while (ips && std::getline(ips, line))
    ss << line << std::endl;

  child.wait();
#else
  // @todo : remove all of this whenever compilation in CPP98 is dropped
  char buferr[256];
  std::string command1;
  if (start_dir != "")
      command1 = "cd " + start_dir + " && ";
  command1 += command + " 2>&1";

  // Creation of a pipe between the exit and the entry
  // fd[0]entry and fd[1] exit
  int fd[2];
  if (pipe(fd) == -1) {
    throw DYNError(DYN::Error::GENERAL, SystemCallFailed, "pipe", strerror_r(errno, buferr, sizeof (buferr)));
  }

  pid_t pid;

  pid = fork();
  if (pid < 0) {  // fork failed
    throw DYNError(DYN::Error::GENERAL, SystemCallFailed, "fork",  strerror_r(errno, buferr, sizeof (buferr)));
  }

  if (pid != 0) {  // Father process (reading the pipe to retrieve the traces made by the son)
    FILE *f = fdopen(fd[0], "r");
    if (f == NULL) {
      throw DYNError(DYN::Error::GENERAL, SystemCallFailed, "fdopen", strerror_r(errno, buferr, sizeof (buferr)));
    }
    if (close(fd[1]) == -1) {
      throw DYNError(DYN::Error::GENERAL, SystemCallFailed, "close", strerror_r(errno, buferr, sizeof (buferr)));
    }

    // To make fd[0] non blocking
    int status = fcntl(fd[0], F_GETFL);
    fcntl(fd[0], F_SETFL, status | O_NONBLOCK);

    parentProcess(fd, ss);

    if (fclose(f) != 0) {
      throw DYNError(DYN::Error::GENERAL, SystemCallFailed, "fclose", strerror_r(errno, buferr, sizeof (buferr)));
    }

    // wait for the main process to finish
    if (waitpid(pid, &status, WUNTRACED) == -1) {
      throw DYNError(DYN::Error::GENERAL, SystemCallFailed, "waitpid", strerror_r(errno, buferr, sizeof (buferr)));
    }
  } else {  // Son process (execution and writing in the pipe for emission of traces)
    if (close(fd[0]) == -1) {
      throw DYNError(DYN::Error::GENERAL, SystemCallFailed, "close", strerror_r(errno, buferr, sizeof (buferr)));
    }

    // Connecting the standard output to the output of the pipe
    dup2(fd[1], fileno(stdout));

    // Execute the shell command.
    execl("/bin/bash", "/bin/bash", "-c", command1.c_str(), reinterpret_cast<char*> (NULL));
    _exit(EXIT_FAILURE);
  }
#endif
}

bool hasEnvVar(std::string const& key) {
  char const* val = getenv(key.c_str());
  return (val != NULL);
}

std::string getEnvVar(std::string const& key) {
  char const* val = getenv(key.c_str());
  return val == NULL ? std::string() : std::string(val);
}

std::string getMandatoryEnvVar(std::string const& key) {
  if (!hasEnvVar(key))
    throw DYNError(DYN::Error::GENERAL, MissingEnvironmentVariable, key);
  return getEnvVar(key);
}
