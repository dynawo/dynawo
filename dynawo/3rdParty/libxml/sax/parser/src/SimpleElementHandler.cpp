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

/** 
 * @file SimpleElementHandler.cpp
 * @brief SimpleElementHandler: implementation file
 *
 */

#include <xml/sax/parser/SimpleElementHandler.h>
#include <xml/sax/parser/ElementName.h>
#include <xml/sax/parser/Attributes.h>

#include <iostream>

namespace xml {
namespace sax {
namespace parser {

SimpleElementHandler::SimpleElementHandler(): 
  depth(0)
{}
  
void SimpleElementHandler::startElement(ElementName const& tag, attributes_type const& attributes) {
  if (depth++ == 0) start();
  do_startElement(tag, attributes);
}

void SimpleElementHandler::endElement(ElementName const& tag) {
  do_endElement(tag);
  if (--depth == 0) end();
}


void SimpleElementHandler::do_startElement(ElementName const&, attributes_type const&) {}

void SimpleElementHandler::do_endElement(ElementName const&) {}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

