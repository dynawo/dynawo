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

#include <xml/sax/parser/Path.h>

#include <gtest/gtest.h>

#include "type_trait_test.hpp"
#include "sequence.hpp"

#include <algorithm>
#include <numeric>
#include <vector>
#include <iterator>

#include <boost/lexical_cast.hpp>
#include <boost/optional.hpp>

namespace p = xml::sax::parser;

template <typename T>
class TestPath : public testing::Test {
protected:
  typedef std::vector<T> data_type;
  typedef typename data_type::const_iterator const_iterator;
  typedef typename data_type::const_reverse_iterator const_reverse_iterator;

  TestPath(): data(5) {}
  
  typename data_type::size_type size() const { return data.size(); }
  
  T const& first() const { return data.first(); }
  T const& last() const { return data.last(); }
  
  const_iterator begin() const { return data.begin(); }
  const_iterator end() const { return data.end(); }
  
  const_reverse_iterator rbegin() const { return data.rbegin(); }
  const_reverse_iterator rend() const { return data.rend(); }

private:
  test_helpers::sequence<T> data;  
};

TYPED_TEST_CASE_P(TestPath);

TYPED_TEST_P(TestPath, Empty) {
  typedef p::path<TypeParam> path;
  path empty_path;
  path const& empty_path_cref = empty_path;

  EXPECT_TRUE(empty_path.empty());
  EXPECT_EQ(empty_path.size(), 0);
  
  EXPECT_NO_THROW(empty_path.parent());
  EXPECT_TRUE(empty_path.empty());

  EXPECT_NO_THROW(empty_path.remove_end());
  EXPECT_TRUE(empty_path.empty());

  EXPECT_NO_THROW(empty_path.clear());
  EXPECT_TRUE(empty_path.empty());
  
  EXPECT_TRUE(empty_path.begin() == empty_path.end()) << "empty path shall have begin() and end() equals";
  EXPECT_TRUE(empty_path_cref.begin() == empty_path_cref.end()) << "empty path shall have begin() and end() equals";
  
  EXPECT_TRUE(empty_path.rbegin() == empty_path.rend()) << "empty path shall have begin() and end() equals";
  EXPECT_TRUE(empty_path_cref.rbegin() == empty_path_cref.rend()) << "empty path shall have begin() and end() equals";

  EXPECT_EQ(empty_path, path());
  EXPECT_FALSE(empty_path != path());
}

// tests paths made of a single element
TYPED_TEST_P(TestPath, Single) {
  typedef p::path<TypeParam> path;
  
  TypeParam const& value = this->first();
  
  path p1( value );
  EXPECT_FALSE( p1.empty() );
    
  EXPECT_EQ( p1.size(), 1 );
  EXPECT_EQ( p1.base(), value );
  
  EXPECT_EQ( p1.base(), *p1.begin() );
  EXPECT_TRUE( p1.begin() != p1.end() );
  EXPECT_TRUE( ++p1.begin() == p1.end() );
  EXPECT_TRUE( p1.begin() == --p1.end() );
  
  EXPECT_EQ( p1.base(), *p1.rbegin() );
  EXPECT_TRUE( p1.rbegin() != p1.rend() );
  EXPECT_TRUE( ++p1.rbegin() == p1.rend() );
  EXPECT_TRUE( p1.rbegin() == --p1.rend() );

  path p2( this->begin(), ++this->begin() );
  EXPECT_EQ( p1, p2 );
  
  //construct an empty by copying then removing end component
  path empty = p1;
  EXPECT_EQ( p1, empty );
  
  EXPECT_NO_THROW(empty.remove_end());
  EXPECT_TRUE(empty.empty());
  EXPECT_NE(p1, empty);
  
  //construct an empty by copying then clearing
  path empty2 = p1;
  empty2.clear();
  EXPECT_EQ( empty, empty2 );
}

// tests paths made of a single element
TYPED_TEST_P(TestPath, Long) {
  typedef p::path<TypeParam> path;

  
  //tests path(begin, end)
  path p1(this->begin(), this->end());
  EXPECT_EQ(p1.base(), this->last());
  
  EXPECT_EQ(p1.size(), this->size());
  EXPECT_TRUE( std::equal(p1.begin(), p1.end(), this->begin() ) );
  
  // tests path(), path = path and path + token
  path p2 = std::accumulate(this->begin(), this->end(), path());
  EXPECT_EQ(p1, p2);
  
  
  TypeParam const& value = this->first();
  path start(value);
  path trail(++this->begin(), this->end());
  
  EXPECT_NE(p1, trail);
  
  EXPECT_EQ( path(start)+=trail, start + trail );
  EXPECT_EQ( ( path(start)+=trail ).size(), start.size() + trail.size() );
  
  EXPECT_EQ( start + trail, value + trail );
  EXPECT_EQ( trail + start, trail + value );
  
  
  
  for (typename TestPath<TypeParam>::const_reverse_iterator it = this->rbegin(); it!=this->rend(); ++it) {
    EXPECT_EQ( p1.size(), std::distance(it, this->rend()) );
    EXPECT_EQ( p1.base(), *it );
    EXPECT_NO_THROW(p1.remove_end());
  }
  EXPECT_TRUE(p1.empty());
}


REGISTER_TYPED_TEST_CASE_P(TestPath, Empty, Single, Long);


typedef testing::Types<int, double, std::string> MyTypes;
INSTANTIATE_TYPED_TEST_CASE_P(My, TestPath, MyTypes);
