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

#ifndef MODELER_DATAINTERFACE_DYNCALCULATEDBUSINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_DYNCALCULATEDBUSINTERFACEIIDM_H_

#include <set>
#include <ostream>

#include <boost/optional.hpp>
#include <boost/shared_ptr.hpp>

#include "DYNBusInterface.h"

namespace IIDM {
class VoltageLevel;
}

namespace DYN {
class BusBarSectionInterface;

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
   * @brief destructor
   */
  ~CalculatedBusInterfaceIIDM();

  /**
   * @brief constructor
   *
   * @param voltageLevel IIDM voltageLevel instance
   * @param name name of the calculated bus
   * @param busIndex index of the calculated bus
   */
  CalculatedBusInterfaceIIDM(IIDM::VoltageLevel& voltageLevel, const std::string& name, const int busIndex);

  /**
   * @copydoc BusInterface::getV0() const
   */
  double getV0() const;

  /**
   * @copydoc BusInterface::getVMin() const
   */
  double getVMin() const;

  /**
   * @copydoc BusInterface::getVMax() const
   */
  double getVMax() const;

  /**
   * @copydoc BusInterface::getAngle0() const
   */
  double getAngle0() const;

  /**
   * @copydoc BusInterface::getVNom() const
   */
  double getVNom() const;

  /**
   * @copydoc BusInterface::getStateVarV() const
   */
  double getStateVarV() const;

  /**
   * @copydoc BusInterface::getStateVarAngle() const
   */
  double getStateVarAngle() const;

  /**
   * @copydoc BusInterface::getID() const
   */
  std::string getID() const;

  /**
   * @copydoc BusInterface::hasConnection(bool hasConnection)
   */
  void hasConnection(bool hasConnection);

  /**
   * @brief Getter for the bus' connection attribute
   * @return @b true if the bus has an outside connection, @b false else
   */
  bool hasConnection() const;

  /**
   * @copydoc BusInterface::importStaticParameters()
   */
  void importStaticParameters();

  /**
   * @copydoc BusInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent();

  /**
   * @brief associate a bus bar section interface to the calculated bus
   * @param bbs : bus bar section to add
   */
  void addBusBarSection(const boost::shared_ptr<BusBarSectionInterface>& bbs);

  /**
   * @brief associate a node to the calculated bus
   * @param node index of the node to add
   */
  void addNode(const int& node);

  /**
   * @brief check if a node is contained in the calculated bus
   * @param node index of the node
   * @return @b true if the node is contained in the calculated bus
   */
  bool hasNode(const int& node);

  /**
   * @brief get the index of nodes associated to the bus
   * @return the index of nodes associated to the bus
   */
  std::set<int> getNodes() const;

  /**
   * @copydoc BusInterface::getBusBarSectionNames() const
   */
  std::vector<std::string> getBusBarSectionNames() const;

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
  int getComponentVarIndex(const std::string& varName) const;

  /**
   * @copydoc BusInterface::getBusIndex() const
   */
  inline int getBusIndex() const {
    return busIndex_;
  }

 private:
  int busIndex_;  ///< bus index
  boost::optional<double> U0_;  ///< initial value of the voltage magnitude
  boost::optional<double> angle0_;  ///< initial value of the voltage angle
  std::string name_;  ///< name of the calculated bus
  std::vector<boost::shared_ptr<BusBarSectionInterface> > busBarSections_;  ///< bus bar section associated to the bus
  std::set<int> nodes_;  ///< index of the nodes associated to the bus
  IIDM::VoltageLevel& voltageLevel_;  ///< IIDM voltage level instance
  bool hasConnection_;  ///< @b true if the bus has an outside connection, @b false else
};  ///< Interface class for CalculatedBusInterface

std::ostream& operator<<(std::ostream& stream, const CalculatedBusInterfaceIIDM& calculatedBus);

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNCALCULATEDBUSINTERFACEIIDM_H_
