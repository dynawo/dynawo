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
 * @file  DYNStaticVarCompensatorInterfaceIIDM.h
 *
 * @brief Static var compensator interface : header file for IIDM implementation
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_DYNSTATICVARCOMPENSATORINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_DYNSTATICVARCOMPENSATORINTERFACEIIDM_H_

#include <boost/shared_ptr.hpp>

#include "DYNStaticVarCompensatorInterface.h"
#include "DYNInjectorInterfaceIIDM.h"

namespace IIDM {
namespace extensions {
namespace standbyautomaton {
class StandbyAutomaton;
}
}
class StaticVarCompensator;
}

namespace DYN {

/**
 * class StaticVarCompensatorInterfaceIIDM
 */
class StaticVarCompensatorInterfaceIIDM : public StaticVarCompensatorInterface, public InjectorInterfaceIIDM<IIDM::StaticVarCompensator> {
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
   * @param svc: static var compensator's iidm instance
   */
  explicit StaticVarCompensatorInterfaceIIDM(IIDM::StaticVarCompensator& svc);

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent();

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters();

  /**
   * @copydoc StaticVarCompensatorInterface::setBusInterface(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc StaticVarCompensatorInterface::setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc StaticVarCompensatorInterface::getBusInterface() const
   */
  boost::shared_ptr<BusInterface> getBusInterface() const;

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
   * @copydoc StaticVarCompensatorInterface::getQ()
   */
  double getQ();

 private:
  IIDM::StaticVarCompensator& staticVarCompensatorIIDM_;  ///< reference to the iidm static var compensator instance
  IIDM::extensions::standbyautomaton::StandbyAutomaton * sa_;  ///< pointer to StandbyAutomaton extension when it exists
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNSTATICVARCOMPENSATORINTERFACEIIDM_H_
