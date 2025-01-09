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
 * @file  DYNModelVoltageLevel.h
 *
 * @brief ModelVoltageLevel header
 *
 * ModelVoltageLevel is the container of all subModels who constitute a voltage level
 * such as buses, switches, generators, loads, shunt etc..
 *
 */

#ifndef MODELS_CPP_MODELNETWORK_DYNMODELVOLTAGELEVEL_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELVOLTAGELEVEL_H_

#include <boost/shared_ptr.hpp>

#include "DYNNetworkComponent.h"
#include "DYNVoltageLevelInterface.h"
#include "DYNGraph.h"

namespace DYN {
class VoltageLevelInterface;
class ModelBus;
class ModelSwitch;

/**
 * class ModelVoltageLevel
 */
class ModelVoltageLevel : public NetworkComponent {
 public:
  /**
   * @brief default constructor
   * @param[in] voltageLevel voltage level data interface to use for the model
   */
  explicit ModelVoltageLevel(const std::shared_ptr<VoltageLevelInterface>& voltageLevel);

  /**
   * @brief list of calculated variables indexes
   */
  typedef enum {
    nbCalculatedVariables_ = 0
  } CalculatedVariables_t;

  /**
   * @brief getter for the voltage level components
   * @return the voltage level components
   */
  inline const std::vector<std::shared_ptr<NetworkComponent> >& getComponents() const {
    return components_;
  }

  /**
   * @brief getter for the voltage level topology kind
   * @return the voltage level topology kind
   */
  inline VoltageLevelInterface::VoltageLevelTopologyKind_t& getTopologyKind() {
    return topologyKind_;
  }

  /**
   * @brief add a new component instance to the voltage level model
   * @param component instance to add
   */
  void addComponent(const std::shared_ptr<NetworkComponent>& component);

 /**
   * @brief add a new component instance to the voltage level model
   * @param component instance to add
   */
  void addComponentEvalG(const std::shared_ptr<NetworkComponent>& component);

  /**
   * @brief add a new bus component instance to the voltage level model
   * @param bus component instance to add
   */
  void addBus(const std::shared_ptr<ModelBus>& bus);

  /**
   * @brief add a new switch component instance to the voltage level model
   * @param sw component instance to add
   */
  void addSwitch(const std::shared_ptr<ModelSwitch>& sw);

  /**
   * @brief compute switches loops
   */
  void computeLoops();

  /**
   * @brief find the shortest path between a node and a bus bar section node, then close all switches between them (if they are breaker)
   * @param nodeToConnect node to connect to a bus bar section
   */
  void connectNode(unsigned int nodeToConnect);

  /**
   * @brief return true if this node can be disconnected
   * @param node node to test
   * @return true if this node can be disconnected
   */
  bool canBeDisconnected(unsigned int node);

  /**
   * @brief find all paths between a node and all bus bar section node, then open the first switches found (if it's a breaker)
   * @param node node to disconnect
   */
  void disconnectNode(unsigned int node);

  /**
   * @brief find the closest bus bar section of a bus in a voltage level
   * @param node the index of the bus for which to look for the closest bus bar section
   * @param shortestPath list of switch names that separate the bus bar section from the initial bus
   * @return the closest bus bar section index
   */
  unsigned int findClosestBBS(unsigned int node, std::vector<std::string>& shortestPath);

  /**
   * @brief return true if the closest bus bar section is switched off or unreachable
   * @param bus the bus from which to look for the closest bus bar section
   * @return true is the closest bus bar section is switched off or unreachable, false otherwise
   */
  bool isClosestBBSSwitchedOff(const std::shared_ptr<ModelBus>& bus);
  /**
   * @brief set the initial currents of each switch
   */
  void setInitialSwitchCurrents();

  /**
   * @brief evaluation F
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(propertyF_t type) override;

  /**
   * @brief evaluate jacobian \f$( J = @F/@x + cj * @F/@x')\f$
   * @param cj jacobian prime coefficient
   * @param rowOffset row offset to use to find the first row to fill
   * @param jt sparse matrix to fill
   */
  void evalJt(double cj, int rowOffset, SparseMatrix& jt) override;

  /**
   * @brief evaluate jacobian \f$( J =  @F/@x')\f$
   * @param rowOffset row offset to use to find the first row to fill
   * @param jtPrim sparse matrix to fill
   */
  void evalJtPrim(int rowOffset, SparseMatrix& jtPrim) override;

  /**
   * @brief define variables
   * @param variables vector of variables to fill
   */
  static void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @brief define parameters
   * @param parameters vector of parameter to fill
   */
  static void defineParameters(std::vector<ParameterModeler>& parameters);

  /**
   * @copydoc NetworkComponent::initSize()
   */
  void initSize() override;

  /**
   * @copydoc NetworkComponent::init(int& yNum )
   */
  void init(int& yNum) override;

  /**
   * @copydoc NetworkComponent::getY0()
   */
  void getY0() override;

  /**
   * @copydoc NetworkComponent::setFequations(std::map<int,std::string>& fEquationIndex)
   */
  void setFequations(std::map<int, std::string>& fEquationIndex) override;

  /**
   * @copydoc NetworkComponent::evalStaticFType()
   */
  void evalStaticFType() override;

  /**
   * @copydoc NetworkComponent::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;

  /**
   * @copydoc NetworkComponent::evalDynamicFType()
   */
  void evalDynamicFType() override;

  /**
   * @copydoc NetworkComponent::evalYMat()
   */
  void evalYMat() override;

