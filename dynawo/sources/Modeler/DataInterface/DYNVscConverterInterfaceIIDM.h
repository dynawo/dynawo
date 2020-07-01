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
 * @file  DYNVscConverterInterfaceIIDM.h
 *
 * @brief Vsc converter interface : header file for IIDM implementation
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_DYNVSCCONVERTERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_DYNVSCCONVERTERINTERFACEIIDM_H_

#include <boost/shared_ptr.hpp>

#include "DYNVscConverterInterface.h"
#include "DYNInjectorInterfaceIIDM.h"

namespace IIDM {
class VscConverterStation;
}

namespace DYN {

/**
 * class VscConverterInterfaceIIDM
 */
class VscConverterInterfaceIIDM : public VscConverterInterface, public InjectorInterfaceIIDM<IIDM::VscConverterStation> {
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
  ~VscConverterInterfaceIIDM();

  /**
   * @brief Constructor
   * @param vsc: vsc converter iidm instance
   */
  explicit VscConverterInterfaceIIDM(IIDM::VscConverterStation& vsc);

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters();

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent();

  /**
   * @copydoc VscConverterInterface::setBusInterface(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc VscConverterInterface::setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc VscConverterInterface::getBusInterface() const
   */
  boost::shared_ptr<BusInterface> getBusInterface() const;

  /**
   * @copydoc VscConverterInterface::getInitialConnected()
   */
  bool getInitialConnected();

  /**
   * @copydoc VscConverterInterface::getVNom() const
   */
  double getVNom() const;

  /**
   * @copydoc VscConverterInterface::hasP()
   */
  bool hasP();

  /**
   * @copydoc VscConverterInterface::hasQ()
   */
  bool hasQ();

  /**
   * @copydoc VscConverterInterface::getP()
   */
  double getP();

  /**
   * @copydoc VscConverterInterface::getQ()
   */
  double getQ();

  /**
   * @copydoc VscConverterInterface::getID() const
   */
  std::string getID() const;

  /**
   * @copydoc VscConverterInterface::getLossFactor() const
   */
  double getLossFactor() const;

  /**
   * @copydoc VscConverterInterface::getVoltageRegulatorOn() const
   */
  bool getVoltageRegulatorOn() const;

  /**
   * @copydoc VscConverterInterface::getReactivePowerSetpoint() const
   */
  double getReactivePowerSetpoint() const;

  /**
   * @copydoc VscConverterInterface::getVoltageSetpoint() const
   */
  double getVoltageSetpoint() const;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const;

  /**
   * @brief Getter for the reference to the iidm vsc converter istance
   * @return the iidm vsc converter istance
   */
  IIDM::VscConverterStation& getVscIIDM();

 private:
  IIDM::VscConverterStation& vscConverterIIDM_;  ///< reference to the iidm vsc converter instance
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNVSCCONVERTERINTERFACEIIDM_H_
