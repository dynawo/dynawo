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
 * @file  HandlerPtr.h
 * @brief  Define smart pointers to Handler object: Different implementation between C++98 and C++11
 *
 */

#ifndef LIBIIDM_GUARD_POINTERS_H
#define LIBIIDM_GUARD_POINTERS_H

#include <memory>

#if defined(__GXX_EXPERIMENTAL_CXX0X__) || __cplusplus >= 201103L
  #define IIDM_UNIQUE_PTR std::unique_ptr
#else
  #define IIDM_UNIQUE_PTR std::auto_ptr
#endif

namespace IIDM {

template <typename T>
IIDM_UNIQUE_PTR<T> make_owner_ptr(T* ptr) {
  return IIDM_UNIQUE_PTR<T>(ptr);
}


template <typename T>
IIDM_UNIQUE_PTR<T const> make_owner_ptr(T const* ptr) {
  return IIDM_UNIQUE_PTR<T>(ptr);
}

} // end of namespace IIDM::

#if __cplusplus < 201103L
  #include <boost/shared_ptr.hpp>
  #include <boost/enable_shared_from_this.hpp>
  namespace shared_ptr_ns = boost;
#else
  namespace shared_ptr_ns = std;
#endif

#endif
