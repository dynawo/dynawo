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
 * @file PathTree.h
 * @brief path in an XML document (subset of XPath)
 *
 */

#ifndef XML_SAX_PARSER_GUARD_PATHTREE_H
#define XML_SAX_PARSER_GUARD_PATHTREE_H

#include <xml/cpp11.h>

#include <boost/optional.hpp>

#include <map>
#include <vector>
#include <iterator>

namespace xml {
namespace sax {
namespace parser {

/*
expected tree features:
insert at path

iterate along a path
  with path "/a/b/c", iterator preents @"/" @"/a" @"/a/b" @"/a/b/c"

iterate along a path
  with path "/a/b/c", iterator preents @"/a/b/c" @"/a/b" @"/a" @"/"
*/

template <typename Iter>
class iterator_range {
public:
  typedef Iter iterator;

  iterator_range() : m_begin(), m_end(m_begin) {}
  iterator_range(iterator const& begin, iterator const& end): m_begin(begin), m_end(end) {}

  iterator begin() const { return m_begin; }
  iterator end() const { return m_end; }

private:
  iterator m_begin, m_end;
};

template <typename C>
iterator_range<typename C::iterator> make_range(C & container) {
  return iterator_range<typename C::iterator>(container.begin(), container.end());
}

template <typename C>
iterator_range<typename C::const_iterator> make_range(C const& container) {
  return iterator_range<typename C::const_iterator>(container.begin(), container.end());
}

template <typename C>
iterator_range<typename C::const_iterator> make_const_range(C const& container) {
  return iterator_range<typename C::const_iterator>(container.begin(), container.end());
}
/**
 * @brief associative tree node.
 *
 * An associative tree is read through a key sequence or path.
 * pathes can be of any length, and there can or can not be several values at a given path.
 * a path is recognized as any iterable sequence of keys.
 * this class defines traversal functionality.
 *
 * path are shared, but some position in a given path may not be filled.
 *
 * the aim of the tree are:
 * * insert at path
 * * look at path
 * * iterate through path: iterate all elements under path. tree.find(path) returns an iterable sequence.
 *
 * @see associative_tree_node and associative_multitree_node
 */

//base node structure, has no value.
template <typename Key, typename CRTP_Node>
class associative_tree_node_base {
protected:
  typedef Key key_type;
  typedef CRTP_Node node;

  typedef std::map<key_type, node> children_type;
  typedef typename children_type::iterator child_iterator;
  typedef typename children_type::const_iterator const_child_iterator;

private:
  children_type m_children;
  //{
protected:
  associative_tree_node_base() {}

  //recursive copy
  associative_tree_node_base(node const& other): m_children(other.m_children) {}

#if __cplusplus >= 201103L
  //recursive move
  associative_tree_node_base(node && other): m_children(std::move(other.m_children)) {}
#endif

  ~associative_tree_node_base() {}


  node& operator=(node other) {
    swap(other);
    return *this;
  }

  void swap(associative_tree_node_base & other) {
    using std::swap;
    swap(m_children, other.m_children);
  }
  //}

public:
  node & make_child (key_type const& key) { return m_children[key]; }

  node const * find_child(key_type const& key) const {
    const_child_iterator there = m_children.find(key);
    return (there!=m_children.end()) ? &there->second : XML_NULLPTR;
  }

  node * find_child(key_type const& key) {
    child_iterator there = m_children.find(key);
    return (there!=m_children.end()) ? &there->second : XML_NULLPTR;
  }
};

template <typename Key, typename CRTP_Node>
inline void swap(associative_tree_node_base<Key, CRTP_Node>& a, associative_tree_node_base<Key, CRTP_Node>& b) { a.swap(b); }



/**
 * @brief .

 * @tparam Key the type of path elements
 * @tparam Value the type of values

 * there can't be value associated to the root elements (the unnamed one)
 */
template <typename Key, typename Node_Type>
class associative_tree_base {
public:
  typedef Key key_type;
  typedef Node_Type node;

private:
  node root;

public:
  template <typename KeySequence>
  node & make(KeySequence const& path) { insert(path.begin(), path.end()); }

  template <typename KeyIterator>
  node & make(KeyIterator path_start, KeyIterator path_end) {
    node * insertion_point = &root;
    for ( ; path_start!=path_end; ++path_start) {
      insertion_point = &insertion_point->make_child(*path_start);
    }
    return *insertion_point;
  }


  template <typename KeySequence>
  node const* search(KeySequence const& path) const { return search(path.begin(), path.end()); }

  template <typename KeyIterator>
  node const* search(KeyIterator path_start, KeyIterator path_end) const {
    node const* target = &root;
    for ( ; target && path_start!=path_end; ++path_start) {
      target = target->find_child(*path_start);
    }
    return target;
  }

};







template <typename Key, typename Value>
class associative_tree_node: public associative_tree_node_base<Key, associative_tree_node<Key, Value> > {
protected:
  typedef associative_tree_node_base<Key, associative_tree_node<Key, Value> > base_type;
  using typename base_type::key_type;
  typedef Value value_type;

  using typename base_type::child_iterator;
  using typename base_type::const_child_iterator;

private:
  boost::optional<Value> m_value;

public:
  associative_tree_node() {}

