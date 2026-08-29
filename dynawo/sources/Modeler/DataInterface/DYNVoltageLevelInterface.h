//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
 * @file  DYNVoltageLevelInterface.h
 *
 * @brief Voltage level data interface : header file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNVOLTAGELEVELINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNVOLTAGELEVELINTERFACE_H_

#include <string>
#include <vector>
#include <memory>

namespace DYN {
class BusInterface;
class SwitchInterface;
class LoadInterface;
class GeneratorInterface;
class StaticVarCompensatorInterface;
class ShuntCompensatorInterface;
class VscConverterInterface;
class LccConverterInterface;
class DanglingLineInterface;

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class VoltageLevelInterface
 * @brief VoltageLevelInterface class
 */
class VoltageLevelInterface {
 public:
  /**
   * @brief destructor
   */
  virtual ~VoltageLevelInterface() = default;

  /**
   * @brief Definition of the voltage level topology
   */
  typedef enum {
    BUS_BREAKER = 1,
    NODE_BREAKER = 2
  } VoltageLevelTopologyKind_t;

  /**
   * @brief Getter for the voltageLevel's id
   * @return The id of the voltageLevel
   */
  virtual const std::string& getID() const = 0;

  /**
   * @brief Getter for the nominal voltage of the voltageLevel
   * @return The nominal voltage of the voltageLevel
   */
  virtual double getVNom() const = 0;

  /**
   * @brief Getter for the voltage level topology kind
   * @return The voltage level topology kind
   */
  virtual VoltageLevelTopologyKind_t getVoltageLevelTopologyKind() const = 0;

  /**
   * @brief find the shortest path between a node and a bus bar section node, then close all switches (if they are breaker)
   * @param node node to connect
   */
  virtual void connectNode(unsigned int node) = 0;

  /**
   * @brief find all paths between a node and all bus bar section node, then open the first switches found (if it's a breaker)
   * @param node node to disconnect
   */
  virtual void disconnectNode(unsigned int node) = 0;

  /**
   * @brief check if one node is connected to a node where there is a bus bar section
   * @param node node to check
   * @return @b true is the node is connected
   */
  virtual bool isNodeConnected(unsigned int node) = 0;

  /**
   * @brief export the new state of switches due to topology change (connect/disconnect node)
   */
  virtual void exportSwitchesState() = 0;

  /**
   * @brief Add a new instance of bus interface to the voltageLevel interface
   * @param bus instance of bus interface to add
   */
  virtual void addBus(const std::shared_ptr<BusInterface>& bus) = 0;

  /**
   * @brief Add a new instance of switch interface to the voltageLevel interface
   * @param sw instance of switch interface to add
   */
  virtual void addSwitch(const std::shared_ptr<SwitchInterface>& sw) = 0;

   /**
   * @brief Add a new instance of load interface to the voltageLevel interface
   * @param load instance of load interface to add
   */
  virtual void addLoad(const std::shared_ptr<LoadInterface>& load) = 0;

  /**
   * @brief Add a new instance of shunt compensator interface to the voltageLevel interface
   * @param shunt instance of shunt compensator interface to add
   */
  virtual void addShuntCompensator(const std::shared_ptr<ShuntCompensatorInterface>& shunt) = 0;

  /**
   * @brief Add a new instance of static var compensator interface to the voltageLevel interface
   * @param svc instance of static var compensator interface to add
   */
  virtual void addStaticVarCompensator(const std::shared_ptr<StaticVarCompensatorInterface>& svc) = 0;

  /**
   * @brief Add a new instance of generator interface to the voltageLevel interface
   * @param generator instance of generator interface to add
   */
  virtual void addGenerator(const std::shared_ptr<GeneratorInterface>& generator) = 0;

  /**
   * @brief Add a new instance of dangling line interface to the voltageLevel interface
   * @param danglingLine instance of danglingLine interface to add
   */
  virtual void addDanglingLine(const std::shared_ptr<DanglingLineInterface>& danglingLine) = 0;

   /**
   * @brief Add a new instance of vsc converter interface to the voltageLevel interface
   * @param vsc instance of vsc converter interface to add
   */
  virtual void addVscConverter(const std::shared_ptr<VscConverterInterface>& vsc) = 0;

  /**
   * @brief Add a new instance of lcc converter interface to the voltageLevel interface
   * @param lcc instance of lcc converter interface to add
   */
  virtual void addLccConverter(const std::shared_ptr<LccConverterInterface>& lcc) = 0;

  /**
   * @brief Getter for the vector of bus interface
   * @return vector of bus interface of the newtork interface
   */
  virtual const std::vector<std::shared_ptr<BusInterface> >& getBuses() const = 0;

  /**
   * @brief Getter for the vector of switch interface
   * @return vector of switch interface of the newtork interface
   */
  virtual const std::vector<std::shared_ptr<SwitchInterface> >& getSwitches() const = 0;

  /**
   * @brief Getter for the vector of load interface
   * @return vector of load interface of the newtork interface
   */
  virtual const std::vector<std::shared_ptr<LoadInterface> >& getLoads() const = 0;

  /**
   * @brief Getter for the vector of shunt compensator interface
   * @return vector of shunt compensator interface of the newtork interface
   */
  virtual const std::vector<std::shared_ptr<ShuntCompensatorInterface> >& getShuntCompensators() const = 0;

  /**
   * @brief Getter for the vector of static var compensator interface
   * @return vector of static var compensator interface of the newtork interface
   */
  virtual const std::vector<std::shared_ptr<StaticVarCompensatorInterface> >& getStaticVarCompensators() const = 0;

  /**
   * @brief Getter for the vector of generator interface
   * @return vector of generator interface of the newtork interface
   */
  virtual const std::vector<std::shared_ptr<GeneratorInterface> >& getGenerators() const = 0;

  /**
   * @brief Getter for the vector of danglingLine interface
   * @return vector of danglingLine of the newtork interface
   */
  virtual const std::vector<std::shared_ptr<DanglingLineInterface> >& getDanglingLines() const = 0;

  /**
   * @brief Getter for the vector of vsc converter interface
   * @return vector of vsc converter of the newtork interface
   */
  virtual const std::vector<std::shared_ptr<VscConverterInterface> >& getVscConverters() const = 0;

  /**
   * @brief Getter for the vector of lcc converter interface
   * @return vector of lcc converter of the newtork interface
   */
  virtual const std::vector<std::shared_ptr<LccConverterInterface> >& getLccConverters() const = 0;

  /**
   * @brief for each components, if there is a dynamic model, indicate for
   * nodes where component is connected that there is an outside connection
   */
  virtual void mapConnections() = 0;

  /**
   * @brief get if the topology of the voltage level is node breaker one
   * @return @b true if the topology of the voltage level is node breaker one
   */
  virtual bool isNodeBreakerTopology() const = 0;
};  /// end of class declaration

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNVOLTAGELEVELINTERFACE_H_
