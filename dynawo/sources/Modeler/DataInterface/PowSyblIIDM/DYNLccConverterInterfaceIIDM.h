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
 * @file  DataInterface/PowSyblIIDM/DYNLccConverterInterfaceIIDM.h
 *
 * @brief Lcc converter interface : header file for IIDM implementation
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNLCCCONVERTERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNLCCCONVERTERINTERFACEIIDM_H_

#include "DYNLccConverterInterface.h"

#include "DYNInjectorInterfaceIIDM.h"

#include <powsybl/iidm/LccConverterStation.hpp>

#include <string>


namespace DYN {

/**
 * class LccConverterInterfaceIIDM
 */
class LccConverterInterfaceIIDM : public LccConverterInterface, public InjectorInterfaceIIDM {
 public:
  /**
   * @brief Constructor
   * @param lcc lcc converter iidm instance
   */
  explicit LccConverterInterfaceIIDM(powsybl::iidm::LccConverterStation& lcc);

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
   * @copydoc LccConverterInterface::setBusInterface(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const std::shared_ptr<BusInterface>& busInterface) override;

  /**
   * @copydoc LccConverterInterface::setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) override;

  /**
   * @copydoc LccConverterInterface::getBusInterface() const
   */
  std::shared_ptr<BusInterface> getBusInterface() const override;

  /**
   * @copydoc LccConverterInterface::getInitialConnected()
   */
  bool getInitialConnected() override;

  /**
   * @copydoc LccConverterInterface::getVNom() const
   */
  double getVNom() const override;

  /**
   * @copydoc LccConverterInterface::hasP()
   */
  bool hasP() override;

  /**
   * @copydoc LccConverterInterface::hasQ()
   */
  bool hasQ() override;

  /**
   * @copydoc LccConverterInterface::getP()
   */
  double getP() override;

  /**
   * @copydoc LccConverterInterface::getQ()
   */
  double getQ() override;

  /**
   * @copydoc LccConverterInterface::getID() const
   */
  const std::string& getID() const override;

  /**
   * @copydoc LccConverterInterface::getLossFactor() const
   */
  double getLossFactor() const override;

  /**
   * @copydoc LccConverterInterface::getPowerFactor() const
   */
  double getPowerFactor() const override;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const override;

  /**
   * @brief Getter for the reference to the iidm lcc converter instance
   * @return the iidm lcc converter instance
   */
  powsybl::iidm::LccConverterStation& getLccIIDM();

 private:
  powsybl::iidm::LccConverterStation& lccConverterIIDM_;  ///< reference to the iidm lcc converter instance
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNLCCCONVERTERINTERFACEIIDM_H_
