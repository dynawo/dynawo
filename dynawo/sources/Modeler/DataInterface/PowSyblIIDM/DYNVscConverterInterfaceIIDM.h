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
 * @file  DataInterface/PowSyblIIDM/DYNVscConverterInterfaceIIDM.h
 *
 * @brief Vsc converter interface : header file for IIDM implementation
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNVSCCONVERTERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNVSCCONVERTERINTERFACEIIDM_H_

#include "DYNVscConverterInterface.h"

#include "DYNInjectorInterfaceIIDM.h"

#include <powsybl/iidm/VscConverterStation.hpp>


namespace DYN {

/**
 * class VscConverterInterfaceIIDM
 */
class VscConverterInterfaceIIDM : public VscConverterInterface, public InjectorInterfaceIIDM {
 public:
  /**
   * @brief Constructor
   * @param vsc vsc converter iidm instance
   */
  explicit VscConverterInterfaceIIDM(powsybl::iidm::VscConverterStation& vsc);

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters() override;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent() override {/* not needed */}

  /**
   * @copydoc ComponentInterface::isConnected()
   */
  bool isConnected() const override;

  /**
   * @copydoc VscConverterInterface::setBusInterface(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const std::shared_ptr<BusInterface>& busInterface) override;

  /**
   * @copydoc VscConverterInterface::setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) override;

  /**
   * @copydoc VscConverterInterface::getBusInterface() const
   */
  std::shared_ptr<BusInterface> getBusInterface() const override;

  /**
   * @copydoc VscConverterInterface::getInitialConnected()
   */
  bool getInitialConnected() override;

  /**
   * @copydoc VscConverterInterface::getVNom() const
   */
  double getVNom() const override;

  /**
   * @copydoc VscConverterInterface::hasP()
   */
  bool hasP() override;

  /**
   * @copydoc VscConverterInterface::hasQ()
   */
  bool hasQ() override;

  /**
   * @copydoc VscConverterInterface::getP()
   */
  double getP() override;

  /**
   * @copydoc VscConverterInterface::getQ()
   */
  double getQ() override;

  /**
   * @copydoc VscConverterInterface::getQMax()
   */
  double getQMax() override;

  /**
   * @copydoc VscConverterInterface::getQMax()
   */
  double getQMin() override;

  /**
   * @copydoc VscConverterInterface::getReactiveCurvesPoints()
   */
  std::vector<ReactiveCurvePoint> getReactiveCurvesPoints() const override;

  /**
   * @copydoc VscConverterInterface::getID() const
   */
  const std::string& getID() const override;

  /**
   * @copydoc VscConverterInterface::getLossFactor() const
   */
  double getLossFactor() const override;

  /**
   * @copydoc VscConverterInterface::getVoltageRegulatorOn() const
   */
  bool getVoltageRegulatorOn() const override;

  /**
   * @copydoc VscConverterInterface::getReactivePowerSetpoint() const
   */
  double getReactivePowerSetpoint() const override;

  /**
   * @copydoc VscConverterInterface::getVoltageSetpoint() const
   */
  double getVoltageSetpoint() const override;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const override;

  /**
   * @brief Getter for the reference to the iidm vsc converter istance
   * @return the iidm vsc converter istance
   */
  powsybl::iidm::VscConverterStation& getVscIIDM();

 private:
  powsybl::iidm::VscConverterStation& vscConverterIIDM_;  ///< reference to the iidm vsc converter instance
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNVSCCONVERTERINTERFACEIIDM_H_
