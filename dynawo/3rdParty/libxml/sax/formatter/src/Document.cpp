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
 * @file internals/xml/libxml_raii.h
 * @brief complement to libXML, in order to provide RAII support
 */

#include <xml/sax/formatter/Document.h>

namespace xml {
namespace sax {
namespace formatter {

Document::Document(Formatter & f): formatter(f) {formatter.startDocument();}

Document::~Document() {formatter.endDocument();}

Element Document::element(std::string const& name) {
  return Element(formatter, name);
}

Element Document::element(std::string const& name, AttributeList const& attrs) {
  return Element(formatter, name, attrs);
}

Element Document::element(std::string const& namespacePrefix, std::string const& name) {
  return Element(formatter, namespacePrefix, name);
}

Element Document::element(std::string const& namespacePrefix, std::string const& name, AttributeList const& attrs) {
  return Element(formatter, namespacePrefix, name, attrs);
}





Element::Element(Formatter & formatter, std::string const& name):
  formatter(formatter)
{
  formatter.startElement(name, AttributeList());
}

Element::Element(Formatter & f, std::string const& name, AttributeList const& attrs):
  formatter(f)
{
  formatter.startElement(name, attrs);
}



Element::Element(Formatter & formatter, std::string const& namespacePrefix, std::string const& name):
  formatter(formatter)
{
  formatter.startElement(namespacePrefix, name, AttributeList());
}

Element::Element(Formatter & f, std::string const& namespacePrefix, std::string const& name, AttributeList const& attrs):
  formatter(f)
{
  formatter.startElement(namespacePrefix, name, attrs);
}



Element::~Element() {formatter.endElement();}



Element& Element::empty_element(std::string const& name) {
  Element(formatter, name);
  return *this;
}

Element& Element::empty_element(std::string const& name, AttributeList const& attrs) {
  Element(formatter, name, attrs);
  return *this;
}

Element& Element::empty_element(std::string const& namespacePrefix, std::string const& name, AttributeList const& attrs) {
  Element(formatter, namespacePrefix, name, attrs);
  return *this;
}

Element& Element::empty_element(std::string const& namespacePrefix, std::string const& name) {
  Element(formatter, namespacePrefix, name);
  return *this;
}


} // end of namespace xml::sax::formatter::
} // end of namespace xml::sax::
} // end of namespace xml::
