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
 * @file  DataInterface/PowSyblIIDM/DYNFictTwoWTransformerInterfaceIIDM.h
 *
 * @brief Fictitious Two windings transformer: header file to create of TwoWindingTransformer from ThreeWindingTransfomer leg
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNFICTTWOWTRANSFORMERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNFICTTWOWTRANSFORMERINTERFACEIIDM_H_

#include "DYNTwoWTransformerInterface.h"
#include "DYNCurrentLimitInterface.h"

#include <powsybl/iidm/ThreeWindingsTransformer.hpp>


namespace DYN {

/**
 * class TwoWTransformerInterfaceIIDM
 */
class FictTwoWTransformerInterfaceIIDM : public TwoWTransformerInterface {
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
   * @brief Constructor
   * @param Id Id two windings fictitous transformer's iidm instance
   * @param leg reference to original three winding transformer leg
   * @param initialConnected1 @b true if the fictitous transformer's side 1 is connected, @b false else
   * @param VNom1 nominal voltage of the fictitious transformer's side 1 in kV
   * @param ratedU1 rated voltage of the fictitious transformer's side 1 in kV
   * @param activeSeason active season of the fictitious transformer
   */
  explicit FictTwoWTransformerInterfaceIIDM(const std::string& Id,
                                            stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg>& leg,
                                            bool initialConnected1, double VNom1, double ratedU1, const std::string& activeSeason);


  /**
   * @copydoc TwoWTransformerInterface::addCurrentLimitInterface1(std::unique_ptr<CurrentLimitInterface> currentLimitInterface)
   */
  void addCurrentLimitInterface1(std::unique_ptr<CurrentLimitInterface> currentLimitInterface);

  /**
   * @copydoc TwoWTransformerInterface::addCurrentLimitInterface2(std::unique_ptr<CurrentLimitInterface> currentLimitInterface)
   */
  void addCurrentLimitInterface2(std::unique_ptr<CurrentLimitInterface> currentLimitInterface);

  /**
   * @copydoc TwoWTransformerInterface::getCurrentLimitInterfaces1() const
   */
  const std::vector<std::unique_ptr<CurrentLimitInterface> >& getCurrentLimitInterfaces1() const {
      static std::vector<std::unique_ptr<CurrentLimitInterface> > empty;
      return empty;
  }

  /**
   * @copydoc TwoWTransformerInterface::getCurrentLimitInterfaces2() const
   */
  const std::vector<std::unique_ptr<CurrentLimitInterface> >& getCurrentLimitInterfaces2() const;

  /**
   * @copydoc TwoWTransformerInterface::setBusInterface1(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface1(const std::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc TwoWTransformerInterface::setVoltageLevelInterface1(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface1(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc TwoWTransformerInterface::setBusInterface2(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface2(const std::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc TwoWTransformerInterface::setVoltageLevelInterface2(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface2(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc TwoWTransformerInterface::getBusInterface1() const
   */
  std::shared_ptr<BusInterface> getBusInterface1() const;

  /**
   * @copydoc TwoWTransformerInterface::getBusInterface2() const
   */
  std::shared_ptr<BusInterface> getBusInterface2() const;

  /**
   * @copydoc TwoWTransformerInterface::getID() const
   */
  const std::string& getID() const;

  /**
   * @copydoc TwoWTransformerInterface::getInitialConnected1()
   */
  bool getInitialConnected1();

  /**
   * @copydoc TwoWTransformerInterface::getInitialConnected2()
   */
  bool getInitialConnected2();

  /**
   * @copydoc TwoWTransformerInterface::getVNom1() const
   */
  double getVNom1() const;

  /**
   * @copydoc TwoWTransformerInterface::getVNom2() const
   */
  double getVNom2() const;

  /**
   * @copydoc TwoWTransformerInterface::getRatedU1() const
   */
  double getRatedU1() const;

  /**
   * @copydoc TwoWTransformerInterface::getRatedU2() const
   */
  double getRatedU2() const;

  /**
   * @copydoc TwoWTransformerInterface::getPhaseTapChanger() const
   */
  const std::unique_ptr<PhaseTapChangerInterface>& getPhaseTapChanger() const;

  /**
   * @copydoc TwoWTransformerInterface::getRatioTapChanger() const
   */
  const std::unique_ptr<RatioTapChangerInterface>& getRatioTapChanger() const;

  /**
   * @copydoc TwoWTransformerInterface::setPhaseTapChanger(std::unique_ptr<PhaseTapChangerInterface> tapChanger)
   */
  void setPhaseTapChanger(std::unique_ptr<PhaseTapChangerInterface> tapChanger);

  /**
   * @copydoc TwoWTransformerInterface::setRatioTapChanger(std::unique_ptr<RatioTapChangerInterface> tapChanger)
   */
  void setRatioTapChanger(std::unique_ptr<RatioTapChangerInterface> tapChanger);

  /**
   * @copydoc TwoWTransformerInterface::getR() const
   */
  double getR() const;

  /**
   * @copydoc TwoWTransformerInterface::getX() const
   */
  double getX() const;

  /**
   * @copydoc TwoWTransformerInterface::getG() const
   */
  double getG() const;

  /**
   * @copydoc TwoWTransformerInterface::getB() const
   */
  double getB() const;

  /**
   * @copydoc TwoWTransformerInterface::getP1()
   */
  double getP1();

  /**
   * @copydoc TwoWTransformerInterface::getQ1()
   */
  double getQ1();

  /**
   * @copydoc TwoWTransformerInterface::getP2()
   */
  double getP2();

  /**
   * @copydoc TwoWTransformerInterface::getQ2()
   */
  double getQ2();

  /**
   * @copydoc TwoWTransformerInterface::getActiveSeason()
   */
  std::string getActiveSeason() const final {
    return activeSeason_;
  }

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

  /**
   * @copydoc ComponentInterface::isConnected()
   */
  bool isConnected() const;

 private:
  stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg> leg_;  ///< reference to original three winding transformer leg
  std::string Id_;                                 ///< Id of fictitious transformer
  std::shared_ptr<BusInterface> busInterface1_;  ///< busInterface of the bus where the side 1 of the tfo is connected
  std::shared_ptr<BusInterface> busInterface2_;  ///< busInterface of the bus where the side 2 of the tfo is connected
  std::shared_ptr<VoltageLevelInterface> voltageLevelInterface1_;  ///< voltageLevel interface where the side 1 of the line is connected
  std::shared_ptr<VoltageLevelInterface> voltageLevelInterface2_;  ///< voltageLevel interface where the side 2 of the line is connected
  std::unique_ptr<PhaseTapChangerInterface> phaseTapChanger_;  ///< reference to the phase tap changer interface instance
  std::unique_ptr<RatioTapChangerInterface> ratioTapChanger_;  ///< reference to the ratio tap changer interface instance

  std::vector<std::unique_ptr<CurrentLimitInterface> > currentLimitInterfaces2_;  ///< current limit interfaces for side 2


  bool initialConnected1_;  ///< whether the tfo is initially connected at side 1
  boost::optional<bool> initialConnected2_;  ///< whether the tfo is initially connected at side 2
  double VNom1_;            ///< nominal voltage of the fictitious transformer's side 1 in kV
  double RatedU1_;          ///< rated voltage of the fictitious transformer's side 1 in kV
  const std::string activeSeason_;  ///< active season of the fictitious transformer
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNFICTTWOWTRANSFORMERINTERFACEIIDM_H_
