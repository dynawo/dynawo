//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
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

namespace curves {

/**
 * @class Point
 * @brief Point interface class
 *
 * Interface class for point. Point is a container describing a point of a curve
 * during simulation:  for describing a point, there is two fields: time of the point,
 * and value of the point.
 */
class Point {
 public:
  /**
   * @brief Constructor
   *
   * @param time time associated to the point
   * @param value value associated to the point
   *
   */
  Point(const double& time, const double& value);

  /**
   * @brief Setter for point's time
   * @param time point's time
   */
  void setTime(const double& time);

  /**
   * @brief Setter for point's value
   * @param value point's value
   */
  void setValue(const double& value);

  /**
   * @brief Getter for point's time
   * @return point's time
   */
  double getTime() const;

  /**
   * @brief Getter for point's value
   * @return point's value
   */
  double getValue() const;

 private:
  double time_;   ///< time associated to the point
  double value_;  ///< value associated to the point
};

}  // end of namespace curves

#endif  // API_CRV_CRVPOINT_H_
