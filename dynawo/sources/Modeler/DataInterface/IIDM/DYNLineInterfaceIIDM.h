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
 * @file  DataInterface/IIDM/DYNLineInterfaceIIDM.h
 *
 * @brief  Line data interface : header file for IIDM interface
 *
 */
#ifndef MODELER_DATAINTERFACE_IIDM_DYNLINEINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_IIDM_DYNLINEINTERFACEIIDM_H_

#include <boost/shared_ptr.hpp>

#include "DYNLineInterface.h"
#include "DYNComponentInterfaceIIDM.h"

namespace IIDM {
class Line;
}

namespace DYN {

class LineInterfaceIIDM : public ComponentInterfaceIIDM, public LineInterface {
 public:
  /**
   * @brief defines the index of each state variable
   */
  typedef enum {
    VAR_P1 = 0,
    VAR_P2,
    VAR_Q1,
    VAR_Q2,
    VAR_STATE
  } indexVar_t;

 public:
  /**
   * @brief Destructor
   */
  ~LineInterfaceIIDM();

  /**
   * @brief Constructor
   * @param line line's iidm instance
   */
  explicit LineInterfaceIIDM(IIDM::Line& line);


  /**
   * @copydoc LineInterface::getVNom1() const
   */
  double getVNom1() const;

  /**
   * @copydoc LineInterface::getVNom2() const
   */
  double getVNom2() const;

  /**
   * @copydoc LineInterface::getR() const
   */
  double getR() const;

  /**
   * @copydoc LineInterface::getX() const
   */
  double getX() const;

  /**
   * @copydoc LineInterface::getB1() const
   */
  double getB1() const;

  /**
   * @copydoc LineInterface::getB2() const
   */
  double getB2() const;

  /**
   * @copydoc LineInterface::getG1() const
   */
  double getG1() const;

  /**
   * @copydoc LineInterface::getG2() const
   */
  double getG2() const;

  /**
  * @copydoc LineInterface::getP1()
  */
  double getP1();

  /**
  * @copydoc LineInterface::getQ1()
  */
  double getQ1();

  /**
  * @copydoc LineInterface::getP2()
  */
  double getP2();

  /**
  * @copydoc LineInterface::getQ2()
  */
  double getQ2();

  /**
   * @copydoc LineInterface::getInitialConnected1()
   */
  bool getInitialConnected1();

  /**
   * @copydoc LineInterface::getInitialConnected2()
   */
  bool getInitialConnected2();

  /**
   * @copydoc LineInterface::getID() const
   */
  std::string getID() const;

  /**
   * @copydoc LineInterface::setBusInterface1(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface1(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @brief Setter for the line's voltageLevel interface side 1
   * @param voltageLevelInterface of the bus where the side 1 of the line is connected
   */
  void setVoltageLevelInterface1(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc LineInterface::setBusInterface2(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface2(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @brief Setter for the line's voltageLevel interface side 2
   * @param voltageLevelInterface of the bus where the side 2 of the line is connected
   */
  void setVoltageLevelInterface2(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc LineInterface::getBusInterface1() const
   */
  boost::shared_ptr<BusInterface> getBusInterface1() const;

  /**
   * @copydoc LineInterface::getBusInterface2() const
   */
  boost::shared_ptr<BusInterface> getBusInterface2() const;

  /**
   * @copydoc LineInterface::addCurrentLimitInterface1(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface)
   */
  void addCurrentLimitInterface1(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface);

  /**
   * @copydoc LineInterface::addCurrentLimitInterface2(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface)
   */
  void addCurrentLimitInterface2(const boost::shared_ptr<CurrentLimitInterface>& currentLimitInterface);

  /**
   * @copydoc LineInterface::getCurrentLimitInterfaces1() const
   */
  std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces1() const;

  /**
   * @copydoc LineInterface::getCurrentLimitInterfaces2() const
   */
  std::vector<boost::shared_ptr<CurrentLimitInterface> > getCurrentLimitInterfaces2() const;

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
  IIDM::Line& lineIIDM_;  ///< reference to the iidm line instance
  boost::shared_ptr<BusInterface> busInterface1_;  ///< busInterface of the bus where the side 1 of the line is connected
  boost::shared_ptr<BusInterface> busInterface2_;  ///< busInterface of the bus where the side 2 of the line is connected
  boost::shared_ptr<VoltageLevelInterface> voltageLevelInterface1_;  ///< voltageLevel interface where the side 1 of the line is connected
  boost::shared_ptr<VoltageLevelInterface> voltageLevelInterface2_;  ///< voltageLevel interface where the side 2 of the line is connected

  std::vector<boost::shared_ptr<CurrentLimitInterface> > currentLimitInterfaces1_;  ///< current limit interfaces for side 1
  std::vector<boost::shared_ptr<CurrentLimitInterface> > currentLimitInterfaces2_;  ///< current limit interfaces for side 2
  boost::optional<bool> initialConnected1_;  ///< side 1 initially connected
  boost::optional<bool> initialConnected2_;  ///< side 2 initially connected
};  ///< Interface class for Line model
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_IIDM_DYNLINEINTERFACEIIDM_H_
