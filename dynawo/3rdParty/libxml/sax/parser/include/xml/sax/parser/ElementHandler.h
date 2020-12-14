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
 * @file ElementHandler.h
 * @brief ElementHandler Handler
 *
 */

#ifndef XML_SAX_PARSER_GUARD_ELEMENT_HANDLER_H
#define XML_SAX_PARSER_GUARD_ELEMENT_HANDLER_H

#include <xml/sax/parser/Attributes_fwd.h>
#include <xml/sax/parser/ElementName.h>

#include <boost/function.hpp>
#include <vector>

namespace xml {
namespace sax {
namespace parser {

/**
 * @brief ElementHandler interface.
  */
class ElementHandler {
public:
  typedef Attributes attributes_type;
  typedef ElementName elementName_type;

  typedef boost::function<void()> start_observer;
  typedef boost::function<void()> end_observer;

public:
  /**
   * @brief Constructor
   */
  ElementHandler(){};

  /**
   * @brief Destructor
   */
  virtual ~ElementHandler(){};

  /**
   * @brief Called when an XML element opening tag is read.
   *
   * @param name Name of the element
   * @param attributes the attributes of the read element
   */
  virtual void startElement(elementName_type const& name, attributes_type const& attributes) = 0;

  /**
   * @brief Called when an XML element closing tag is read.
   *
   * @param name Name of the element
   */
  virtual void endElement(elementName_type const& name) = 0;

  /**
   * @brief Called when characters are read inside an XML element.
   *
   * @param characters Characters read from the element
   */
  virtual void readCharacters(std::string const& characters);

  ElementHandler& onStart(start_observer const&);
  ElementHandler& onEnd(end_observer const&);

protected:
  void start() const;
  void end() const;

  void start();
  void end();

private:
  typedef std::vector<start_observer> start_observers_type;
  typedef std::vector<end_observer> end_observers_type;
  start_observers_type start_observers;
  end_observers_type end_observers;
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
