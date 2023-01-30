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
 * @file  DataInterface/IIDM/DYNTwoWTransformerInterfaceIIDM.h
 *
 * @brief Two windings transformer data interface : header file for IIDM implementation
 *
 */
#ifndef MODELER_DATAINTERFACE_IIDM_DYNTWOWTRANSFORMERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_IIDM_DYNTWOWTRANSFORMERINTERFACEIIDM_H_

#include <boost/shared_ptr.hpp>

#include "DYNTwoWTransformerInterface.h"

namespace IIDM {
class Transformer2Windings;
}

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
  ~TwoWTransformerInterfaceIIDM();

  /**
   * @brief Constructor
   * @param tfo two windings transformer's iidm instance
   */
  explicit TwoWTransformerInterfaceIIDM(IIDM::Transformer2Windings & tfo);


  /**
   * @copydoc TwoWTransformerInterface::addCurrentLimitInterface1(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface)
   */
  void addCurrentLimitInterface1(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface);

  /**
   * @copydoc TwoWTransformerInterface::addCurrentLimitInterface2(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface)
   */
  void addCurrentLimitInterface2(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface);

  /**
   * @copydoc TwoWTransformerInterface::getCurrentLimitInterfaces1() const
   */
  std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces1() const;

  /**
   * @copydoc TwoWTransformerInterface::getCurrentLimitInterfaces2() const
   */
  std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces2() const;

  /**
   * @copydoc TwoWTransformerInterface::getActiveSeason()
   */
  std::string getActiveSeason() const final {
    return "UNDEFINED";
  }

  /**
   * @copydoc TwoWTransformerInterface::setBusInterface1(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface1(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc TwoWTransformerInterface::setVoltageLevelInterface1(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface1(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc TwoWTransformerInterface::setBusInterface2(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface2(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc TwoWTransformerInterface::setVoltageLevelInterface2(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface2(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc TwoWTransformerInterface::getBusInterface1() const
   */
  boost::shared_ptr<BusInterface> getBusInterface1() const;

  /**
   * @copydoc TwoWTransformerInterface::getBusInterface2() const
   */
  boost::shared_ptr<BusInterface> getBusInterface2() const;

  /**
   * @copydoc TwoWTransformerInterface::getID() const
   */
  std::string getID() const;

  /**
   * @copydoc TwoWTransformerInterface::getInitialConnected1()
   */
  bool getInitialConnected1();

  /**
   * @copydoc TwoWTransformerInterface::getInitialConnected2()
   */
  bool getInitialConnected2();

  /**
   * @brief Checks the connection state of the line's side 1
   * @return @b true if the line's side 1 is connected, @b false else
   */
  bool isConnected1() const;

  /**
   * @brief Checks the connection state of the line's side 2
   * @return @b true if the line's side 2 is connected, @b false else
   */
  bool isConnected2() const;

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
  boost::shared_ptr<PhaseTapChangerInterface> getPhaseTapChanger() const;

  /**
   * @copydoc TwoWTransformerInterface::getRatioTapChanger() const
   */
  boost::shared_ptr<RatioTapChangerInterface> getRatioTapChanger() const;

  /**
   * @copydoc TwoWTransformerInterface::setPhaseTapChanger(const boost::shared_ptr<PhaseTapChangerInterface>& tapChanger)
   */
  void setPhaseTapChanger(const boost::shared_ptr<PhaseTapChangerInterface>& tapChanger);

  /**
   * @copydoc TwoWTransformerInterface::setRatioTapChanger(const boost::shared_ptr<RatioTapChangerInterface>& tapChanger)
   */
  void setRatioTapChanger(const boost::shared_ptr<RatioTapChangerInterface>& tapChanger);

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

  /**
   * @copydoc ComponentInterface::isPartiallyConnected()
   */
  bool isPartiallyConnected() const;

 private:
  IIDM::Transformer2Windings& tfoIIDM_;  ///< reference to the tfo's iidm instance
  boost::shared_ptr<BusInterface> busInterface1_;  ///< busInterface of the bus where the side 1 of the tfo is connected
  boost::shared_ptr<BusInterface> busInterface2_;  ///< busInterface of the bus where the side 2 of the tfo is connected
  boost::shared_ptr<VoltageLevelInterface> voltageLevelInterface1_;  ///< voltageLevel interface where the side 1 of the line is connected
  boost::shared_ptr<VoltageLevelInterface> voltageLevelInterface2_;  ///< voltageLevel interface where the side 2 of the line is connected
  boost::shared_ptr<PhaseTapChangerInterface> phaseTapChanger_;  ///< reference to the phase tap changer interface instance
  boost::shared_ptr<RatioTapChangerInterface> ratioTapChanger_;  ///< reference to the ratio tap changer interface instance

  std::vector<boost::shared_ptr<CurrentLimitInterface> > currentLimitInterfaces1_;  ///< current limit interfaces for side 1
  std::vector<boost::shared_ptr<CurrentLimitInterface> > currentLimitInterfaces2_;  ///< current limit interfaces for side 2

  boost::optional<bool> initialConnected1_;  ///< whether the tfo is initially connected at side 1
  boost::optional<bool> initialConnected2_;  ///< whether the tfo is initially connected at side 2
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_IIDM_DYNTWOWTRANSFORMERINTERFACEIIDM_H_
