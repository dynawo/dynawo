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
 * @file Attributes.h
 * @brief Attributes definition
 */

#ifndef LIBXML_SAX_PARSER_GUARD_ATTRIBUTES_H
#define LIBXML_SAX_PARSER_GUARD_ATTRIBUTES_H

#include <xml/sax/parser/Attributes_fwd.h>

#include <xml/sax/parser/ParserException.h>

#include <xml/cpp11.h>

#include <boost/lexical_cast.hpp>
#include <boost/optional.hpp>

#include <string>
#include <map>
#include <stdexcept>


/**
 * @brief the global namespace of libXML
 */
namespace xml {
/**
 * @brief the namespace for XML SAX
 */
namespace sax {
/**
 * @brief the namespace for XML SAX parser
 */
namespace parser {

class Attributes {
public:
  /// the type used as name of xml attributes
  typedef std::string name_type;

  /// the basic value type of xml attributes
  typedef std::string value_type;

private:
  typedef std::map<name_type, value_type> attributes_type;

  attributes_type attributes;

public:
  Attributes& set(name_type const& name, value_type const& value) { attributes[name] = value; return *this; }

  bool has(name_type const& name) const { return attributes.count(name) != 0; }

  template <typename T>
  T get(name_type const& name) const {
    attributes_type::const_iterator it = attributes.find(name);
    if ( it == attributes.end() ) {
      throw ParserException("missing attribute " + name);
    }
    try {
      return boost::lexical_cast<T>(it->second);
    } catch (boost::bad_lexical_cast const& e) {
      throw ParserException("bad value for "+name+" :"+e.what());
    }
  }

  // returns true if name was found and its value stored into value.
  template <typename T>
  bool get(name_type const& name, T & value) const {
    attributes_type::const_iterator it = attributes.find(name);
    if ( it == attributes.end() ) return false;

    //does not throw, unlike lexical_cast
    return boost::conversion::try_lexical_convert(it->second, value);
  }
  
  class SearchedAttribute;
  
  SearchedAttribute operator[] (name_type const& id) const;

private:  
  value_type const* find(name_type const& name) const {
    attributes_type::const_iterator it = attributes.find(name);
    return ( it != attributes.end() ) ? &it->second : XML_NULLPTR;
  }

};


template <>
inline bool Attributes::get<bool>(name_type const& name, bool & value) const {
  attributes_type::const_iterator it = attributes.find(name);
  if (it == attributes.end()) return false;

  if (it->second == "true") {
    value = true;
  }
  else if (it->second == "false") {
    value = false;
  }
  else {
    value = boost::lexical_cast<bool>(it->second);
  }
  return true;
}


template <>
inline bool Attributes::get<bool>(name_type const& name) const {
  bool value;
  if (!get(name, value)) {
    throw ParserException("missing attribute " + name);
  }
  return value;
}





class Attributes::SearchedAttribute {
private:
  parser::Attributes::name_type const& name;
  parser::Attributes::value_type const* value;
public:
  explicit SearchedAttribute(parser::Attributes::name_type const& name, parser::Attributes::value_type const* value = 0): name(name), value(value) {}

  bool exists() const { return value; }
  
  parser::Attributes::value_type const& as_string() const {
    if (!value) throw std::runtime_error("no string value for attribute "+name);
    return *value;
  }
  
  operator parser::Attributes::value_type const& () const { return as_string(); }

  template<typename T>
  T as() const { return *this; }

  template<typename T>
  operator T () const {
    if (!value) throw std::runtime_error("no value for required attribute "+name);
    try {
      return boost::lexical_cast<T>(*value);
    } catch (boost::bad_lexical_cast const& e) {
      throw std::runtime_error( make_message(name, e) );
    }
  }

  template<typename T>
  operator boost::optional<T> () const {
    if (!value) return boost::none;
    try {
      return boost::lexical_cast<T>(*value);
    } catch (boost::bad_lexical_cast const& e) {
      throw std::runtime_error( make_message(name, e, "optional ") );
    }
  }
  
  //or overloads
  template<typename T>
  T operator | (T const& default_value) const;

private:
  static std::string make_message(std::string const& name, boost::bad_lexical_cast const& e, std::string const& prefix = "");
};

template <>
Attributes::SearchedAttribute::operator double() const;

template <>
Attributes::SearchedAttribute::operator int() const;

template <>
Attributes::SearchedAttribute::operator bool () const;

template <>
Attributes::SearchedAttribute::operator boost::optional<bool> () const;


//NOTE: specialisation of cast operators must be defined before uses of this operator.
template<typename T>
inline T Attributes::SearchedAttribute::operator | (T const& default_value) const {
  return !value ? default_value : as<T>();
}


} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif

