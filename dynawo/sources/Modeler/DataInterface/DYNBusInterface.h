//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
 * @file  DYNBusInterface.h
 *
 * @brief Bus data interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNBUSINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNBUSINTERFACE_H_

#include <string>

#include "DYNComponentInterface.hpp"

namespace DYN {

class BusInterface : public ComponentInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~BusInterface() { }

  /**
   * @brief Getter for the voltage magnitude of the bus
   * @return The voltage magnitude of the bus in kV
   */
  virtual double getV0() const = 0;

  /**
   * @brief Getter for the minimum voltage magnitude of the bus
   * @return The minimum voltage magnitude of the bus in kV
   * returns 0.8*vNom if vMin does not exist
   */
  virtual double getVMin() const = 0;

  /**
   * @brief Getter for the maximum voltage magnitude of the bus
   * @return The maximum voltage magnitude of the bus in kV
   * returns 1.2*vNom if vMax does not exist
   */
  virtual double getVMax() const = 0;

  /**
   * @brief Getter for the voltage angle of the bus
   * @return The voltage angle of the bus in degree
   */
  virtual double getAngle0() const = 0;

  /**
   * @brief Getter for the nominal voltage of the bus
   * @return The nominal voltage of the bus in kV
   */
  virtual double getVNom() const = 0;

  /**
   * @brief Getter for the state variable "v"
   * @return The value of state variable v of the bus in kV
   */
  virtual double getStateVarV() const = 0;

  /**
   * @brief Getter for the state variable "angle"
   * @return The value of state variable angle of the bus in degree
   */
  virtual double getStateVarAngle() const = 0;

  /**
   * @brief Getter for the bus' id
   * @return The id of the bus
   */
  virtual std::string getID() const = 0;

  /**
   * @brief Getter for the bus index
   * @return The index of the bus
   */
  virtual int getBusIndex() const = 0;

  /**
   * @brief Setter for bus outside connection attribute
   * @param hasConnection @b true if the bus has an outside connection, @b false else
   *
   * the bus has an outside connection if there is at least one dynamic model
   * connected to the bus
   */
  virtual void hasConnection(bool hasConnection) = 0;

  /**
   * @brief Getter for the bus' connection attribute
   * @return @b true if the bus has an outside connection, @b false else
   */
  virtual bool hasConnection() const = 0;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  virtual void exportStateVariablesUnitComponent() = 0;

  /**
   * @brief get the names of bus bar section associated to the bus
   * @return names of the bus bar section associated to the bus
   */
  virtual std::vector<std::string> getBusBarSectionNames() const = 0;
};  ///< Interface class for Bus model
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNBUSINTERFACE_H_
