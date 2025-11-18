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
 * @file  CRVCurvesCollection.h
 *
 * @brief Curves collection description : interface file
 *
 */

#ifndef API_CRV_CRVCURVESCOLLECTION_H_
#define API_CRV_CRVCURVESCOLLECTION_H_

#include "CRVCurve.h"

#include <string>

namespace curves {

/**
 * @class CurvesCollection
 * @brief Curves collection interface class
 *
 * Interface class for curves collection object. This a container for curves
 */
class CurvesCollection {
 public:
    /**
   * @brief constructor
   *
   * @param id curvesCollection's id
   */
  explicit CurvesCollection(const std::string& id);

  /**
   * @brief add a curve to the collection
   *
   * @param curve curve to add to the collection
   */
  void add(const std::shared_ptr<Curve>& curve);

  /**
   * @brief add a new point for each curve
   *
   * @param time time of the new point
   */
  void updateCurves(double time);

  /**
  * @brief get curves
  *
  * @return curves
  */
  const std::vector<std::shared_ptr<Curve> >& getCurves() const {
    return curves_;
  }

 private:
  std::vector<std::shared_ptr<Curve> > curves_;    ///< Vector of the curves object
  std::string id_;                                 ///< Curves collections id
};

}  // namespace curves

#endif  // API_CRV_CRVCURVESCOLLECTION_H_
