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
 * @file  DYNThreeWTransformerInterfaceIIDM.h
 *
 * @brief Three windings transformer data interface : header file for IIDM implementation
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNTHREEWTRANSFORMERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_DYNTHREEWTRANSFORMERINTERFACEIIDM_H_

#include <boost/shared_ptr.hpp>

#include "DYNThreeWTransformerInterface.h"

namespace IIDM {
class Transformer3Windings;
}

namespace DYN {

/**
 * ThreeTransformerInterfaceIIDM
 */
class ThreeWTransformerInterfaceIIDM : public ThreeWTransformerInterface {
 public:
  /**
   * @brief Destructor
   */
  ~ThreeWTransformerInterfaceIIDM();

  /**
   * @brief Constructor
   * @param tfo three windings transformer's iidm instance
   */
  explicit ThreeWTransformerInterfaceIIDM(IIDM::Transformer3Windings& tfo);

  /**
   * @copydoc ThreeWTransformerInterface::addCurrentLimitInterface1(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface)
   */
  void addCurrentLimitInterface1(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface);

  /**
   * @copydoc ThreeWTransformerInterface::addCurrentLimitInterface2(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface)
   */
  void addCurrentLimitInterface2(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface);

  /**
   * @copydoc ThreeWTransformerInterface::addCurrentLimitInterface3(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface)
   */
  void addCurrentLimitInterface3(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface);

  /**
   * @copydoc ThreeWTransformerInterface::getCurrentLimitInterfaces1() const
   */
  std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces1() const;

  /**
   * @copydoc ThreeWTransformerInterface::getCurrentLimitInterfaces2() const
   */
  std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces2() const;

  /**
   * @copydoc ThreeWTransformerInterface::getCurrentLimitInterfaces3() const
   */
  std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces3() const;

  /**
   * @copydoc ThreeWTransformerInterface::setBusInterface1(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface1(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc ThreeWTransformerInterface::setBusInterface2(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface2(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc ThreeWTransformerInterface::setBusInterface3(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface3(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc ThreeWTransformerInterface::setVoltageLevelInterface1(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface1(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc ThreeWTransformerInterface::setVoltageLevelInterface2(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface2(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc ThreeWTransformerInterface::setVoltageLevelInterface3(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface3(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc ThreeWTransformerInterface::getBusInterface1() const
   */
  boost::shared_ptr<BusInterface> getBusInterface1() const;

  /**
   * @copydoc ThreeWTransformerInterface::getBusInterface2() const
   */
  boost::shared_ptr<BusInterface> getBusInterface2() const;

  /**
   * @copydoc ThreeWTransformerInterface::getBusInterface3() const
   */
  boost::shared_ptr<BusInterface> getBusInterface3() const;

  /**
   * @copydoc ThreeWTransformerInterface::getID() const
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
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const;

 private:
  IIDM::Transformer3Windings& tfoIIDM_;  ///< reference to the tfo's iidm instance
  boost::shared_ptr<BusInterface> busInterface1_;  ///< busInterface of the bus where the side 1 of the tfo is connected
  boost::shared_ptr<BusInterface> busInterface2_;  ///< busInterface of the bus where the side 2 of the tfo is connected
  boost::shared_ptr<BusInterface> busInterface3_;  ///< busInterface of the bus where the side 3 of the tfo is connected
  boost::shared_ptr<VoltageLevelInterface> voltageLevelInterface1_;  ///< voltageLevelInterface of the voltageLevel where the side 1 of the tfo is connected
  boost::shared_ptr<VoltageLevelInterface> voltageLevelInterface2_;  ///< voltageLevelInterface of the voltageLevel where the side 2 of the tfo is connected
  boost::shared_ptr<VoltageLevelInterface> voltageLevelInterface3_;  ///< voltageLevelInterface of the voltageLevel where the side 3 of the tfo is connected
  std::vector<boost::shared_ptr<CurrentLimitInterface> > currentLimitInterfaces1_;  ///< current limit interfaces for side 1
  std::vector<boost::shared_ptr<CurrentLimitInterface> > currentLimitInterfaces2_;  ///< current limit interfaces for side 2
  std::vector<boost::shared_ptr<CurrentLimitInterface> > currentLimitInterfaces3_;  ///< current limit interfaces for side 3
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNTHREEWTRANSFORMERINTERFACEIIDM_H_
