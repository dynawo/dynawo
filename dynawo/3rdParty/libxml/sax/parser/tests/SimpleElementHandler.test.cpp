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

#include <xml/sax/parser/SimpleElementHandler.h>
#include <xml/sax/parser/Attributes.h>

#include <gtest/gtest.h>

#include "type_trait_test.hpp"


namespace p = xml::sax::parser;
namespace ns = p::ns;

using p::ElementHandler;
using p::SimpleElementHandler;

class MySimpleElementHandler: public SimpleElementHandler {
public:
  MySimpleElementHandler(int value = 0): value(value) {}
  operator int () const { return value; }
  
  virtual void readCharacters(std::string const&) { value*=2; }
  
protected:
  virtual void do_startElement(p::ElementName const&, attributes_type const&) { ++value; }
  virtual void do_endElement(p::ElementName const&) { --value; }

private:
  int value;
};

TEST(TestElementHandler, Interface) {
  const p::ElementName e("name");

  MySimpleElementHandler h(0);
  EXPECT_EQ(h, 0);
  
  EXPECT_NO_THROW( h.startElement(e, MySimpleElementHandler::attributes_type()) );
  EXPECT_EQ(h, 1);
  EXPECT_NO_THROW( h.readCharacters("value") );
  EXPECT_EQ(h, 2);
  EXPECT_NO_THROW( h.endElement(e) );
  EXPECT_EQ(h, 1);
}
