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
 * @file Parser.h
 * @brief XML parser description : header file
 *
 */

#ifndef XML_SAX_PARSER_GUARD_PARSER_H
#define XML_SAX_PARSER_GUARD_PARSER_H

#include <string>
#include <iosfwd>

namespace xml {
namespace sax {
namespace parser {

class DocumentHandler;

/**
 * @brief XML SAX parser interface class
 *
 * Parser objects allow to parse an XML file
 */
class Parser {
public:
  /**
   * @brief Destructor
   */
  virtual ~Parser();

  /**
   * @brief Parsing method
   *
   * Parses given file. Can also check xsd schema validity.
   *
   * @param filePath File to parse path
   * @param handler The new handler to use
   * @param xsdCheck If set to 'true', check schema validity
   */
  virtual void parse(std::string const& filePath, DocumentHandler & handler, bool xsdCheck = false) = 0;

  /**
   * @brief Parsing method
   *
   * Parses given stream. Can also check xsd schema validity.
   *
   * @param inputStream Stream to parse
   * @param handler The new handler to use
   * @param xsdCheck If set to 'true', check schema validity
   */
  virtual void parse(std::istream & inputStream, DocumentHandler & handler, bool xsdCheck = false) = 0;

  /**
   * @brief adds an xml schema to the parser
   *
   * @param schemaPath path to the file containing the schema
   * @returns the namespace target of the schema
   */
  virtual std::string addXmlSchema(std::string const& schemaPath) = 0;
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
