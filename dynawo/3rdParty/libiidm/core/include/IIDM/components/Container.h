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
 * @file components/Container.h
 * @brief inheriting from Container grants the capability to hold a kind of Identifiable
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_CONTAINER_H
#define LIBIIDM_COMPONENTS_GUARD_CONTAINER_H

#include <IIDM/Export.h>
#include <IIDM/BasicTypes.h>
#include <IIDM/components/Identifiable.h>

#include <IIDM/components/ContainedIn.h>

#include <IIDM/utils/linked_map.h>

#include <IIDM/cpp11_type_traits.h>

namespace IIDM {

/**
 * @brief allows an inheriting class to contains Identifiable-Like.
 * @tparam T type of contained objects. T shall have a member function "id_type id() const" and inherit from ContainedIn.
 * add is only protected, to allow public inheritance (which is required to set the parent)
 */
template <typename T>
class IIDM_EXPORT Contains {
private:
  typedef linked_map<id_type, T> contents_type;
  contents_type contents;

public:
  ///type of the contained objects
  typedef T value_type;

  ///iterator on value_type constants
  typedef typename contents_type::const_iterator const_iterator;
  ///iterator on value_type
  typedef typename contents_type::iterator iterator;

  ///unsigned integral type used to represent number of contained object
  typedef typename contents_type::size_type size_type;

public:
  ///tells if this container is empty
  bool empty() const { return contents.empty(); }

  ///tells the number of contained objects
  size_type size() const { return contents.size(); }

  /**
   * @brief search an object by its id.
   *
   * Gets a const_iterator to object bound to the given id.
   * @returns the iterator to the object if found, end() otherwise.
   */
  const_iterator find(id_type const& id) const { return contents.find(id); }

  /**
   * @brief search an object by its id.
   *
   * Gets an iterator to object bound to the given id.
   * @returns the iterator to the object if found, end() otherwise.
   */
  iterator find(id_type const& id) { return contents.find(id); }
  
  /**
   * @brief search an object by its id.
   *
   * Gets a reference to object bound to the given id.
   * @returns an optional constant reference, or boost::none if no bound object is found.
   */
  value_type const& get(id_type const& id) const { return contents.get(id); }

  /**
   * @brief search an object by its id.
   *
   * Gets a reference to object bound to the given id.
   * @returns an optional reference, or boost::none if no bound object is found.
   */
  value_type & get(id_type const& id) { return contents.get(id); }

  ///tells if an object exists with the given id
  bool exists(id_type const& id) const { return contents.contains(id); }

  ///gets an iterator to the first of the contained objects.
  const_iterator begin() const { return contents.begin(); }

  ///gets an iterator to the end of the contained objects.
  const_iterator end() const { return contents.end(); }

  ///gets an iterator to the first of the contained objects.
  iterator begin() { return contents.begin(); }

  ///gets an iterator to the end of the contained objects.
  iterator end() { return contents.end(); }

protected:
  /**
   * @brief adds an object
   *
   * adds a copy of the given object into this container, if its id is not already used.
   *
   * @param c the object to add
   * @returns a reference to the added object
   */
  value_type& add(value_type const& c) {
    std::pair<iterator, bool> result = contents.insert(c.id(), c);
    if (!result.second) throw std::runtime_error("rejected: id already present: '" + c.id() + "'");
    return become_parent_of( *result.first );
  }

public:
  virtual ~Contains() {}

protected:
  Contains() {}

public:
  Contains& operator=(Contains other) {
    std::swap(contents, other.contents);
    return *this;
  }

  Contains(Contains const& other): contents(other.contents) {
    //attach the copied elements to this.
    for (iterator it = contents.begin(); it != contents.end(); ++it) {
      become_parent_of(*it);
    }
  }

  #if __cplusplus >= 201103L
  /** move constructor */
  Contains(Contains && other): contents(other.contents) {
    //attach the newly contained elements to this.
    for (iterator it = contents.begin(); it != contents.end(); ++it) {
      become_parent_of(*it);
    }
  }
  #endif

private:
  value_type& become_parent_of(value_type& child) {
    child.setParent( static_cast<typename value_type::parent_type&>(*this) );
    return child;
  }
  
};

} // end of namespace IIDM

#endif

