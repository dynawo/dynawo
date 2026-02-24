//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

//======================================================================
/**
 * @file  DataInterface/PowSyblIIDM/DYNBatteryInterfaceIIDM.h
 *
 * @brief Battery data interface : header file for IIDM interface
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNBATTERYINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNBATTERYINTERFACEIIDM_H_

#include "DYNGeneratorInterface.h"
#include "DYNInjectorInterfaceIIDM.h"

#include <powsybl/iidm/Battery.hpp>
#include <powsybl/iidm/extensions/iidm/ActivePowerControl.hpp>
#include <powsybl/iidm/extensions/iidm/CoordinatedReactiveControl.hpp>

namespace DYN {

/**
 * class BatteryInterfaceIIDM
 */
class BatteryInterfaceIIDM : public GeneratorInterface, public InjectorInterfaceIIDM {
 public:
  /**
   * @brief defines the index of each state variable
   */
  typedef enum {
    VAR_P = 0,
    VAR_Q,
    VAR_STATE
  } indexVar_t;

 public:
  /**
   * @brief Constructor
   * @param battery battery iidm instance
   */
  explicit BatteryInterfaceIIDM(powsybl::iidm::Battery& battery);

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent() override;

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters() override;

  /**
   * @copydoc GeneratorInterface::setBusInterface(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const std::shared_ptr<BusInterface>& busInterface) override;

  /**
   * @copydoc GeneratorInterface::setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) override;

  /**
   * @copydoc GeneratorInterface::getBusInterface() const
   */
  std::shared_ptr<BusInterface> getBusInterface() const override;

  /**
   * @copydoc GeneratorInterface::getInitialConnected()
   */
  bool getInitialConnected() override;

  /**
   * @copydoc GeneratorInterface::getP()
   */
  double getP() override;

  /**
   * @copydoc GeneratorInterface::getStateVarP()
   */
  double getStateVarP() override;

  /**
   * @copydoc GeneratorInterface::getPMin()
   */
  double getPMin() override;

  /**
   * @copydoc GeneratorInterface::getPMax()
   */
  double getPMax() override;

  /**
   * @copydoc GeneratorInterface::getTargetP()
   */
  double getTargetP() override;

  /**
   * @copydoc GeneratorInterface::getQ()
   */
  double getQ() override;

  /**
   * @copydoc GeneratorInterface::getQMax()
   */
  double getQMax() override;

  /**
   * @copydoc GeneratorInterface::getQNom()
   */
  double getQNom() override;

  /**
   * @copydoc GeneratorInterface::getQMin()
   */
  double getQMin() override;

  /**
   * @copydoc GeneratorInterface::getTargetQ()
   */
  double getTargetQ() override;

  /**
   * @copydoc GeneratorInterface::getTargetV()
   */
  double getTargetV() override;

  /**
   * @copydoc GeneratorInterface::getID() const
   */
  const std::string& getID() const override;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const override;

  /**
   * @copydoc GeneratorInterface::getReactiveCurvesPoints() const
   */
  std::vector<ReactiveCurvePoint> getReactiveCurvesPoints() const override;

  /**
   * @copydoc GeneratorInterface::isVoltageRegulationOn() const
   */
  bool isVoltageRegulationOn() const override;

  /**
   * @copydoc GeneratorInterface::hasActivePowerControl() const
   */
  bool hasActivePowerControl() const override;

  /**
   * @copydoc GeneratorInterface::isParticipating() const
   */
  bool isParticipating() const override;

  /**
   * @copydoc GeneratorInterface::getActivePowerControlDroop() const
   */
  double getActivePowerControlDroop() const override;

  /**
   * @copydoc GeneratorInterface::hasCoordinatedReactiveControl() const
   */
  bool hasCoordinatedReactiveControl() const override;

  /**
   * @copydoc GeneratorInterface::getCoordinatedReactiveControlPercentage() const
   */
  double getCoordinatedReactiveControlPercentage() const override;

  /**
   * @brief Getter for the generator' country
   * @return the battery country
   */
  inline const std::string& getCountry() const {
    return country_;
  }

  /**
   * @brief Setter for the generator' country
   * @param country battery country
   */
  inline void setCountry(const std::string& country) {
    country_ = country;
  }

  /**
   * @copydoc GeneratorInterface::getEnergySource() const
   */
  EnergySource_t getEnergySource() const override;

 private:
  powsybl::iidm::Battery& batteryIIDM_;  ///< reference to the iidm battery instance
  std::string country_;  ///< country of the generator
  stdcxx::Reference<powsybl::iidm::extensions::iidm::ActivePowerControl> activePowerControl_;  ///< reference to ActivePowerControl extension
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNBATTERYINTERFACEIIDM_H_
