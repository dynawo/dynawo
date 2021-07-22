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
 * @file DYNCurrentLimitsPerSeasonIIDMExtension.h
 * @brief IIDM extension for current limit per seson interface file
 */

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCURRENTLIMITSPERSEASONIIDMEXTENSION_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCURRENTLIMITSPERSEASONIIDMEXTENSION_H_

#include <array>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

namespace DYN {

/**
 * @brief Current limit per season IIDM extension interface
 */
class CurrentLimitsPerSeasonIIDMExtension {
 public:
  /**
   * @brief Temporary limit
   */
  struct TemporaryLimit {
    std::string name;                  ///< name of the temporary limit
    unsigned long acceptableDuration;  ///< acceptable duration of the temporary limit
    double value;                      ///< value of the temporary limit
    bool fictitious;                   ///< determines if the temporary limit is fictitious
  };

  /// @brief Current limit
  struct CurrentLimit {
    double permanentLimit;                        ///< Permanent limit
    std::vector<TemporaryLimit> temporaryLimits;  ///< list of temporary limits
  };
  /// @brief Current limits, from currentLimit1 to currentLimit3
  struct CurrentLimits {
    // currentLimit1 corresponds to index 0
    std::array<std::shared_ptr<CurrentLimit>, 3> currentLimits;  ///< current limits
  };
  /// @brief alias for season name
  using SeasonName = std::string;

 public:
  /// @brief Destructor
  virtual ~CurrentLimitsPerSeasonIIDMExtension() {}

  /**
   * @brief Retrieve current limits
   * @returns map of current limits
   */
  virtual const std::unordered_map<SeasonName, CurrentLimits>& getCurrentLimits() const = 0;
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCURRENTLIMITSPERSEASONIIDMEXTENSION_H_
