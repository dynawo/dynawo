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
 * @file CRVCurveFactory.h
 *
 * @brief Dynawo curves factory : header file
 *
 */

#ifndef API_CRV_CRVCURVEFACTORY_H_
#define API_CRV_CRVCURVEFACTORY_H_

#include <boost/shared_ptr.hpp>

#include "CRVCurve.h"

namespace curves {

/**
 * @class CurveFactory
 * @brief Curve factory class
 *
 * CurveFactory encapsulates methods for creating new
 * @p Curve objects.
 */
class CurveFactory {
 public:
  /**
   * @brief Create new Curve instance
   *
   * @returns a shared pointer to a new @p Curve
   */
  static boost::shared_ptr<Curve> newCurve();
};

}  //  namespace curves

#endif  // API_CRV_CRVCURVEFACTORY_H_
