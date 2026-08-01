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
 * @file DYDMacroStaticRef.h
 * @brief MacroStaticRef : interface file
 *
 */

#ifndef API_DYD_DYDMACROSTATICREF_H_
#define API_DYD_DYDMACROSTATICREF_H_

#include <string>

namespace dynamicdata {

/**
 * @class MacroStaticRef
 * @brief MacroStaticRef interface class
 *
 */
class MacroStaticRef {
 public:
  /**
   * @brief MacroStaticRef::Impl constructor
   *
   * MacroStaticRef::Impl constructor.
   *
   * @param[in] id id of the macroStaticRef
   */
  explicit MacroStaticRef(const std::string& id);

  /**
   * @brief macroStaticRef id getter
   *
   * @return the id of the macroStaticRef
   */
  const std::string& getId() const;

 private:
  std::string id_;  ///< id of the macroStaticRef
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROSTATICREF_H_
