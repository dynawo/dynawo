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

#include <xml/sax/parser/Attributes.h>

#include <gtest/gtest.h>

#include "type_trait_test.hpp"
#include <boost/optional/optional_io.hpp>

namespace p = xml::sax::parser;
using p::Attributes;

class TestAttributes: public testing::Test {
protected:
  Attributes attributes;

  TestAttributes() {
    attributes.set("name1", "value1");
    attributes.set("name2", "value2");
  }
};

TEST_F(TestAttributes, construction) {
  EXPECT_TRUE(attributes.has("name1"));
  EXPECT_TRUE(attributes.has("name2"));
  
  EXPECT_NE( attributes.get<std::string>("name1"), attributes.get<std::string>("name2") );
  EXPECT_EQ(attributes.get<std::string>("name1"), "value1");
  EXPECT_EQ(attributes.get<std::string>("name2"), "value2");
}

TEST_F(TestAttributes, reassignation) {
  EXPECT_EQ(attributes.get<std::string>("name1"), "value1");
  attributes.set("name1", "value2");
  EXPECT_EQ(attributes.get<std::string>("name1"), "value2");
}

TEST_F(TestAttributes, reading) {
  // missing value
  EXPECT_THROW(attributes.get<std::string>("not a key"), p::ParserException);
  // wrong value type
  EXPECT_THROW(attributes.get<double>("name2"), p::ParserException);
  
  double d = 0;
  std::string s = "";
  
  EXPECT_FALSE(attributes.get("not a key", d));
  EXPECT_FALSE(attributes.get("not a key", s));
  
  EXPECT_FALSE(attributes.get("name1", d));
  
  EXPECT_TRUE(attributes.get("name1", s));
  EXPECT_EQ(s, "value1");
}


TEST_F(TestAttributes, booleans) {
  attributes.set("bool1", "true");
  attributes.set("bool2", "false");
  
  EXPECT_EQ(attributes.get<bool>("bool1"), true);
  EXPECT_EQ(attributes.get<bool>("bool2"), false);
}


class TestSearchedAttribute: public testing::Test {
public:
  typedef Attributes::SearchedAttribute SearchedAttribute;
protected:
  Attributes attributes;

  //used to check conversion extraction.
  template <typename T>
  static T use(T value) {return value;}
  
  
  template <typename T>
  static std::string make_string(T const& value) { return boost::lexical_cast<std::string>(value); }
  
  
  template <typename T>
  void test(T const& value, T const& failed_value) {
    std::string const string_value = make_string(value);
    
    attributes.set("key", string_value);
    SearchedAttribute searched = attributes["key"];
    SearchedAttribute failed = attributes["missing"];
    
    EXPECT_TRUE(searched.exists());
    EXPECT_FALSE(failed.exists());
    
    EXPECT_EQ(searched.as_string(), string_value);
    EXPECT_EQ(searched.as<T>(), value);
    
    EXPECT_EQ(use<T const&>(searched), value);
    EXPECT_EQ(use< boost::optional<T> const& >(searched), value);
    EXPECT_EQ(use< boost::optional<T> const& >(failed), boost::none);
    
    EXPECT_EQ(use<T>(searched | failed_value), value);
    EXPECT_EQ(use<T>(failed | failed_value), failed_value);
  }
};

template <>
std::string TestSearchedAttribute::make_string(bool const& b) { return b ? "true" : "false"; }


TEST_F(TestSearchedAttribute, string2) {
  test<std::string>("value", "nothing");
}

TEST_F(TestSearchedAttribute, int) {
  test<int>(1, 0);
}

TEST_F(TestSearchedAttribute, double) {
  test<double>(0.5, 2);
}

TEST_F(TestSearchedAttribute, bool) {
  test<bool>(true, false);
}
