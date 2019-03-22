//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libiidm, a library to model IIDM networks and allows
// importing and exporting them to files.
//

/**
 * @file components/Identifiable.cpp
 * @brief Identifiable implementation file
 */
#include <IIDM/components/Identifiable.h>
#include <IIDM/cpp11.h>

#include <sstream>
#include <stdexcept>

namespace IIDM {

/* property management */

std::string
Identifiable::value_of(property_id_type const& property) const {
  properties_type::const_iterator it = m_properties.find(property);
  if ( it != m_properties.end() ) {
    return it->second;
  }
  else {
    std::ostringstream msg;
    msg<<" Property name: "<<property <<" does not exist.";
    throw std::runtime_error( msg.str() );
  }
}

boost::optional<std::string>
Identifiable::find_property(property_id_type const& property) const {
  properties_type::const_iterator it = m_properties.find(property);
  return it != m_properties.end() ? boost::make_optional(it->second) : boost::none;
}

std::string
Identifiable::find_property(property_id_type const& property, std::string const& defaultValue) const {
  boost::optional<std::string> const& value = find_property(property);
  return value.value_or(defaultValue);
}

void
Identifiable::configure(property_id_type const& property, std::string const& value) {
  std::pair<properties_type::const_iterator, bool> insertion = m_properties.insert(
    properties_type::value_type(property, value)
  );

  if (!insertion.second) {
    std::stringstream msg;
    msg<<" Property name: "<<property <<" already exist.";
    throw std::runtime_error( msg.str() );
  }
}



/* extension management */

bool Identifiable::has_extension(extension_id_type const& name) const { return find_extension(name); }

void Identifiable::setExtension(extension_id_type const& name, Extension* e) {
  Extension* & target = m_extensions[name];
  delete target;
  target = e;
}

Extension*
Identifiable::find_extension(extension_id_type const& name) {
  extensions_type::iterator it = m_extensions.find(name);
  return (it != m_extensions.end()) ? it->second : IIDM_NULLPTR;
}


Extension const*
Identifiable::find_extension(extension_id_type const& name) const {
  extensions_type::const_iterator it = m_extensions.find(name);
  return (it != m_extensions.end()) ? it->second : IIDM_NULLPTR;
}

/* ************ constructoers ************ */

Identifiable::Identifiable(Identifier const& id, properties_type const& properties): m_id(id), m_properties(properties) {}


Identifiable::Identifiable(Identifiable const& other): m_id(other.m_id), m_properties(other.m_properties) {
  for (extensions_type::const_iterator it = other.m_extensions.begin(); it != other.m_extensions.end(); ++it) {
    m_extensions[it->first] = it->second->clone().release();
  }
}

Identifiable::~Identifiable() {
  for (extensions_type::iterator it = m_extensions.begin(); it != m_extensions.end(); ++it) {
    delete it->second;
  }
}


Identifiable& Identifiable::operator=(Identifiable other) {
  swap(other);
  return *this;
}

Identifiable& Identifiable::swap(Identifiable & other) {
  using std::swap;
  swap(m_id, other.m_id);
  swap(m_properties, other.m_properties);
  swap(m_extensions, other.m_extensions);
  return *this;
}


} // end of namespace IIDM
