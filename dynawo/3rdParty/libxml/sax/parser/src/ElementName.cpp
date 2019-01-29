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
 * @file ElementName.cpp
 * @brief ElementName : implementation file
 *
 */

#include <xml/sax/parser/ElementName.h>

#include <boost/tokenizer.hpp>
  
namespace xml {
namespace sax {
namespace parser {

namespace ns {

uri const empty;

XmlPath uri::operator() (std::string const& element_sequence) const {
  XmlPath path;
  
  typedef boost::tokenizer<boost::char_separator<char> > tokenizer;
  tokenizer tokens(element_sequence, boost::char_separator<char>("/") );
  
  for (tokenizer::iterator it = tokens.begin(); it != tokens.end(); ++it) {
    path += ElementName(*this, *it);
  }
  
  return path;
}

} // end of namespace xml::sax::parser::ns::

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
