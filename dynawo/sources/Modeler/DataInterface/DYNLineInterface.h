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
#include "DYNCurrentLimits.h"

#include <boost/optional.hpp>

namespace DYN {
class BusInterface;
class CurrentLimitInterface;
class VoltageLevelInterface;

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * class LineInterface
 */
class LineInterface : public ComponentInterface {
 public:
  /**
   * @brief Constructor
   * @param hasInitialConditions @b true if component has initial conditions set, @b false else
   */
  explicit LineInterface(bool hasInitialConditions = true) : ComponentInterface(hasInitialConditions) {}

  /**
   * @brief Destructor
   */
  ~LineInterface() override = default;

  /**
   * @brief Add a curent limit interface for side 1
   * @param currentLimitInterface current limit interface for the side 1 of the line
   */
  virtual void addCurrentLimitInterface1(std::unique_ptr<CurrentLimitInterface> currentLimitInterface) = 0;

  /**
   * @brief Add a curent limit interface for side 2
   * @param currentLimitInterface current limit interface for the side 2 of the line
   */
  virtual void addCurrentLimitInterface2(std::unique_ptr<CurrentLimitInterface> currentLimitInterface) = 0;

  /**
   * @brief Getter for the current limit interfaces for side 1
   * @return currentLimitInterface of the line's side 1
   */
  virtual const std::vector<std::unique_ptr<CurrentLimitInterface> >& getCurrentLimitInterfaces1() const = 0;

  /**
   * @brief Getter for the current limit interfaces for side 2
   * @return currentLimitInterface of the line's side 2
   */
  virtual const std::vector<std::unique_ptr<CurrentLimitInterface> >& getCurrentLimitInterfaces2() const = 0;

  /**
   * @brief Setter for the line's bus interface side 1
   * @param busInterface of the bus where the side 1 of the line is connected
   */
  virtual void setBusInterface1(const std::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the line's bus interface side 2
   * @param busInterface of the bus where the side 2 of the line is connected
   */
  virtual void setBusInterface2(const std::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Getter for the line's bus interface side 1
   * @return busInterface of the bus where the side 1 of the line is connected
   */
  virtual std::shared_ptr<BusInterface> getBusInterface1() const = 0;

  /**
   * @brief Getter for the line's bus interface side 2
   * @return busInterface of the bus where the side 2 of the line is connected
   */
  virtual std::shared_ptr<BusInterface> getBusInterface2() const = 0;

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
   * @return The resistance of the line in ohm
   */
  virtual double getR() const = 0;

  /**
   * @brief Getter for the reactance of the line
   * @return The reactance of the line in ohm
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
  const std::string& getID() const override = 0;

  /**
   * @brief Retrieve active season for the line
   * @returns active season
   */
  virtual std::string getActiveSeason() const = 0;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent() override = 0;

  /**
   * @brief Retrieve the permanent limit
   *
   * @param season the season to apply
   * @param side the current limit side
   * @returns the permanent limit or nullopt if current limit extension, season or side not found
   */
  virtual boost::optional<double> getCurrentLimitPermanent(const std::string& season, CurrentLimitSide side) const = 0;

  /**
   * @brief Retrieve the side of temporary limits of a current limit
   *
   * @param season the season to apply
   * @param side the current limit side
   * @returns the side of temporary limits or nullopt if current limit extension, season or side not found
   */
  virtual boost::optional<unsigned int> getCurrentLimitNbTemporary(const std::string& season, CurrentLimitSide side) const = 0;

  /**
   * @brief Retrieve the name of a temporary limit of a current limit
   *
   * @param season the season to apply
   * @param side the current limit side
   * @param indexTemporary the index of the temporary limit
   * @returns the name of the temporary limit or nullopt if current limit extension, season, side or index not found
   */
  virtual boost::optional<std::string> getCurrentLimitTemporaryName(const std::string& season, CurrentLimitSide side,
    unsigned int indexTemporary) const = 0;

  /**
   * @brief Retrieve the acceptable duration of a temporary limit of a current limit
   *
   * @param season the season to apply
   * @param side the current limit side
   * @param indexTemporary the index of the temporary limit
   * @returns the acceptable duration of the temporary limit or nullopt if current limit extension, season, side or index not found
   */
  virtual boost::optional<unsigned long> getCurrentLimitTemporaryAcceptableDuration(const std::string& season, CurrentLimitSide side,
    unsigned int indexTemporary) const = 0;

  /**
   * @brief Retrieve the value of a temporary limit of a current limit
   *
   * @param season the season to apply
   * @param side the current limit side
   * @param indexTemporary the index of the temporary limit
   * @returns the value of the temporary limit or nullopt if current limit extension, season, side or index not found
   */
  virtual boost::optional<double> getCurrentLimitTemporaryValue(const std::string& season, CurrentLimitSide side, unsigned int indexTemporary) const = 0;

  /**
   * @brief Determines if a temporary limit of a current limit is fictitious
   *
   * @param season the season to apply
   * @param side the current limit side
   * @param indexTemporary the index of the temporary limit
   * @returns true if the temporary limit is fictitious, false if not or nullopt if current limit extension, season, side or index not found
   */
  virtual boost::optional<bool> getCurrentLimitTemporaryFictitious(const std::string& season, CurrentLimitSide side, unsigned int indexTemporary) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNLINEINTERFACE_H_
