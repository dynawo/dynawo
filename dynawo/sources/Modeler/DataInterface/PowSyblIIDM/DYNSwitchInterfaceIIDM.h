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

/**
 * @file  DataInterface/PowSyblIIDM/DYNSwitchInterfaceIIDM.h
 *
 * @brief Switch data interface : header file for IIDM implementation
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSWITCHINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSWITCHINTERFACEIIDM_H_

#include <powsybl/iidm/Switch.hpp>

#include "DYNSwitchInterface.h"

namespace DYN {

/**
 * class SwitchInterfaceIIDM
 */
class SwitchInterfaceIIDM : public SwitchInterface {
 public:
  /**
   * @brief defines the index of each state variable
   */
  typedef enum {
    VAR_STATE = 0
  } indexVar_t;

  /**
   * @brief Constructor
   * @param sw the switch's iidm instance
   */
  explicit SwitchInterfaceIIDM(powsybl::iidm::Switch& sw);

  /**
   * @copydoc SwitchInterface::setBusInterface1(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface1(const std::shared_ptr<BusInterface>& busInterface) override;

  /**
   * @copydoc SwitchInterface::setBusInterface2(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface2(const std::shared_ptr<BusInterface>& busInterface) override;

  /**
   * @copydoc SwitchInterface::getBusInterface1() const
   */
  std::shared_ptr<BusInterface> getBusInterface1() const override;

  /**
   * @copydoc SwitchInterface::getBusInterface2() const
   */
  std::shared_ptr<BusInterface> getBusInterface2() const override;

  /**
   * @copydoc SwitchInterface::isOpen() const
   */
  bool isOpen() const override;

  /**
   * @copydoc SwitchInterface::getID() const
   */
  const std::string& getID() const override;

  /**
   * @copydoc ComponentInterface::isConnected()
   */
  bool isConnected() const override;

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters() override;
  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent() override;

  /**
   * @copydoc SwitchInterface::open()
   */
  void open() override;

  /**
   * @copydoc SwitchInterface::close()
   */
  void close() override;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const override;

  /**
   * @copydoc SwitchInterface::isRetained()
   */
  bool isRetained() const override;

 private:
  powsybl::iidm::Switch& switchIIDM_;              ///< reference to the iidm switch instance
  std::shared_ptr<BusInterface> busInterface1_;  ///< busInterface of the bus where the side 1 of the switch is connected
  std::shared_ptr<BusInterface> busInterface2_;  ///< busInterface of the bus where the side 2 of the switch is connected
};                                                 ///< class for switch model interface
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSWITCHINTERFACEIIDM_H_
