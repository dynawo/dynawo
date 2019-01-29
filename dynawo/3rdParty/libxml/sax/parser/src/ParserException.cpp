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

//======================================================================
/** 
 * @file ParserException.cpp
 * @brief XML parser exception description : implementation file
 *
 */
//======================================================================
#include <sstream>

#include <xml/sax/parser/ParserException.h>

namespace xml {
namespace sax {
namespace parser {

ParserException::ParserException():
  message_(""),
  parsedFile_(""),
  line_(-1),
  msgstring_("")
{}

ParserException::ParserException(std::string const& message, std::string const& parsedFile, int line):
  message_(message),
  parsedFile_(parsedFile),
  line_(line)
{
  std::stringstream msg;
  if (!parsedFile_.empty()) {
    msg << parsedFile_ << ':';
  }
  if (line_>0) {
    msg << line_ << ':';
  }
  msg << message_;

  msgstring_ = msg.str();
}


ParserException::~ParserException() throw() {}

const char*
ParserException::what() const throw() { return msgstring_.c_str(); }

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
