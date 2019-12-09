//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libiidm, a library to model IIDM networks and allows
// importing and exporting them to files.
//

/**
 * @file  ExecUtils.cpp
 *
 * @brief implementation of utility function
 */

#include <stdlib.h>
#include <stdexcept>

#include <IIDM/xml/ExecUtils.h>

namespace IIDM {

std::string getMandatoryEnvVar(std::string const& key) {
  char const* val = getenv(key.c_str());
  if (val != NULL)
    return std::string(val);
  else
    throw std::runtime_error("libiidm mandatory environment variable " + key + " is not defined.");
}

} // end of namespace IIDM::
