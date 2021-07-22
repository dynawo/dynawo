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
 * @file  DYNHvdcAngleDroopActivePowerControlIIDMExtension.h
 *
 * @brief Stub implementation for HVDC angle droop active power control IIDM extension
 *
 */

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNHVDCANGLEDROOPACTIVEPOWERCONTROLIIDMEXTENSION_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNHVDCANGLEDROOPACTIVEPOWERCONTROLIIDMEXTENSION_H_

#include <boost/optional.hpp>

namespace DYN {
/// @brief HVDC Angle Droop active power control IIDM extension interface
class HvdcAngleDroopActivePowerControlIIDMExtension {
 public:
  /// @brief Destructor
  virtual ~HvdcAngleDroopActivePowerControlIIDMExtension() {}

  /**
   * @brief Get droop
   * @returns the droop value or nullopt if the extension containing the data is not defined
   */
  virtual boost::optional<double> getDroop() const = 0;

  /**
   * @brief Get P0
   * @returns the P0 value or nullopt if the extension containing the data is not defined
   */
  virtual boost::optional<double> getP0() const = 0;

  /**
   * @brief Determines if the HVDC is enabled
   * @returns true if enabled, false if not or nullopt if the extension containing the data is not defined
   */
  virtual boost::optional<bool> isEnabled() const = 0;
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNHVDCANGLEDROOPACTIVEPOWERCONTROLIIDMEXTENSION_H_
