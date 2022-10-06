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
 * @file ComposableElementHandler.h
 * @brief XML event handler abstract implementation : interface file
 *
 */

#ifndef XML_SAX_PARSER_GUARD_COMPOSABLE_ELEMENT_HANDLER_H
#define XML_SAX_PARSER_GUARD_COMPOSABLE_ELEMENT_HANDLER_H

#include <vector>
#include <boost/function.hpp>

#include <xml/sax/parser/ElementName.h>

#include <xml/sax/parser/ElementHandler.h>
#include <xml/sax/parser/ComposableBase.h>

#include <xml/sax/parser/Path.h>
#include <xml/sax/parser/PathTree.h>

#include <xml/cpp11.h>

namespace xml {
namespace sax {
namespace parser {

/**
 * @brief handler built by attaching handlers or functors to an xml path.
 *
 * A full handler can be attached to a path, or just one of the event handling functors
 */
class ComposableElementHandler : public virtual ElementHandler, private ComposableBase {
public:
  using ComposableBase::startElement_observer;
  using ComposableBase::endElement_observer;
  using ComposableBase::characters_observer;

public:
  ComposableElementHandler() {}

  // not using override keyword generates a warning, processed as an error, in dynawo
  /** @brief Destructor */
  ~ComposableElementHandler() override {}

public:
  using ComposableBase::path_type;

  using ComposableBase::onStartElement;
  using ComposableBase::onEndElement;
  using ComposableBase::onReadCharacters;

  using ComposableBase::onElement;

public:
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
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
