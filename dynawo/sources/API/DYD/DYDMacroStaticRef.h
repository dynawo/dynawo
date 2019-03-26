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
 * @file DYDMacroStaticRef.h
 * @brief MacroStaticRef : interface file
 *
 */

#ifndef API_DYD_DYDMACROSTATICREF_H_
#define API_DYD_DYDMACROSTATICREF_H_

#include <string>

#include "DYDExport.h"

namespace dynamicdata {

/**
 * @class MacroStaticRef
 * @brief MacroStaticRef interface class
 *
 */
class __DYNAWO_DYD_EXPORT MacroStaticRef {
 public:
  /**
   * @brief Destructor
   */
  virtual ~MacroStaticRef() {}
  /**
   * @brief macroStaticRef id getter
   *
   * @return the id of the macroStaticRef
   */
  virtual std::string getId() const = 0;

  class Impl;  // Implementation class
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROSTATICREF_H_
