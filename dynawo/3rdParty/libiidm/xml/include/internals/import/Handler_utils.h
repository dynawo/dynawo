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
 * @file xml/import/Handler_utils.h
 * @brief utilities for handler definitions
 */

#ifndef LIBIIDM_XML_INTERNALS_IMPORT_GUARD_HANDLER_UTILS_H
#define LIBIIDM_XML_INTERNALS_IMPORT_GUARD_HANDLER_UTILS_H

#include <IIDM/cpp11.h>

#include <boost/function.hpp>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/bind.hpp>

namespace IIDM {
namespace xml {
/**
 * @brief creates a void(void) functor binding a setter
 * @tparam B type of the target builder
 * @tparam V type of the value to assign
 * @param b the target builder
 * @param f the member function of applied to b, with the given value
 * @param value reference to a value
 */
template <typename B, typename V>
boost::function<void(void)>
inline make_setter(B& b, B& (B::*f) (V const&), V const& value) {
  return boost::phoenix::bind( f, boost::phoenix::ref(b), boost::phoenix::cref(value) );
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
