//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DataInterface/PowSyblIIDM/DYNLineInterfaceIIDM.h
 *
 * @brief  Line data interface : header file for IIDM interface
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNLINEINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNLINEINTERFACEIIDM_H_

#include <powsybl/iidm/Line.hpp>

#include "DYNLineInterface.h"
#include "DYNCurrentLimitInterface.h"
#include "DYNActiveSeasonIIDMExtension.h"
#include "DYNCurrentLimitsPerSeasonIIDMExtension.h"
#include "DYNIIDMExtensions.hpp"

#include <boost/noncopyable.hpp>

namespace DYN {

/**
 * class LineInterfaceIIDM
 */
class LineInterfaceIIDM : public LineInterface, public boost::noncopyable {
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
  ~LineInterfaceIIDM() override;

  /**
   * @brief Constructor
   * @param line line's iidm instance
   */
  explicit LineInterfaceIIDM(powsybl::iidm::Line& line);

  /**
   * @copydoc LineInterface::getVNom1() const
   */
  double getVNom1() const override;

  /**
   * @copydoc LineInterface::getVNom2() const
   */
  double getVNom2() const override;

  /**
   * @copydoc LineInterface::getR() const
   */
  double getR() const override;

  /**
   * @copydoc LineInterface::getX() const
   */
  double getX() const override;

  /**
   * @copydoc LineInterface::getB1() const
   */
  double getB1() const override;

  /**
   * @copydoc LineInterface::getB2() const
   */
  double getB2() const override;

  /**
   * @copydoc LineInterface::getG1() const
   */
  double getG1() const override;

  /**
   * @copydoc LineInterface::getG2() const
   */
  double getG2() const override;

  /**
  * @copydoc LineInterface::getP1()
  */
  double getP1() override;

  /**
  * @copydoc LineInterface::getQ1()
  */
  double getQ1() override;

  /**
  * @copydoc LineInterface::getP2()
  */
  double getP2() override;

  /**
  * @copydoc LineInterface::getQ2()
  */
  double getQ2() override;

  /**
   * @copydoc LineInterface::getInitialConnected1()
   */
  bool getInitialConnected1() override;

  /**
   * @copydoc LineInterface::getInitialConnected2()
   */
  bool getInitialConnected2() override;

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
   * @copydoc LineInterface::getID() const
   */
  const std::string& getID() const override;

