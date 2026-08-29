//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file DYNCurrentLimitsPerSeasonIIDMExtension.h
 * @brief IIDM extension for current limit per season interface file
 */

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCURRENTLIMITSPERSEASONIIDMEXTENSION_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCURRENTLIMITSPERSEASONIIDMEXTENSION_H_

#include <array>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

#include "DYNCurrentLimits.h"

namespace DYN {

/**
 * @brief Current limit per season IIDM extension interface
 */
class CurrentLimitsPerSeasonIIDMExtension {
 public:
  /// @brief alias for season name
  using SeasonName = std::string;

 public:
  /// @brief Destructor
  virtual ~CurrentLimitsPerSeasonIIDMExtension() = default;

  /**
   * @brief Retrieve current limits
   * @returns map of current limits
   */
  virtual const std::unordered_map<SeasonName, CurrentLimits>& getCurrentLimits() const = 0;
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCURRENTLIMITSPERSEASONIIDMEXTENSION_H_
