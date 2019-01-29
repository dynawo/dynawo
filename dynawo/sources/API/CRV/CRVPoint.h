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
 * @file  CRVPoint.h
 *
 * @brief Dynawo curves point : interface file
 *
 */
#ifndef API_CRV_CRVPOINT_H_
#define API_CRV_CRVPOINT_H_

#include "CRVExport.h"

namespace curves {

/**
 * @class Point
 * @brief Point interface class
 *
 * Interface class for point. Point is a container describing a point of a curve
 * during simulation:  for describing a point, there is two fields: time of the point,
 * and value of the point.
 */
class __DYNAWO_CRV_EXPORT Point {
 public:
  virtual ~Point() { }

  /**
   * @brief Setter for point's time
   * @param time point's time
   */
  virtual void setTime(const double& time) = 0;

  /**
   * @brief Setter for point's value
   * @param value point's value
   */
  virtual void setValue(const double& value) = 0;

  /**
   * @brief Getter for point's time
   * @return point's time
   */
  virtual double getTime() const = 0;

  /**
   * @brief Getter for point's value
   * @return point's value
   */
  virtual double getValue() const = 0;

  class Impl;
};

}  // end of namespace curves

#endif  // API_CRV_CRVPOINT_H_

