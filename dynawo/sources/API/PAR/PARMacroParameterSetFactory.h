//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file PARMacroParameterSetFactory.h
 * @brief PARMacroParameterSetFactory : header file
 *
 */

#ifndef API_PAR_PARMACROPARAMETERSETFACTORY_H_
#define API_PAR_PARMACROPARAMETERSETFACTORY_H_

#include "PARMacroParameterSet.h"

namespace parameters {

/**
 * @class MacroParameterSetFactory
 * @brief MacroParameterSetFactory factory class
 *
 * MacroParameterSetFactory encapsulates methods for creating new
 * @p MacroParameterSet objects.
 */
class MacroParameterSetFactory {
 public:
  /**
   * @brief Create MacroParameterSet instance
   *
   * @param[in] id : id for new MacroParameterSet instance
   * @returns a shared pointer to a new @p MacroParameterSet with given ID
   */
  static boost::shared_ptr<MacroParameterSet> newMacroParameterSet(const std::string& id);
};

}  //  namespace parameters

#endif  // API_PAR_PARMACROPARAMETERSETFACTORY_H_
