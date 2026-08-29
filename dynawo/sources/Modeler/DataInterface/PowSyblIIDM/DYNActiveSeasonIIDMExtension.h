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
 * @file DYNActiveSeasonIIDMExtension.h
 * @brief Active season IIDM extension interface
 */

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNACTIVESEASONIIDMEXTENSION_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNACTIVESEASONIIDMEXTENSION_H_

#include <string>

namespace DYN {
/**
 * @brief Active season IIDM extension interface
 */
class ActiveSeasonIIDMExtension {
 public:
  /// @brief Destructor
  virtual ~ActiveSeasonIIDMExtension() = default;

  /**
   * @brief Retrieve the active season value
   * @returns active season value
   */
  virtual std::string getValue() const = 0;
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNACTIVESEASONIIDMEXTENSION_H_
