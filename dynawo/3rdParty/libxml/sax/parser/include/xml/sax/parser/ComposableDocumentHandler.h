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

#ifndef XML_SAX_PARSER_GUARD_COMPOSABLEDOCUMENTHANDLER_H
#define XML_SAX_PARSER_GUARD_COMPOSABLEDOCUMENTHANDLER_H

#include <xml/sax/parser/ElementName.h>

#include <xml/sax/parser/DocumentHandler.h>
#include <xml/sax/parser/ComposableBase.h>


#include <vector>
#include <boost/function.hpp>

namespace xml {
namespace sax {
namespace parser {

/**
 * @class DocumentHandler
 * @brief Used by parsers to handle the parsing events
 *
 */
class ComposableDocumentHandler : public DocumentHandler, private ComposableBase {
public:
  /**
   * @brief Destructor
   */
  // not using override keyword generates a warning, processed as an error, in dynawo
  ~ComposableDocumentHandler() override {}

  /**
   * @brief Called when a document parsing starts. Calls begin()
   */
  virtual void startDocument() XML_OVERRIDE XML_FINAL;

  /**
   * @brief Called when a document parsing ends. Calls end()
   */
  virtual void endDocument() XML_OVERRIDE XML_FINAL;

  /**
   * @brief Called when an XML element opening tag is read.
   *
   * @param name Name of the element
   * @param attributes the attributes of the read element
   */
  virtual void startElement(ElementName const& name, attributes_type const& attributes) XML_OVERRIDE XML_FINAL;

  /**
   * @brief Called when an XML element closing tag is read.
   *
   * @param name Name of the element
   */
  virtual void endElement(ElementName const& name) XML_OVERRIDE XML_FINAL;

  /**
   * @brief Characters inside XML element event handler
   *
   * @param chars Characters to write in the element
   */
  virtual void readCharacters(std::string const& characters) XML_OVERRIDE XML_FINAL;

public:
  typedef boost::function<void ()> startDocument_observer;
  typedef boost::function<void ()> endDocument_observer;

  using ComposableBase::startElement_observer;
  using ComposableBase::endElement_observer;
  using ComposableBase::characters_observer;

public:
  //adds a possibility to startDocument
  ComposableDocumentHandler& onStartDocument(startDocument_observer const&);

  //adds a possibility to startDocument
  ComposableDocumentHandler& onEndDocument(endDocument_observer const&);

  using ComposableBase::path_type;

  using ComposableBase::onStartElement;
  using ComposableBase::onEndElement;
  using ComposableBase::onReadCharacters;

  using ComposableBase::onElement;

private:
  typedef std::vector<startDocument_observer> startDocument_observers_type;
  typedef std::vector<endDocument_observer> endDocument_observers_type;

  startDocument_observers_type startDocument_observers;
  endDocument_observers_type endDocument_observers;
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
