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

#include <xml/sax/parser/Parser.h>
#include <xml/sax/parser/ParserFactory.h>

#include <xml/sax/parser/Attributes.h>

#include <xml/sax/parser/ComposableDocumentHandler.h>
#include <xml/sax/parser/CDataCollector.h>

#include <gtest/gtest.h>

#include "type_trait_test.hpp"

#include <iostream>
#include <sstream>

namespace p = xml::sax::parser;
namespace ns = p::ns;

struct value_collector: public p::CDataCollector {
  std::vector<int> ints;

  void do_endElement(p::ElementName const&) {
    ints.push_back( boost::lexical_cast<int>(data()) );
  }
};

class TestParser: public testing::Test {
protected:
  value_collector value_handler;
  p::ComposableDocumentHandler doc;

  TestParser() {
    doc.onElement(ns::uri::empty("root/value"), value_handler);
  }
};

TEST_F(TestParser, ValidBasicInput) {
  std::istringstream data(
    "<root>"
      "<value>1</value>"
      "<value>2</value>"
      "<value>3</value>"
      "<value>4</value>"
    "</root>"
  );

  ASSERT_NO_THROW(
    p::ParserFactory().createParser()->parse(data, doc, false)
  );

  ASSERT_EQ(value_handler.ints.size(), 4);
  for (int i = 0; i<4; ++i) {
    EXPECT_EQ(value_handler.ints[i], i+1);
  }
}


TEST_F(TestParser, ValidPrettyInput) {
  std::istringstream data(
    "<root>\n\t<value>1</value>\n\t<value>2</value>\n\t<value>3</value>\n\t<value>4</value></root>"
  );

  ASSERT_NO_THROW(
    p::ParserFactory().createParser()->parse(data, doc, false)
  );

  ASSERT_EQ(value_handler.ints.size(), 4);
  for (int i = 0; i<4; ++i) {
    EXPECT_EQ(value_handler.ints[i], i+1);
  }
}
