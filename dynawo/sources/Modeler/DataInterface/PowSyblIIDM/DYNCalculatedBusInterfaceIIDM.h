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

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCALCULATEDBUSINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCALCULATEDBUSINTERFACEIIDM_H_

#include "DYNBusInterface.h"

#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/Bus.hpp>

#include <boost/optional.hpp>
#include <boost/shared_ptr.hpp>
#include <set>
#include <ostream>

namespace DYN {

/**
 * @class CalculatedBusInterfaceIIDM
 * @brief Specialisation of BusInterface class for calculated bus
 */
class CalculatedBusInterfaceIIDM : public BusInterface {
 public:
  /**
   * @brief defines the index of each state variable
   */
  typedef enum {
    VAR_V = 0,
    VAR_ANGLE = 1
  } indexVar_t;

  /**
   * @brief constructor
   *
   * @param voltageLevel IIDM voltageLevel instance
   * @param name name of the calculated bus
   * @param busIndex index of the calculated bus
   */
  CalculatedBusInterfaceIIDM(powsybl::iidm::VoltageLevel& voltageLevel, const std::string& name, const int busIndex);

  /**
   * @copydoc BusInterface::getV0() const
   */
  double getV0() const override;

  /**
   * @copydoc BusInterface::getVMin() const
   */
  double getVMin() const override;

  /**
   * @copydoc BusInterface::getVMax() const
   */
  double getVMax() const override;

  /**
   * @copydoc BusInterface::getAngle0() const
   */
  double getAngle0() const override;

  /**
   * @copydoc BusInterface::getVNom() const
   */
  double getVNom() const override;

  /**
   * @copydoc BusInterface::getStateVarV() const
   */
  double getStateVarV() const override;

  /**
   * @copydoc BusInterface::getStateVarAngle() const
   */
  double getStateVarAngle() const override;

  /**
   * @copydoc BusInterface::getID() const
   */
  const std::string& getID() const override;

  /**
   * @copydoc BusInterface::hasConnection(bool hasConnection)
   */
  void hasConnection(bool hasConnection) override;

  /**
   * @brief Getter for the bus' connection attribute
   * @return @b true if the bus has an outside connection, @b false else
   */
  bool hasConnection() const override;

  /**
   * @copydoc BusInterface::importStaticParameters()
   */
  void importStaticParameters() override;

  /**
   * @copydoc BusInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent() override;

  /**
   * @brief associate a bus bar section interface to the calculated bus
   * @param bbs : bus bar section id to add
   */
  void addBusBarSection(const std::string& bbs);

  /**
   * @brief associate a node to the calculated bus
   * @param node index of the node to add
   */
  void addNode(const int node);

  /**
   * @brief check if a node is contained in the calculated bus
   * @param node index of the node
   * @return @b true if the node is contained in the calculated bus
   */
  bool hasNode(const int node);

  /**
   * @brief get the index of nodes associated to the bus
   * @return the index of nodes associated to the bus
   */
  std::set<int> getNodes() const;

  /**
   * @brief check if a bus bar section is contained in the calculated bus
   * @param bbs id of the bus bar section
   * @return @b true if the bus bar section is contained in the calculated bus
   */
  bool hasBusBarSection(const std::string& bbs) const;

  /**
   * @copydoc BusInterface::getBusBarSectionIdentifiers() const
   */
  const std::vector<std::string>& getBusBarSectionIdentifiers() const override;

  /**
   * @copydoc BusInterface::isFictitious() const
   */
  bool isFictitious() const final {
    return false;
  }

  /**
   * @brief set the initial value of the voltage magnitude
   * @param u0 : initial value of the voltage magnitude
   */
  void setU0(const double& u0);

  /**
   * @brief set the initial value of the voltage angle
   * @param angle0 : initial value of the voltage angle
   */
  void setAngle0(const double& angle0);

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const override;

  /**
   * @copydoc BusInterface::getBusIndex() const
   */
  inline int getBusIndex() const override {
    return busIndex_;
  }

  /**
   * @brief Getter for the bus' country
   * @return the bus country
   */
  inline const std::string& getCountry() const {
    return country_;
  }

  /**
   * @brief Setter for the bus' country
   * @param country bus country
   */
  inline void setCountry(const std::string& country) {
    country_ = country;
  }

 private:
  int busIndex_;  ///< bus index
  boost::optional<double> U0_;  ///< initial value of the voltage magnitude
  boost::optional<double> angle0_;  ///< initial value of the voltage angle
  std::string name_;  ///< name of the calculated bus
  std::set<int> nodes_;  ///< index of the nodes associated to the bus
  powsybl::iidm::VoltageLevel& voltageLevel_;  ///< IIDM voltage level instance
  bool hasConnection_;  ///< @b true if the bus has an outside connection, @b false else
  std::string country_;  ///< country of the bus
  std::vector<std::string> bbsIdentifiers_;  ///< identifiers of the bus bar sections
  std::vector<stdcxx::Reference<powsybl::iidm::BusbarSection>> bbs_;  ///< bus bar sections
};  ///< Interface class for CalculatedBusInterface

std::ostream& operator<<(std::ostream& stream, const CalculatedBusInterfaceIIDM& calculatedBus);

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCALCULATEDBUSINTERFACEIIDM_H_
