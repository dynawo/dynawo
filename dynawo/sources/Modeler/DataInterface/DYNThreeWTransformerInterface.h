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
 * @file  DYNThreeWTransformerInterface.h
 *
 * @brief Three windings transformer data interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNTHREEWTRANSFORMERINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNTHREEWTRANSFORMERINTERFACE_H_

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
 * @brief 3W transformer interface
 */
class ThreeWTransformerInterface : public ComponentInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~ThreeWTransformerInterface() = default;

  /**
   * @brief Add a curent limit interface for side 1
   * @param currentLimitInterface current limit interface for the side 1 of the tfo
   */
  virtual void addCurrentLimitInterface1(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface) = 0;

  /**
   * @brief Add a curent limit interface for side 2
   * @param currentLimitInterface current limit interface for the side 2 of the tfo
   */
  virtual void addCurrentLimitInterface2(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface) = 0;

  /**
   * @brief Add a curent limit interface for side 3
   * @param currentLimitInterface current limit interface for the side 3 of the tfo
   */
  virtual void addCurrentLimitInterface3(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface) = 0;

  /**
   * @brief Getter for the current limit interfaces for side 1
   * @return currentLimitInterface of the tfo's side 1
   */
  virtual std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces1() const = 0;

  /**
   * @brief Getter for the current limit interfaces for side 2
   * @return currentLimitInterface of the tfo's side 2
   */
  virtual std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces2() const = 0;

  /**
   * @brief Getter for the current limit interfaces for side 3
   * @return currentLimitInterface of the tfo's side 3
   */
  virtual std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces3() const = 0;

  /**
   * @brief Retrieve active season for the transformer
   * @returns active season
   */
  virtual std::string getActiveSeason() const = 0;

  /**
   * @brief Setter for the tfo's bus interface side 1
   * @param busInterface of the bus where the side 1 of the tfo is connected
   */
  virtual void setBusInterface1(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the tfo's bus interface side 2
   * @param busInterface of the bus where the side 2 of the tfo is connected
   */
  virtual void setBusInterface2(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the tfo's bus interface side 3
   * @param busInterface of the bus where the side 3 of the tfo is connected
   */
  virtual void setBusInterface3(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the tfo's voltageLevel interface side 1
   * @param voltageLevelInterface of the voltageLevel where the side 1 of the tfo is connected
   */
  virtual void setVoltageLevelInterface1(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Setter for the tfo's voltageLevel interface side 2
   * @param voltageLevelInterface of the voltageLevel where the side 2 of the tfo is connected
   */
  virtual void setVoltageLevelInterface2(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Setter for the tfo's voltageLevel interface side 3
   * @param voltageLevelInterface of the voltageLevel where the side 3 of the tfo is connected
   */
  virtual void setVoltageLevelInterface3(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Getter for the tfo's bus interface side 1
   * @return busInterface of the bus where the side 1 of the tfo is connected
   */
  virtual boost::shared_ptr<BusInterface> getBusInterface1() const = 0;

  /**
   * @brief Getter for the tfo's bus interface side 2
   * @return busInterface of the bus where the side 2 of the tfo is connected
   */
  virtual boost::shared_ptr<BusInterface> getBusInterface2() const = 0;

  /**
   * @brief Getter for the tfo's bus interface side 3
   * @return busInterface of the bus where the side 3 of the tfo is connected
   */
  virtual boost::shared_ptr<BusInterface> getBusInterface3() const = 0;

  /**
   * @brief Getter for the tfo's id
   * @return The id of the tfo
   */
  virtual std::string getID() const = 0;

  /**
   * @brief Getter for the initial connection state of the tfo's side 1
   * @return @b true if the tfo's side 1 is connected, @b false else
   */
  virtual bool getInitialConnected1() = 0;

  /**
   * @brief Getter for the initial connection state of the tfo's side 2
   * @return @b true if the tfo's side 2 is connected, @b false else
   */
  virtual bool getInitialConnected2() = 0;

  /**
   * @brief Getter for the initial connection state of the tfo's side 3
   * @return @b true if the tfo's side 3 is connected, @b false else
   */
  virtual bool getInitialConnected3() = 0;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  virtual void exportStateVariablesUnitComponent() = 0;
};  ///< Three windings transformer data interface class

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNTHREEWTRANSFORMERINTERFACE_H_
