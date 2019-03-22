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

#include <xml/sax/parser/DocumentHandler.h>
#include <xml/sax/parser/Attributes.h>

#include <gtest/gtest.h>

#include "type_trait_test.hpp"


namespace p = xml::sax::parser;
namespace ns = p::ns;

using p::DocumentHandler;

class MyDocumentHandler: public DocumentHandler {};

TEST(TestDocumentHandler, Interface) {
  ASSERT_TYPE_EQ( MyDocumentHandler::attributes_type, p::Attributes );

  const p::ElementName e("name");

  MyDocumentHandler h;
  EXPECT_NO_THROW( h.startDocument() );
  EXPECT_NO_THROW( h.startElement(e, MyDocumentHandler::attributes_type()) );
  EXPECT_NO_THROW( h.readCharacters("value") );
  EXPECT_NO_THROW( h.endElement(e) );
  EXPECT_NO_THROW( h.endDocument() );
}
