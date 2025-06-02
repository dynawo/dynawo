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
 * @file DYNCurrentLimits.h
 * @brief Base structure for description of current limits
 */

#ifndef MODELER_DATAINTERFACE_DYNCURRENTLIMITS_H_
#define MODELER_DATAINTERFACE_DYNCURRENTLIMITS_H_

#include <boost/shared_ptr.hpp>
#include <unordered_map>
#include <vector>

namespace DYN {
/**
 * @brief Current Limit side enum
 */
typedef enum {
  CURRENT_LIMIT_SIDE_1 = 1,  ///< side 1
  CURRENT_LIMIT_SIDE_2,      ///< side 2
  CURRENT_LIMIT_SIDE_3       ///< side 3
} CurrentLimitSide;

/**
 * @brief Temporary limit
 */
struct TemporaryLimit {
  std::string name;                  ///< name of the  temporary limit
  unsigned long acceptableDuration;  ///< acceptable duration of the temporary limit
  double value;                      ///< value of the temporary limit
  bool fictitious;                   ///< determines if the temporary limit is fictitious
};

/// @brief Current limit
struct CurrentLimit {
  double permanentLimit;                        ///< Permanent limit
  std::vector<TemporaryLimit> temporaryLimits;  ///< list of temporary limits
};
/// @brief Current limits
struct CurrentLimits {
  /**
 * @brief Hash structure for CurrentLimitSide
 */
  struct CurrentLimitSideHash {
    /**
   * @brief Operator to retrieve currentLimitSide hash value
   *
   * @param currentLimitSide the currentLimitSide to hash
   * @returns the hash value
   */
    size_t operator()(CurrentLimitSide currentLimitSide) const {
      return static_cast<size_t>(currentLimitSide);
    }
  };

  std::unordered_map<CurrentLimitSide, std::shared_ptr<CurrentLimit>, CurrentLimitSideHash > currentLimits;  ///< current limits
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNCURRENTLIMITS_H_
