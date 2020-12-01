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
 * @file DYDUnitDynamicModelFactory.h
 * @brief Modelica model factory : header file
 *
 */

#ifndef API_DYD_DYDUNITDYNAMICMODELFACTORY_H_
#define API_DYD_DYDUNITDYNAMICMODELFACTORY_H_

#include "DYDUnitDynamicModel.h"

#include <boost/shared_ptr.hpp>

namespace dynamicdata {

/**
 * @class UnitDynamicModelFactory
 * @brief UnitDynamicModelFactory factory class
 *
 * UnitDynamicModelFactory encapsulate methods for creating new
 * @p UnitDynamicModel objects.
 */
class UnitDynamicModelFactory {
 public:
  /**
   * @brief Create new UnitDynamicModel instance
   *
   * @param[in] modelId ID for new UnitDynamicModel instance
   * @param[in] modelName name of model used to instanciate this model
   * @returns Shared pointer to a new @p UnitDynamicModel with given ID
   */
  static boost::shared_ptr<UnitDynamicModel> newModel(const std::string& modelId, const std::string& modelName);
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDUNITDYNAMICMODELFACTORY_H_
