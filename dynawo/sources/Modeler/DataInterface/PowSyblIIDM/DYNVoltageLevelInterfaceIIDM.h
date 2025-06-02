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
 * @file  DataInterface/PowSyblIIDM/DYNVoltageLevelInterfaceIIDM.h
 *
 * @brief VoltageLevel data interface : header file for IIDM interface
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNVOLTAGELEVELINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNVOLTAGELEVELINTERFACEIIDM_H_

#include "DYNVoltageLevelInterface.h"
#include "DYNGraph.h"
#include "DYNCalculatedBusInterfaceIIDM.h"
#include "DYNSwitchInterface.h"

#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/extensions/SlackTerminal.hpp>

#include <unordered_map>
#include <boost/optional.hpp>

namespace DYN {

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
  explicit VoltageLevelInterfaceIIDM(powsybl::iidm::VoltageLevel& voltageLevel);

  /**
   * @brief Getter for the voltageLevel's id
   * @return The id of the voltageLevel
   */
  const std::string& getID() const override;

  /**
   * @copydoc VoltageLevelInterface::getVNom() const
   */
  double getVNom() const override;

  /**
   * @copydoc VoltageLevelInterface::getVoltageLevelTopologyKind() const
   */
  VoltageLevelTopologyKind_t getVoltageLevelTopologyKind() const override;

  /**
   * @copydoc VoltageLevelInterface::connectNode(const unsigned int& node)
   */
  void connectNode(const unsigned int& node) override;

  /**
   * @copydoc VoltageLevelInterface::disconnectNode(const unsigned int& node)
   */
  void disconnectNode(const unsigned int& node) override;

  /**
   * @copydoc VoltageLevelInterface::isNodeConnected(const unsigned int& node)
   */
  bool isNodeConnected(const unsigned int& node) override;

  /**
   * @copydoc VoltageLevelInterface::addSwitch()
   */
  void addSwitch(const std::shared_ptr<SwitchInterface>& sw) override;

  /**
   * @copydoc VoltageLevelInterface::addBus()
   */
  void addBus(const std::shared_ptr<BusInterface>& bus) override;

  /**
   * @copydoc VoltageLevelInterface::addGenerator()
   */
  void addGenerator(const std::shared_ptr<GeneratorInterface>& generator) override;

  /**
   * @copydoc VoltageLevelInterface::addLoad()
   */
  void addLoad(const std::shared_ptr<LoadInterface>& load) override;

  /**
   * @copydoc VoltageLevelInterface::addShuntCompensator()
   */
  void addShuntCompensator(const std::shared_ptr<ShuntCompensatorInterface>& shunt) override;

  /**
   * @copydoc VoltageLevelInterface::addDanglingLine()
   */
  void addDanglingLine(const std::shared_ptr<DanglingLineInterface>& danglingLine) override;

  /**
   * @copydoc VoltageLevelInterface::addStaticVarCompensator()
   */
  void addStaticVarCompensator(const std::shared_ptr<StaticVarCompensatorInterface>& svc) override;

  /**
   * @copydoc VoltageLevelInterface::addVscConverter()
   */
  void addVscConverter(const std::shared_ptr<VscConverterInterface>& vsc) override;

  /**
   * @copydoc VoltageLevelInterface::addLccConverter()
   */
  void addLccConverter(const std::shared_ptr<LccConverterInterface>& lcc) override;

  /**
   * @copydoc VoltageLevelInterface::getBuses()
   */
  const std::vector<std::shared_ptr<BusInterface> >& getBuses() const override;

  /**
   * @copydoc VoltageLevelInterface::getSwitches()
   */
  const std::vector<std::shared_ptr<SwitchInterface> >& getSwitches() const override;

  /**
   * @copydoc VoltageLevelInterface::getLoads()
   */
  const std::vector<std::shared_ptr<LoadInterface> >& getLoads() const override;

  /**
   * @copydoc VoltageLevelInterface::getShuntCompensators()
   */
  const std::vector<std::shared_ptr<ShuntCompensatorInterface> >& getShuntCompensators() const override;

  /**
   * @copydoc VoltageLevelInterface::getStaticVarCompensators()
   */
  const std::vector<std::shared_ptr<StaticVarCompensatorInterface> >& getStaticVarCompensators() const override;

  /**
   * @copydoc VoltageLevelInterface::getGenerators()
   */
  const std::vector<std::shared_ptr<GeneratorInterface> >& getGenerators() const override;

  /**
   * @copydoc VoltageLevelInterface::getDanglingLines()
   */
  const std::vector<std::shared_ptr<DanglingLineInterface> >& getDanglingLines() const override;

  /**
   * @copydoc VoltageLevelInterface::getVscConverters()
   */
  const std::vector<std::shared_ptr<VscConverterInterface> >& getVscConverters() const override;

  /**
   * @copydoc VoltageLevelInterface::getLccConverters()
   */
  const std::vector<std::shared_ptr<LccConverterInterface> >& getLccConverters() const override;

  /**
   * @copydoc VoltageLevelInterface::mapConnections()
   */
  void mapConnections() override;

  /**
   *  @brief calculate bus topology from node topology if node topology is used in iidm network
   */
  void calculateBusTopology();

  /**
   * @brief get the vector of calculated bus created from the node view
   * @return vector of calculated bus created from the node view
   */
  inline const std::vector<std::shared_ptr<CalculatedBusInterfaceIIDM> >& getCalculatedBus() const {
    return calculatedBus_;
  }

  /**
   * @copydoc VoltageLevelInterface::exportSwitchesState()
   */
  void exportSwitchesState() override;

  /**
   * @brief get the detailed status of the node
   * @return @b true if the node is detailed
   */
  inline bool isNodeBreakerTopology() const override {
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

  /**
   * @brief Get the slack bus id
   *
   * @return the slack bus id, or boost::none if extension is not found for current voltage level
   */
  boost::optional<std::string> getSlackBusId() const;

 private:
  /**
   * @brief Count the number of switches that should be closed to connect this path
   *
   * @param path path to be analyzed
   * @return the number of switches that should be closed to connect this path
   */
  unsigned countNumberOfSwitchesToClose(const std::vector<std::string>& path) const;

 private:
  powsybl::iidm::VoltageLevel& voltageLevelIIDM_;  ///< reference to the iidm voltageLevel instance
  bool isNodeBreakerTopology_;  ///< @b true if the topology of the voltageLevel is node breaker topology
  std::unordered_map<std::shared_ptr<SwitchInterface>, double, SwitchInterfaceHash> switchState_;  ///< state to apply to switch (due to topology change)
  std::map<std::string, std::shared_ptr<SwitchInterface> > switchesById_;  ///< switch interface by Id
  Graph graph_;  ///< topology graph to find node connection
  std::unordered_map<std::string, float> weights1_;  ///< weight of 1 for each edge in the graph
  std::vector<std::shared_ptr<BusInterface> > buses_;  ///< bus interface created
  std::vector<std::shared_ptr<CalculatedBusInterfaceIIDM> > calculatedBus_;  ///< vector of calculated bus created from the node view
  std::vector<std::shared_ptr<SwitchInterface> > switches_;  ///< switch interface created
  std::vector<std::shared_ptr<GeneratorInterface> > generators_;  ///< generator interface created
  std::vector<std::shared_ptr<LoadInterface> > loads_;  ///< load interface created
  std::vector<std::shared_ptr<ShuntCompensatorInterface> > shunts_;  ///< shunt compensator interface created
  std::vector<std::shared_ptr<DanglingLineInterface> > danglingLines_;  ///< dangling line interface created
  std::vector<std::shared_ptr<StaticVarCompensatorInterface> > staticVarCompensators_;  ///< staticVarCompensator interface created
  std::vector<std::shared_ptr<VscConverterInterface> > vscConverters_;  ///< vscConverter interface created
  std::vector<std::shared_ptr<LccConverterInterface> > lccConverters_;  ///< lccConverter interface created
  std::string country_;  ///< country of the voltage level

  stdcxx::Reference<powsybl::iidm::extensions::SlackTerminal> slackTerminalExtension_;  ///< slack terminal extension
};  /// end of class declaration

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNVOLTAGELEVELINTERFACEIIDM_H_
