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
 * @file  DYNShuntCompensatorInterfaceIIDM.h
 *
 * @brief Shunt compensator interface : header file for IIDM implementation
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_DYNSHUNTCOMPENSATORINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_DYNSHUNTCOMPENSATORINTERFACEIIDM_H_

#include <boost/shared_ptr.hpp>

#include "DYNShuntCompensatorInterface.h"
#include "DYNInjectorInterfaceIIDM.h"

namespace IIDM {
class ShuntCompensator;
}

namespace DYN {

/**
 * class ShuntCompensatorInterfaceIIDM
 */
class ShuntCompensatorInterfaceIIDM : public ShuntCompensatorInterface, public InjectorInterfaceIIDM<IIDM::ShuntCompensator> {
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
   * @brief Destructor
   */
  ~ShuntCompensatorInterfaceIIDM();

  /**
   * @brief Constructor
   * @param shunt: shunt compensator's iidm instance
   */
  explicit ShuntCompensatorInterfaceIIDM(IIDM::ShuntCompensator& shunt);

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent();

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters();

  /**
   * @copydoc ShuntCompensatorInterface::setBusInterface(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc ShuntCompensatorInterface::setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc ShuntCompensatorInterface::getBusInterface() const
   */
  boost::shared_ptr<BusInterface> getBusInterface() const;

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
  std::string getID() const;

  /**
   * @copydoc ShuntCompensatorInterface::getCurrentSection() const
   */
  int getCurrentSection() const;

  /**
   * @copydoc ShuntCompensatorInterface::getMaximumSection() const
   */
  int getMaximumSection() const;

  /**
   * @copydoc ShuntCompensatorInterface::getBPerSection() const
   */
  double getBPerSection() const;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const;

 private:
  IIDM::ShuntCompensator& shuntCompensatorIIDM_;  ///< reference to the iidm shunt compensator instance
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNSHUNTCOMPENSATORINTERFACEIIDM_H_