  //recursive copy
  associative_tree_node(associative_tree_node const& other):
    base_type(other),
    m_value(other.m_value)
  {}

#if __cplusplus >= 201103L
  //recursive move
  associative_tree_node(associative_tree_node && other):
    associative_tree_node_base<Key, Value>(std::move(other)),
    m_value(std::move(other.m_value))
  {}
#endif

  ~associative_tree_node() {}

  associative_tree_node& operator=(associative_tree_node other) {
    swap(other);
    return *this;
  }

  void swap(associative_tree_node & other) {
    using std::swap;
    base_type::swap(other);
    swap(m_value, other.m_value);
  }

  void value(value_type const& value) { m_value = value; }

  bool has_value() const { return static_cast<bool>(m_value); }

  value_type const& value() const { return *m_value; }
  value_type & value() { return *m_value; }
};

template <typename Key, typename Value>
inline void swap(associative_tree_node<Key, Value>& a, associative_tree_node<Key, Value>& b) { a.swap(b); }


/**
 * @brief .

 * @tparam Key the type of path elements
 * @tparam Value the type of values

 * there can't be value associated to the root elements (the unnamed one)
 */
template <typename Key, typename Value>
class path_tree: private associative_tree_base<Key, associative_tree_node<Key, Value> > {
private:
  typedef associative_tree_base<Key, associative_tree_node<Key, Value> > base_type;
public:
  using typename base_type::key_type;

  typedef Value value_type;

private:
  typedef typename base_type::node node;

public:

  template <typename KeySequence>
  void insert(KeySequence const& path, value_type const& value) { insert(path.begin(), path.end(), value); }

  template <typename KeyIterator>
  void insert(KeyIterator path_start, KeyIterator path_end, value_type const& value) {
    this->make(path_start, path_end).value(value);
  }


  template <typename KeySequence>
  boost::optional<value_type const&> find(KeySequence const& path) const { return find(path.begin(), path.end()); }

  template <typename KeyIterator>
  boost::optional<value_type const&> find(KeyIterator path_start, KeyIterator path_end) const {
    node const* target = this->search(path_start, path_end);
    if (!target || !target->has_value()) return boost::none;
    return target->value();
  }
};




template <typename Key, typename Value>
class associative_multitree_node: public associative_tree_node_base<Key, associative_multitree_node<Key, Value> > {
protected:
  typedef associative_tree_node_base<Key, associative_multitree_node<Key, Value> > base_type;
  using typename base_type::key_type;
  typedef Value value_type;

  using typename base_type::child_iterator;
  using typename base_type::const_child_iterator;

private:
  typedef std::vector<value_type> values_type;
public:
  typedef typename values_type::size_type size_type;

  typedef typename values_type::iterator value_iterator;
  typedef typename values_type::const_iterator const_value_iterator;

  typedef iterator_range<value_iterator> value_range;
  typedef iterator_range<const_value_iterator> const_value_range;

private:
  values_type m_values;

public:
  associative_multitree_node() {}

  //recursive copy
  associative_multitree_node(associative_multitree_node const& other):
    base_type(other),
    m_values(other.m_values)
  {}

#if __cplusplus >= 201103L
  //recursive move
  associative_multitree_node(associative_multitree_node && other):
    associative_tree_node_base<Key,Value>(std::move(other)),
    m_values(std::move(other.m_values))
  {}
#endif

  ~associative_multitree_node() {}

  associative_multitree_node& operator=(associative_multitree_node other) {
    swap(other);
    return *this;
  }

  void swap(associative_multitree_node & other) {
    using std::swap;
    base_type::swap(other);
    swap(m_values, other.m_values);
  }


  value_range values() { return make_range(m_values); }
  const_value_range values() const { return make_range(m_values); }

  value_iterator begin() { return m_values.begin(); }
  value_iterator end() { return m_values.end(); }

  const_value_iterator begin() const { return m_values.begin(); }
  const_value_iterator end() const { return m_values.end(); }

  bool empty() const { return m_values.empty(); }
  size_type size() const { return m_values.size(); }

  void add(value_type const& value) { m_values.push_back(value); }
};

template <typename Key, typename Value>
inline void swap(associative_multitree_node<Key, Value>& a, associative_multitree_node<Key, Value>& b) { a.swap(b); }


/**
 * @brief .

 * @tparam Key the type of path elements
 * @tparam Value the type of values

 * there can't be value associated to the root elements (the unnamed one)
 */
template <typename Key, typename Value>
class path_multitree: private associative_tree_base<Key, associative_multitree_node<Key, Value> > {
  private:
  typedef associative_tree_base<Key, associative_multitree_node<Key, Value> > base_type;
public:
  using typename base_type::key_type;

  typedef Value value_type;

private:
  typedef typename base_type::node node;

public:
  typedef typename node::value_range value_range;
  typedef typename node::const_value_range const_value_range;


  template <typename KeySequence>
  void insert(KeySequence const& path, value_type const& value) { insert(path.begin(), path.end(), value); }

  template <typename KeyIterator>
  void insert(KeyIterator path_start, KeyIterator path_end, value_type const& value) {
    this->make(path_start, path_end).add(value);
  }


  template <typename KeySequence>
  const_value_range find(KeySequence const& path) const { return find(path.begin(), path.end()); }

  template <typename KeyIterator>
  const_value_range find(KeyIterator path_start, KeyIterator path_end) const {
    node const* target = this->search(path_start, path_end);
    return target ? target->values() : const_value_range();
  }
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
