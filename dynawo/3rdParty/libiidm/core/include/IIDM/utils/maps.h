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
 * @file utils/maps.h
 * @brief maps utilities for libiidm
 */

#ifndef LIBIIDM_UTILS_GUARD_MAPS_H
#define LIBIIDM_UTILS_GUARD_MAPS_H

#include <map>
#include <iterator>
#include <sstream>

#include <boost/optional.hpp>
#include <boost/core/ref.hpp>

#include <boost/iterator/transform_iterator.hpp>
#include <boost/iterator/indirect_iterator.hpp>

#include <IIDM/cpp11_type_traits.h>
#include <IIDM/Export.h>


namespace IIDM {

template <typename Map>
typename Map::mapped_type const*
map_contains(Map const& map, typename Map::key_type const& key) {
  return map.find(key)!=map.end();
}

template <typename Map>
typename Map::mapped_type *
map_find(Map & map, typename Map::key_type const& key) {
  typename Map::iterator it = map.find(key);
  return (it!=map.end()) ? &(it->second) : IIDM_NULLPTR;
}

template <typename Map>
typename Map::mapped_type const*
map_find(Map const& map, typename Map::key_type const& key) {
  typename Map::const_iterator it = map.find(key);
  return (it!=map.end()) ? &(it->second) : IIDM_NULLPTR;
}

template <typename Map>
typename Map::mapped_type &
map_get(Map & map, typename Map::key_type const& key) {
  typename Map::iterator it = map.find(key);
  if (it != map.end()) {
    return it->second;
  }

  std::ostringstream oss;
  oss << "unknown key: " << key;
  throw std::range_error(oss.str());
}

template <typename Map>
typename Map::mapped_type const& 
map_get(Map const& map, typename Map::key_type const& key) {
  typename Map::const_iterator it = map.find(key);
  if (it != map.end()) {
    return it->second;
  }

  std::ostringstream oss;
  oss << "unknown key: " << key;
  throw std::range_error(oss.str());
}

namespace details {
/**
 * @brief An unary functor to access the member of class T specified by the MemberPtr template parameter.
 */
template<typename T, typename MemberType, MemberType T::*MemberPtr>
struct access_member_f {
  // preserve cv-qualification of T for T::second_type
  typedef typename tt::conditional<
    tt::is_const<T>::value,
    typename tt::conditional<  
      tt::is_volatile<T>::value,
      typename tt::add_cv<MemberType>::type,
      typename tt::add_const<MemberType>::type
    >::type,
    typename tt::conditional<
      tt::is_volatile<T>::value,
      typename tt::add_volatile<MemberType>::type,
      MemberType
    >::type
  >::type& result_type;

  result_type operator ()(T& t) const { return t.*MemberPtr; }
};

} // end of namespace IIDM::details::

/**
 * @brief An iterator adaptor accessing the member called 'second' of the class the iterator is pointing to.
 */
// note: we use the Iterator's reference instead of value_type because it is the cv-qualified iterated type.
template<typename Iterator>
class map_value_iterator_adapter:
  public boost::transform_iterator<
    details::access_member_f<
      typename tt::remove_reference< typename std::iterator_traits<Iterator>::reference >::type, 
      typename std::iterator_traits<Iterator>::value_type::second_type, 
      &std::iterator_traits<Iterator>::value_type::second
    >, 
    Iterator
  >
{
private:
  typedef boost::transform_iterator<
    details::access_member_f<
      typename IIDM::tt::remove_reference< typename std::iterator_traits<Iterator>::reference >::type, 
      typename std::iterator_traits<Iterator>::value_type::second_type, 
      &std::iterator_traits<Iterator>::value_type::second
    >, 
    Iterator
  > baseclass;

public:
  map_value_iterator_adapter(): baseclass() {}

  // note: allow implicit conversion from Iterator
  map_value_iterator_adapter(Iterator it): baseclass(it) {}
};

} // end of namespace IIDM::

#endif
