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

#include <xml/sax/formatter/AttributeList.h>

#include <gtest/gtest.h>

#include <algorithm>
#include <vector>

#include <boost/assign/std/vector.hpp>


namespace f = xml::sax::formatter;
using boost::assign::operator+=;

using f::AttributeList;

namespace xml {
namespace sax {
namespace formatter {

inline bool operator==(AttributeList::attribute const& a, AttributeList::attribute const& b) {
  return (a.name == b.name) && (a.value == b.value);
}

}
}
}

struct TestAttributeList: public testing::Test {
  typedef std::vector< AttributeList::attribute > temoin_type;

  bool is_valid(AttributeList const& list, temoin_type const& temoin) const {
    return (list.size() == temoin.size())
      && std::equal(list.begin(), list.end(), temoin.begin())
    ;
  }
};

TEST_F(TestAttributeList, EmptyCreation) {
  AttributeList list;

  ASSERT_TRUE(list.empty());
  ASSERT_EQ(list.size(), 0);

  ASSERT_TRUE(list.begin() == list.end()) << "begin() and end() shall be equal on empty AttributeList";
}

TEST_F(TestAttributeList, ValueCreation) {
  AttributeList list("key", "value");

  ASSERT_FALSE(list.empty());
  ASSERT_EQ(list.size(), 1);

  ASSERT_TRUE(list.begin() != list.end()) << "begin() and end() shall not be equal on non-empty AttributeList";

  ASSERT_EQ(list.begin()->name, "key");
  ASSERT_EQ(list.begin()->value, "value");

  ASSERT_TRUE(++list.begin() == list.end()) << "++begin() and end() shall be equal on an AttributeList with one value";

  list.clear();

  ASSERT_TRUE(list.empty());
  ASSERT_EQ(list.size(), 0);

  ASSERT_TRUE(list.begin() == list.end()) << "begin() and end() shall be equal on empty AttributeList";
}


TEST_F(TestAttributeList, StringsOrdered) {
  temoin_type temoin;
  temoin +=
    AttributeList::attribute("a", "A"),
    AttributeList::attribute("b", "B"),
    AttributeList::attribute("c", "C");

  // AttributeList are sorted.
  AttributeList list = AttributeList("a", "A")("b", "B")("c", "C");

  ASSERT_EQ( list.size(), std::distance(list.begin(), list.end()) );

  ASSERT_TRUE( is_valid(list, temoin) );
}

TEST_F(TestAttributeList, StringsUnordered) {
  temoin_type temoin;
  temoin +=
    AttributeList::attribute("b", "B"),
    AttributeList::attribute("a", "A"),
    AttributeList::attribute("c", "C");

  AttributeList list = AttributeList()("b", "B")("a", "A");
  list.add("c", "C");

  ASSERT_TRUE( is_valid(list, temoin) );
}



TEST_F(TestAttributeList, Bools) {
  temoin_type temoin;
  temoin +=
    AttributeList::attribute("true", "true"),
    AttributeList::attribute("false", "false");

  AttributeList list;

  ASSERT_NO_THROW(list("true", true));
  ASSERT_NO_THROW(list("false", false));

  ASSERT_TRUE( is_valid(list, temoin) );
}

TEST_F(TestAttributeList, Ints) {
  temoin_type temoin;
  temoin +=
    AttributeList::attribute("a", "1"),
    AttributeList::attribute("b", "2"),
    AttributeList::attribute("c", "-7"),
    AttributeList::attribute("d", "0");

  AttributeList list;

  ASSERT_NO_THROW(list("a", 1));
  ASSERT_NO_THROW(list("b", 2));
  ASSERT_NO_THROW(list("c", -7));
  ASSERT_NO_THROW(list("d", 0));

  ASSERT_TRUE( is_valid(list, temoin) );
}

TEST_F(TestAttributeList, Optionals) {
  using boost::optional;

  ASSERT_TRUE(AttributeList("key", optional<int>()).empty())<< "empty optional shall not be emitted";
  ASSERT_TRUE(AttributeList("int", optional<int>(1)).size()==1)<< "valued optional must be emitted";
}



TEST_F(TestAttributeList, Definitions) {
  temoin_type temoin;
  temoin +=
    AttributeList::attribute("b", "B"),
    AttributeList::attribute("c", "C");

  AttributeList list = AttributeList("a", "A");
  EXPECT_NO_THROW(list.remove("a"))<<"remove(key) should be able to remove a key with a value";
  EXPECT_NO_THROW(list.remove("none"))<<"remove(key) should not throw with a key not defined";

  EXPECT_NO_THROW(list.add("b", "b-failed"))<<"add(key, value) should be callable on unset key";
  EXPECT_NO_THROW(list.set("b", "B"))<<"set(key, value) should be callable on previously set key";

  EXPECT_NO_THROW(list.set("c", "c-failed"))<<"set(key, value) should be callable on unset key";
  EXPECT_NO_THROW(list("c", "C"))<<"operator()(key, value) should be callable on previously set key";
  EXPECT_THROW(list.add("c", "c-add-failure"), std::runtime_error)<<"add(key, value) should throw when called on previously set key";

  if (HasNonfatalFailure()) FAIL() << "AttributeList definition has failed";

  ASSERT_TRUE( is_valid(list, temoin) );
}
