//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  DataInterface/PowSyblIIDM/DYNShuntCompensatorInterfaceIIDM.h
 *
 * @brief Shunt compensator interface : header file for IIDM implementation
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSHUNTCOMPENSATORINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSHUNTCOMPENSATORINTERFACEIIDM_H_

#include "DYNShuntCompensatorInterface.h"
#include "DYNInjectorInterfaceIIDM.h"
#include <powsybl/iidm/ShuntCompensator.hpp>

namespace DYN {

/**
 * class ShuntCompensatorInterfaceIIDM
 */
class ShuntCompensatorInterfaceIIDM : public ShuntCompensatorInterface, public InjectorInterfaceIIDM {
 public:
  /**
   * @brief defines the index of each state variable
   */
  typedef enum {
    VAR_Q = 0,
    VAR_STATE,
    VAR_CURRENTSECTION
  } indexVar_t;

 public:
  /**
   * @brief Constructor
   * @param shunt shunt compensator's iidm instance
   */
  explicit ShuntCompensatorInterfaceIIDM(powsybl::iidm::ShuntCompensator& shunt);

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
   * @copydoc ShuntCompensatorInterface::setBusInterface(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const std::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc ShuntCompensatorInterface::setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc ShuntCompensatorInterface::getBusInterface() const
   */
  std::shared_ptr<BusInterface> getBusInterface() const;

  /**
   * @copydoc ShuntCompensatorInterface::getInitialConnected()
   */
  bool getInitialConnected();

  /**
   * @copydoc ShuntCompensatorInterface::getVNom() const
   */
  double getVNom() const;

  /**
   * @copydoc ShuntCompensatorInterface::getQ()
   */
  double getQ();

  /**
   * @copydoc ShuntCompensatorInterface::getID() const
   */
  const std::string& getID() const;

  /**
   * @copydoc ShuntCompensatorInterface::getCurrentSection() const
   */
  int getCurrentSection() const;

  /**
   * @copydoc ShuntCompensatorInterface::getMaximumSection() const
   */
  int getMaximumSection() const;

  /**
   * @copydoc ShuntCompensatorInterface::isVoltageRegulationOn() const
   */
  bool isVoltageRegulationOn() const final;

  /**
   * @copydoc ShuntCompensatorInterface::getTargetV() const
   */
  double getTargetV() const final;

  /**
   * @brief Getter for the shuntCompensator's cumulative susceptance at given section
   *  i.e. the sum of the sections' susceptances from 1 to section
   * @param section at which calculate the shuntsCompensator's susceptance
   * @return The cumulative susceptance in Siemens, at given section of the shunt compensator
   */
  double getB(const int section) const;

  /**
   * @brief Getter for model type of the shunt compensator
   * @return @b true if the shunt compensator is linear, @b false otherwise
   */
  bool isLinear() const;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const;

 private:
  powsybl::iidm::ShuntCompensator& shuntCompensatorIIDM_;  ///< reference to the iidm shunt compensator instance
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSHUNTCOMPENSATORINTERFACEIIDM_H_
