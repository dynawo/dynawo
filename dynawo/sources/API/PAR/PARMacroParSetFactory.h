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
 * @file PARMacroParSetFactory.h
 * @brief PARMacroParFactory : header file
 *
 */

#ifndef API_PAR_PARMACROPARSETFACTORY_H_
#define API_PAR_PARMACROPARSETFACTORY_H_

#include "PARMacroParSet.h"
#include <boost/shared_ptr.hpp>

namespace parameters {

/**
 * @class MacroParSetFactory
 * @brief MacroParSetFactory factory class
 *
 * MacroParSetFactory encapsulates methods for creating new
 * @p MacroParSet objects.
 */
class MacroParSetFactory {
 public:
  /**
   * @brief Create MacroParSet instance
   *
   * @param[in] id : id for new MacroParSet instance
   * @returns a shared pointer to a new @p MacroParSet with given ID
   */
  static boost::shared_ptr<MacroParSet> newMacroParSet(const std::string& id);
};

}  //  namespace parameters

#endif  // API_PAR_PARMACROPARSETFACTORY_H_
