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
 * @file  FSVFinalStateValuesCollection.h
 *
 * @brief Final state values collection description : interface file
 *
 */

#ifndef API_FSV_FSVFINALSTATEVALUESCOLLECTION_H_
#define API_FSV_FSVFINALSTATEVALUESCOLLECTION_H_

#include "FSVFinalStateValue.h"

#include <string>
#include <vector>
#include <memory>


namespace finalStateValues {

/**
 * @class FinalStateValuesCollection
 * @brief Final state values collection interface class
 *
 * Interface class for final state values collection object. This is a container for final state values
 */
class FinalStateValuesCollection {
 public:
  /**
   * @brief constructor
   *
   * @param id finalStateValuesCollection's id
   */
  explicit FinalStateValuesCollection(const std::string& id);

  /**
   * @brief add a final state value to the collection
   *
   * @param finalStateValue state value final state value to add to the collection
   */
  void add(const std::shared_ptr<FinalStateValue>& finalStateValue);

  /**
   * @brief add a new point for each final state value
   *
   * @param time time of the new point
   */
  void updateFinalStateValues(double time);

  /**
  * @brief get final state values
  *
  * @return final state values
  */
  const std::vector<std::shared_ptr<FinalStateValue> >& getFinalStateValues() const {
    return finalStateValues_;
  }

 private:
  std::vector<std::shared_ptr<FinalStateValue> > finalStateValues_;   ///< Vector of the final state values object
  std::string id_;                                                    ///< Final state values collections id
};

}  // namespace finalStateValues

#endif  // API_FSV_FSVFINALSTATEVALUESCOLLECTION_H_
