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
 * @file  DYNSwitchInterfaceIIDM.h
 *
 * @brief Switch data interface : header file for IIDM implementation
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNSWITCHINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_DYNSWITCHINTERFACEIIDM_H_

#include <boost/shared_ptr.hpp>
#include "DYNSwitchInterface.h"

namespace IIDM {
class Switch;
}

namespace DYN {
class Switch;

class SwitchInterfaceIIDM : public SwitchInterface {
 public:
  /**
   * @brief defines the index of each state variable
   */
  typedef enum {
    VAR_STATE = 0
  } indexVar_t;

  /**
   * @brief Destructor
   */
  ~SwitchInterfaceIIDM();

  /**
   * @brief Constructor
   * @param sw: the switch's iidm instance
   */
  explicit SwitchInterfaceIIDM(IIDM::Switch& sw);

  /**
   * @copydoc SwitchInterface::setBusInterface1(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface1(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc SwitchInterface::setBusInterface2(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface2(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc SwitchInterface::getBusInterface1() const
   */
  boost::shared_ptr<BusInterface> getBusInterface1() const;

  /**
   * @copydoc SwitchInterface::getBusInterface2() const
   */
  boost::shared_ptr<BusInterface> getBusInterface2() const;

  /**
   * @copydoc SwitchInterface::isOpen() const
   */
  bool isOpen() const;

  /**
   * @copydoc SwitchInterface::getID() const
   */
  std::string getID() const;

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters();
  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent();

  /**
   * @copydoc SwitchInterface::open()
   */
  void open();

  /**
   * @copydoc SwitchInterface::close()
   */
  void close();

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const;

 private:
  IIDM::Switch& switchIIDM_;  ///< reference to the iidm switch instance
  boost::shared_ptr<BusInterface> busInterface1_;  ///< busInterface of the bus where the side 1 of the switch is connected
  boost::shared_ptr<BusInterface> busInterface2_;  ///< busInterface of the bus where the side 2 of the switch is connected
};  ///< class for switch model interface
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNSWITCHINTERFACEIIDM_H_
