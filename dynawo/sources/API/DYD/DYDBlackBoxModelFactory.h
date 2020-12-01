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
 * @file DYDBlackBoxModelFactory.h
 * @brief Blackbox model factory : header file
 *
 */

#ifndef API_DYD_DYDBLACKBOXMODELFACTORY_H_
#define API_DYD_DYDBLACKBOXMODELFACTORY_H_

#include "DYDBlackBoxModel.h"

#include <boost/shared_ptr.hpp>

namespace dynamicdata {
/**
 * @class BlackBoxModelFactory
 * @brief BlackBoxModelFactory factory class
 *
 * BlackBoxModelFactory encapsulate methods for creating new
 * @p BlackBoxModel objects.
 */
class BlackBoxModelFactory {
 public:
  /**
   * @brief Create new BlackBoxModel instance
   *
   * @param[in] modelId ID for new BlackBoxModel instance
   * @returns Shared pointer to a new @p BlackBoxModel with given ID
   */
  static boost::shared_ptr<BlackBoxModel> newModel(const std::string& modelId);
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDBLACKBOXMODELFACTORY_H_
