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
 * @file FormatterException.h
 * @brief XML formatter exception description : header file
 *
 */

#ifndef XML_SAX_FORMATTER_EXCEPTION_H
#define XML_SAX_FORMATTER_EXCEPTION_H

#include <stdexcept>
#include <string>

namespace xml {
namespace sax {
namespace formatter {

/**
 * @class FormatterException
 * @brief Formatter SAX library typed exception
 */
class FormatterException : public std::runtime_error {
public:
  /**
   * @brief Default constructor
   */
  FormatterException();

  /**
   * @brief constructor
   *
   * @param message : exception message
   */
  FormatterException(std::string const& message);

  /**
   * @brief Destructor
   */
  virtual ~FormatterException() throw();
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
