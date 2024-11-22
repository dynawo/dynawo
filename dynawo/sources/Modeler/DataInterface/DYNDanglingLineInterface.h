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
 * @file  DYNDanglingLineInterface.h
 *
 * @brief Dangling line data interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNDANGLINGLINEINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNDANGLINGLINEINTERFACE_H_

#include "DYNComponentInterface.hpp"

namespace DYN {
class BusInterface;
class VoltageLevelInterface;
class CurrentLimitInterface;

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @brief Dangling line interface
 */
class DanglingLineInterface : public ComponentInterface {
 public:
  /**
   * @brief Constructor
   * @param hasInitialConditions @b true if component has initial conditions set, @b false else
   */
  explicit DanglingLineInterface(bool hasInitialConditions = true) : ComponentInterface(hasInitialConditions) {}

  /**
   * @brief Destructor
   */
  virtual ~DanglingLineInterface() = default;

  /**
   * @brief Add a curent limit interface
   * @param currentLimitInterface current limit interface for the danglingline
   */
  virtual void addCurrentLimitInterface(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface) = 0;

  /**
   * @brief Getter for the current limit interfaces f
   * @return currentLimitInterface of the danglingline
   */
  virtual std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces() const = 0;

  /**
   * @brief Setter for the danglingLine's bus interface
   * @param busInterface of the bus where the dangling line is connected
   */
  virtual void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the danglingLine's voltage interface
   * @param voltageLevelInterface of the voltageLevel where the dangling line is connected
   */
  virtual void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Getter for the danglingLine's bus interface
   * @return busInterface of the bus where the dangling line is connected
   */
  virtual boost::shared_ptr<BusInterface> getBusInterface() const = 0;

  /**
   * @brief Getter for the active power of the dangling line
   * @return The active power of the dangling line in MW
   */
  virtual double getP() = 0;

  /**
   * @brief Getter for the active power of the load injection
   * @return The active power of the load injection in MW
   */
  virtual double getP0() const = 0;

  /**
   * @brief Getter for the reactive power of the dangling line
   * @return The reactive power of the dangling line in Mvar
   */
  virtual double getQ() = 0;

  /**
   * @brief Getter for the reactive power of the load injection
   * @return The reactive power of the load injection in Mvar
   */
  virtual double getQ0() const = 0;

  /**
   * @brief Getter for the bus nominal voltage where the dangling line is connected
   * @return The bus nominal voltage where the dangling line is connected in kV
   */
  virtual double getVNom() const = 0;

  /**
   * @brief Getter for the resistance of the dangling line
   * @return The resistance of the dangling line in ohm
   */
  virtual double getR() const = 0;

  /**
   * @brief Getter for the reactance of the dangling line
   * @return The reactance of the dangling line in ohm
   */
  virtual double getX() const = 0;

  /**
   * @brief Getter for the conductance of the dangling line
   * @return The conductance of the dangling line in siemens
   */
  virtual double getG() const = 0;

  /**
   * @brief Getter for the susceptance of the dangling line
   * @return The susceptance of the dangling line in siemens
   */
  virtual double getB() const = 0;

  /**
   * @brief Getter for initial connection state of the dangling line
   * @return @b true is the dangling line is connected, @b false else
   */
  virtual bool getInitialConnected() = 0;

  /**
   * @brief Getter for the dangling line's id
   * @return The id of the dangling line
   */
  virtual std::string getID() const = 0;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  virtual void exportStateVariablesUnitComponent() = 0;
};  ///< class for dangling line model interface

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNDANGLINGLINEINTERFACE_H_
