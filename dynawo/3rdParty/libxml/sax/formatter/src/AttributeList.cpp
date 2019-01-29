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
 * @file AttributeList.cpp
 * @brief XML attribute list description : implementation file
 *
 */

#include <xml/sax/formatter/AttributeList.h>

namespace xml {
namespace sax {
namespace formatter {

// inserts an attribute if it is not already present
AttributeList& AttributeList::add(std::string const& name, std::string const& value) {
  if (as_map().emplace(name, value).second == false) {
    throw std::runtime_error("Can't change value of attribute "+name);
  }
  return *this;
}

// updates or inserts an attribute
AttributeList& AttributeList::set(std::string const& name, std::string const& value) {
  search_iterator it = as_map().find(name);
  if (it==as_map().end()) {
    as_list().emplace_back(name, value);
  } else {
    as_map().replace(it, attribute(name, value));
  }
  return *this;
}



AttributeList& AttributeList::remove(std::string const& name) {
  as_map().erase(name);
  return *this;
}



/**
 * @brief Clear the attribute list
 */
void AttributeList::clear() { m_values.clear(); }


  

AttributeList::const_iterator AttributeList::begin() const {
  return as_list().begin();
}

AttributeList::const_iterator AttributeList::end() const {
  return as_list().end();
}


} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
