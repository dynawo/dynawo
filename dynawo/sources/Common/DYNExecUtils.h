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
 * @file  DYNExecUtils.h
 *
 * @brief define utily function
 *
 */

#ifndef COMMON_DYNEXECUTILS_H_
#define COMMON_DYNEXECUTILS_H_

#include <string>
#include <sstream>

/**
 * @brief get the canonical path from a path
 *
 * @param path : path to find the canonical path
 *
 * @return the canonical path
 */
std::string prettyPath(const std::string & path);

/**
 * @brief execute a command
 *
 * @param command command to execute
 * @param ss log from the executed command
 * @param start_dir optional starting directory (current dir by default)
 * @return return code
 */
int executeCommand(const std::string & command, std::stringstream & ss, const std::string & start_dir = "");

/**
 * @brief retrieve a given environment variable
 *
 * @param key key of the environment variable
 *
 * @return value of the environment variable
 */
std::string getEnvVar(std::string const& key);

/**
 * @brief retrieve a given mandatory environment variable
 *
 * @param key key of the mandatory environment variable
 *
 * @return value of the mandatory environment variable
 */
std::string getMandatoryEnvVar(std::string const& key);

/**
 * @brief check whether a given environment variable exists
 *
 * @param key  key of the environment variable
 *
 * @return @b true if the variable exists
 */
bool hasEnvVar(std::string const& key);

#endif  // COMMON_DYNEXECUTILS_H_
