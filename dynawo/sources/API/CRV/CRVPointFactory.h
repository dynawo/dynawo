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
 * @file CRVPointFactory.h
 *
 * @brief Dynawo curves point factory : header file
 *
 */

#ifndef API_CRV_CRVPOINTFACTORY_H_
#define API_CRV_CRVPOINTFACTORY_H_

#include "CRVPoint.h"

#include <memory>


namespace curves {
/**
 * @class PointFactory
 * @brief Point factory class
 *
 * PointFactory encapsulates methods for creating new
 * @p Point objects.
 */
class PointFactory {
 public:
  /**
   * @brief Create new Point instance
   *
   * @param[in] time : time of the  new Point instance
   * @param[in] value : value of the new Point instance
   * @returns a unique pointer to a new @p Point
   */
  static std::unique_ptr<Point> newPoint(const double& time, const double& value);
};

}  //  namespace curves

#endif  // API_CRV_CRVPOINTFACTORY_H_
