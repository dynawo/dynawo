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
#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>   // waitpid
#include <cstring>
#include <unistd.h>
#include <fcntl.h>
#include <cerrno>
#include <sstream>

#include "DYNMacrosMessage.h"

using std::string;
using std::stringstream;

string
prettyPath(const std::string & path) {
  // only works if the file or the path exists !!!
  char *real_path = realpath(path.c_str(), NULL);
  string prettyPath(real_path);
  free(real_path);
  return prettyPath;
}

void
executeCommand(const std::string & command, std::stringstream & ss) {
  ss << "Executing command : " << command << std::endl;
  char buferr[256];
  std::string command1 = command + " 2>&1";

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
}

bool hasEnvVar(std::string const& key) {
  char const* val = getenv(key.c_str());
  return (val != NULL);
}

std::string getEnvVar(std::string const& key) {
  char const* val = getenv(key.c_str());
  return val == NULL ? std::string() : std::string(val);
}
