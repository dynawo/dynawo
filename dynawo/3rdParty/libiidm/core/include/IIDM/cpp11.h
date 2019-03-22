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
 * @file cpp11.h
 * @brief support macros for some c++11 additions
 * features like override and final semi-keywords where added in C++11.
 * this header provides macro to use them in both pre-C++11 and C++11 mode
 */

#ifndef LIBIIDM_GUARD_CPP11_H
#define LIBIIDM_GUARD_CPP11_H

/*
definitions of several C++11 keywords
override, final and constexpr are just removed in C++03
nullptr is replaced by NULL
*/
#if __cplusplus >= 201103L
  ///the C++11 override special identifier
  #define IIDM_OVERRIDE override
  ///the C++11 final special identifier
  #define IIDM_FINAL final

  ///the C++11 noexcept specifier
  #define IIDM_NOEXCEPT noexcept
  ///the C++11 noexcept(...) specifier
  #define IIDM_NOEXCEPT_IF(X) noexcept(X)


  ///the C++11 nullptr keyword
  #define IIDM_NULLPTR nullptr

  ///the C++11 constexpr keyword
  #define IIDM_CONSTEXPR constexpr

#else //not a C++11 compilation
  ///the C++11 override special identifier
  #define IIDM_OVERRIDE

  ///the C++11 final special identifier
  #define IIDM_FINAL

  ///the C++11 noexcept specifier, which is not available in C++03
  #define IIDM_NOEXCEPT

  ///the C++11 noexcept(...) specifier, which is not available in C++03
  #define IIDM_NOEXCEPT_IF(X)


  ///the C++11 nullptr keyword, given the NULL value
  #define IIDM_NULLPTR NULL

  ///the C++11 constexpr keyword, which is not available in C++03
  #define IIDM_CONSTEXPR

#endif

#endif
