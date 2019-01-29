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
 * @file ParserException.h
 * @brief XML parser exception description : header file
 *
 */

#ifndef XML_SAX_PARSER_GUARD_PARSEREXCEPTION_H
#define XML_SAX_PARSER_GUARD_PARSEREXCEPTION_H

#include <exception>
#include <string>

namespace xml {
namespace sax {
namespace parser {

/**
 * @brief Parser SAX library typed exception
 */
class ParserException : virtual public std::exception {
  public:
    /**
     * @brief Default constructor
     */
    ParserException();
    
    /**
     * @brief constructor
     *
     * @param message : exception message
     * @param parsedFile : file parsed when the exception occurs
     * @param line : line where the exception occurs
     */
    ParserException(const std::string& message,const std::string& parsedFile="",int line=0);
    
    /**
     * @brief Destructor
     */
    virtual ~ParserException() throw();
    
    /**
     * @brief return exception message
     */
    virtual const char* what() const throw();

  private:
    std::string message_; ///< exception message
    std::string parsedFile_; ///< file parsed when the exception occurs
    int line_; ///< line in the file where the exception occurs
    std::string msgstring_; ///< complete exception message
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
