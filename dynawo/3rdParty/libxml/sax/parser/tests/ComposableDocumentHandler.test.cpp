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

#include <xml/sax/parser/ComposableDocumentHandler.h>
#include <xml/sax/parser/Attributes.h>

#include <gtest/gtest.h>

#include "type_trait_test.hpp"

namespace p = xml::sax::parser;
namespace ns = p::ns;

using p::ComposableDocumentHandler;


struct listener {
  unsigned int n;

  listener(): n(0) {}

  void operator() () { ++n; }

  bool operator==(unsigned int value) const { return n==value; }
  bool operator!=(unsigned int value) const { return n!=value; }
};

std::ostream& operator <<( std::ostream& os, listener const& l) {
  return os << "count="<<l.n;
}


void f() {}

TEST(TestComposableBase, Creation) {
  ComposableDocumentHandler doc;
  ASSERT_NO_THROW( doc.onStartDocument(&f) );
  ASSERT_NO_THROW( doc.onEndDocument(&f) );
}

TEST(TestComposableBase, onStartDocument) {
  const p::ElementName node("node");

  ComposableDocumentHandler doc;
  listener l;

  ASSERT_EQ(l, 0);

  ASSERT_NO_THROW( doc.onStartDocument( boost::ref(l) ) );
  ASSERT_EQ(l, 0);

  ASSERT_NO_THROW( doc.startDocument() );
  ASSERT_EQ(l, 1);

  ASSERT_NO_THROW( doc.startElement(node, p::Attributes()) );
  ASSERT_NO_THROW( doc.readCharacters("value") );
  ASSERT_NO_THROW( doc.endElement(node) );
  ASSERT_EQ(l, 1);

  ASSERT_NO_THROW( doc.endDocument() );
  ASSERT_EQ(l, 1);
}

TEST(TestComposableBase, onEndDocument) {
  const p::ElementName node("node");

  ComposableDocumentHandler doc;
  listener l;

  ASSERT_EQ(l, 0);

  ASSERT_NO_THROW( doc.onEndDocument( boost::ref(l) ) );
  ASSERT_EQ(l, 0);

  ASSERT_NO_THROW( doc.startDocument() );
  ASSERT_EQ(l, 0);

  ASSERT_NO_THROW( doc.startElement(node, p::Attributes()) );
  ASSERT_NO_THROW( doc.readCharacters("value") );
  ASSERT_NO_THROW( doc.endElement(node) );
  ASSERT_EQ(l, 0);

  ASSERT_NO_THROW( doc.endDocument() );
  ASSERT_EQ(l, 1);
}
