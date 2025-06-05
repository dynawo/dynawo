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
 * @file  DataInterface/PowSyblIIDM/DYNFictVoltageLevelInterfaceIIDM.h
 *
 * @brief Fictitious Voltage Level : header file to create VoltageLevel from scratch
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNFICTVOLTAGELEVELINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNFICTVOLTAGELEVELINTERFACEIIDM_H_

#include "DYNVoltageLevelInterface.h"
#include "DYNGraph.h"
#include "DYNCalculatedBusInterfaceIIDM.h"


namespace DYN {

/**
 * @class FictVoltageLevelInterfaceIIDM
 * @brief FictVoltageLevelInterface class for IIDM
 */
class FictVoltageLevelInterfaceIIDM : public VoltageLevelInterface {
 public:
  /**
   * @brief Constructor
   * @param Id : Id of fictitious voltageLevel
   * @param VNom : nominal voltage of fictitious voltageLevel
   * @param country : country of fictious voltage
   */
  explicit FictVoltageLevelInterfaceIIDM(const std::string& Id, const double& VNom, const std::string& country);

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
  const std::vector<std::shared_ptr<SwitchInterface> >& getSwitches() const override {
    static std::vector<std::shared_ptr<SwitchInterface> > v;
    return v;
  }

  /**
   * @copydoc VoltageLevelInterface::getLoads()
   */
  const std::vector<std::shared_ptr<LoadInterface> >& getLoads() const override {
    static std::vector<std::shared_ptr<LoadInterface> > v;
    return v;
  }

  /**
   * @copydoc VoltageLevelInterface::getShuntCompensators()
   */
  const std::vector<std::shared_ptr<ShuntCompensatorInterface> >& getShuntCompensators() const override {
    static std::vector<std::shared_ptr<ShuntCompensatorInterface> > v;
    return v;
  }

  /**
   * @copydoc VoltageLevelInterface::getStaticVarCompensators()
   */
  const std::vector<std::shared_ptr<StaticVarCompensatorInterface> >& getStaticVarCompensators() const override {
    static std::vector<std::shared_ptr<StaticVarCompensatorInterface> > v;
    return v;
  }

  /**
   * @copydoc VoltageLevelInterface::getGenerators()
   */
  const std::vector<std::shared_ptr<GeneratorInterface> >& getGenerators() const override {
    static std::vector<std::shared_ptr<GeneratorInterface> > v;
    return v;
  }

  /**
   * @copydoc VoltageLevelInterface::getDanglingLines()
   */
  const std::vector<std::shared_ptr<DanglingLineInterface> >& getDanglingLines() const override {
    static std::vector<std::shared_ptr<DanglingLineInterface> > v;
    return v;
  }

  /**
   * @copydoc VoltageLevelInterface::getVscConverters()
   */
  const std::vector<std::shared_ptr<VscConverterInterface> >& getVscConverters() const override {
    static std::vector<std::shared_ptr<VscConverterInterface> > v;
    return v;
  }

  /**
   * @copydoc VoltageLevelInterface::getLccConverters()
   */
  const std::vector<std::shared_ptr<LccConverterInterface> >& getLccConverters() const override {
    static std::vector<std::shared_ptr<LccConverterInterface> > v;
    return v;
  }

  /**
   * @copydoc VoltageLevelInterface::mapConnections()
   */
  void mapConnections() override {
    /* not needed */
  }

  /**
   * @copydoc VoltageLevelInterface::exportSwitchesState()
   */
  void exportSwitchesState() override {
    /* not needed */
  }

  /**
   * @brief get the detailed status of the node
   * @return @b true if the node is detailed
   */
  inline bool isNodeBreakerTopology() const override {
    return false;
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
  std::string Id_;  ///< Id of fictitious voltage level
  double VNom_;    ///< nominal voltage of voltageLevel in kV
  std::string country_;  ///< country of the voltage level
  std::vector<std::shared_ptr<BusInterface> > buses_;  ///< bus interface created
};  /// end of class declaration

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNFICTVOLTAGELEVELINTERFACEIIDM_H_
