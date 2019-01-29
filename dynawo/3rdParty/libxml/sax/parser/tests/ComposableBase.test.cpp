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

#include <xml/sax/parser/ComposableBase.h>
#include <xml/sax/parser/Attributes.h>

#include <gtest/gtest.h>

#include "type_trait_test.hpp"

namespace p = xml::sax::parser;
namespace ns = p::ns;

using p::ComposableBase;

//inherit to expose destructor
class MyComposable : public ComposableBase {};

namespace elt {
std::string const root  = "root";
std::string const child = "child";
}

struct inspector {
  unsigned int count_root;
  unsigned int count_child;
  unsigned int depth_child;
  
  inspector(): count_root(0), count_child(0), depth_child(0) {}
};


struct start_counter {
  inspector & target;
  unsigned int inspector::* counter;
  
  start_counter(inspector & target, unsigned int inspector::* counter): target(target), counter(counter) {}
  
  void operator() (p::ElementName const&, p::Attributes const&) const {
    ++(target.*counter);
  }
};

struct end_counter {
  inspector & target;
  unsigned int inspector::* counter;
  
  end_counter(inspector & target, unsigned int inspector::* counter): target(target), counter(counter) {}
  
  bool operator() (p::ElementName const&) const {
    --(target.*counter);
    return true;
  }
};


TEST(TestComposableBase, Interface) {
  const p::ElementName root (elt::root );
  const p::ElementName child(elt::child);
  
  const p::Attributes no_attributes;
  const p::Attributes attributes = p::Attributes().set("a1", "1").set("a2", "2");
  
  inspector i;
  MyComposable h;
  
  ASSERT_NO_THROW( h.onStartElement(root, start_counter(i, &inspector::count_root)) );
  
  ASSERT_NO_THROW( h.onStartElement(root+child, start_counter(i, &inspector::count_child)) );
  ASSERT_NO_THROW( h.onStartElement(root+child, start_counter(i, &inspector::depth_child)) );
  ASSERT_NO_THROW( h.onEndElement(root+child, end_counter(i, &inspector::depth_child)) );
  
  ASSERT_NO_THROW( h.onStartElement(root+child+child, start_counter(i, &inspector::count_child)) );
  ASSERT_NO_THROW( h.onStartElement(root+child+child, start_counter(i, &inspector::depth_child)) );
  ASSERT_NO_THROW( h.onEndElement(root+child+child, end_counter(i, &inspector::depth_child)) );

  ASSERT_EQ(i.count_root , 0);
  ASSERT_EQ(i.count_child, 0);
  ASSERT_EQ(i.depth_child, 0);
  
  ASSERT_NO_THROW( h.startElement(root, attributes) );
  EXPECT_EQ(i.count_root , 1);
  EXPECT_EQ(i.count_child, 0);
  EXPECT_EQ(i.depth_child, 0);
  
  ASSERT_NO_THROW( h.startElement(child, no_attributes) );
  EXPECT_EQ(i.count_root , 1);
  EXPECT_EQ(i.count_child, 1);
  EXPECT_EQ(i.depth_child, 1);
  
  ASSERT_NO_THROW( h.startElement(child, no_attributes) );
  EXPECT_EQ(i.count_root , 1);
  EXPECT_EQ(i.count_child, 2);
  EXPECT_EQ(i.depth_child, 2);

  ASSERT_NO_THROW( h.readCharacters("value") );

  ASSERT_NO_THROW( h.endElement(child) );
  EXPECT_EQ(i.count_root , 1);
  EXPECT_EQ(i.count_child, 2);
  EXPECT_EQ(i.depth_child, 1);

  ASSERT_NO_THROW( h.endElement(child) );
  EXPECT_EQ(i.count_root , 1);
  EXPECT_EQ(i.count_child, 2);
  EXPECT_EQ(i.depth_child, 0);

  ASSERT_NO_THROW( h.endElement(root) );
  EXPECT_EQ(i.count_root , 1);
  EXPECT_EQ(i.count_child, 2);
  EXPECT_EQ(i.depth_child, 0);
}


