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
 * @file DYDMacroStaticReferenceFactory.h
 * @brief MacroStaticReference factory : header file
 *
 */

#ifndef API_DYD_DYDMACROSTATICREFERENCEFACTORY_H_
#define API_DYD_DYDMACROSTATICREFERENCEFACTORY_H_

#include "DYDMacroStaticReference.h"

#include <memory>

namespace dynamicdata {

/**
 * @class MacroStaticReferenceFactory
 * @brief MacroStaticReference factory class
 *
 * MacroStaticReferenceFactory encapsulates methods for creating new
 * @p MacroStaticReference objects.
 */
class MacroStaticReferenceFactory {
 public:
  /**
   * @brief Create new MacroStaticReference instance
   *
   * @param[in] id : id for new MacroStaticReference instance
   * @returns a unique pointer to a new @p macroStaticReference with given ID
   */
  static std::unique_ptr<MacroStaticReference> newMacroStaticReference(const std::string& id);
};

}  //  namespace dynamicdata

#endif  // API_DYD_DYDMACROSTATICREFERENCEFACTORY_H_
