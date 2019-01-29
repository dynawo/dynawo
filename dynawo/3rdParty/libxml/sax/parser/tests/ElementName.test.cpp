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

#include <xml/sax/parser/ElementName.h>

#include <gtest/gtest.h>

#include "type_trait_test.hpp"

#include <vector>


#include <boost/lexical_cast.hpp>
#include <boost/optional.hpp>

namespace p = xml::sax::parser;
namespace ns = p::ns;

using ns::uri;
using p::ElementName;

TEST(TestUri, Basic) {
  EXPECT_EQ( uri(), ns::empty );
  EXPECT_EQ( uri("name").name(), "name" );
  EXPECT_EQ( uri("name"), std::string("name") );
  EXPECT_EQ( static_cast<std::string>(uri("name")), "name" );
}

TEST(TestUri, Operators) {
  uri a("a"), b("b");

  EXPECT_EQ( a, a );
  EXPECT_LE( a, a );
  EXPECT_GE( a, a );
  EXPECT_FALSE( a > a );
  EXPECT_FALSE( a < a );
  EXPECT_FALSE( a != a );

  EXPECT_EQ( b, b );

  EXPECT_NE( a, b );

  EXPECT_LT( a, b );
  EXPECT_LE( a, b );
  EXPECT_GT( b, a );
  EXPECT_GE( b, a );

  EXPECT_FALSE( a >  b );
  EXPECT_FALSE( a >= b );
  EXPECT_FALSE( b <  a );
  EXPECT_FALSE( b <= a );
}

TEST(TestUri, Compare) {
  uri a("a"), b("b");

  EXPECT_LE( a.compare(b), 0);
  EXPECT_LE( a.compare(a), 0);

  EXPECT_LT( a.compare(b), 0);
  EXPECT_GT( b.compare(a), 0);

  EXPECT_GE( b.compare(a), 0);
  EXPECT_GE( b.compare(b), 0);
}


TEST(TestElementName, Basic) {
  const ElementName element("name");
  EXPECT_EQ( element, ElementName(ns::empty, "name") );

  EXPECT_EQ( element.name, "name" );
  EXPECT_EQ( element.ns, ns::empty );
  EXPECT_EQ( element, std::string("name") );

  const uri basic("http://exemple.net/xsd/basic.xsd");
  EXPECT_EQ( ElementName(basic, "name").ns, basic );
}



TEST(TestElementName, LongPath) {
  using p::XmlPath;

  const uri basic("http://exemple.net/xsd/basic.xsd");

  const ElementName tokens[3]={
    ElementName(basic, "a"),
    ElementName(basic, "b"),
    ElementName(basic, "c")
  };

  const XmlPath p1 = basic("a/b/c");
  const XmlPath p2 = basic("a") + basic("b") + basic("c");
  const XmlPath p3(tokens, tokens+3);

  EXPECT_EQ( p1, p2 );
  EXPECT_EQ( p2, p3 );
  EXPECT_EQ( p1, p3 );
}
