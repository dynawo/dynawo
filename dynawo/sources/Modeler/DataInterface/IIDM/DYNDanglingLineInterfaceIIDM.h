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
 * @file  DataInterface/IIDM/DYNDanglingLineInterfaceIIDM.h
 *
 * @brief Dangling line data interface : header file for IIDM implementation
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_IIDM_DYNDANGLINGLINEINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_IIDM_DYNDANGLINGLINEINTERFACEIIDM_H_

#include <boost/shared_ptr.hpp>

#include "DYNDanglingLineInterface.h"
#include "DYNInjectorInterfaceIIDM.h"

namespace IIDM {
class DanglingLine;
}

namespace DYN {

class DanglingLineInterfaceIIDM : public DanglingLineInterface, public InjectorInterfaceIIDM<IIDM::DanglingLine> {
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
  ~DanglingLineInterfaceIIDM();

  /**
   * @brief Constructor
   * @param danglingLine :  dangling line's iidm instance
   */
  explicit DanglingLineInterfaceIIDM(IIDM::DanglingLine& danglingLine);

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent();

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters();

  /**
   * @copydoc DanglingLineInterface::setBusInterface(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc DanglingLineInterface::setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc DanglingLineInterface::getBusInterface() const
   */
  boost::shared_ptr<BusInterface> getBusInterface() const;

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
  std::string getID() const;

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
   * @copydoc DanglingLineInterface::addCurrentLimitInterface(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface)
   */
  void addCurrentLimitInterface(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface);

  /**
   * @copydoc DanglingLineInterface::getCurrentLimitInterfaces() const
   */
  std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces() const;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const;

 private:
  IIDM::DanglingLine& danglingLineIIDM_;  ///< reference to the iidm dangling line reference
  std::vector<boost::shared_ptr<CurrentLimitInterface> > currentLimitInterfaces_;  ///< current limit interfaces
};  ///< class for dangling line interface
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_IIDM_DYNDANGLINGLINEINTERFACEIIDM_H_