  /**
   *  @copydoc NetworkComponent::evalStaticYType()
   */
  void evalStaticYType() override;

  /**
   * @copydoc NetworkComponent::evalDynamicYType()
   */
  void evalDynamicYType() override;

  /**
   * @copydoc NetworkComponent::evalG(double t)
   */
  void evalG(double t) override;

  /**
   * @copydoc NetworkComponent::setGequations(std::map<int,std::string>& gEquationIndex)
   */
  void setGequations(std::map<int, std::string>& gEquationIndex) override;

  /**
   * @copydoc NetworkComponent::evalZ(double t)
   */
  NetworkComponent::StateChange_t evalZ(double t) override;

  /**
   * @copydoc NetworkComponent::evalState(double time)
   */
  StateChange_t evalState(double time) override;

  /**
   * @copydoc NetworkComponent::evalNodeInjection()
   */
  void evalNodeInjection()  override;

  /**
   * @copydoc NetworkComponent::evalDerivatives(double cj)
   */
  void evalDerivatives(double cj) override;

  /**
   * @copydoc NetworkComponent::evalDerivativesPrim()
   */
  void evalDerivativesPrim() override { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalCalculatedVars()
   */
  void evalCalculatedVars() override;

  /**
   * @brief get the global indexes of the variables used to compute a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @param numVars vector to fill with the indexes
   *
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, std::vector<int>& numVars) const override;

  /**
   * @brief evaluate the jacobian associated to a calculated variable based on the current values of continuous variables
   *
   * @param numCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned numCalculatedVar, std::vector<double>& res) const override;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @return value of the calculated variable based on the current values of continuous variables
   */
  double evalCalculatedVarI(unsigned numCalculatedVar) const override;

  /**
   * @copydoc NetworkComponent::instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables) override;

  /**
   * @copydoc NetworkComponent::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params)
   */
  void setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) override;

  /**
   * @copydoc NetworkComponent::defineNonGenericParameters(std::vector<ParameterModeler>& parameters)
   */
  void defineNonGenericParameters(std::vector<ParameterModeler>& parameters) override;

  /**
   * @copydoc NetworkComponent::defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement)
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) override;

  /**
   * @copydoc NetworkComponent::addBusNeighbors()
   */
  void addBusNeighbors() override;

  /**
   * @copydoc NetworkComponent::setReferenceY( double* y, double* yp, double* f, int offsetY, int offsetF)
   */
  void setReferenceY(double* y, double* yp, double* f, int offsetY, int offsetF) override;

  /**
   * @copydoc NetworkComponent::setReferenceZ(double* z, bool* zConnected, int offsetZ )
   */
  void setReferenceZ(double* z, bool* zConnected, int offsetZ) override;

  /**
   * @copydoc NetworkComponent::setReferenceCalculatedVar(double* calculatedVars, int offsetCalculatedVars )
   */
  void setReferenceCalculatedVar(double* calculatedVars, int offsetCalculatedVars) override;

  /**
   * @copydoc NetworkComponent::setReferenceG(state_g* g, int offsetG )
   */
  void setReferenceG(state_g* g, int offsetG) override;

  /**
   * @brief export the variables values of the sub model for dump
   *
   * @param streamVariables : map associating the file where values should be dumped with the stream of values
   */
  void dumpVariables(boost::archive::binary_oarchive& streamVariables) const override;

  /**
   * @brief load the variables values from a previous dump
   *
   * @param streamVariables stream of values where the variables were dumped
   * @param variablesFileName file name
   * @return success
   */
  bool loadVariables(boost::archive::binary_iarchive& streamVariables, const std::string& variablesFileName) override;

  /**
   * @brief append the internal variables values to a stringstream
   *
   * @param streamVariables : map associating the file where values should be dumped with the stream of values
   */
  void dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const override;

  /**
   * @brief import the internal variables values of the component from stringstream
   *
   * @param streamVariables : stream with binary formated internalVariables
   */
  void loadInternalVariables(boost::archive::binary_iarchive& streamVariables) override;

 private:
  /**
   * @brief build graph used by the voltage level to deal with topology change
   */
  void defineGraph();

  boost::optional<Graph> graph_;  ///< topology graph to find node connection
  std::unordered_map<std::string, float> weights1_;  ///< weight of 1 for each edge in the graph
  std::unordered_map<unsigned, std::pair<unsigned, std::vector<std::string> > > closestBBS_;  ///< node id -> closest bbs + shortest path
  VoltageLevelInterface::VoltageLevelTopologyKind_t topologyKind_;  ///< voltage level topology (bus breaker or node breaker)
  std::vector<std::shared_ptr<NetworkComponent> > components_;  ///< all components in a voltage level
  std::vector<std::shared_ptr<NetworkComponent> > componentsEvalG_;  ///< all components in a voltage level
  std::map<int, std::shared_ptr<ModelBus> > busesByIndex_;  ///< map of voltage level buses with their index
  std::vector<std::shared_ptr<ModelBus> > busesWithBBS_;  ///< vector of buses that contain a bus bar section
  std::vector<std::shared_ptr<ModelSwitch> > switches_;  ///< all switch components in a voltage level
  std::map<std::string, std::shared_ptr<ModelSwitch> > switchesById_;  ///< map of voltage level switches with their id
  std::vector<int> componentIndexByCalculatedVar_;  ///< index of component for each calculated var
};

}  // namespace DYN
#endif  // MODELS_CPP_MODELNETWORK_DYNMODELVOLTAGELEVEL_H_
