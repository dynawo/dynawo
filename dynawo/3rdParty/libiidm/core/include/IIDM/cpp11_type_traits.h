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
 * @file cpp11_type_traits.h
 * @brief <type_traits> from C++11 or fallback from boost.
 */

#ifndef LIBIIDM_GUARD_CPP11_TYPE_TRAITS_H
#define LIBIIDM_GUARD_CPP11_TYPE_TRAITS_H

#if __cplusplus >= 201103L

#include <type_traits>

namespace IIDM {
namespace tt = std;
}
#define IIDM_ENABLE_IF std::enable_if

#else

#include <boost/type_traits.hpp>
#include <boost/core/enable_if.hpp>

namespace IIDM {
namespace tt = boost;
}
#define IIDM_ENABLE_IF boost::enable_if_c

#endif  // C++11

#endif
