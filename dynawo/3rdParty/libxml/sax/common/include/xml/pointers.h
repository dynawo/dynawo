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
 * @file  HandlerPtr.h
 * @brief  Define smart pointers to Handler object: Different implementation between C++98 and C++11
 *
 */

#ifndef XML_SAX_POINTERS_H
#define XML_SAX_POINTERS_H

#include <memory>

#if __cplusplus < 201103L
  #define XML_OWNER_PTR std::auto_ptr
#else
  #define XML_OWNER_PTR std::unique_ptr
#endif

#if __cplusplus < 201103L
  #include <boost/shared_ptr.hpp>
  #include <boost/enable_shared_from_this.hpp>
  namespace shared_ptr_ns = boost;
#else
  namespace shared_ptr_ns = std;
#endif

#endif
