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
 * @file  STPOOutputsCollectionFactory.h
 *
 * @brief Dynawo Outputs collection factory : header file
 *
 */
#ifndef API_STPO_STPOOUTPUTSFACTORY_H_
#define API_STPO_STPOOUTPUTSFACTORY_H_

#include "STPOOutputsCollection.h"

namespace stepOutputs {
/**
 * @class OutputsCollectionFactory
 * @brief Outputs collection factory class
 *
 * OutputsCollectionFactory encapsulate methods for creating new
 * @p OutputsCollection objects.
 */
class OutputsCollectionFactory {
 public:
  /**
   * @brief Create new OutputsCollection instance
   *
   * @param id id of the new instance
   *
   * @return unique pointer to a new empty @p OutputsCollection
   */
  static std::unique_ptr<OutputsCollection> newInstance(const std::string& id);

  /**
   * @brief Create new OutputsCollection instance as a clone of given instance
   *
   * @param[in] original OutputsCollection to be cloned
   *
   * @return Unique pointer to a new @p OutputsCollection copied from original
   */
  static std::unique_ptr<OutputsCollection> copyInstance(const std::shared_ptr<OutputsCollection>& original);

  /**
   * @brief Create new OutputsCollection instance as a clone of given instance
   *
   * @param[in] original OutputsCollection to be cloned
   *
   * @return Unique pointer to a new @p OutputsCollection copied from original
   */
  static std::unique_ptr<OutputsCollection> copyInstance(const OutputsCollection& original);
};
}  // namespace stepOutputs

#endif  // API_STPO_STPOOUTPUTSFACTORY_H_
