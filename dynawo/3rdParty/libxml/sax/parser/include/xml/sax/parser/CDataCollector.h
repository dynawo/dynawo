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
 * @file CDataCollector.h
 * @brief CDataCollector interface
 *
 */

#ifndef XML_SAX_PARSER_GUARD_CDATACOLLECTOR_H
#define XML_SAX_PARSER_GUARD_CDATACOLLECTOR_H

#include <xml/sax/parser/SimpleElementHandler.h>
#include <xml/sax/parser/Attributes.h>
#include <boost/optional.hpp>
#include <string>

namespace xml {
namespace sax {
namespace parser {

class CDataCollector: public SimpleElementHandler {
public:
  CDataCollector();
  virtual ~CDataCollector() {}
  
  /**
   * @brief characters inside XML element event handler
   *
   * @param chars Characters to write in the element
   */
  virtual void readCharacters(std::string const& characters) XML_OVERRIDE XML_FINAL;
  
protected:
  virtual void do_startElement(ElementName const& tag, attributes_type const& attributes) XML_OVERRIDE XML_FINAL;

  ElementName const& tag() const { return *tag_; }
  
  ElementName::name_type const& name() const { return tag_->name; }
  
  std::string const& data() const { return data_; }
  
  attributes_type const& attributes() const { return attributes_; }
  
  attributes_type::SearchedAttribute attribute(attributes_type::name_type const& id) const { return attributes_[id]; }
  
private:
  boost::optional<ElementName> tag_;
  std::string data_;
  attributes_type attributes_;
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
