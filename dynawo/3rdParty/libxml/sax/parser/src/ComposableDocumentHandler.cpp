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
 * @file ComposableDocumentHandler.cpp
 * @brief ComposableDocumentHandler : implementation file
 *
 */

#include <xml/sax/parser/ComposableDocumentHandler.h>

#include <xml/sax/parser/Path.h>

#include <iostream>

namespace xml {
namespace sax {
namespace parser {

ComposableDocumentHandler& ComposableDocumentHandler::onStartDocument(startDocument_observer const& o) {
  startDocument_observers.push_back(o);
  return *this;
}

ComposableDocumentHandler& ComposableDocumentHandler::onEndDocument(endDocument_observer const& o) {
  endDocument_observers.push_back(o);
  return *this;
}





void ComposableDocumentHandler::startDocument() {
  for (startDocument_observers_type::iterator it=startDocument_observers.begin(); it!=startDocument_observers.end(); ++it) {
    (*it)();
  }
}

void ComposableDocumentHandler::endDocument() {
  for (endDocument_observers_type::iterator it=endDocument_observers.begin(); it!=endDocument_observers.end(); ++it) {
    (*it)();
  }
}



void ComposableDocumentHandler::startElement(ElementName const& name, attributes_type const& attributes) {
  ComposableBase::startElement(name, attributes);
}

void ComposableDocumentHandler::endElement(ElementName const& name) {
  ComposableBase::endElement(name);
}

void ComposableDocumentHandler::readCharacters(std::string const& characters) {
  ComposableBase::readCharacters(characters);
  
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
