//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libxml, a library to handle XML files parsing.
//

/**
 * @file cpp11_type_traits.h
 * @brief <type_traits> from C++11 or fallback from boost.
 */

#ifndef LIBXML_GUARD_CPP11_TYPE_TRAITS_H
#define LIBXML_GUARD_CPP11_TYPE_TRAITS_H

#if __cplusplus >= 201103L

#include <type_traits>
namespace xml {
namespace tt = std;
}
#define XML_ENABLE_IF std::enable_if

#else

#include <boost/type_traits.hpp>
#include <boost/core/enable_if.hpp>
namespace xml {
namespace tt = boost;
}
#define XML_ENABLE_IF boost::enable_if_c

#endif  // C++11

#endif
