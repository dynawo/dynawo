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
 * @file DataInterface/IIDM/DYNServiceManagerInterfaceIIDM.h
 *
 * @brief Service manager IIDM implementation file
 *
 */
#ifndef MODELER_DATAINTERFACE_IIDM_DYNSERVICEMANAGERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_IIDM_DYNSERVICEMANAGERINTERFACEIIDM_H_

#include "DYNServiceManagerInterface.h"

#include <string>
#include <vector>

namespace DYN {

/**
 * @brief Implementation for IIDM dynawo service
 */
class ServiceManagerInterfaceIIDM : public ServiceManagerInterface {
 public:
  /**
   * @copydoc ServiceManagerInterface::getBusesConnectedBySwitch
   */
  virtual std::vector<std::string> getBusesConnectedBySwitch(const std::string& busId, const std::string& VLId) const;
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_IIDM_DYNSERVICEMANAGERINTERFACEIIDM_H_
