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
 * @file  DYNTwoWTransformerInterface.h
 *
 * @brief Two windings transformer data interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNTWOWTRANSFORMERINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNTWOWTRANSFORMERINTERFACE_H_

#include "DYNComponentInterface.hpp"

namespace DYN {
class BusInterface;
class PhaseTapChangerInterface;
class RatioTapChangerInterface;
class CurrentLimitInterface;
class VoltageLevelInterface;

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * class TwoWTransformerInterface
 */
class TwoWTransformerInterface : public ComponentInterface {
 public:
  /**
   * @brief Constructor
   * @param hasInitialConditions @b true if component has initial conditions set, @b false else
   */
  explicit TwoWTransformerInterface(bool hasInitialConditions = true) : ComponentInterface(hasInitialConditions) {}

  /**
   * @brief Destructor
   */
  virtual ~TwoWTransformerInterface() { }

  /**
   * @brief Setter for the tfo's bus interface side 1
   * @param busInterface of the bus where the side 1 of the tfo is connected
   */
  virtual void setBusInterface1(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the tfo's voltageLevel interface side 1
   * @param voltageLevelInterface of the bus where the side 1 of the tfo is connected
   */
  virtual void setVoltageLevelInterface1(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Setter for the tfo's bus interface side 2
   * @param busInterface of the bus where the side 2 of the tfo is connected
   */
  virtual void setBusInterface2(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the tfo's voltageLevel interface side 2
   * @param voltageLevelInterface of the bus where the side 2 of the tfo is connected
   */
  virtual void setVoltageLevelInterface2(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

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
   * @brief Retrieve active season for the transformer
   * @returns active season
   */
  virtual std::string getActiveSeason() const = 0;

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
   * @brief Getter for the nominal voltage of the tfo's side 1
   * @return The nominal voltage of the tfo's side 1 in kV
   */
  virtual double getVNom1() const = 0;

  /**
   * @brief Getter for the nominal voltage of the tfo's side 2
   * @return The nominal voltage of the tfo's side 2 in kV
   */
  virtual double getVNom2() const = 0;

  /**
   * @brief Getter for the rated voltage of the tfo's side 1
   * @return The rated voltage of the tfo's side 1 in kV
   */
  virtual double getRatedU1() const = 0;

  /**
   * @brief Getter for the rated voltage of the tfo's side 2
   * @return The rated voltage of the tfo's side 2 in kV
   */
  virtual double getRatedU2() const = 0;

  /**
   * @brief Getter for the active power of the transformer at side 1
   * @return The active power of the transformer in MW  at side 1
   */
  virtual double getP1() = 0;

  /**
   * @brief Getter for the reactive power of the transformer at side 1
   * @return The reactive power of the transformer in Mvar at side 1
   */
  virtual double getQ1() = 0;

  /**
   * @brief Getter for the active power of the transformer at side 2
   * @return The active power of the transformer in MW  at side 2
   */
  virtual double getP2() = 0;

  /**
   * @brief Getter for the reactive power of the transformer at side 2
   * @return The reactive power of the transformer in Mvar at side 2
   */
  virtual double getQ2() = 0;

  /**
   * @brief Getter for the instance of phaseTapChanger interface
   * @return the instance of phaseTapChanger interface
   */
  virtual boost::shared_ptr<PhaseTapChangerInterface> getPhaseTapChanger() const = 0;

  /**
   * @brief Getter for the instance of ratioTapChanger interface
   * @return the instance of ratioTapChanger interface
   */
  virtual boost::shared_ptr<RatioTapChangerInterface> getRatioTapChanger() const = 0;

  /**
   * @brief Setter for the instance of phase tap changer interface
   * @param tapChanger the instance of phaseTapChanger interface
   */
  virtual void setPhaseTapChanger(const boost::shared_ptr<PhaseTapChangerInterface>& tapChanger) = 0;
  /**
   * @brief Setter for the instance of ratio tap changer interface
   * @param tapChanger the instance of ratioTapChanger interface
   */
  virtual void setRatioTapChanger(const boost::shared_ptr<RatioTapChangerInterface>& tapChanger) = 0;

  /**
   * @brief Getter for the resistance of the tfo
   * @return The resistance of the tfo in ohms
   */
  virtual double getR() const = 0;

  /**
   * @brief Getter for the reactance of the tfo
   * @return The reactance of the tfo in ohms
   */
  virtual double getX() const = 0;

  /**
   * @brief Getter for the conductance of the tfo
   * @return The conductance of the tfo in siemens
   */
  virtual double getG() const = 0;

  /**
   * @brief Getter for the susceptance of the tfo
   * @return The susceptance of the tfo in siemens
   */
  virtual double getB() const = 0;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  virtual void exportStateVariablesUnitComponent() = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNTWOWTRANSFORMERINTERFACE_H_
