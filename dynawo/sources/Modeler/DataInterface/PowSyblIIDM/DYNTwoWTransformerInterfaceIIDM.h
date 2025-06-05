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
 * @file  DataInterface/PowSyblIIDM/DYNTwoWTransformerInterfaceIIDM.h
 *
 * @brief Two windings transformer data interface : header file for IIDM implementation
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNTWOWTRANSFORMERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNTWOWTRANSFORMERINTERFACEIIDM_H_

#include "DYNTwoWTransformerInterface.h"
#include "DYNCurrentLimitInterface.h"
#include "DYNActiveSeasonIIDMExtension.h"
#include "DYNIIDMExtensions.hpp"

#include <powsybl/iidm/TwoWindingsTransformer.hpp>

namespace DYN {

/**
 * class TwoWTransformerInterfaceIIDM
 */
class TwoWTransformerInterfaceIIDM : public TwoWTransformerInterface {
 public:
  /**
   * @brief defines the index of each state variable
   */
  typedef enum {
    VAR_P1 = 0,
    VAR_P2,
    VAR_Q1,
    VAR_Q2,
    VAR_STATE,
    VAR_TAPINDEX
  } indexVar_t;

 public:
  /**
   * @brief Destructor
   */
  ~TwoWTransformerInterfaceIIDM() override;

  /**
   * @brief Constructor
   * @param tfo two windings transformer's iidm instance
   */
  explicit TwoWTransformerInterfaceIIDM(powsybl::iidm::TwoWindingsTransformer & tfo);


  /**
   * @copydoc TwoWTransformerInterface::addCurrentLimitInterface1(std::unique_ptr<CurrentLimitInterface> currentLimitInterface)
   */
  void addCurrentLimitInterface1(std::unique_ptr<CurrentLimitInterface> currentLimitInterface) override;

  /**
   * @copydoc TwoWTransformerInterface::addCurrentLimitInterface2(std::unique_ptr<CurrentLimitInterface> currentLimitInterface)
   */
  void addCurrentLimitInterface2(std::unique_ptr<CurrentLimitInterface> currentLimitInterface) override;

  /**
   * @copydoc TwoWTransformerInterface::getCurrentLimitInterfaces1() const
   */
  const std::vector<std::unique_ptr<CurrentLimitInterface> >& getCurrentLimitInterfaces1() const override;

  /**
   * @copydoc TwoWTransformerInterface::getCurrentLimitInterfaces2() const
   */
  const std::vector<std::unique_ptr<CurrentLimitInterface> >& getCurrentLimitInterfaces2() const override;

  /**
   * @copydoc TwoWTransformerInterface::getActiveSeason()
   */
  std::string getActiveSeason() const final;

  /**
   * @copydoc TwoWTransformerInterface::setBusInterface1(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface1(const std::shared_ptr<BusInterface>& busInterface) override;

  /**
   * @copydoc TwoWTransformerInterface::setVoltageLevelInterface1(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface1(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) override;

  /**
   * @copydoc TwoWTransformerInterface::setBusInterface2(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface2(const std::shared_ptr<BusInterface>& busInterface) override;

  /**
   * @copydoc TwoWTransformerInterface::setVoltageLevelInterface2(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface2(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) override;

  /**
   * @copydoc TwoWTransformerInterface::getBusInterface1() const
   */
  std::shared_ptr<BusInterface> getBusInterface1() const override;

  /**
   * @copydoc TwoWTransformerInterface::getBusInterface2() const
   */
  std::shared_ptr<BusInterface> getBusInterface2() const override;

  /**
   * @copydoc TwoWTransformerInterface::getID() const
   */
  const std::string& getID() const override;

  /**
   * @copydoc TwoWTransformerInterface::getInitialConnected1()
   */
  bool getInitialConnected1() override;

  /**
   * @copydoc TwoWTransformerInterface::getInitialConnected2()
   */
  bool getInitialConnected2() override;

  /**
   * @brief Checks the connection state of the transformer's side 1
   * @return @b true if the transformer's side 1 is connected, @b false else
   */
  bool isConnected1() const;

  /**
   * @brief Checks the connection state of the transformer's side 2
   * @return @b true if the transformer's side 2 is connected, @b false else
   */
  bool isConnected2() const;

  /**
   * @copydoc TwoWTransformerInterface::getVNom1() const
   */
  double getVNom1() const override;

