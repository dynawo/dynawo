//
// Copyright (c) 2024, RTE (http://www.rte-france.com)
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
 * @file PARParametersSetFactory.h
 *
 * @brief Dynawo parameter set factory : header file
 *
 */

#ifndef API_PAR_PARPARAMETERSSETFACTORY_H_
#define API_PAR_PARPARAMETERSSETFACTORY_H_

#include "PARParametersSet.h"

#include <memory>


namespace parameters {

/**
 * @class ParametersSetFactory
 *
 * @brief parameters set factory
 *
 */
class ParametersSetFactory {
 public:
  /**
   * @brief Create a new ParametersSet instance
   * @param id id of the set of parameters
   *
   * @returns Shared pointer to a new empty @p ParametersSet
   */
  static std::shared_ptr<ParametersSet> newParametersSet(const std::string& id);

  /**
   * @brief Create a new ParametersSet instance as a clone of a given instance
   *
   * @param[in] original ParametersSetCollection to be cloned
   *
   * @returns Shared pointer to a new @p ParametersSet copied from original
   */
  static std::shared_ptr<ParametersSet> copySet(const std::shared_ptr<ParametersSet>& original);
};

}  // namespace parameters

#endif  // API_PAR_PARPARAMETERSSETFACTORY_H_
