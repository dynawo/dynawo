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
 * @file AttributeList.h
 * @brief XML attribute list description : header file
 *
 */

#ifndef XML_SAX_FORMATTER_ATTRIBUTELIST_H
#define XML_SAX_FORMATTER_ATTRIBUTELIST_H

#include <string>
#include <map>

#include <boost/lexical_cast.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/optional.hpp>


#include <boost/multi_index_container.hpp>
#include <boost/multi_index/sequenced_index.hpp>
#include <boost/multi_index/ordered_index.hpp>
#include <boost/multi_index/member.hpp>



namespace xml {
namespace sax {
namespace formatter {

/**
 * @class AttributeList
 * @brief Class used to store a list of attributes
 *
 * An AttributeList instance can store attributes on multiple types.
 * The types available are those that allow a boost::lexical_cast<string>
 * conversion.
 */
class AttributeList {
public:
  struct attribute {
    std::string name;
    std::string value;
    attribute(std::string const& name, std::string const& value): name(name), value(value) {}
  };

private:
  // a container of attributes ordered both by name and by insertion order
  typedef boost::multi_index::multi_index_container<
    attribute,
    boost::multi_index::indexed_by<
      boost::multi_index::sequenced<>,
      boost::multi_index::ordered_unique<
        boost::multi_index::member<attribute, std::string, &attribute::name>
      >
    >
  > values_type;

  values_type m_values;


  // Typedefs for the sequence index and the ordered index
  enum { InsertionOrder, NameOrder };
  typedef values_type::nth_index<InsertionOrder>::type insertion_order_index;
  typedef values_type::nth_index<NameOrder>::type name_order_index;


  insertion_order_index & as_list() { return m_values.get<InsertionOrder>(); }
  insertion_order_index const& as_list() const { return m_values.get<InsertionOrder>(); }

  name_order_index & as_map() { return m_values.get<NameOrder>(); }
  name_order_index const& as_map() const { return m_values.get<NameOrder>(); }

  typedef insertion_order_index::const_iterator ordered_iterator;
  typedef name_order_index::const_iterator search_iterator;

public:
  typedef values_type::size_type size_type;
  typedef ordered_iterator const_iterator;

public:
  AttributeList() {}

  template <typename V>
  AttributeList(std::string const& name, V const& value) {set(name, value);}

  //build interface.

  template <typename V>
  AttributeList& operator() (std::string const& name, V const& value) {
    return set(name, value);
  }

  /**
   * @brief Adds or replace a string attribute into the attribute list
   *
   * @param name Name of the attribute
   * @param value Value of the attribute
   */
  AttributeList& set(std::string const& name, std::string const& value);

  /**
   * @brief Adds or replace a boolean attribute into the attribute list
   *
   * @param name Name of the attribute
   * @param value Value of the attribute
   */
  AttributeList& set(std::string const& name, bool value) {
    return set( name, std::string(value ? "true" : "false") );
  }

  /**
   * @brief Adds or replace an attribute of given type into the attribute list
   *
   * @param name Name of the attribute
   * @param value Value of the attribute
   */
  template<typename V>
  AttributeList& set(std::string const& name, V const& value) {
    return set(name, boost::lexical_cast<std::string>(value));
  }

  /**
   * @brief Adds or replace an optional attribute if it is defined into the attribute list
   *
   * @param name Name of the attribute
   * @param value Value of the attribute
   */
  template <typename V>
  AttributeList& set(std::string const& name, boost::optional<V> const& value) {
    return value ? set(name, *value) : remove(name);
  }


  /**
   * @brief Adds a string attribute into the attribute list
   *
   * @param name Name of the attribute
   * @param value Value of the attribute
   * @throw std::runtime_error if the attribute was already set
   */
  AttributeList& add(std::string const& name, std::string const& value);

  /**
   * @brief Adds a boolean attribute into the attribute list
   *
   * @param name Name of the attribute
   * @param value Value of the attribute
   * @throw std::runtime_error if the attribute was already set
   */
  AttributeList& add(std::string const& name, bool value) {
    return add( name, std::string(value ? "true" : "false") );
  }

  /**
   * @brief Adds an attribute of given type into the attribute list
   *
   * @param name Name of the attribute
   * @param value Value of the attribute
   * @throw std::runtime_error if the attribute was already set
   */
  template<typename V>
  AttributeList& add(std::string const& name, V const& value) {
    return add(name, boost::lexical_cast<std::string>(value));
  }

  /**
   * @brief Adds an optional attribute if it is defined into the attribute list
   *
   * @param name Name of the attribute
   * @param value Value of the attribute
   * @throw std::runtime_error if the attribute was already set
   */
  template <typename V>
  AttributeList& add(std::string const& name, boost::optional<V> const& value) {
    return value ? add(name, *value) : remove(name);
  }


  /**
   * @brief Remmoves an attribute.
   *
   * @param name Name of the attribute to remove
   */
  AttributeList& remove(std::string const& name);


  /**
   * @brief Clear the attribute list
   */
  void clear();


  //read interface.
  /**
   * @brief Counts the number of attributes in the attribute list
   *
   * @returns Number of attributes in the list
   */
  size_type size() const { return m_values.size(); }

  bool empty() const { return m_values.empty(); }

  const_iterator begin() const;
  const_iterator end() const;

};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
