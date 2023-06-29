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
 * @file  DYNServiceManagerInterface.h
 *
 * @brief Service manager interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNSERVICEMANAGERINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNSERVICEMANAGERINTERFACE_H_

#include <string>
#include <vector>
#include "DYNBusInterface.h"

namespace DYN {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @brief Interface for dynawo service interface
 */
struct ServiceManagerInterface {
  /**
   * @brief Destructor
   */
  virtual ~ServiceManagerInterface() {}

  /// @brief Default constructor
  ServiceManagerInterface() = default;
  /// @brief Default copy constructor
  ServiceManagerInterface(const ServiceManagerInterface&) = default;
  /**
   * @brief Default copy assignement operator
   * @returns this
   */
  ServiceManagerInterface& operator=(const ServiceManagerInterface&) = default;

  /**
   * @brief Retrieve the buses linked to a bus by a switches network path
   *
   * precondition: bus of id @p busId is contained in voltage level @p VLId . @p VLId argument is here to improve performance
   * and avoid searching for the container of the bus.
   *
   * The voltage level interface must have a bus breaker topology
   *
   * @param busId bus id to check
   * @param VLId the id of the voltage level containing @p busId
   * @returns the list of the bus ids linked to @p busId
   */
  virtual std::vector<std::string> getBusesConnectedBySwitch(const std::string& busId, const std::string& VLId) const = 0;

  /**
   * @brief Returns true if the bus is connected to the network
   *
   * precondition: bus of id @p busId is contained in voltage level @p VLId . @p VLId argument is here to improve performance
   * and avoid searching for the container of the bus.
   *
   * @param busId bus id to check
   * @param VLId the id of the voltage level containing @p busId
   * @returns true if the bus @p busId is connected to the network
   */
  virtual bool isBusConnected(const std::string& busId, const std::string& VLId) const = 0;

  /**
   * @brief Retrieve the regulated bus interface
   *
   * @param regulatingComponent id of the regulating object
   * @returns regulated bus interface
   */
  virtual boost::shared_ptr<BusInterface> getRegulatedBus(const std::string& regulatingComponent) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNSERVICEMANAGERINTERFACE_H_
