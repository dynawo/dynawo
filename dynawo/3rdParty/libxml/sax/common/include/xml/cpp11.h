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
 * @file cpp11.h
 * @brief support macros for some c++11 additions
 * features like override and final semi-keywords where added in C++11.
 * this header provides macro to use them in both pre-C++11 and C++11 mode
 */

#ifndef LIBXML_GUARD_CPP11_H
#define LIBXML_GUARD_CPP11_H

/*
definitions of several C++11 keywords
override, final and constexpr are just removed in C++03
nullptr is replaced by NULL
*/
#if __cplusplus >= 201103L
  ///the C++11 override special identifier
  #define XML_OVERRIDE override
  ///the C++11 final special identifier
  #define XML_FINAL final

  ///the C++11 noexcept specifier
  #define XML_NOEXCEPT(X) noexcept(X)

  #define XML_NOTHROW noexcept


  ///the C++11 nullptr keyword
  #define XML_NULLPTR nullptr

  ///the C++11 constexpr keyword
  #define XML_CONSTEXPR constexpr

#else //not a C++11 compilation
  ///the C++11 override special identifier
  #define XML_OVERRIDE

  ///the C++11 final special identifier
  #define XML_FINAL

  ///the C++11 noexcept(...) specifier, which is not available in C++03
  #define XML_NOEXCEPT(X)

  #define XML_NOTHROW throw()


  ///the C++11 nullptr keyword, given the NULL value
  #define XML_NULLPTR NULL

  ///the C++11 constexpr keyword, which is not available in C++03
  #define XML_CONSTEXPR

#endif

#endif
