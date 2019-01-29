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
 * @file Attributes.cpp
 * @brief Attributes : implementation file
 *
 */

#include <xml/sax/parser/Attributes.h>

#include <sstream>

namespace xml {
namespace sax {
namespace parser {

std::string
Attributes::SearchedAttribute::make_message(std::string const& name, boost::bad_lexical_cast const& e, std::string const& prefix) {
  std::ostringstream stream;
  stream << "error while parsing " << prefix << name <<": "<< e.what();
  return stream.str();
}

Attributes::SearchedAttribute
Attributes::operator[] (parser::Attributes::name_type const& id) const {
  return SearchedAttribute( id, find(id) );
}




template <>
Attributes::SearchedAttribute::operator double() const {
  if (!value) throw std::runtime_error("no value for double required attribute "+name);
  try {
    return boost::lexical_cast<double>(*value);
  } catch (boost::bad_lexical_cast const& e) {
    throw std::runtime_error( make_message(name, e) );
  }
}

template <>
Attributes::SearchedAttribute::operator int() const {
  if (!value) throw std::runtime_error("no value for integer required attribute "+name);
  try {
    return boost::lexical_cast<int>(*value);
  } catch (boost::bad_lexical_cast const& e) {
    throw std::runtime_error( make_message(name, e) );
  }
}

template <>
Attributes::SearchedAttribute::operator bool () const {
  if (!value) throw std::runtime_error("no value for required bool attribute "+name);
  return (*value=="true");
}

template <>
Attributes::SearchedAttribute::operator boost::optional<bool> () const {
  if (!value) return boost::none;
  return (*value=="true");
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
