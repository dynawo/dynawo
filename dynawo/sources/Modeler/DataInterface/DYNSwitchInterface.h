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
 * @file  DYNSwitchInterface.h
 *
 * @brief Switch data interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNSWITCHINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNSWITCHINTERFACE_H_


#include "DYNComponentInterface.hpp"

namespace DYN {
class BusInterface;

/**
 * class SwitchInterface
 */
class SwitchInterface : public ComponentInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~SwitchInterface() { }

  /**
   * @brief Getter for the switch's state
   * @return @b true if the switch is open, @b false else
   */
  virtual bool isOpen() const = 0;

  /**
   * @brief open the IIDM switch
   */
  virtual void open() = 0;

  /**
   * @brief close the IIDM switch
   */
  virtual void close() = 0;

  /**
   * @brief Getter for the switch's id
   * @return The id of the switch
   */
  virtual std::string getID() const = 0;

  /**
   * @brief Setter for the switch's bus interface side 1
   * @param busInterface of the bus where the side 1 of the switch is connected
   */
  virtual void setBusInterface1(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the switch's bus interface side 2
   * @param busInterface of the bus where the side 2 of the switch is connected
   */
  virtual void setBusInterface2(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Getter for the switch's bus interface side 1
   * @return busInterface of the bus where the side 1 of the switch is connected
   */
  virtual boost::shared_ptr<BusInterface> getBusInterface1() const = 0;

  /**
   * @brief Getter for the switch's bus interface side 2
   * @return busInterface of the bus where the side 2 of the switch is connected
   */
  virtual boost::shared_ptr<BusInterface> getBusInterface2() const = 0;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  virtual void exportStateVariablesUnitComponent() = 0;
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNSWITCHINTERFACE_H_
