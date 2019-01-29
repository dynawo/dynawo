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

#include <xml/sax/parser/CDataCollector.h>
#include <xml/sax/parser/Attributes.h>

#include <gtest/gtest.h>

#include "type_trait_test.hpp"


namespace p = xml::sax::parser;

struct test_CDataCollector: public p::CDataCollector {
  using CDataCollector::tag;
  using CDataCollector::name;
  using CDataCollector::data;
  using CDataCollector::attributes;
  using CDataCollector::attribute;
};

TEST(TestElementHandler, Interface) {
  const p::ns::uri uri("uri");
  
  const p::ElementName e1(uri, "name1");
  const p::ElementName e2(uri, "name2");
  
  p::Attributes attributes;
  attributes.set("key", "value");
  
  
  test_CDataCollector h;
  
  ASSERT_NO_THROW( h.startElement(e1, attributes) );
  EXPECT_EQ(h.tag(), e1);
  EXPECT_EQ(h.name(), e1.name);
  EXPECT_TRUE(h.data().empty());
  
  ASSERT_NO_THROW( h.readCharacters("a") );
  EXPECT_EQ(h.tag(), e1);
  EXPECT_EQ(h.name(), e1.name);
  EXPECT_EQ(h.data(), "a");
  
  ASSERT_NO_THROW( h.startElement(e2, attributes) );
  EXPECT_EQ(h.tag(), e2);
  EXPECT_EQ(h.name(), e2.name);
  EXPECT_EQ(h.data(), "a");
  
  ASSERT_NO_THROW( h.readCharacters("b") );
  EXPECT_EQ(h.tag(), e2);
  EXPECT_EQ(h.name(), e2.name);
  EXPECT_EQ(h.data(), "b");
  
  ASSERT_NO_THROW( h.readCharacters("c") );
  EXPECT_EQ(h.tag(), e2);
  EXPECT_EQ(h.name(), e2.name);
  EXPECT_EQ(h.data(), "c");
  
  ASSERT_NO_THROW( h.endElement(e1) );
  EXPECT_EQ(h.tag(), e2);
  EXPECT_EQ(h.name(), e2.name);
  EXPECT_EQ(h.data(), "c");
  
  ASSERT_NO_THROW( h.endElement(e2) );
  EXPECT_EQ(h.tag(), e2);
  EXPECT_EQ(h.name(), e2.name);
  EXPECT_EQ(h.data(), "c");
}
