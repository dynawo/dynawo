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
 * @file xml/exception.h
 * @brief exception related to xml parsing
 */

#ifndef LIBIIDM_XML_GUARD_EXCEPTION_H
#define LIBIIDM_XML_GUARD_EXCEPTION_H

#include <stdexcept>

namespace IIDM {
namespace xml {

struct error: std::runtime_error {
  explicit error(std::string const& msg): std::runtime_error(msg) {}
};

/** exception thrown when an error occurs while registering an extension */
struct extension_error: error {
  explicit extension_error(std::string const& msg): error(msg) {}
};

/** exception thrown when an error occurs while registering an extension */
struct export_error: error {
  explicit export_error(std::string const& msg): error(msg) {}
};

/** exception thrown when an error occurs while registering an extension */
struct import_error: error {
  import_error(std::string const& msg): error(msg) {}
};

} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
