//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems
//

/**
 * @file  DYNReactiveCurvePointsInterface.h
 *
 * @brief Reactive curve points interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNREACTIVECURVEPOINTSINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNREACTIVECURVEPOINTSINTERFACE_H_

#include <vector>

namespace DYN {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/// @brief Curve points data interface
class ReactiveCurvePointsInterface {
 public:
  /**
   * @brief Reactive curve point
   *
   * Represents a reactive curve point extracted from network file
   */
  struct ReactiveCurvePoint {
    /**
     * @brief Constructor
     *
     * @param p_p active power
     * @param p_qmin minimum reactive power
     * @param p_qmax maximum reactive power
     */
    ReactiveCurvePoint(double p_p, double p_qmin, double p_qmax) : p(p_p), qmin(p_qmin), qmax(p_qmax) {}

    double p;     ///< active power
    double qmin;  ///< minimum reactive power
    double qmax;  ///< maximum reactive power
  };

 public:
  /// @brief Destructor
  virtual ~ReactiveCurvePointsInterface() = default;

  /**
   * @brief Retrieve the list of reactive curve points, if any
   * @returns list of reactive curve points
   */
  virtual std::vector<ReactiveCurvePoint> getReactiveCurvesPoints() const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNREACTIVECURVEPOINTSINTERFACE_H_
