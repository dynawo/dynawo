//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

//======================================================================
/**
 * @file  DataInterface/PowSyblIIDM/DYNLoadInterfaceIIDM.h
 *
 * @brief Load data interface: header file for IIDM implementation
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNLOADINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNLOADINTERFACEIIDM_H_

#include "DYNLoadInterface.h"

#include "DYNInjectorInterfaceIIDM.h"

#include <powsybl/iidm/Load.hpp>

#include <string>

namespace DYN {

/**
 * class LoadInterfaceIIDM
 */
class LoadInterfaceIIDM : public LoadInterface, public InjectorInterfaceIIDM {
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
   * @param load : the load's iidm instance
   */
  explicit LoadInterfaceIIDM(powsybl::iidm::Load& load);

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent() override;

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters() override;

  /**
   * @copydoc ComponentInterface::isConnected()
   */
  bool isConnected() const override;

  /**
   * @copydoc LoadInterface::setBusInterface(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const std::shared_ptr<BusInterface>& busInterface) override;

  /**
   * @copydoc LoadInterface::setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) override;

  /**
   * @copydoc LoadInterface::getBusInterface() const
   */
  std::shared_ptr<BusInterface> getBusInterface() const override;

  /**
   * @copydoc LoadInterface::getInitialConnected()
   */
  bool getInitialConnected() override;

  /**
   * @copydoc LoadInterface::getP()
   */
  double getP() override;

  /**
   * @copydoc LoadInterface::getStateVarP()
   */
  double getStateVarP() const override;

  /**
   * @copydoc LoadInterface::getP0()
   */
  double getP0() const override;

  /**
   * @copydoc LoadInterface::getQ()
   */
  double getQ() override;

  /**
   * @copydoc LoadInterface::getQ0()
   */
  double getQ0() const override;

  /**
   * @copydoc LoadInterface::getID() const
   */
  const std::string& getID() const override {
    return loadIIDM_.getId();
  }

  /**
   * @copydoc LoadInterface::getPUnderVoltage()
   */
  double getPUnderVoltage() override;

  /**
   * @copydoc LoadInterface::isFictitious()
   */
  bool isFictitious() override;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const override;

  /**
   * @brief Getter for the load' country
   * @return the load country
   */
  inline const std::string& getCountry() const {
    return country_;
  }

  /**
   * @brief Setter for the load' country
   * @param country load country
   */
  inline void setCountry(const std::string& country) {
    country_ = country;
  }

 private:
  powsybl::iidm::Load& loadIIDM_;  ///< reference to the iidm load instance
  double loadPUnderV_;             ///< load power value if voltage is under threshold
  double v0_;                      ///< initial voltage of the bus where the load is connected
  double vNom_;                    ///<  nominal voltage of the bus where the load is connected
  std::string country_;            ///< country of the load
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNLOADINTERFACEIIDM_H_
