//
// Copyright (c) 2020, RTE (http://www.rte-france.com)
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
 * @file  DYNServiceManagerInterfaceIIDM.cpp
 *
 * @brief Service manager : implementation file for IIDM implementation
 *
 */

#include "DYNServiceManagerInterfaceIIDM.h"

namespace DYN {
std::vector<std::string>
ServiceManagerInterfaceIIDM::getBusesConnectedBySwitch(const std::string&, const std::string&) const {
  // IIDM 1.0 doesn't support buses connected by switches so we always return an empty array
  return std::vector<std::string>();
}

boost::shared_ptr<BusInterface>
ServiceManagerInterfaceIIDM::getRegulatedBus(const std::string& regulatingComponent) const {
  // IIDM 1.0 doesn't support regulating terminals
  return boost::shared_ptr<BusInterface> ();
}
}  // namespace DYN
