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
 * @file DocumentHandler.h
 * @brief DocumentHandler : interface file
 *
 */

#ifndef XML_SAX_PARSER_GUARD_DOCUMENTHANDLER_H
#define XML_SAX_PARSER_GUARD_DOCUMENTHANDLER_H

#include <xml/cpp11.h>

#include <xml/sax/parser/Attributes_fwd.h>
#include <xml/sax/parser/ElementName.h>

#include <string>

namespace xml {
namespace sax {
namespace parser {

/**
 * @class DocumentHandler
 * @brief Used by parsers to handle the parsing events
 *
 */
class DocumentHandler {
public:
  typedef xml::sax::parser::Attributes attributes_type;

public:
  /**
   * @brief Destructor
   */
  virtual ~DocumentHandler() {};

  /**
   * @brief Called when a document parsing starts. Calls begin()
   */
  virtual void startDocument() {}

  /**
   * @brief Called when a document parsing ends. Calls end()
   */
  virtual void endDocument() {}

  /**
   * @brief Called when an XML element opening tag is read.
   *
   * @param name Name of the element
   * @param attributes the attributes of the read element
   */
  virtual void startElement(ElementName const& name, attributes_type const& attributes);

  /**
   * @brief Called when an XML element closing tag is read.
   *
   * @param name Name of the element
   */
  virtual void endElement(ElementName const& name);

  /**
   * @brief Called when characters are read inside an XML element.
   *
   * @param chars Characters read from the element
   */
  virtual void readCharacters(std::string const& characters);
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
