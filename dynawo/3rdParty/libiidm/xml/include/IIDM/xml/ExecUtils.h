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
 * @file  ExecUtils.h
 *
 * @brief define utily function
 *
 */

#ifndef LIBIIDM_XML_INTERNALS_IMPORT_GUARD_EXECUTILS_H
#define LIBIIDM_XML_INTERNALS_IMPORT_GUARD_EXECUTILS_H

#include <string>

namespace IIDM {

/**
 * @brief retrieve a given mandatory environment variable
 *
 * @param key key of the mandatory environment variable
 *
 * @return value of the mandatory environment variable
 */
std::string getMandatoryEnvVar(std::string const& key);

#endif  // LIBIIDM_XML_INTERNALS_IMPORT_GUARD_EXECUTILS_H

} // end of namespace IIDM::
