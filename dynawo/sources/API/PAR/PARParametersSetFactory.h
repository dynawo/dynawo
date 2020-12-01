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
 * @file PARParametersSetFactory.h
 * @brief Dynawo parameters set factory : header file
 *
 */

#ifndef API_PAR_PARPARAMETERSSETFACTORY_H_
#define API_PAR_PARPARAMETERSSETFACTORY_H_

#include "PARParametersSet.h"

#include <boost/shared_ptr.hpp>

namespace parameters {
/**
 * @class ParametersSetFactory
 * @brief ParametersSet factory class
 *
 * ParametersSetFactory encapsulate methods for creating new
 * @p ParametersSet objects.
 */
class ParametersSetFactory {
 public:
  /**
   * @brief Create new ParametersSet instance
   *
   * @param id Id of the parameters set
   *
   * @returns Shared pointer to a new empty @p ParametersSet
   */
  static boost::shared_ptr<ParametersSet> newInstance(std::string id);

  /**
   * @brief Create new ParametersSet instance as a clone of given instance
   *
   * @param[in] original ParametersSet to be cloned
   *
   * @returns Shared pointer to a new @p ParametersSet copied from original
   */
  static boost::shared_ptr<ParametersSet> copyInstance(boost::shared_ptr<ParametersSet> original);

  /**
   * @brief Create new ParametersSet instance as a clone of given instance
   *
   * @param[in] original ParametersSet to be cloned
   *
   * @returns Shared pointer to a new @p ParametersSet copied from original
   */
  static boost::shared_ptr<ParametersSet> copyInstance(const ParametersSet& original);
};

}  // namespace parameters

#endif  // API_PAR_PARPARAMETERSSETFACTORY_H_
