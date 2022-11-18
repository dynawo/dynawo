//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
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

#include <boost/shared_ptr.hpp>

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
   * @brief Destructor
   */
  ~BatteryInterfaceIIDM();

  /**
   * @brief Constructor
   * @param battery battery iidm instance
   */
  explicit BatteryInterfaceIIDM(powsybl::iidm::Battery& battery);

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent();

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters();

  /**
   * @copydoc GeneratorInterface::setBusInterface(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc GeneratorInterface::setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc GeneratorInterface::getBusInterface() const
   */
  boost::shared_ptr<BusInterface> getBusInterface() const;

  /**
   * @copydoc GeneratorInterface::getInitialConnected()
   */
  bool getInitialConnected();

  /**
   * @copydoc GeneratorInterface::getP()
   */
  double getP();

  /**
   * @copydoc GeneratorInterface::getPMin()
   */
  double getPMin();

  /**
   * @copydoc GeneratorInterface::getPMax()
   */
  double getPMax();

  /**
   * @copydoc GeneratorInterface::getTargetP()
   */
  double getTargetP();

  /**
   * @copydoc GeneratorInterface::getQ()
   */
  double getQ();

  /**
   * @copydoc GeneratorInterface::getQMax()
   */
  double getQMax();

  /**
   * @copydoc GeneratorInterface::getDiagramQMax()
   */
  double getDiagramQMax();

  /**
   * @copydoc GeneratorInterface::getQMin()
   */
  double getQMin();

  /**
   * @copydoc GeneratorInterface::getTargetQ()
   */
  double getTargetQ();

  /**
   * @copydoc GeneratorInterface::getTargetV()
   */
  double getTargetV();

  /**
   * @copydoc GeneratorInterface::getID() const
   */
  std::string getID() const;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const;

  /**
   * @copydoc GeneratorInterface::getReactiveCurvesPoints() const
   */
  std::vector<ReactiveCurvePoint> getReactiveCurvesPoints() const;

  /**
   * @copydoc GeneratorInterface::isVoltageRegulationOn() const
   */
  bool isVoltageRegulationOn() const;

  /**
   * @copydoc GeneratorInterface::hasActivePowerControl() const
   */
  bool hasActivePowerControl() const;

  /**
   * @copydoc GeneratorInterface::isParticipating() const
   */
  bool isParticipating() const;

  /**
   * @copydoc GeneratorInterface::getActivePowerControlDroop() const
   */
  double getActivePowerControlDroop() const;

  /**
   * @copydoc GeneratorInterface::hasCoordinatedReactiveControl() const
   */
  bool hasCoordinatedReactiveControl() const;

  /**
   * @copydoc GeneratorInterface::getCoordinatedReactiveControlPercentage() const
   */
  double getCoordinatedReactiveControlPercentage() const;

  /**
   * @copydoc GeneratorInterface::getDroop() const
   */
  boost::optional<double> getDroop() const final;

  /**
   * @copydoc GeneratorInterface::getDroop() const
   */
  boost::optional<bool> isParticipate() const final;

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

 private:
  powsybl::iidm::Battery& batteryIIDM_;  ///< reference to the iidm battery instance
  std::string country_;  ///< country of the generator
  stdcxx::Reference<powsybl::iidm::extensions::iidm::ActivePowerControl> activePowerControl_;  ///< reference to ActivePowerControl extension
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNBATTERYINTERFACEIIDM_H_
