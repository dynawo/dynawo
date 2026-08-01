//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file gtest_dynawo.h
 * @brief defined some useful macros used in unit test based on gtest library
 * this file is only useful for unit test and should not be added to dynawo distribution
 */

#ifndef COMMON_GTEST_DYNAWO_H_
#define COMMON_GTEST_DYNAWO_H_

#include <sstream>
#ifndef _MSC_VER
#include <cxxabi.h>
#endif
#include <cstdlib>
#include <gtest/gtest.h>
#include "gmock/gmock.h"
#include "DYNError.h"

/**
 * @brief return the string name associated to the type of the error
 *
 * @param type type of the error
 *
 * @return type of the error as a string
 */
inline std::string type2Str(const DYN::Error::TypeError_t& type) {
  std::string string2Return = "unknown";
  switch (type) {
    case DYN::Error::UNDEFINED:
      string2Return = "UNDEFINED";
      break;
    case DYN::Error::SUNDIALS_ERROR:
      string2Return = "SUNDIALS_ERROR";
      break;
    case DYN::Error::SOLVER_ALGO:
      string2Return = "SOLVER_ALGO";
      break;
    case DYN::Error::MODELER:
      string2Return = "MODELER";
      break;
    case DYN::Error::GENERAL:
      string2Return = "GENERAL";
      break;
    case DYN::Error::SIMULATION:
      string2Return = "SIMULATION";
      break;
    case DYN::Error::NUMERICAL_ERROR:
      string2Return = "NUMERICAL_ERROR";
      break;
    case DYN::Error::STATIC_DATA:
      string2Return = "STATIC_DATA";
      break;
    case DYN::Error::API:
      string2Return = "API";
      break;
  }
  return string2Return;
}

/**
 * @brief return the string name associated to the key of the error
 *
 * @param key key of the error
 *
 * @return key of the error as a string
 */
inline std::string key2Str(const int key) {
  return DYN::KeyError_t::names(static_cast<DYN::KeyError_t::value>(key));
}


/**
 * @brief macro to test if the error returns by a function is the right one
 *
 * @param F function/method to launch
 * @param ERROR_TYPE type of the error expected
 * @param ERROR_KEY key of the error expected
 *
 */
#ifndef _MSC_VER
#define ASSERT_THROW_DYNAWO(F, ERROR_TYPE, ERROR_KEY)                                            \
  GTEST_AMBIGUOUS_ELSE_BLOCKER_                                                                  \
  if (::testing::internal::AlwaysTrue()) {                                                       \
    try                                                                                          \
    {                                                                                            \
      F;                                                                                         \
      FAIL();                                                                                    \
    }                                                                                            \
    catch(const DYN::Error& e)                                                                   \
    {                                                                                            \
      EXPECT_EQ(type2Str(ERROR_TYPE), type2Str(e.type()));                                       \
      EXPECT_EQ(key2Str(ERROR_KEY), key2Str(e.key()));                                           \
    }                                                                                            \
    catch (const std::exception& e) {                                                            \
      int status = -1;                                                                           \
      std::ostringstream oss;                                                                    \
      oss << "Expected: " << #F << " throws an exception of type DYN::Error" << std::endl;       \
      oss << "  Actual: it throws an exception of type ";                                        \
      char* realname = abi::__cxa_demangle(typeid(e).name(), NULL, NULL, &status);               \
      oss << ((status == 0) ? realname : typeid(e).name());                                      \
      std::free(realname);                                                                       \
      GTEST_FATAL_FAILURE_(oss.str().c_str());                                                   \
    }                                                                                            \
    catch (...) {                                                                                \
      std::ostringstream oss;                                                                    \
      oss << "Expected: " << #F << " throws an exception of type DYN::Error" << std::endl;       \
      oss << "  Actual: it throws an exception of unknown type";                                 \
      GTEST_FATAL_FAILURE_(oss.str().c_str());                                                   \
    }                                                                                            \
  } else  /* NOLINT */                                                                           \
    EXPECT_FALSE(false)
