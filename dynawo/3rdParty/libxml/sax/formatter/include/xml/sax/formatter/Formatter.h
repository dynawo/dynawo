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
 * @file Formatter.h
 * @brief XML formatter description : interface file
 *
 */

#ifndef XML_SAX_FORMATTER_FORMATTER_H
#define XML_SAX_FORMATTER_FORMATTER_H

#include <xml/sax/formatter/FormatterPtr.h>
#include <xml/sax/formatter/AttributeList.h>

#include <ostream>
#include <string>

namespace xml {
namespace sax {
namespace formatter {

/**
 * @class Formatter
 * @brief SAX XML Formatter
 *
 * Formatter objects allow to create XML streams throw event-driven
 * serialization.
 */
class Formatter {
public:
  /**
   * @brief Destructor
   */
  virtual ~Formatter();

  /**
   * @brief Formatter factory
   *
   * Creates a Formatter which will write on given output stream an XML stream
   * pretty formatted or not. A default namespace for the document can be chosen.
   *
   * @param out Stream to write XML stream on
   * @param indentation If set to "", no spacing is added to make its format user friendly
   * @param defaultNamespace Default namespace URI of the XML file (put in the xmlns
   * attribute of the first element)
   * @param encoding encoding of the XML files (put in encoding attribute of document)
   *
   * @returns FormatterPtr to the created Formatter instance.
   */
  static FormatterPtr createFormatter(std::ostream& out, std::string const& defaultNamespace = "",
    std::string const& indentation = "  ", const std::string& encoding = "ISO-8859-1") {
    return FormatterPtr(newFormatter(out, defaultNamespace, indentation, encoding));
  }

  /**
   * @brief Adds a namespace declaration for current Formatter
   *
   * Adds a new namespace for current Formatter objects. Namespaces are pairs of
   * prefix name and namespace uri. They are exported ax attribute in the first
   * element of the XML file as attributes of type :
   *    xmlns:prefix="uri"
   * @param prefix Prefix used for the namespace
   * @param uri URI of the namespace
   */
  virtual void addNamespace(std::string const& prefix, std::string const& uri) = 0;

  /**
   * @brief Start the XML document
   *
   * Adds the XML declaration in the stream
   */
  virtual void startDocument() = 0;

  /**
   * @brief Set encoding for exported document
   *
   * @param encoding the new encoding
   */
  virtual void setEncoding(const std::string& encoding) = 0;

  /**
   * @brief End the XML document
   *
   * Flushes the output stream
   */
  virtual void endDocument() = 0;

  /**
   * @brief Start an XML element
   *
   * Start an XML element with given name, no attributes and in the default namespace
   *
   * @param name Name of the element
   * namespace if nothing specified)
   */
  void startElement(std::string const& name) { return startElement("", name); }

  /**
   * @brief Start an XML element
   *
   * Start an XML element with given name, attributes and in the default namespace
   *
   * @param name Name of the element
   * @param attrs List of the element's attributes
   * namespace if nothing specified)
   */
  void startElement(std::string const& name, AttributeList const& attrs) { return startElement("", name, attrs); }

  /**
   * @brief Start an XML element
   *
   * Start an XML element with given name, no attributes and in given namespace
   *
   * @param name Name of the element
   * @param namespacePrefix Namespace used, repesented as its prefix (default namespace is "")
   */
  void startElement(std::string const& namespacePrefix, std::string const& name) { return startElement(namespacePrefix, name, AttributeList()); }


  /**
   * @brief Start an XML element
   *
   * Start an XML element with given name, attributes and in given namespace
   *
   * @param name Name of the element
   * @param attrs List of the element's attributes
   * @param namespacePrefix Namespace used, repesented as its prefix (default namespace is "")
   */
  virtual void startElement(std::string const& namespacePrefix, std::string const& name, AttributeList const& attrs) = 0;

  /**
   * @brief End the current XML element
   */
  virtual void endElement() = 0;

  /**
   * @brief Write characters in the element
   *
   * @param chars Characters to write in the element
   */
  virtual void characters(std::string const& chars) = 0;

public:
  static Formatter* newFormatter(std::ostream& out, std::string const& defaultNamespace = "",
      std::string const& indentation = "  ", const std::string& encoding = "ISO-8859-1");
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
