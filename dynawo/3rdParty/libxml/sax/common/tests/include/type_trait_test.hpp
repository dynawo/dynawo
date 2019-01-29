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

/** @file type_trait_test.hpp
 * @brief Extends the Google C++ test framework to provides type check capability without compilation failure.
 */
#ifndef TYPE_TRAIT_TEST_GUARD_TYPE_TRAIT_TEST_H
#define TYPE_TRAIT_TEST_GUARD_TYPE_TRAIT_TEST_H

#include <gtest/gtest.h>

#include <boost/core/demangle.hpp>
#include <boost/utility/identity_type.hpp>
#include <boost/core/is_same.hpp>

//due to inherent difficulties with macros, the "," separator of template arguments need special handling
//TTT_TYPE((type-with-comma)) is a possible solution. e.g. TTT_TYPE((std::map<int, int>))

/**
 * @brief Allows the use of template types in macros. Use with two parenthesis pairs: `TTT_TYPE((type-with-comma))`
 *
 * Macro are using "top level commas" as argument separator, and only accept parenthesis as escape scheme.
 * but template type also use comma as parameter separator, and `(T)` is not a valid type (even if T is)
 *
 * exemple: `TTT_TYPE((std::map<int, int>))` produces `std::map<int, int>`
 */
#define TTT_TYPE(T) BOOST_IDENTITY_TYPE(T)

/**
 * @brief creates a type_test for a type with comma in template types. Use with two parenthesis pairs: `TTT_TYPE((type-with-comma))`
 *
 * exemple: `TTT_TYPE_TEST((std::map<int, int>))` is equivalent to `type_trait_test::type_test< std::map<int, int> >()`
 */
#define TTT_TYPE_TEST(T) type_trait_test::type_test< BOOST_IDENTITY_TYPE(T) >()


/** @brief ASSERT_EQ() that two types are equal (no comma allowed) */
#define ASSERT_TYPE_EQ(A, B) ASSERT_EQ( type_trait_test::type_test<A>(), type_trait_test::type_test<B>())

/** @brief ASSERT_NE() that two types are not equal (no comma allowed) */
#define ASSERT_TYPE_NE(A, B) ASSERT_NE( type_trait_test::type_test<A>(), type_trait_test::type_test<B>())

/** @brief EXPECT_EQ() that two types are equal (no comma allowed) */
#define EXPECT_TYPE_EQ(A, B) EXPECT_EQ( type_trait_test::type_test<A>(), type_trait_test::type_test<B>())

/** @brief EXPECT_NE() that two types are not equal (no comma allowed) */
#define EXPECT_TYPE_NE(A, B) EXPECT_NE( type_trait_test::type_test<A>(), type_trait_test::type_test<B>())

/**
*/
namespace type_trait_test {
  
/**
 * @brief represents a type for test purpose.
 * @tparam T represented type.
 */
template <typename T>
struct type_test{
  type_test() {}
  type_test(T const&) {}
  
  
  /**
   * @brief tells that the underlying types are equal for this type_test and another type_test of the same type.
   * @returns true
   */
  bool operator==(type_test const&) const {return true;}

  /**
   * @brief tells if the underlying types are different for this type_test and another type_test of the same type.
   * @returns false
   */
  bool operator!=(type_test const&) const {return false;}

  /**
   * @brief tells if the underlying types are equal for this type_test and a type_test of another type.
   * @tparam O the represented type of the other type_test.
   * @returns false, since if O is T, the non-template operator== is called
   */
  template <typename O>
  bool operator==(type_test<O> const&) const {return boost::core::is_same<T, O>::value;}


  /**
   * @brief tells that the underlying types are different for this type_test and a type_test of another type.
   * @tparam O the represented type of the other type_test.
   * @returns true, since if O is T, the non-template operator!= is called
   */
  template <typename O>
  bool operator!=(type_test<O> const&) const {return !boost::core::is_same<T, O>::value;}
};

/**
 * @brief prints the underlying type of a type_test.
 * @tparam T underlying type of the printed type_type
 * @param stream the output stream to write into
 * @param the printed type
 * @returns the stream, with the type printed.
 */
template <typename T>
inline std::ostream& operator<<(std::ostream& stream, type_test<T> const&) {
  return stream << "type[ " << boost::core::demangle(typeid(T).name()) << " ]";
}

/**
 * @brief creates a type_test related to a specific value.
 
 * Also strips `const&` specification.
 * @return a type_test structure representing the type
*/
template <typename T>
type_test<T> get_type(T const&) { return type_test<T>(); }

/**
 * @brief creates a type_test for a given type.
 * @see make_type<T>()
 */
template <typename T>
type_test<T> get_type() { return type_test<T>(); }

/**
 * @brief creates a type_test for a given type.
 * @see get_type<T>()
 */
template <typename T>
type_test<T> make_type() { return type_test<T>(); }

}// end of namespace type_trait_test::
#endif