#else
#define ASSERT_THROW_DYNAWO(F, ERROR_TYPE, ERROR_KEY)                                            \
  try                                                                                            \
  {                                                                                              \
    F;                                                                                           \
    FAIL();                                                                                      \
  }                                                                                              \
  catch(const DYN::Error& e)                                                                     \
  {                                                                                              \
    EXPECT_EQ(type2Str(ERROR_TYPE), type2Str(e.type()));                                         \
    EXPECT_EQ(key2Str(ERROR_KEY), key2Str(e.key()));                                             \
  }                                                                                              \
  catch (const std::exception& e) {                                                              \
    int status = -1;                                                                             \
    std::ostringstream oss;                                                                      \
    oss << "Expected: " << #F << " throws an exception of type DYN::Error" << std::endl;         \
    oss << "  Actual: it throws an exception of type ";                                          \
    oss << typeid(e).name();                                                                     \
    GTEST_FATAL_FAILURE_(oss.str().c_str());                                                     \
  }                                                                                              \
  catch (...) {                                                                                  \
    int status;                                                                                  \
    std::ostringstream oss;                                                                      \
    oss << "Expected: " << #F << " throws an exception of type DYN::Error" << std::endl;         \
    oss << "  Actual: it throws an exception of unknown type";                                   \
    GTEST_FATAL_FAILURE_(oss.str().c_str());                                                     \
  }
#endif

/**
 * @brief macro to test if the function returns an assert
 *
 * @param F function/method to launch
 */
#define EXPECT_ASSERT_DYNAWO(F)                                      \
  GTEST_AMBIGUOUS_ELSE_BLOCKER_                                      \
  if (::testing::FLAGS_gtest_death_test_style = "threadsafe", false) \
    ;                                                                \
  else  /* NOLINT */                                                 \
    EXPECT_EXIT(F, ::testing::KilledBySignal(SIGABRT), ".*")

/**
 * @brief macro to test if two double are equals
 *
 * @param A first double
 * @param B second double
 */
#define ASSERT_DOUBLE_EQUALS_DYNAWO(A, B)                          \
  GTEST_AMBIGUOUS_ELSE_BLOCKER_                                    \
  if (!doubleEquals(A, B)) {                                       \
    std::ostringstream oss;                                        \
    oss << "Expected: " << A << " equals to " << B << std::endl;   \
    GTEST_FATAL_FAILURE_(oss.str().c_str());                       \
  } else  /* NOLINT */                                             \
    ASSERT_EQ(doubleEquals(A, B), true)

/**
 * @brief Macro replacement for GTest TEST macro for CLang only
 */
#ifdef __clang__
#define TEST_DYNAWO_(test_case_name, test_name)                    \
  _Pragma("clang diagnostic push")                                 \
  _Pragma("clang diagnostic ignored \"-Wglobal-constructors\"")    \
  GTEST_TEST(test_case_name, test_name)                            \
  _Pragma("clang diagnostic pop")

#undef TEST
#define TEST(test_case_name, test_name) TEST_DYNAWO_(test_case_name, test_name)
#endif

/**
 * @brief Macro to initialize Xml environment
 */
#ifdef __clang__
#define INIT_XML_DYNAWO                                            \
  testing::Environment* initXmlEnvironment();                      \
  _Pragma("clang diagnostic push")                                 \
  _Pragma("clang diagnostic ignored \"-Wglobal-constructors\"")    \
  static testing::Environment* const env_ = initXmlEnvironment()   \
  _Pragma("clang diagnostic pop")
#else
#define INIT_XML_DYNAWO                                            \
  testing::Environment* initXmlEnvironment();                      \
  static testing::Environment* const env = initXmlEnvironment()
#endif

#endif  // COMMON_GTEST_DYNAWO_H_
