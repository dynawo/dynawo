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
 * @file JOBUtils.hpp
 * @brief Utils for jobs file managements
 */
#ifndef API_JOB_JOBUTILS_HPP_
#define API_JOB_JOBUTILS_HPP_

#include <boost/make_shared.hpp>
#include <boost/shared_ptr.hpp>

namespace job {

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

}  // namespace job

#endif  // API_JOB_JOBUTILS_HPP_
