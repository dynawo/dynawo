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
 * @file  DataInterface/PowSyblIIDM/DYNDanglingLineInterfaceIIDM.h
 *
 * @brief Dangling line data interface : header file for IIDM implementation
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNDANGLINGLINEINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNDANGLINGLINEINTERFACEIIDM_H_

#include "DYNDanglingLineInterface.h"
#include "DYNInjectorInterfaceIIDM.h"
#include "DYNCurrentLimitInterface.h"
#include <powsybl/iidm/DanglingLine.hpp>

namespace DYN {

/**
 * class DanglingLineInterfaceIIDM
 */
class DanglingLineInterfaceIIDM : public DanglingLineInterface, public InjectorInterfaceIIDM {
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
   * @param danglingLine :  dangling line's iidm instance
   */
  explicit DanglingLineInterfaceIIDM(powsybl::iidm::DanglingLine& danglingLine);

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
   * @copydoc DanglingLineInterface::setBusInterface(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const std::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc DanglingLineInterface::setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc DanglingLineInterface::getBusInterface() const
   */
  std::shared_ptr<BusInterface> getBusInterface() const;

  /**
   * @copydoc DanglingLineInterface::getInitialConnected()
   */
  bool getInitialConnected();

  /**
   * @copydoc DanglingLineInterface::getVNom() const
   */
  double getVNom() const;

  /**
   * @copydoc DanglingLineInterface::getP()
   */
  double getP();

  /**
   * @copydoc DanglingLineInterface::getQ()
   */
  double getQ();

  /**
   * @copydoc DanglingLineInterface::getID() const
   */
  const std::string& getID() const;

  /**
   * @copydoc DanglingLineInterface::getP0() const
   */
  double getP0() const;

  /**
   * @copydoc DanglingLineInterface::getQ0() const
   */
  double getQ0() const;

  /**
   * @copydoc DanglingLineInterface::getR() const
   */
  double getR() const;

  /**
   * @copydoc DanglingLineInterface::getX() const
   */
  double getX() const;

  /**
   * @copydoc DanglingLineInterface::getG() const
   */
  double getG() const;

  /**
   * @copydoc DanglingLineInterface::getB() const
   */
  double getB() const;

  /**
   * @copydoc DanglingLineInterface::addCurrentLimitInterface(std::unique_ptr<CurrentLimitInterface> currentLimitInterface)
   */
  void addCurrentLimitInterface(std::unique_ptr<CurrentLimitInterface> currentLimitInterface);

  /**
   * @copydoc DanglingLineInterface::getCurrentLimitInterfaces() const
   */
  const std::vector<std::unique_ptr<CurrentLimitInterface> >& getCurrentLimitInterfaces() const;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const;

 private:
  powsybl::iidm::DanglingLine& danglingLineIIDM_;  ///< reference to the iidm dangling line reference
  std::vector<std::unique_ptr<CurrentLimitInterface> > currentLimitInterfaces_;  ///< current limit interfaces
};  ///< class for dangling line interface
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNDANGLINGLINEINTERFACEIIDM_H_
