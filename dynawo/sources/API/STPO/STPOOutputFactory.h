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
 * @file STPOOutputFactory.h
 *
 * @brief Dynawo outputs factory : header file
 *
 */

#ifndef API_STPO_STPOOUTPUTFACTORY_H_
#define API_STPO_STPOOUTPUTFACTORY_H_

#include "STPOOutput.h"

namespace stepOutputs {

/**
 * @class OutputFactory
 * @brief Output factory class
 *
 * OutputFactory encapsulates methods for creating new
 * @p Output objects.
 */
class OutputFactory {
 public:
  /**
   * @brief Create new Output instance
   *
   * @returns a unique pointer to a new @p Output
   */
  static std::unique_ptr<Output> newOutput();
};

}  //  namespace stepOutputs

#endif  // API_STPO_STPOOUTPUTFACTORY_H_
