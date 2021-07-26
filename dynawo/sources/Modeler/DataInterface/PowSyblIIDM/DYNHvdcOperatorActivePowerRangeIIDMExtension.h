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
 * @file  DYNHvdcOperatorActivePowerRangeIIDMExtension.h
 * @brief HVDC active power range IIDM extension
 *
 */

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNHVDCOPERATORACTIVEPOWERRANGEIIDMEXTENSION_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNHVDCOPERATORACTIVEPOWERRANGEIIDMEXTENSION_H_

#include <boost/optional.hpp>

namespace DYN {
/// @brief Interface
class HvdcOperatorActivePowerRangeIIDMExtension {
 public:
  /// @brief Destructor
  virtual ~HvdcOperatorActivePowerRangeIIDMExtension() {}

  /**
   * @brief Retrieve OPR from CS1 to CS2
   * @returns the value or nullopt if extension containing the data not found
   */
  virtual boost::optional<double> getOprFromCS1toCS2() const = 0;

  /**
   * @brief Retrieve OPR from CS2 to CS1
   * @returns the value or nullopt if extension containing the data not found
   */
  virtual boost::optional<double> getOprFromCS2toCS1() const = 0;
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNHVDCOPERATORACTIVEPOWERRANGEIIDMEXTENSION_H_
