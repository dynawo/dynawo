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
 * @file DYDIdentifiableFactory.h
 * @brief identifiable factory : header file
 *
 */

#ifndef API_DYD_DYDIDENTIFIABLEFACTORY_H_
#define API_DYD_DYDIDENTIFIABLEFACTORY_H_

#include "DYDIdentifiable.h"

#include <memory>

namespace dynamicdata {

/**
 * @class IdentifiableFactory
 * @brief IdentifiableFactory factory class
 *
 * IdentifiableFactory encapsulate methods for creating new
 * @p Identifiable objects.
 */
class IdentifiableFactory {
 public:
  /**
   * @brief Create new Identifiable instance
   *
   * @param[in] id ID for new Identifiable instance
   * @returns Unique pointer to a new @p Identifiable with given ID
   */
  static std::unique_ptr<Identifiable> newIdentifiable(const std::string& id);
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDIDENTIFIABLEFACTORY_H_
