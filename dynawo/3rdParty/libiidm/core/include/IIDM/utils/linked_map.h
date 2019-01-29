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
 * @file utils/linked_map.h
 * @brief map keeping insertion order.
 */

#ifndef LIBIIDM_UTILS_GUARD_VECTOR_MAP_H
#define LIBIIDM_UTILS_GUARD_VECTOR_MAP_H


#if __cplusplus >= 201103L
#include <unordered_map>
#include <initializer_list>
#include <tuple>
#else
#include <map>
#endif
#include <list>
#include <iterator>

#include <IIDM/cpp11_type_traits.h>
#include <IIDM/Export.h>

namespace IIDM {

/**
 * @brief An associative container iterable in insertion order.
 * @tparam Key type of key.
 * @tparam Value type of attached value.
 */
template <typename Key, typename Value>
class IIDM_EXPORT linked_map {
private:
  /*
  according to std::list documentation:
  Addition, removal and moving the elements within the list or across several lists does not invalidate the iterators or references.
  An iterator is invalidated only when the corresponding element is deleted.
  */
  typedef std::list<Value> list_type;

  #if __cplusplus >= 201103L
  typedef std::unordered_map<Key, typename list_type::iterator> map_type;
  #else
  typedef std::map<Key, typename list_type::iterator> map_type;
  #endif

  map_type map;
  list_type list;

public:
  typedef Value value_type;
  typedef Key key_type;

  typedef typename map_type::value_type map_value_type;

  typedef typename list_type::size_type size_type;

  typedef typename list_type::const_iterator const_iterator;
  typedef typename list_type::iterator iterator;
  typedef typename list_type::const_reverse_iterator const_reverse_iterator;
  typedef typename list_type::reverse_iterator reverse_iterator;

public:
  #if __cplusplus < 201103L
  linked_map(): map(), list() {}
  #else
  linked_map() = default;

  ~linked_map() = default;
  #endif

  linked_map(linked_map const& other): list(other.list) {
    const const_iterator other_begin = other.list.begin();
    for (typename map_type::const_iterator it = other.map.begin(); it != other.map.end(); ++it) {
      iterator target_it = list.begin();
      std::advance(target_it, std::distance(other_begin, const_iterator(it->second)));
      
      map.insert( map_value_type(it->first, target_it) );
    }
  }

  #if __cplusplus >= 201103L
  /** move constructor */
  linked_map(linked_map && other): linked_map() { swap(*this, other); }
  #endif

  linked_map& operator=(linked_map other) {
    swap(*this, other);
    return *this;
  }

  friend void swap(linked_map& a, linked_map& b) IIDM_NOEXCEPT {
    using std::swap;
    swap(a.map, b.map);
    swap(a.list, b.list);
  }

  //extra constructors:
  template<typename InputIterator>
  linked_map(InputIterator first, InputIterator last): map(), list() {
    insert(first, last);
  }

  #if __cplusplus >= 201103L
  linked_map(std::initializer_list<value_type> values): linked_map(values.begin(), values.end()) {}

  linked_map& operator=(std::initializer_list<map_value_type> values) {
    return *this = linked_map(std::move(values));
  }
  #endif

//reading interface
public:
  /**
   * @brief Checks if this container has no elements.
   *
   * @returns `true` if the container is empty, `false` otherwise
   */
  bool empty() const IIDM_NOEXCEPT { return list.empty(); }

  /**
   * @brief Returns the number of elements in the container.
   *
   * Returns the number of elements in the container, i.e. `std::distance(begin(), end())`.
   *
   * @returns The number of elements in the container.
   */
  size_type size() const IIDM_NOEXCEPT { return list.size(); }

  /**
   * @brief Checks if this container has a value for a specific key.
   *
   * @param key the key to search for
   * @returns `true` if the container contains a value for the specified key, `false` otherwise
   */
  bool contains(key_type const& key) const IIDM_NOEXCEPT { return map.find(key) != map.end(); }


  /**
   * @brief search the value associated to a given key.
   *
   * @param key the key to search for
   * @returns the constant iterator to the associated value, or `end()` if not found.
   */
  const_iterator find(key_type const& key) const IIDM_NOEXCEPT {
    typename map_type::const_iterator it = map.find(key);
    return it != map.end() ? it->second : end();
  }

  /**
   * @brief search the value associated to a given key.
   *
   * @param key the key to search for
   * @returns the iterator to the associated value, or `end()` if not found.
   */
  iterator find(key_type const& key) IIDM_NOEXCEPT {
    typename map_type::iterator it = map.find(key);
    return it != map.end() ? it->second : end();
  }

  /**
   * @brief search the value associated to a given key.
   *
   * @param key the key to search for
   * @returns the iterator to the associated value, or `end()` if not found.
   */
  const_iterator operator() (key_type const& key) const IIDM_NOEXCEPT { return find(key); }

  /**
   * @brief search the value associated to a given key.
   *
   * @param key the key to search for
   * @returns the iterator to the associated value, or `end()` if not found.
   */
  iterator operator() (key_type const& key) IIDM_NOEXCEPT { return find(key); }

  /**
   * @brief search the object associated to a given key.
   * @param key the key to search for
   *
   * @returns the constant reference to the designated object.
   * @throws `std::range_error` when key as no binding.
   */
  value_type const& get(key_type const& key) const {
    const_iterator it = find(key);
    if (it == end()) throw std::range_error("unknown key: " + key);
    return *it;
  }

  /**
   * @brief search the object associated to a given key.
   * @param key the key to search for
   *
   * @returns the reference to the designated object.
   * @throws `std::range_error` when key as no binding.
   */
  value_type& get(key_type const& key) {
    iterator it = find(key);
    if (it == end()) throw std::range_error("unknown key: " + key);
    return *it;
  }

  /**
   * @brief search the object associated to a given key.
   * @param key the key to search for
   *
   * @returns the constant reference to the designated object.
   * @throws `std::range_error` when key as no binding.
   */
  value_type const& operator[] (key_type const& key) const { return get(key); }

  /**
   * @brief search the object associated to a given key.
   * @param key the key to search for
   *
   * @returns the reference to the designated object.
   * @throws `std::range_error` when key as no binding.
   */
  value_type& operator[] (key_type const& key) { return get(key); }

//modifing interface
public:
  /**
   * removes all values from this container.
   */
  void clear() IIDM_NOEXCEPT { map.clear(); list.clear(); }

  /**
   * @brief Removes the value bound to a given key
   * @param key the key to erase
   *
   * @returns `true` if a value was removed, `false otherwise`
   */
  bool erase(key_type const& key) {
    typename map_type::iterator it = map.find(key);
    if (it != map.end()) {
      list.erase(it->second);
      map.erase(it);
      return true;
    }
    return false;
  }

  /**
   * @brief Binds a value to a given key, if not already set
   * @param key the key of the value to set.
   * @param value the value of the new element.
   * @returns a pair with the iterator to the value at the given key and a boolean with value `true` if insertion took place, and `false` otherwise.
   */
  std::pair<iterator, bool> insert(key_type const& key, value_type const& value) {
    return do_insert(key, value, false);
  }

  /**
   * @brief Sets the value bound to a given key, inserting an element if needed.
   * @param key the key to insert the element at.
   * @param value the value of the element.
   * @returns a pair with the iterator to the value at the given key and a boolean with value `true` if insertion took place, and `false` otherwise.
   */
  std::pair<iterator, bool> set(key_type const& key, value_type const& value) {
    return do_insert(key, value, true);
  }

  /**
   * @brief Sets the value bound to a given key, inserting an element if needed.
   * @param key the key to insert the element at.
   * @param value the value of the element.
   * @returns a pair with the iterator to the value at the given key and a boolean with value `true` if insertion took place, and `false` otherwise.
   */
  std::pair<iterator, bool> insert_or_assign(key_type const& key, value_type const& value) {
    return set(key, value);
  }

  /**
   * @brief Tries to insert a range of elements.
   *
   * @tparam InputIterator input iterator pointing to pairs of key, value. (it->first is key_type, it->second is value_type)
   *
   * @param  first Iterator pointing to the start of the range to be inserted.
   * @param  last Iterator pointing to the end of the range.
   *
   *  Complexity similar to that of the range constructor.
   */
  template<typename InputIterator>
  void insert(InputIterator first, InputIterator last) {
    for(; first != last; ++first) {
      insert(first->first, first->second);
    }
  }

  #if __cplusplus >= 201103L
  /**
   * @brief inserts an element
   * @tparam V the types of arguments to use to construct the value
   * @param key the key to insert the element at.
   * @param values the arguments to use to construct the inserted value.
   * @returns a pair with the iterator to the value at the given key and a boolean with value `true` if insertion took place, and `false` otherwise.
   */
  template<typename... V, typename = typename std::enable_if<std::is_constructible<value_type, V&&...>::value>::type>
  std::pair<iterator, bool> insert(key_type const& key, V&&... values) {
    return do_insert(key, std::forward<V>(values)..., false);
  }

  /**
   * @brief inserts an element
   * @tparam V the types of arguments to use to construct the value
   * @param key the key to insert the element at.
   * @param values the value of the element.
   * @returns a pair with the iterator to the value at the given key and a boolean with value `true` if insertion took place, and `false` otherwise.
   */
  template<typename... V, typename = typename std::enable_if<std::is_constructible<value_type, V&&...>::value>::type>
  std::pair<iterator, bool> insert(key_type && key, V&&... values) {
    return do_insert(key, std::forward<V>(values)..., false);
  }

  /**
   *  @brief Tries to insert a list of std::pairs.
   *  @param values An initializer of pairs to be inserted.
   *
   *  Complexity similar to that of the range constructor.
   */
  void insert(std::initializer_list<map_value_type> values) { insert(values.begin(), values.end()); }

