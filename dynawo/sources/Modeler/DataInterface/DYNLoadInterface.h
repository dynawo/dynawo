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
 * @file  DYNLoadInterface.h
 *
 * @brief Load data interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNLOADINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNLOADINTERFACE_H_

#include "DYNComponentInterface.hpp"

namespace DYN {
class BusInterface;
class VoltageLevelInterface;
class ModelLoad;

/**
 * class LoadInterface
 */
class LoadInterface : public ComponentInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~LoadInterface() { }

  /**
   * @brief Setter for the load's bus interface
   * @param busInterface of the bus where the load is connected
   */
  virtual void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the load's voltage interface
   * @param voltageLevelInterface of the voltageLevel where the load is connected
   */
  virtual void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Getter for the load's bus interface
   * @return busInterface of the bus where the load is connected
   */
  virtual boost::shared_ptr<BusInterface> getBusInterface() const = 0;

  /**
   * @brief Getter for the active power of the load
   * @return The active power of the load in MW (load convention)
   */
  virtual double getP() = 0;

  /**
   * @brief Getter for the reactive power of the load
   * @return The reactive power of the load in Mvar (load convention)
   */
  virtual double getQ() = 0;

  /**
   * @brief Getter for the initial connection state of the load
   * @return @b true is the load is connected, @b false else
   */
  virtual bool getInitialConnected() = 0;

  /**
   * @brief Getter for the load's id
   * @return The id of the load
   */
  virtual std::string getID() const = 0;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  virtual void exportStateVariablesUnitComponent() = 0;

  /**
   * @brief load power under voltage threshold
   * @return value of load power if voltage is under threshold, 0 otherwise
   */
  virtual double getPUnderVoltage() = 0;
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNLOADINTERFACE_H_
