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
 * @file  DYNGeneratorActivePowerControlIIDMExtension.h
 *
 * @brief Generator active control IIDM extension interface
 *
 */

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNGENERATORACTIVEPOWERCONTROLIIDMEXTENSION_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNGENERATORACTIVEPOWERCONTROLIIDMEXTENSION_H_

#include <boost/optional.hpp>

namespace DYN {
/// @brief Generator ative power control extension
class GeneratorActivePowerControlIIDMExtension {
 public:
  /// @brief Destructor
  virtual ~GeneratorActivePowerControlIIDMExtension() = default;

  /**
   * @brief Get the droop parameter
   * @returns the droop parameter value, or nullopt if the parameter is not found
   */
  virtual boost::optional<double> getDroop() const = 0;

  /**
   * @brief Determines if the generator is participate
   * @returns true if the generatpr is participate, false if not, or nullopt if the parameter is not found
   */
  virtual boost::optional<bool> isParticipate() const = 0;

  /**
   * @brief Determines if the extension exists
   * @returns whether the extension exists
   */
  virtual bool exists() const = 0;
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNGENERATORACTIVEPOWERCONTROLIIDMEXTENSION_H_
