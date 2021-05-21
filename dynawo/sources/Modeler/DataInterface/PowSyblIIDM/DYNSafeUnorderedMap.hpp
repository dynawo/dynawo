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

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSAFEUNORDEREDMAP_HPP_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSAFEUNORDEREDMAP_HPP_

#include <mutex>
#include <unordered_map>

namespace DYN {

template<typename Key, typename T, typename Hash = std::hash<Key>, typename KeyEqual = std::equal_to<Key>,
         typename Allocator = std::allocator<std::pair<Key const, T> > >
class SafeUnorderedMap {
 public:
  using Map = typename std::unordered_map<Key, T, Hash, KeyEqual, Allocator>;
  using Mutex = std::mutex;
  using Lock = std::unique_lock<Mutex>;

  const Map& map() const {
    return map_;
  }

  T& at(const Key& key) {
    return map_.at(key);
  }
  const T& at(const Key& key) const {
    return map_.at(key);
  }

  void clear() {
    Lock lock(mutex_);
    map_.clear();
  }

  void insert(const typename Map::value_type& value) {
    Lock lock(mutex_);
    map_.insert(value);
  }
  template<class... Args>
  void emplace(Args&&... args) {
    Lock lock(mutex_);
    map_.emplace(std::forward<Args>(args)...);
  }
  typename Map::iterator erase(typename  Map::const_iterator pos) {
    Lock lock(mutex_);
    return map_.erase(pos);
  }

 private:
  mutable Mutex mutex_;
  Map map_;
};

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSAFEUNORDEREDMAP_HPP_
