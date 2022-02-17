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
 * @file  DataInterface/IIDM/DYNVoltageLevelInterfaceIIDM.h
 *
 * @brief VoltageLevel data interface : header file for IIDM interface
 *
 */
#ifndef MODELER_DATAINTERFACE_IIDM_DYNVOLTAGELEVELINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_IIDM_DYNVOLTAGELEVELINTERFACEIIDM_H_

#include <vector>
#include "DYNVoltageLevelInterface.h"
#include "DYNGraph.h"

namespace IIDM {
class VoltageLevel;
}

namespace DYN {
class SwitchInterface;
class CalculatedBusInterfaceIIDM;
class LoadInterface;
class BusInterface;
class GeneratorInterface;
class DanglingLineInterface;
class StaticVarCompensatorInterface;
class VscConverterInterface;
class LccConverterInterface;
class ShuntCompensatorInterface;

/**
 * @class VoltageLevelInterfaceIIDM
 * @brief VoltageLevelInterface class for IIDM
 */
class VoltageLevelInterfaceIIDM : public VoltageLevelInterface {
 public:
  /**
   * @brief Constructor
   * @param voltageLevel : voltageLevel's iidm instance
   */
  explicit VoltageLevelInterfaceIIDM(IIDM::VoltageLevel& voltageLevel);

  /**
   * @brief destructor
   */
  ~VoltageLevelInterfaceIIDM();

  /**
   * @brief Getter for the voltageLevel's id
   * @return The id of the voltageLevel
   */
  std::string getID() const;

  /**
   * @copydoc VoltageLevelInterface::getVNom() const
   */
  double getVNom() const;

  /**
   * @copydoc VoltageLevelInterface::getVoltageLevelTopologyKind() const
   */
  VoltageLevelTopologyKind_t getVoltageLevelTopologyKind() const;

  /**
   * @copydoc VoltageLevelInterface::connectNode(const unsigned int& node)
   */
  void connectNode(const unsigned int& node);

  /**
   * @copydoc VoltageLevelInterface::disconnectNode(const unsigned int& node)
   */
  void disconnectNode(const unsigned int& node);

  /**
   * @copydoc VoltageLevelInterface::isNodeConnected(const unsigned int& node)
   */
  bool isNodeConnected(const unsigned int& node);

  /**
   * @copydoc VoltageLevelInterface::addSwitch()
   */
  void addSwitch(const boost::shared_ptr<SwitchInterface>& sw);

  /**
   * @copydoc VoltageLevelInterface::addBus()
   */
  void addBus(const boost::shared_ptr<BusInterface>& bus);

  /**
   * @copydoc VoltageLevelInterface::addGenerator()
   */
  void addGenerator(const boost::shared_ptr<GeneratorInterface>& generator);

  /**
   * @copydoc VoltageLevelInterface::addLoad()
   */
  void addLoad(const boost::shared_ptr<LoadInterface>& load);

  /**
   * @copydoc VoltageLevelInterface::addShuntCompensator()
   */
  void addShuntCompensator(const boost::shared_ptr<ShuntCompensatorInterface>& shunt);

  /**
   * @copydoc VoltageLevelInterface::addDanglingLine()
   */
  void addDanglingLine(const boost::shared_ptr<DanglingLineInterface>& danglingLine);

  /**
   * @copydoc VoltageLevelInterface::addStaticVarCompensator()
   */
  void addStaticVarCompensator(const boost::shared_ptr<StaticVarCompensatorInterface>& svc);

  /**
   * @copydoc VoltageLevelInterface::addVscConverter()
   */
  void addVscConverter(const boost::shared_ptr<VscConverterInterface>& vsc);

  /**
   * @copydoc VoltageLevelInterface::addLccConverter()
   */
  void addLccConverter(const boost::shared_ptr<LccConverterInterface>& lcc);

  /**
   * @copydoc VoltageLevelInterface::getBuses()
   */
  const std::vector< boost::shared_ptr<BusInterface> >& getBuses() const;

  /**
   * @copydoc VoltageLevelInterface::getSwitches()
   */
  const std::vector< boost::shared_ptr<SwitchInterface> >& getSwitches() const;

  /**
   * @copydoc VoltageLevelInterface::getLoads()
   */
  const std::vector< boost::shared_ptr<LoadInterface> >& getLoads() const;

  /**
   * @copydoc VoltageLevelInterface::getShuntCompensators()
   */
  const std::vector< boost::shared_ptr<ShuntCompensatorInterface> >& getShuntCompensators() const;

  /**
   * @copydoc VoltageLevelInterface::getStaticVarCompensators()
   */
  const std::vector< boost::shared_ptr<StaticVarCompensatorInterface> >& getStaticVarCompensators() const;

  /**
   * @copydoc VoltageLevelInterface::getGenerators()
   */
  const std::vector< boost::shared_ptr<GeneratorInterface> >& getGenerators() const;

  /**
   * @copydoc VoltageLevelInterface::getDanglingLines()
   */
  const std::vector< boost::shared_ptr<DanglingLineInterface> >& getDanglingLines() const;

  /**
   * @copydoc VoltageLevelInterface::getVscConverters()
   */
  const std::vector< boost::shared_ptr<VscConverterInterface> >& getVscConverters() const;

  /**
   * @copydoc VoltageLevelInterface::getLccConverters()
   */
  const std::vector< boost::shared_ptr<LccConverterInterface> >& getLccConverters() const;

  /**
   * @copydoc VoltageLevelInterface::mapConnections()
   */
  void mapConnections();

  /**
   * @copydoc VoltageLevelInterface::exportSwitchesState()
   */
  void exportSwitchesState();

  /**
   *  @brief calculate bus topology from node topology if node topology is used in iidm network
   */
  void calculateBusTopology();

  /**
   * @brief get the vector of calculated bus created from the node view
   * @return vector of calculated bus created from the node view
   */
  inline const std::vector<boost::shared_ptr<CalculatedBusInterfaceIIDM> >& getCalculatedBus() const {
    return calculatedBus_;
  }

  /**
   * @brief get the detailed status of the node
   * @return @b true if the node is detailed
   */
  inline bool isNodeBreakerTopology() const {
    return isNodeBreakerTopology_;
  }

  /**
   * @brief Getter for the voltage level' country
   * @return the voltage level country
   */
  inline const std::string& getCountry() const {
    return country_;
  }

  /**
   * @brief Setter for the voltage level' country
   * @param country voltage level country
   */
  inline void setCountry(const std::string& country) {
    country_ = country;
  }

 private:
  /**
   * @brief Count the number of switches that should be closed to connect this path
   *
   * @param path path to be analyzed
   * @return the number of switches that should be closed to connect this path
   */
  unsigned countNumberOfSwitchesToClose(const std::vector<std::string>& path) const;

 private:
  IIDM::VoltageLevel& voltageLevelIIDM_;  ///< reference to the iidm voltageLevel instance
  bool isNodeBreakerTopology_;  ///< @b true if the topology of the voltageLevel is node breaker topology
  std::map< std::string, boost::shared_ptr<SwitchInterface> > switchesById_;  ///< switch interface by Id
  std::map< boost::shared_ptr<SwitchInterface>, double > switchState_;  ///< state to apply to switch (due to topology change)
  Graph graph_;  ///< topology graph to find node connection
  boost::unordered_map<std::string, float> weights1_;  ///< weight of 1 for each edge in the graph
  std::vector<boost::shared_ptr<BusInterface> > buses_;  ///< bus interface created
  std::vector<boost::shared_ptr<SwitchInterface> > switches_;  ///< switch interface created
  std::vector<boost::shared_ptr<CalculatedBusInterfaceIIDM> > calculatedBus_;  ///< vector of calculated bus created from the node view
  std::vector<boost::shared_ptr<GeneratorInterface> > generators_;  ///< generator interface created
  std::vector<boost::shared_ptr<LoadInterface> > loads_;  ///< load interface created
  std::vector<boost::shared_ptr<ShuntCompensatorInterface> > shunts_;  ///< shunt compensator interface created
  std::vector<boost::shared_ptr<DanglingLineInterface> > danglingLines_;  ///< dangling line interface created
  std::vector<boost::shared_ptr<StaticVarCompensatorInterface> > staticVarCompensators_;  ///< staticVarCompensator interface created
  std::vector<boost::shared_ptr<VscConverterInterface> > vscConverters_;  ///< vscConverter interface created
  std::vector<boost::shared_ptr<LccConverterInterface> > lccConverters_;  ///< lccConverter interface created
  std::string country_;  ///< country of the voltage level
};  /// end of class declaration

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_IIDM_DYNVOLTAGELEVELINTERFACEIIDM_H_