  /**
   * @copydoc TwoWTransformerInterface::getVNom2() const
   */
  double getVNom2() const override;

  /**
   * @copydoc TwoWTransformerInterface::getRatedU1() const
   */
  double getRatedU1() const override;

  /**
   * @copydoc TwoWTransformerInterface::getRatedU2() const
   */
  double getRatedU2() const override;

  /**
   * @copydoc TwoWTransformerInterface::getPhaseTapChanger() const
   */
  const std::unique_ptr<PhaseTapChangerInterface>& getPhaseTapChanger() const override;

  /**
   * @copydoc TwoWTransformerInterface::getRatioTapChanger() const
   */
  const std::unique_ptr<RatioTapChangerInterface>& getRatioTapChanger() const override;

  /**
   * @copydoc TwoWTransformerInterface::setPhaseTapChanger(std::unique_ptr<PhaseTapChangerInterface> tapChanger)
   */
  void setPhaseTapChanger(std::unique_ptr<PhaseTapChangerInterface> tapChanger) override;

  /**
   * @copydoc TwoWTransformerInterface::setRatioTapChanger(std::unique_ptr<RatioTapChangerInterface> tapChanger)
   */
  void setRatioTapChanger(std::unique_ptr<RatioTapChangerInterface> tapChanger) override;

  /**
   * @copydoc TwoWTransformerInterface::getR() const
   */
  double getR() const override;

  /**
   * @copydoc TwoWTransformerInterface::getX() const
   */
  double getX() const override;

  /**
   * @copydoc TwoWTransformerInterface::getG() const
   */
  double getG() const override;

  /**
   * @copydoc TwoWTransformerInterface::getB() const
   */
  double getB() const override;

  /**
   * @copydoc TwoWTransformerInterface::getP1()
   */
  double getP1() override;

  /**
   * @copydoc TwoWTransformerInterface::getQ1()
   */
  double getQ1() override;

  /**
   * @copydoc TwoWTransformerInterface::getP2()
   */
  double getP2() override;

  /**
   * @copydoc TwoWTransformerInterface::getQ2()
   */
  double getQ2() override;

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters() override;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent() override;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const override;

  /**
   * @copydoc ComponentInterface::isConnected()
   */
  bool isConnected() const override;

  /**
   * @copydoc ComponentInterface::isPartiallyConnected()
   */
  bool isPartiallyConnected() const override;

 private:
  /**
   * @brief Copy constructor
   * @param other two windings transformer to copy
   */
  explicit TwoWTransformerInterfaceIIDM(const TwoWTransformerInterfaceIIDM& other) = delete;

 private:
  powsybl::iidm::TwoWindingsTransformer& tfoIIDM_;  ///< reference to the tfo's iidm instance
  std::shared_ptr<BusInterface> busInterface1_;  ///< busInterface of the bus where the side 1 of the tfo is connected
  std::shared_ptr<BusInterface> busInterface2_;  ///< busInterface of the bus where the side 2 of the tfo is connected
  std::shared_ptr<VoltageLevelInterface> voltageLevelInterface1_;  ///< voltageLevel interface where the side 1 of the line is connected
  std::shared_ptr<VoltageLevelInterface> voltageLevelInterface2_;  ///< voltageLevel interface where the side 2 of the line is connected
  std::unique_ptr<PhaseTapChangerInterface> phaseTapChanger_;  ///< reference to the phase tap changer interface instance
  std::unique_ptr<RatioTapChangerInterface> ratioTapChanger_;  ///< reference to the ratio tap changer interface instance

  std::vector<std::unique_ptr<CurrentLimitInterface> > currentLimitInterfaces1_;  ///< current limit interfaces for side 1
  std::vector<std::unique_ptr<CurrentLimitInterface> > currentLimitInterfaces2_;  ///< current limit interfaces for side 2

  ActiveSeasonIIDMExtension* activeSeasonExtension_;                                         ///< Active season extension
  IIDMExtensions::DestroyFunction<ActiveSeasonIIDMExtension> destroyActiveSeasonExtension_;  ///< active season destroy function

  boost::optional<bool> initialConnected1_;  ///< whether the tfo is initially connected at side 1
  boost::optional<bool> initialConnected2_;  ///< whether the tfo is initially connected at side 2
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNTWOWTRANSFORMERINTERFACEIIDM_H_
