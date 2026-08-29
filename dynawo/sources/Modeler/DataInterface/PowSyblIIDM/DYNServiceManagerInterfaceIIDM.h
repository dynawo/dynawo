//
// Copyright (c) 2020, RTE (http://www.rte-france.com)
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
 * @file DataInterface/PowSyblIIDM/DYNServiceManagerInterfaceIIDM.h
 *
 * @brief Service manager IIDM implementation file
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSERVICEMANAGERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSERVICEMANAGERINTERFACEIIDM_H_

#include "DYNGraph.h"
#include "DYNServiceManagerInterface.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

#include <string>
#include <unordered_map>
#include <vector>

namespace DYN {

class DataInterfaceIIDM;

/**
 * @brief Implementation for IIDM dynawo service
 */
class ServiceManagerInterfaceIIDM : public ServiceManagerInterface {
 public:
  /**
   * @brief Constructor
   *
   * @param dataInterface data interface corresponding to current service manager
   */
  explicit ServiceManagerInterfaceIIDM(const DataInterfaceIIDM* const dataInterface);

  /**
   * @copydoc ServiceManagerInterface::getBusesConnectedBySwitch
   */
  std::vector<std::string> getBusesConnectedBySwitch(const std::string& busId, const std::string& VLId) const final;

  /**
   * @copydoc ServiceManagerInterface::isBusConnected
   */
  bool isBusConnected(const std::string& busId, const std::string& VLId) const final;

  /**
   * @copydoc ServiceManagerInterface::getRegulatedBus
   */
  std::shared_ptr<BusInterface> getRegulatedBus(const std::string& regulatingComponent) const override;

 private:
  /**
   * @brief Build graph associated with a voltage level
   *
   * @param graph Graph to update
   * @param vl the voltage level to process
   */
  static void buildGraph(Graph& graph, const std::shared_ptr<VoltageLevelInterface>& vl);

  /**
   * @brief retrieve the regulated bus on the side of the regulated object
   *
   * @param terminal regulated terminal
   * @returns regulated bus on the side of the regulated object
   */
  std::shared_ptr<BusInterface> getRegulatedBusOnSide(const powsybl::iidm::Terminal& terminal) const;

 private:
  const DataInterfaceIIDM* const dataInterface_;  ///< data interface
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSERVICEMANAGERINTERFACEIIDM_H_
