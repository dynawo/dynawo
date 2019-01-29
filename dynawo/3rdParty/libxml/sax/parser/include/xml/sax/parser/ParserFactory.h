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
 * @file ParserFactory.h
 * @brief XML parser description : header file
 *
 */

#ifndef XML_SAX_PARSER_GUARD_PARSERFACTORY_H
#define XML_SAX_PARSER_GUARD_PARSERFACTORY_H

#include <xml/sax/parser/Parser.h>
#include <xml/pointers.h>

namespace xml {
namespace sax {
namespace parser {

class Parser;

typedef XML_OWNER_PTR<Parser> ParserPtr; /**< smart pointer to Parser object. unique_ptr if available, auto_ptr otherwise. **/

/**
 * @brief XML SAX parser factory
 *
 * Creates sax parsers for xml document.
 */
class ParserFactory {
public:
  ParserFactory();
  
  ~ParserFactory();

  //this inline methode allows library users to chose if they are using C++11 or boost pointers.
  /**
   * @brief Creates a sax Parser suitable for xml documents.
   *
   * @returns pointer to the created Parser instance.
   */
  ParserPtr createParser() const { return ParserPtr(newParser()); }

private:
  /**
   * @brief allocates a new parser.
   */
  Parser* newParser() const;
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
