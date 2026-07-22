//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file PARMacroParSet.h
 * @brief PARMacroParSet : interface file
 *
 */

#ifndef API_PAR_PARMACROPARSET_H_
#define API_PAR_PARMACROPARSET_H_

#include <string>

namespace parameters {
/**
 * @class MacroParSet
 * @brief MacroParSet interface class
 */
class MacroParSet {
 public:
  /**
   * @brief MacroParSet constructor
   * @param[in] id id of the macroParSet
   */
  explicit MacroParSet(const std::string& id);

  /**
   * @brief macroParSet id getter
   * @returns the id of the macroParSet
   */
  const std::string& getId() const;
 private:
  std::string id_;  ///< id of the macroParSet
};
}  // namespace parameters


#endif  // API_PAR_PARMACROPARSET_H_
