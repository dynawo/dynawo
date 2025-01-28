//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  FSVFinalStateValuesCollectionFactory.h
 *
 * @brief Dynawo Final state values collection factory : header file
 *
 */
#ifndef API_FSV_FSVFINALSTATEVALUESCOLLECTIONFACTORY_H_
#define API_FSV_FSVFINALSTATEVALUESCOLLECTIONFACTORY_H_

#include "FSVFinalStateValuesCollection.h"


namespace finalStateValues {
/**
 * @class FinalStateValuesCollectionFactory
 * @brief Final state values collection factory class
 *
 * FinalStateValuesCollectionFactory encapsulate methods for creating new
 * @p FinalStateValuesCollection objects.
 */
class FinalStateValuesCollectionFactory {
 public:
  /**
   * @brief Create new FinalStateValuesCollection instance
   *
   * @param id id of the new instance
   *
   * @return unique pointer to a new empty @p FinalStateValuesCollection
   */
  static std::unique_ptr<FinalStateValuesCollection> newInstance(const std::string& id);

  /**
   * @brief Create new FinalStateValuesCollection instance as a clone of given instance
   *
   * @param[in] original FinalStateValuesCollection to be cloned
   *
   * @return Unique pointer to a new @p FinalStateValuesCollection copied from original
   */
  static std::unique_ptr<FinalStateValuesCollection> copyInstance(const std::shared_ptr<FinalStateValuesCollection>& original);

  /**
   * @brief Create new FinalStateValuesCollection instance as a clone of given instance
   *
   * @param[in] original FinalStateValuesCollection to be cloned
   *
   * @return Unique pointer to a new @p FinalStateValuesCollection copied from original
   */
  static std::unique_ptr<FinalStateValuesCollection> copyInstance(const FinalStateValuesCollection& original);
};
}  // namespace finalStateValues

#endif  // API_FSV_FSVFINALSTATEVALUESCOLLECTIONFACTORY_H_
