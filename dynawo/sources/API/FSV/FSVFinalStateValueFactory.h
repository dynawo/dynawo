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
 * @file FSVFinalStateValueFactory.h
 *
 * @brief Dynawo final state values factory : header file
 *
 */

#ifndef API_FSV_FSVFINALSTATEVALUEFACTORY_H_
#define API_FSV_FSVFINALSTATEVALUEFACTORY_H_

#include "FSVFinalStateValue.h"

#include <memory>


namespace finalStateValues {

/**
 * @brief FinalStateValue factory class
 *
 * FinalStateValueFactory encapsulates methods for creating new
 * @p FinalStateValue objects.
 */
class FinalStateValueFactory {
 public:
  /**
   * @brief Create new FinalStateValue instance
   *
   * @returns a unique pointer to a new @p FinalStateValue
   */
  static std::unique_ptr<FinalStateValue> newFinalStateValue();
};

}  //  namespace finalStateValues

#endif  // API_FSV_FSVFINALSTATEVALUEFACTORY_H_
