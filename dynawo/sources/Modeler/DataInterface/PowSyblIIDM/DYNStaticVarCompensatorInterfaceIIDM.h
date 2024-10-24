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
 * @file  DataInterface/PowSyblIIDM/DYNStaticVarCompensatorInterfaceIIDM.h
 *
 * @brief Static var compensator interface : header file for IIDM implementation
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSTATICVARCOMPENSATORINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSTATICVARCOMPENSATORINTERFACEIIDM_H_

#include <powsybl/iidm/StaticVarCompensator.hpp>
#include <powsybl/iidm/extensions/iidm/VoltagePerReactivePowerControl.hpp>

#include "DYNStaticVarCompensatorInterface.h"
#include "DYNInjectorInterfaceIIDM.h"
#include "DYNStaticVarCompensatorInterfaceIIDMExtension.h"
#include "DYNIIDMExtensions.hpp"

namespace DYN {

/**
 * class StaticVarCompensatorInterfaceIIDM
 */
class StaticVarCompensatorInterfaceIIDM : public StaticVarCompensatorInterface, public InjectorInterfaceIIDM {
 public:
  /**
   * @brief defines the index of each state variable
   */
  typedef enum {
    VAR_P = 0,
    VAR_Q,
    VAR_STATE,
    VAR_REGULATINGMODE
  } indexVar_t;

 public:
  /**
   * @brief Destructor
   */
  ~StaticVarCompensatorInterfaceIIDM();

  /**
   * @brief Constructor
   * @param svc static var compensator's iidm instance
   */
  explicit StaticVarCompensatorInterfaceIIDM(powsybl::iidm::StaticVarCompensator& svc);

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent();

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters();

  /**
   * @copydoc ComponentInterface::isConnected()
   */
  bool isConnected() const;

  /**
   * @copydoc StaticVarCompensatorInterface::setBusInterface(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const std::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc StaticVarCompensatorInterface::setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc StaticVarCompensatorInterface::getBusInterface() const
   */
  std::shared_ptr<BusInterface> getBusInterface() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getInitialConnected()
   */
  bool getInitialConnected();

  /**
   * @copydoc StaticVarCompensatorInterface::getVNom() const
   */
  double getVNom() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getID() const
   */
  std::string getID() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getBMin() const
   */
  double getBMin() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getUMinActivation() const
   */
  double getUMinActivation() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getUMaxActivation() const
   */
  double getUMaxActivation() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getUSetPointMin() const
   */
  double getUSetPointMin() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getUSetPointMax() const
   */
  double getUSetPointMax() const;

  /**
   * @copydoc StaticVarCompensatorInterface::hasStandbyAutomaton() const
   */
  bool hasStandbyAutomaton() const;

  /**
   * @copydoc StaticVarCompensatorInterface::isStandBy() const
   */
  bool isStandBy() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getB0() const
   */
  double getB0() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getBMax() const
   */
  double getBMax() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getVSetPoint() const
   */
  double getVSetPoint() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getReactivePowerSetPoint() const
   */
  double getReactivePowerSetPoint() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getRegulationMode() const
   */
  StaticVarCompensatorInterface::RegulationMode_t getRegulationMode() const;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const;

  /**
   * @copydoc StaticVarCompensatorInterface::getP()
   */
  double getP();

  /**
   * @copydoc StaticVarCompensatorInterface::getQ()
   */
  double getQ();

  /**
   * @copydoc StaticVarCompensatorInterface::hasVoltagePerReactivePowerControl() const
   */
  bool hasVoltagePerReactivePowerControl() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getSlope() const
   */
  double getSlope() const;

 private:
  powsybl::iidm::StaticVarCompensator& staticVarCompensatorIIDM_;  ///< reference to the iidm static var compensator instance
  StaticVarCompensatorInterfaceIIDMExtension* extension_;  ///< extension's pointer
  IIDMExtensions::DestroyFunction<StaticVarCompensatorInterfaceIIDMExtension> destroy_extension_;  ///< function pointer to destroy the extension
  stdcxx::Reference<powsybl::iidm::extensions
                    ::iidm::VoltagePerReactivePowerControl> voltagePerReactivePowerControl_;  ///< reference to voltagePerReactivePowerControl_ extension
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSTATICVARCOMPENSATORINTERFACEIIDM_H_
