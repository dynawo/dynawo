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
 * @file Path.h
 * @brief path in an XML document (subset of XPath)
 *
 */

#ifndef XML_SAX_PARSER_GUARD_PATH_H
#define XML_SAX_PARSER_GUARD_PATH_H

#include <list>
#include <algorithm>
#include <ostream>

namespace xml {
namespace sax {
namespace parser {

template <typename Token>
class path {
private:
  typedef std::list<Token> token_sequence_type;
  token_sequence_type m_path;

public:
  typedef Token token_type;
  typedef typename token_sequence_type::size_type size_type;

  typedef typename token_sequence_type::const_iterator const_iterator;
  typedef typename token_sequence_type::iterator iterator;

  typedef typename token_sequence_type::const_reverse_iterator const_reverse_iterator;
  typedef typename token_sequence_type::reverse_iterator reverse_iterator;

public:
  path() {}
  path(token_type const& t): m_path(1, t) {}

  template <typename It>
  path(It first, It end): m_path(first, end) {}

  path& operator += (token_type const& t) { m_path.push_back(t); return *this; }

  path& operator += (path const& p) {
    m_path.insert(m_path.end(), p.m_path.begin(), p.m_path.end());
    return *this;
  }

  token_type const& base() const {return m_path.back();}

  path& remove_end() { if (!empty()) m_path.pop_back(); return *this; }

  path parent() const {
    return path(m_path.begin(), --m_path.end());
  }

  bool empty() const { return m_path.empty(); }
  size_type size() const { return m_path.size(); }

  void clear() { m_path.clear(); }

  const_iterator begin() const { return m_path.begin(); }
  const_iterator end() const { return m_path.end(); }

  iterator begin() { return m_path.begin(); }
  iterator end() { return m_path.end(); }


  const_reverse_iterator rbegin() const { return m_path.rbegin(); }
  const_reverse_iterator rend() const { return m_path.rend(); }

  reverse_iterator rbegin() { return m_path.rbegin(); }
  reverse_iterator rend() { return m_path.rend(); }
};

template <typename Token>
inline path<Token> operator + (path<Token> a, path<Token> const& b) { return a+=b; }

template <typename Token, typename T>
inline path<Token> operator + (T const& a, path<Token> const& b) { return path<Token>(a)+=b; }

template <typename Token, typename T>
inline path<Token> operator + (path<Token> a, T const& b) { return a+=Token(b); }

template <typename Token>
inline bool operator == (path<Token> const& a, path<Token> const& b) {
  return (a.size() == b.size()) && std::equal(a.begin(), a.end(), b.begin()) ;
}


template <typename Token>
inline bool operator == (path<Token> const& p, Token const& t) {
  return (p.size() == 1) && (p.base()==t);
}

template <typename Token>
inline bool operator == (Token const& t, path<Token> const& p) { return p == t; }

template <typename Token>
inline bool operator != (path<Token> const& a, path<Token> const& b) { return !(a==b); }

template <typename Token>
inline bool operator != (path<Token> const& p, Token const& t) { return !(p==t); }

template <typename Token>
inline bool operator != (Token const& t, path<Token> const& p) { return !(p==t); }





template <typename Token>
inline std::ostream& operator<<(std::ostream& stream, path<Token> const& p) {
  for (typename path<Token>::const_iterator it = p.begin(); it!=p.end(); ++it) {
    stream << '/' << *it;
  }
  return stream;
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
