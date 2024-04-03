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

//======================================================================
/**
 * @file  DYNStaticVarCompensatorInterface.h
 *
 * @brief static var compensator interface : header file
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_DYNSTATICVARCOMPENSATORINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNSTATICVARCOMPENSATORINTERFACE_H_

#include "DYNComponentInterface.hpp"

namespace DYN {
class BusInterface;
class VoltageLevelInterface;

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @brief Static var compensator interface
 */
class StaticVarCompensatorInterface : public ComponentInterface {
 public:
  /**
   * @brief Definition of the regulation mode of the static var compensator
   */
  // Enumeration in Modelica always begins from 1.
  // To be consistent with Modelica constant in RegulatingMode.mo in SVarC, OFF=1 instead of 0
  typedef enum {
    OFF = 1,
    STANDBY = 2,
    RUNNING_V = 3,
    RUNNING_Q = 4
  } RegulationMode_t;

 public:
  /**
   * @brief Constructor
   * @param hasInitialConditions @b true if component has initial conditions set, @b false else
   */
  explicit StaticVarCompensatorInterface(bool hasInitialConditions = true) : ComponentInterface(hasInitialConditions) {}

  /**
   * @brief Destructor
   */
  virtual ~StaticVarCompensatorInterface() = default;

  /**
   * @brief Setter for the staticVarCompensator's bus interface
   * @param busInterface of the bus where the static var compensator is connected
   */
  virtual void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the staticVarCompensator's voltage interface
   * @param voltageLevelInterface of the voltageLevel where the staticVarCompensator is connected
   */
  virtual void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Getter for the staticVarCompensator's bus interface
   * @return busInterface of the bus where the static var compensator is connected
   */
  virtual boost::shared_ptr<BusInterface> getBusInterface() const = 0;

  /**
   * @brief Getter for the nominal voltage of the bus where the static var compensator is connected
   * @return The nominal voltage of the bus where the static var compensator is connected in kV
   */
  virtual double getVNom() const = 0;

  /**
   * @brief Getter for the minimum susceptance
   * @return the minimum susceptance
   */
  virtual double getBMin() const = 0;

  /**
   * @brief Getter for the maximum susceptance
   * @return the maximum susceptance
   */
  virtual double getBMax() const = 0;

  /**
   * @brief Getter for the voltage set-point
   * @return The voltage set-point in kV
   */
  virtual double getVSetPoint() const = 0;

  /**
   * @brief Getter for the reactive power set-point
   * @return The reactive power set-point in Mvar
   */
  virtual double getReactivePowerSetPoint() const = 0;

  /**
   * @brief Getter for the regulating mode of the static var compensator
   * @return the regulating mode of the static var compensator
   */
  virtual RegulationMode_t getRegulationMode() const = 0;

  /**
   * @brief Getter for the initial connection state of the static var compensator
   * @return @b true if the static var compensator is connected, @b false else
   */
  virtual bool getInitialConnected() = 0;

  /**
   * @brief Getter for the static var compensator's id
   * @return The id of the static var compensator
   */
  virtual std::string getID() const = 0;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  virtual void exportStateVariablesUnitComponent() = 0;

  /**
   * @brief Getter for the extension's presence
   * @return true if the extension is loaded
   */
  virtual bool hasStandbyAutomaton() const = 0;

  /**
   * @brief Getter for the voltage limit inf for running mode activation when in standby
   * @return the the voltage limit inf for running mode activation when in standby
   */
  virtual double getUMinActivation() const = 0;

  /**
   * @brief Getter for the voltage limit sup for running mode activation when in standby
   * @return the the voltage limit sup for running mode activation when in standby
   */
  virtual double getUMaxActivation() const = 0;

  /**
   * @brief Getter for the voltage target once Umin has been reached
   * @return the voltage target once Umin has been reached
   */
  virtual double getUSetPointMin() const = 0;

  /**
   * @brief Getter for the voltage target once Umax has been reached
   * @return the voltage target once Umax has been reached
   */
  virtual double getUSetPointMax() const = 0;

  /**
   * @brief Getter for the standby state of the svc
   * @return true if in standby mode
   */
  virtual bool isStandBy() const = 0;

  /**
   * @brief Getter for the constant shunt susceptance used in standby mode
   * @return the constant shunt susceptance used in standby mode
   */
  virtual double getB0() const = 0;

  /**
   * @brief Getter for the active power of static var compensator in MW (Receptor convention)
   * @return The active power of the static var compensator in MW (Receptor convention)
   */
  virtual double getP() = 0;

  /**
   * @brief Getter for the reactive power of static var compensator in Mvar (Receptor convention)
   * @return The reactive power of the static var compensator in Mvar (Receptor convention)
   */
  virtual double getQ() = 0;

  /**
   * @brief Determines if static var compensator has voltage per reactive power control information
   * @returns whether static var compensator has voltage per reactive power control information
   */
  virtual bool hasVoltagePerReactivePowerControl() const = 0;

  /**
   * @brief Getter for static var compensator slope
   * @returns static var compensator slope value
   */
  virtual double getSlope() const = 0;
};  ///< Interface class for Static Var Compensator

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNSTATICVARCOMPENSATORINTERFACE_H_
