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

#include <xml/sax/parser/ElementHandler.h>
#include <xml/sax/parser/Attributes.h>

#include <gtest/gtest.h>

#include "type_trait_test.hpp"

#include <boost/bind.hpp>


namespace p = xml::sax::parser;
namespace ns = p::ns;

using p::ElementHandler;

class MyElementHandler: public ElementHandler {
public:
  virtual void startElement(elementName_type const&, attributes_type const&) {}

  virtual void endElement(elementName_type const&) {}
  
  using ElementHandler::start;
  using ElementHandler::end;
};

typedef p::ElementHandler::start_observer start_observer;
typedef p::ElementHandler::end_observer end_observer;

struct Observer{
private:
  int value;

public:
  Observer(int value = 0): value(value) {}
  
  void start() {++value;}
  void end() {--value;}
  
  operator int () const { return value; }
  
  start_observer as_start_observer() { return boost::bind(&Observer::start, this); }
  end_observer as_end_observer() { return boost::bind(&Observer::end, this); }
};

TEST(TestElementHandler, Interface) {
  ASSERT_TYPE_EQ( MyElementHandler::attributes_type, p::Attributes );
  
  const p::ElementName e("name");
  Observer o1(0), o2(2);
  
  ASSERT_EQ(o1, 0);
  ASSERT_EQ(o2, 2);
  
  MyElementHandler h;
  ASSERT_NO_THROW( h.onStart(boost::bind(&Observer::start, &o1)) );
  ASSERT_NO_THROW( h.onEnd(boost::bind(&Observer::end, &o1)) );

  ASSERT_NO_THROW( h.onStart(boost::bind(&Observer::start, &o2)).onEnd(boost::bind(&Observer::end, &o2)) );
  
  EXPECT_EQ(o1, 0);
  EXPECT_EQ(o2, 2);
  EXPECT_NO_THROW( h.start() );
  EXPECT_EQ(o1, 1);
  EXPECT_EQ(o2, 3);
  EXPECT_NO_THROW( h.end() );
  EXPECT_EQ(o1, 0);
  EXPECT_EQ(o2, 2);
  
  EXPECT_NO_THROW( h.startElement(e, MyElementHandler::attributes_type()) );
  EXPECT_NO_THROW( h.readCharacters("value") );
  EXPECT_EQ(o1, 0);
  EXPECT_EQ(o2, 2);
  EXPECT_NO_THROW( h.endElement(e) );
}
