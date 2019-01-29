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
 * @file ElementName.h
 * @brief ElementName definition
 */

#ifndef LIBXML_SAX_PARSER_GUARD_ELEMENTNAME_H
#define LIBXML_SAX_PARSER_GUARD_ELEMENTNAME_H

#include <string>
#include <iosfwd>

#include <xml/sax/parser/Path.h>
#include <boost/operators.hpp>

namespace xml {
namespace sax {
namespace parser {

class ElementName;

/**
 * @brief a XmlPath is a sequence of ElementName
 */
typedef path<ElementName> XmlPath;

namespace ns {
/// the type of namespace identifiers
// having a wrapper around a string permits to define operator without polluting std::string
class uri: public boost::totally_ordered<uri> {
private:
  std::string m_uri;
public:
  uri(): m_uri() {}
  uri(std::string const& uri): m_uri(uri) {}
  
  std::string const& name() const { return m_uri; }
  operator std::string const& () const { return m_uri; }

  /**
   * @brief constructs a path by applying this namespace to each element of the sequence
   * @param element_sequence the sequence to apply on. elements are separated by '/'
   */
  XmlPath operator() (std::string const& element_sequence) const;
  
  int compare(uri const& other) const { return m_uri.compare(other.m_uri); }
};

inline bool operator == (uri const& a, uri const& b) { return a.name() == b.name(); }
inline bool operator <  (uri const& a, uri const& b) { return a.name() < b.name(); }

/**
 * @brief empty namespace uri.
 * 
 * An empty namespace uri to be used on instead of uri default constructor.
 */
extern uri const empty;

inline std::ostream& operator<<(std::ostream& stream, uri const& u) { return stream << u.name(); }

} // end of namespace xml::sax::parser::ns::


typedef ns::uri namespace_uri;


/**
 * @brief represents the full name of an xml element.
 */
class ElementName: public boost::totally_ordered<ElementName> {
public:
  /// the type of names
  typedef std::string name_type;

public:
  ElementName(name_type const& name): name(name), ns() {}

  ElementName(ns::uri const& ns, name_type const& name): name(name), ns(ns) {}

  name_type name;
  ns::uri ns;
  
  int compare(ElementName const& other) const {
    int tag_cmp = name.compare(other.name);
    if (tag_cmp!=0) return tag_cmp;
    return ns.compare(other.ns);
  }
};

inline bool operator== (ElementName const& a, ElementName const& b) { return a.name == b.name && a.ns == b.ns; }
inline bool operator < (ElementName const& a, ElementName const& b) { return a.compare(b) < 0; }



inline std::ostream& operator<<(std::ostream& stream, ElementName const& e) {
  return stream << e.ns << ':' << e.name;
}

inline XmlPath operator + (ElementName const& a, ElementName const& b) { return XmlPath(a)+=b; }

inline XmlPath operator + (ElementName::name_type const& a, ElementName const& b) { return XmlPath(ElementName(a))+=b; }

inline XmlPath operator + (ElementName const& a, ElementName::name_type const& b) { return XmlPath(a)+=ElementName(b); }

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif

