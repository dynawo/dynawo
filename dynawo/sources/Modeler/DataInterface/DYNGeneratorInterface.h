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
 * @file  DYNGeneratorInterface.h
 *
 * @brief Generator data interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNGENERATORINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNGENERATORINTERFACE_H_

#include "DYNComponentInterface.hpp"
#include "DYNReactiveCurvePointsInterface.h"

#include <vector>
#include <boost/optional.hpp>

namespace DYN {
class BusInterface;
class VoltageLevelInterface;

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @brief Generator component
 */
class GeneratorInterface : public ComponentInterface, public ReactiveCurvePointsInterface {
 public:
  /**
   * @brief energy source type definition
   */
  typedef enum {
    SOURCE_HYDRO,
    SOURCE_NUCLEAR,
    SOURCE_WIND,
    SOURCE_THERMAL,
    SOURCE_SOLAR,
    SOURCE_OTHER
  } EnergySource_t;
  /**
   * @brief Constructor
   * @param hasInitialConditions @b true if component has initial conditions set, @b false else
   */
  explicit GeneratorInterface(bool hasInitialConditions = true) : ComponentInterface(hasInitialConditions) {}

  /**
   * @brief Setter for the generator's bus interface
   * @param busInterface of the bus where the generator is connected
   */
  virtual void setBusInterface(const std::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the generator's voltage interface
   * @param voltageLevelInterface of the voltageLevel where the generator is connected
   */
  virtual void setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Getter for the generator's bus interface
   * @return busInterface of the bus where the generator is connected
   */
  virtual std::shared_ptr<BusInterface> getBusInterface() const = 0;

  /**
   * @brief Getter for the active power of the generator
   * @return The active power of the generator in MW (generator convention)
   */
  virtual double getP() = 0;

  /**
   * @brief Getter for the state variable "p"
   * @return The value of state variable p of the generator in MW
   */
  virtual double getStateVarP() = 0;

  /**
   * @brief Getter for the minimum active power of the generator
   * @return The minimum active power of the generator in MW (generator convention)
   */
  virtual double getPMin() = 0;

  /**
   * @brief Getter for the maximum active power of the generator
   * @return The maximum active power of the generator in MW (generator convention)
   */
  virtual double getPMax() = 0;

  /**
   * @brief Getter for the target active power of the generator
   * @return The target active power of the generator in MW (receptor convention)
   */
  virtual double getTargetP() = 0;

  /**
   * @brief Getter for the reactive power of the generator
   * @return The reactive power of the generator in Mvar (generator convention)
   */
  virtual double getQ() = 0;

  /**
   * @brief Getter for the maximum reactive power of the generator
   * @return The maximum reactive power of the generator in Mvar (generator convention)
   */
  virtual double getQMax() = 0;

  /**
   * @brief Getter for the nominal reactive power of the generator
   * @return The nominal reactive power of the generator in Mvar (generator convention), computed as the maximum absolute value of the PQ diagram
   */
  virtual double getQNom() = 0;

  /**
   * @brief Getter for the minimum reactive power of the generator
   * @return The minimum reactive power of the generator in Mvar (generator convention)
   */
  virtual double getQMin() = 0;

  /**
   * @brief Getter for the target reactive power of the generator
   * @return The target reactive power of the generator in Mvar (receptor convention)
   */
  virtual double getTargetQ() = 0;

  /**
   * @brief Getter for the target voltage of the generator
   * @return The target voltage of the generator in kV
   */
  virtual double getTargetV() = 0;

  /**
   * @brief Getter for the initial connection state of the generator
   * @return @b true if the generator is connected, @b false else
   */
  virtual bool getInitialConnected() = 0;

  /**
   * @brief Getter for the generator's id
   * @return The id of the generator
   */
  virtual const std::string& getID() const = 0;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  virtual void exportStateVariablesUnitComponent() = 0;

  /**
   * @copydoc ReactiveCurvePointsInterface::getReactiveCurvesPoints() const
   */
  virtual std::vector<ReactiveCurvePoint> getReactiveCurvesPoints() const = 0;

  /**
   * @brief Determines if voltage regulation is on
   * @returns whether voltage regulation is on
   */
  virtual bool isVoltageRegulationOn() const = 0;

  /**
   * @brief Determines if generator has active power control information
   * @returns whether generator has active power control information
   */
  virtual bool hasActivePowerControl() const = 0;

  /**
   * @brief Determines if generator is participating in active power control
   * @returns whether generator is participating to active power control
   */
  virtual bool isParticipating() const = 0;

  /**
   * @brief Getter for the active power control droop
   * @returns active power control droop value
   */
  virtual double getActivePowerControlDroop() const = 0;

  /**
   * @brief Determines if generator has coordinated reactive power control information
   * @returns whether generator has coordinated reactive power power control information
   */
  virtual bool hasCoordinatedReactiveControl() const = 0;

  /**
   * @brief Getter for the reactive power control percentage of participation
   * @returns reactive power control percentage of participation value
   */
  virtual double getCoordinatedReactiveControlPercentage() const = 0;

  /**
   * @brief Getter for energy source type
   * @returns energy source type
   */
  virtual EnergySource_t getEnergySource() const = 0;
};  ///< Class for Generator data interface

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNGENERATORINTERFACE_H_
