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
 * @file  DYNLineInterface.h
 *
 * @brief Line data interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNLINEINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNLINEINTERFACE_H_

#include "DYNComponentInterface.hpp"

namespace DYN {
class BusInterface;
class CurrentLimitInterface;
class VoltageLevelInterface;

/**
 * class LineInterface
 */
class LineInterface : public ComponentInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~LineInterface() { }

  /**
   * @brief Add a curent limit interface for side 1
   * @param currentLimitInterface current limit interface for the side 1 of the line
   */
  virtual void addCurrentLimitInterface1(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface) = 0;

  /**
   * @brief Add a curent limit interface for side 2
   * @param currentLimitInterface current limit interface for the side 2 of the line
   */
  virtual void addCurrentLimitInterface2(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface) = 0;

  /**
   * @brief Getter for the current limit interfaces for side 1
   * @return currentLimitInterface of the line's side 1
   */
  virtual std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces1() const = 0;

  /**
   * @brief Getter for the current limit interfaces for side 2
   * @return currentLimitInterface of the line's side 2
   */
  virtual std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces2() const = 0;

  /**
   * @brief Setter for the line's bus interface side 1
   * @param busInterface of the bus where the side 1 of the line is connected
   */
  virtual void setBusInterface1(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the line's voltageLevel interface side 1
   * @param voltageLevelInterface of the bus where the side 1 of the line is connected
   */
  virtual void setVoltageLevelInterface1(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Setter for the line's bus interface side 2
   * @param busInterface of the bus where the side 2 of the line is connected
   */
  virtual void setBusInterface2(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the line's voltageLevel interface side 2
   * @param voltageLevelInterface of the bus where the side 2 of the line is connected
   */
  virtual void setVoltageLevelInterface2(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Getter for the line's bus interface side 1
   * @return busInterface of the bus where the side 1 of the line is connected
   */
  virtual boost::shared_ptr<BusInterface> getBusInterface1() const = 0;

  /**
   * @brief Getter for the line's bus interface side 2
   * @return busInterface of the bus where the side 2 of the line is connected
   */
  virtual boost::shared_ptr<BusInterface> getBusInterface2() const = 0;

  /**
   * @brief Getter for the nominal voltage of the line side 1
   * @return The nominal voltage of the line in kV side 1
   */
  virtual double getVNom1() const = 0;

  /**
   * @brief Getter for the nominal voltage of the line side 2
   * @return The nominal voltage of the line in kV side 2
   */
  virtual double getVNom2() const = 0;

  /**
   * @brief Getter for the resistance of the line
   * @return The resistance of the line in ohms
   */
  virtual double getR() const = 0;

  /**
   * @brief Getter for the reactance of the line
   * @return The reactance of the line in ohms
   */
  virtual double getX() const = 0;

  /**
   * @brief Getter for the side 1 susceptance of the line
   * @return The side 1 susceptance of the line in siemens
   */
  virtual double getB1() const = 0;

  /**
   * @brief Getter for the side 2 susceptance of the line
   * @return The side 2 susceptance of the line in siemens
   */
  virtual double getB2() const = 0;

  /**
   * @brief Getter for the side 1 conductance of the line
   * @return The side 1 conductance of the line in siemens
   */
  virtual double getG1() const = 0;

  /**
   * @brief Getter for the side 2 conductance of the line
   * @return The side 2 conductance of the line in siemens
   */
  virtual double getG2() const = 0;

  /**
   * @brief Getter for the initial active power of the line's side 1
   * @return the initial active power of the line's side 1
   */
  virtual double getP1() = 0;

  /**
   * @brief Getter for the initial reactive power of the line's side 1
   * @return the initial reactive power of the line's side 1
   */
  virtual double getQ1() = 0;

  /**
   * @brief Getter for the initial active power of the line's side 2
   * @return the initial active power of the line's side 2
   */
  virtual double getP2() = 0;

  /**
  * @brief Getter for the initial reactive power of the line's side 2
  * @return the initial reactive power of the line's side 2
  */
  virtual double getQ2() = 0;

  /**
   * @brief Getter for the initial connection state of the line's side 1
   * @return @b true if the line's side 1 is connected, @b false else
   */
  virtual bool getInitialConnected1() = 0;

  /**
   * @brief Getter for the initial connection state of the line's side 2
   * @return @b true if the line's side 2 is connected, @b false else
   */
  virtual bool getInitialConnected2() = 0;

  /**
   * @brief Getter for the line's id
   * @return The id of the line
   */
  virtual std::string getID() const = 0;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  virtual void exportStateVariablesUnitComponent() = 0;
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNLINEINTERFACE_H_
