//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
 * @file DYDStaticRefFactory.h
 * @brief StaticRef factory : header file
 *
 */

#ifndef API_DYD_DYDSTATICREFFACTORY_H_
#define API_DYD_DYDSTATICREFFACTORY_H_

#include "DYDStaticRef.h"

#include <boost/shared_ptr.hpp>

namespace dynamicdata {

/**
 * @class StaticRefFactory
 * @brief StaticRef factory class
 *
 * StaticRefFactory encapsulate methods for creating new
 * @p StaticRef objects.
 */
class StaticRefFactory {
 public:
  /**
   * @brief Create new StaticRef instance
   *
   * @returns Shared pointer to a new @p StaticRef
   */
  static boost::shared_ptr<StaticRef> newStaticRef();
  /**
   * @brief Create new StaticRef instance
   *
   * @param[in] modelVar : dynamic model variable
   * @param[in] staticVar : static model variable
   * @returns Shared pointer to a new @p StaticRef
   */
  static boost::shared_ptr<StaticRef> newStaticRef(const std::string& modelVar, const std::string& staticVar);
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDSTATICREFFACTORY_H_
