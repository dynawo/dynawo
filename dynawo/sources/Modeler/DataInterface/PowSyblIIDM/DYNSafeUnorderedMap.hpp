//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file DYNSafeUnorderedMap.hpp
 *
 * @brief Safe unordered map with a lock-free access
 */

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSAFEUNORDEREDMAP_HPP_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSAFEUNORDEREDMAP_HPP_

#include <mutex>
#include <unordered_map>

namespace DYN {

/**
 * @brief Safe unordered map class
 */
template<typename Key, typename T, typename Hash = std::hash<Key>, typename KeyEqual = std::equal_to<Key>,
         typename Allocator = std::allocator<std::pair<Key const, T> > >
class SafeUnorderedMap {
 public:
  /// @brief Alias for underlying unordered map
  using Map = typename std::unordered_map<Key, T, Hash, KeyEqual, Allocator>;
  /// @brief Alias for mutex type
  using Mutex = std::mutex;
  /// @brief Alias for lock type
  using Lock = std::unique_lock<Mutex>;

  /**
   * @brief Retrieve in read-only the underlying map
   * @returns underlying map
   */
  const Map& map() const {
    return map_;
  }

  /**
   * @brief Acces key element by reference for update purpose
   * @param key the key of the element to retrieve
   * @returns the element by reference
   */
  T& at(const Key& key) {
    // No lock here : lock-free access to have better performances
    return map_.at(key);
  }

  /**
   * @brief Acces key element by reference for access purpose
   * @param key the key of the element to retrieve
   * @returns the element
   */
  const T& at(const Key& key) const {
    // No lock here : lock-free access to have better performances
    return map_.at(key);
  }

  /**
   * @brief Clear the map
   */
  void clear() {
    Lock lock(mutex_);
    map_.clear();
  }

  /**
   * @brief Insert a new element
   * @param value the new element to insert
   */
  void insert(const typename Map::value_type& value) {
    Lock lock(mutex_);
    map_.insert(value);
  }

 private:
  mutable Mutex mutex_;  ///< Mutex to protect against simulatenous insertions
  Map map_;              ///< underlying map
};

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSAFEUNORDEREDMAP_HPP_
