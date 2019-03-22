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
 * @file SimpleElementHandler.h
 * @brief SimpleElementHandler: interface file
 *
 */

#ifndef XML_SAX_PARSER_GUARD_SIMPLE_ELEMENT_HANDLER_H
#define XML_SAX_PARSER_GUARD_SIMPLE_ELEMENT_HANDLER_H

#include <xml/sax/parser/ElementHandler.h>

#include <xml/cpp11.h>

namespace xml {
namespace sax {
namespace parser {

/**
 * @brief SAX XML Handler interface class
 *
 * Handler objects are responsible of event handling when parsing an XML file.
 */
class SimpleElementHandler: public virtual ElementHandler {
public:
  SimpleElementHandler();
  virtual ~SimpleElementHandler() {}

  /**
   * @brief Called when an XML element opening tag is read.
   *
   * if name is the root name, calls StructureListenable::start();
   *
   * Inheriters shall not redefine this method, but do_startElement(...)
   *
   * @param name Name of the element
   * @param attributes the attributes of the read element
   */
  virtual void startElement(ElementName const& name, attributes_type const& attributes) XML_OVERRIDE XML_FINAL;

  /**
   * @brief Called when an XML element closing tag is read.
   *
   * if name is the root name, calls StructureListenable::end();
   *
   * Inheriters shall not redefine this method, but do_endElement(...)
   *
   * @param name Name of the element
   */
  virtual void endElement(ElementName const& name) XML_OVERRIDE XML_FINAL;

protected:
  virtual void do_startElement(ElementName const& name, attributes_type const& attributes);
  virtual void do_endElement(ElementName const& name);
  unsigned int depth;
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
#endif
