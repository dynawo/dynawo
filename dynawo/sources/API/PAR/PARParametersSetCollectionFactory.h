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
 * @file PARParametersSetCollectionFactory.h
 * @brief Dynawo parameters set collection factory : header file
 *
 */

#ifndef API_PAR_PARPARAMETERSSETCOLLECTIONFACTORY_H_
#define API_PAR_PARPARAMETERSSETCOLLECTIONFACTORY_H_

#include "PARParametersSetCollection.h"


namespace parameters {

/**
 * @class ParametersSetCollectionFactory
 * @brief ParametersSetCollection factory class
 *
 * ParametersSetCollectionFactory encapsulate methods for creating new
 * @p ParametersSetCollection objects.
 */
class ParametersSetCollectionFactory {
 public:
  /**
   * @brief Create new ParametersSetCollection instance
   *
   * @returns Unique pointer to a new empty @p ParametersSetCollection
   */
  static std::unique_ptr<ParametersSetCollection> newCollection();

  /**
   * @brief Create new ParametersSetCollection instance as a clone of given instance
   *
   * @param[in] original ParametersSetCollection to be cloned
   *
   * @returns Unique pointer to a new @p ParametersSetCollection copied from original
   */
  static std::unique_ptr<ParametersSetCollection> copyCollection(const std::unique_ptr<ParametersSetCollection>& original);
};

}  // namespace parameters

#endif  // API_PAR_PARPARAMETERSSETCOLLECTIONFACTORY_H_