  /**
   * @brief inserts an element, inserting an element if needed.
   * @tparam V the types of arguments to use to construct the value
   * @param key the key to insert the element at.
   * @param values the arguments to use to construct the inserted value.
   * @returns a pair with the iterator to the value at the given key and a boolean with value `true` if insertion took place, and `false` otherwise.
   */
  template <class... V>
  std::pair<iterator, bool> set(key_type const& key, V&&... values) {
    return do_insert(key, std::forward<V>(values)..., true);
  }

  /**
   * @brief inserts an element, inserting an element if needed.
   * @tparam V the types of arguments to use to construct the value
   * @param key the key to insert the element at.
   * @param values the arguments to use to construct the inserted value.
   * @returns a pair with the iterator to the value at the given key and a boolean with value `true` if insertion took place, and `false` otherwise.
   */
  template <class... V>
  std::pair<iterator, bool> set(key_type&& key, V&&... values) {
    return do_insert(std::forward<key_type>(key), std::forward<V>(values)..., true);
  }

  /**
   * @brief inserts an element, inserting an element if needed.
   * @tparam V the types of arguments to use to construct the value
   * @param key the key to insert the element at.
   * @param values the arguments to use to construct the inserted value.
   * @returns a pair with the iterator to the value at the given key and a boolean with value `true` if insertion took place, and `false` otherwise.
   */
  template <class... V>
  std::pair<iterator, bool> insert_or_assign(key_type const& key, V&&... values) {
    return set(key, std::forward<V>(values)...);
  }

  /**
   * @brief inserts an element, inserting an element if needed.
   * @tparam V the types of arguments to use to construct the value
   * @param key the key to insert the element at.
   * @param values the arguments to use to construct the inserted value.
   * @returns a pair with the iterator to the value at the given key and a boolean with value `true` if insertion took place, and `false` otherwise.
   */
  template <class... V>
  std::pair<iterator, bool> insert_or_assign(key_type&& key, V&&... values) {
    return set(std::forward<key_type>(key), std::forward<V>(values)...);
  }
  #endif

//iterators interface
public:

  ///gets an constant iterator to the first of the contained objects.
  const_iterator cbegin() const IIDM_NOEXCEPT { return list.begin(); }

  ///gets an constant iterator to the end of the contained objects.
  const_iterator cend() const IIDM_NOEXCEPT { return list.end(); }

  ///gets an constant iterator to the first of the contained objects.
  const_iterator begin() const IIDM_NOEXCEPT { return cbegin(); }

  ///gets an constant iterator to the end of the contained objects.
  const_iterator end() const IIDM_NOEXCEPT { return cend(); }

  ///gets an iterator to the first of the contained objects.
  iterator begin() IIDM_NOEXCEPT { return list.begin(); }

  ///gets an iterator to the end of the contained objects.
  iterator end() IIDM_NOEXCEPT { return list.end(); }

  ///gets a constant reverse iterator to the first of the contained objects.
  const_reverse_iterator crbegin() const IIDM_NOEXCEPT { return list.rbegin(); }

  ///gets a constant reverse iterator to the end of the contained objects.
  const_reverse_iterator crend() const IIDM_NOEXCEPT { return list.rend(); }

  ///gets a constant reverse iterator to the first of the contained objects.
  const_reverse_iterator rbegin() const IIDM_NOEXCEPT { return crbegin(); }

  ///gets a rconstant everse iterator to the end of the contained objects.
  const_reverse_iterator rend() const IIDM_NOEXCEPT { return crend(); }

  ///gets a reverse iterator to the first of the contained objects.
  reverse_iterator rbegin() IIDM_NOEXCEPT { return list.rbegin(); }

  ///gets a reverse iterator to the end of the contained objects.
  reverse_iterator rend() IIDM_NOEXCEPT { return list.rend(); }

private:
  ///returns iterator to value and true if inserted, false if replaced
  std::pair<iterator, bool> do_insert(key_type const& key, value_type const& value, bool override) {
    std::pair<typename map_type::iterator, bool> result = map.insert( map_value_type(key, list.end()) );
    if (result.second) {
      list.push_back(value);
      result.first->second = --list.end();
    } else {
      if (override) {
        *result.first->second = value;
      }
    }
    return std::pair<iterator, bool>(result.first->second, result.second);
  }

  #if __cplusplus >= 201103L
  ///returns iterator to value and true if inserted, false if replaced
  template <typename... Args>
  std::pair<iterator, bool> do_insert(key_type && key, Args&&... values, bool override) {
    auto result = map.emplace(key, list.end());
    if (result.second) {
      list.emplace_back(values...);
      result.first->second = --list.end();
    } else {
      if (override) {
        *result.first->second = {values...};
      }
    }
    return std::pair<iterator, bool>(result.first->second, result.second);
  }
  #endif
};

} // end of namespace IIDM

#endif
