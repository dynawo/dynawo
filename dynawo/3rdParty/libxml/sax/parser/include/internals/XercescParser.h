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
 * @file XercescParser.h
 * @brief XML Xerces c++ parser description : header file
 *
 */

#ifndef XML_SAX_PARSER_XERCESCPARSER_H
#define XML_SAX_PARSER_XERCESCPARSER_H

#include <string>
#include <vector>

#include <xercesc/framework/XMLGrammarPool.hpp>

#include <xml/sax/parser/Parser.h>
#include <xml/cpp11.h>
#include <xml/pointers.h>

namespace xml {
namespace sax {
namespace parser {

/**
 * @class XercescParser
 * @brief XML SAX parser implemented class using XercesC++
 *
 * XercescParser uses XercesC++ library to parse XML file
 */
class XercescParser : public Parser {
public:
  /**
   * @brief Constructor
   *
   * Creates a Parser which will parse given file.
   *
   * @param handler Events handler for parsing
   * @returns Created XercescParser instance.
   */
  XercescParser();

  /**
   * @brief Destructor
   */
  virtual ~XercescParser();

  /**
   * @copydoc Parser::parse(std::string const&, DocumentHandler &, bool)
   */
  virtual void parse(std::string const& filePath, DocumentHandler & handler, bool xsdCheck = false) XML_OVERRIDE;

  /**
   * @copydoc Parser::parse(std::istream &, DocumentHandler &, bool)
   */
  virtual void parse(std::istream & inputStream, DocumentHandler & handler, bool xsdCheck = false) XML_OVERRIDE;


  /**
   * @copydoc Parser::addXmlSchema(std::string const&)
   */
  virtual std::string addXmlSchema(std::string const& schemaPath) XML_OVERRIDE;


private:
  class XercesHandler;
  void parse(std::istream&, XercesHandler &, bool xsdCheck = false);

  XML_OWNER_PTR<xercesc::XMLGrammarPool> grammarPool_;  /**< Grammar pool for schema validation **/
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
