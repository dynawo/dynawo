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

#ifndef TESTS_INCLUDE_SEQUENCE_HPP
#define TESTS_INCLUDE_SEQUENCE_HPP

#include <vector>
#include <iterator>

#include <boost/lexical_cast.hpp>

namespace test_helpers {

template <typename T>
struct sequence {
public:
  typedef std::vector<T> data_type;
  
  typedef typename data_type::size_type size_type;
  typedef typename data_type::const_iterator const_iterator;
  typedef typename data_type::const_reverse_iterator const_reverse_iterator;

  sequence(size_type n = 0) {
    for (typename data_type::size_type i = 0; i < n; ++i) {
      data.push_back( boost::lexical_cast<T>(i) );
    }
  }
  
  size_type size() const { return data.size(); }
  
  T const& first() const { return data[0]; }
  T const& second() const { return data[1]; }
  T const& last() const { return data.back(); }
  
  T const& operator[] (size_type n) const { return data[n]; }
  
  const_iterator begin() const { return data.begin(); }
  const_iterator end() const { return data.end(); }
  
  const_reverse_iterator rbegin() const { return data.rbegin(); }
  const_reverse_iterator rend() const { return data.rend(); }

private:
  data_type data;
};

} // end of namespace test_helpers::

#endif
