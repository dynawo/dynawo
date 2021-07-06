//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
//

/**
 * @file DYNClone.hpp
 * @brief clone shared pointer
 */
#ifndef COMMON_DYNCLONE_HPP_
#define COMMON_DYNCLONE_HPP_

#include <boost/make_shared.hpp>
#include <boost/shared_ptr.hpp>
#include <vector>

namespace DYN {

/**
 * @brief Util function to clone content of a shared pointer into another shared pointer
 * @param other the pointer to clone
 * @returns the new shared pointer
 */
template<class T>
inline boost::shared_ptr<T>
clone(const boost::shared_ptr<T>& other) {
  if (!other) {
    return boost::shared_ptr<T>();
  }

  return boost::make_shared<T>(*other);
}

}  // namespace DYN

#endif  // COMMON_DYNCLONE_HPP_
