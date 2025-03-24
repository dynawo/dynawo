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
 * @file DYDMacroStaticRefFactory.h
 * @brief MacroStaticRef factory : header file
 *
 */

#ifndef API_DYD_DYDMACROSTATICREFFACTORY_H_
#define API_DYD_DYDMACROSTATICREFFACTORY_H_

#include "DYDMacroStaticRef.h"

#include <memory>

namespace dynamicdata {
/**
 * @class MacroStaticRefFactory
 * @brief MacroStaticRef factory class
 *
 * MacroStaticReftFactory encapsulates methods for creating new
 * @p MacroStaticRef objects.
 */
class MacroStaticRefFactory {
 public:
  /**
   * @brief Create new MacroStaticRef instance
   *
   * @param[in] id : id for new MacroStaticRef instance
   * @returns a unique pointer to a new @p MacroStaticRef with given id
   */
  static std::unique_ptr<MacroStaticRef> newMacroStaticRef(const std::string& id);
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROSTATICREFFACTORY_H_