  /**
   * @brief Setter for the line's voltageLevel interface side 1
   * @param voltageLevelInterface of the bus where the side 1 of the line is connected
   */
  void setVoltageLevelInterface1(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc LineInterface::setBusInterface1(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface1(const std::shared_ptr<BusInterface>& busInterface) override;

  /**
   * @brief Setter for the line's voltageLevel interface side 2
   * @param voltageLevelInterface of the bus where the side 2 of the line is connected
   */
  void setVoltageLevelInterface2(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc LineInterface::setBusInterface2(const std::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface2(const std::shared_ptr<BusInterface>& busInterface) override;

  /**
   * @copydoc LineInterface::getBusInterface1() const
   */
  std::shared_ptr<BusInterface> getBusInterface1() const override;

  /**
   * @copydoc LineInterface::getBusInterface2() const
   */
  std::shared_ptr<BusInterface> getBusInterface2() const override;

  /**
   * @copydoc LineInterface::addCurrentLimitInterface1(std::unique_ptr<CurrentLimitInterface> currentLimitInterface)
   */
  void addCurrentLimitInterface1(std::unique_ptr<CurrentLimitInterface> currentLimitInterface) override;

  /**
   * @copydoc LineInterface::addCurrentLimitInterface2(std::unique_ptr<CurrentLimitInterface> currentLimitInterface)
   */
  void addCurrentLimitInterface2(std::unique_ptr<CurrentLimitInterface> currentLimitInterface) override;

  /**
   * @copydoc LineInterface::getCurrentLimitInterfaces1() const
   */
  const std::vector<std::unique_ptr<CurrentLimitInterface> >& getCurrentLimitInterfaces1() const override;

  /**
   * @copydoc LineInterface::getCurrentLimitInterfaces2() const
   */
  const std::vector<std::unique_ptr<CurrentLimitInterface> >& getCurrentLimitInterfaces2() const override;

  /**
   * @copydoc LineInterface::getActiveSeason()
   */
  std::string getActiveSeason() const final;

  /**
   * @brief Retrieve the permanent limit
   *
   * @param season the season to apply
   * @param side the current limit side
   * @returns the permanent limit or nullopt if current limit extension, season or side not found
   */
  boost::optional<double> getCurrentLimitPermanent(const std::string& season, CurrentLimitSide side) const final;

  /**
   * @brief Retrieve the side of temporary limits of a current limit
   *
   * @param season the season to apply
   * @param side the current limit side
   * @returns the side of temporary limits or nullopt if current limit extension, season or side not found
   */
  boost::optional<unsigned int> getCurrentLimitNbTemporary(const std::string& season, CurrentLimitSide side) const final;

  /**
   * @brief Retrieve the name of a temporary limit of a current limit
   *
   * @param season the season to apply
   * @param side the current limit side
   * @param indexTemporary the index of the temporary limit
   * @returns the name of the temporary limit or nullopt if current limit extension, season, side or index not found
   */
  boost::optional<std::string> getCurrentLimitTemporaryName(const std::string& season, CurrentLimitSide side, unsigned int indexTemporary) const final;

  /**
   * @brief Retrieve the acceptable duration of a temporary limit of a current limit
   *
   * @param season the season to apply
   * @param side the current limit side
   * @param indexTemporary the index of the temporary limit
   * @returns the acceptable duration of the temporary limit or nullopt if current limit extension, season, side or index not found
   */
  boost::optional<unsigned long> getCurrentLimitTemporaryAcceptableDuration(const std::string& season, CurrentLimitSide side,
    unsigned int indexTemporary) const final;

  /**
   * @brief Retrieve the value of a temporary limit of a current limit
   *
   * @param season the season to apply
   * @param side the current limit side
   * @param indexTemporary the index of the temporary limit
   * @returns the value of the temporary limit or nullopt if current limit extension, season, side or index not found
   */
  boost::optional<double> getCurrentLimitTemporaryValue(const std::string& season, CurrentLimitSide side, unsigned int indexTemporary) const final;

  /**
   * @brief Determines if a temporary limit of a current limit is fictitious
   *
   * @param season the season to apply
   * @param side the current limit side
   * @param indexTemporary the index of the temporary limit
   * @returns true if the temporary limit is fictitious, false if not or nullopt if current limit extension, season, side or index not found
   */
  boost::optional<bool> getCurrentLimitTemporaryFictitious(const std::string& season, CurrentLimitSide side, unsigned int indexTemporary) const final;

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
  powsybl::iidm::Line& lineIIDM_;                                    ///< reference to the iidm line instance
  std::shared_ptr<BusInterface> busInterface1_;                    ///< busInterface of the bus where the side 1 of the line is connected
  std::shared_ptr<BusInterface> busInterface2_;                    ///< busInterface of the bus where the side 2 of the line is connected
  std::shared_ptr<VoltageLevelInterface> voltageLevelInterface1_;  ///< voltageLevel interface where the side 1 of the line is connected
  std::shared_ptr<VoltageLevelInterface> voltageLevelInterface2_;  ///< voltageLevel interface where the side 2 of the line is connected

  std::vector<std::unique_ptr<CurrentLimitInterface> > currentLimitInterfaces1_;  ///< current limit interfaces for side 1
  std::vector<std::unique_ptr<CurrentLimitInterface> > currentLimitInterfaces2_;  ///< current limit interfaces for side 2
  boost::optional<bool> initialConnected1_;                                         ///< side 1 initially connected
  boost::optional<bool> initialConnected2_;                                         ///< side 2 initially connected

  ActiveSeasonIIDMExtension* activeSeasonExtension_;                                         ///< Active season extension
  IIDMExtensions::DestroyFunction<ActiveSeasonIIDMExtension> destroyActiveSeasonExtension_;  ///< active season destroy function
  CurrentLimitsPerSeasonIIDMExtension* currentLimitsPerSeasonExtension_;                        ///< current limit per season IIDM extension
  IIDMExtensions::DestroyFunction<CurrentLimitsPerSeasonIIDMExtension>
      destroyCurrentLimitsPerSeasonExtension_;  ///< current limit per season IIDM extension destroy function
};                                                                                  ///< Interface class for Line model
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNLINEINTERFACEIIDM_H_
