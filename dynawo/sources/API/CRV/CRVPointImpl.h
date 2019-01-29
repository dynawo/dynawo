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
 * @file  CRVPointImpl.h
 *
 * @brief Dynawo curves point : header file
 *
 */
#ifndef API_CRV_CRVPOINTIMPL_H_
#define API_CRV_CRVPOINTIMPL_H_

#include "CRVPoint.h"

namespace curves {

/**
 * @class Point::Impl
 * @brief Point implemented class
 *
 * Implementation of Point interface class
 */
class Point::Impl : public Point {
 public:
  /**
   * @brief Constructor
   *
   * @param time time associated to the point
   * @param value value associated to the point
   *
   */
  Impl(const double& time, const double& value);

  /**
   * @brief Destructor
   */
  ~Impl();

  /**
   * @copydoc Point::setTime(const double& time)
   */
  void setTime(const double& time);

  /**
   * @copydoc Point::setValue(const double& value)
   */
  void setValue(const double& value);

  /**
   * @copydoc Point::getTime()
   */
  double getTime() const;

  /**
   * @copydoc Point::getValue()
   */
  double getValue() const;

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  double time_;  ///< time associated to the point
  double value_;  ///< value associated to the point
};

}  // namespace curves

#endif  // API_CRV_CRVPOINTIMPL_H_
