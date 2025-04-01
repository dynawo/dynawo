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
  explicit ModelVoltageLevel(const boost::shared_ptr<VoltageLevelInterface>& voltageLevel);

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
  inline const std::vector<boost::shared_ptr<NetworkComponent> >& getComponents() const {
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
  void addComponent(const boost::shared_ptr<NetworkComponent>& component);

  /**
   * @brief add a new bus component instance to the voltage level model
   * @param bus component instance to add
   */
  void addBus(const boost::shared_ptr<ModelBus>& bus);

  /**
   * @brief add a new switch component instance to the voltage level model
   * @param sw component instance to add
   */
  void addSwitch(const boost::shared_ptr<ModelSwitch>& sw);

  /**
   * @brief compute switches loops
   */
  void computeLoops();

  /**
   * @brief find the shortest path between a node and a bus bar section node, then close all switches between them (if they are breaker)
   * @param node node to connect to a bus bar section
   */
  void connectNode(const unsigned int node);

  /**
   * @brief return true if this node can be disconnected
   * @param node node to test
   * @return true if this node can be disconnected
   */
  bool canBeDisconnected(const unsigned int node);


  /**
   * @brief find all paths between a node and all bus bar section node, then open the first switches found (if it's a breaker)
   * @param node node to disconnect
   */
  void disconnectNode(const unsigned int node);

  /**
   * @brief find the closest bus bar section of a bus in a voltage level
   * @param node the index of the bus for which to look for the closest bus bar section
   * @param shortestPath list of switch names that separate the bus bar section from the initial bus
   * @return the closest bus bar section index
   */
  unsigned int findClosestBBS(const unsigned int node, std::vector<std::string>& shortestPath);

  /**
   * @brief return true if the closest bus bar section is switched off or unreachable
   * @param bus the bus from which to look for the closest bus bar section
   * @return true is the closest bus bar section is switched off or unreachable, false otherwise
   */
  bool isClosestBBSSwitchedOff(const boost::shared_ptr<ModelBus>& bus);
  /**
   * @brief set the initial currents of each switch
   */
  void setInitialSwitchCurrents();

  /**
   * @brief evaluation F
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(propertyF_t type);

  /**
   * @brief evaluate jacobian \f$( J = @F/@x + cj * @F/@x')\f$
   * @param jt sparse matrix to fill
   * @param cj jacobian prime coefficient
   * @param rowOffset row offset to use to find the first row to fill
   */
  void evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset);

  /**
   * @brief evaluate jacobian \f$( J =  @F/@x')\f$
   * @param jt sparse matrix to fill
   * @param rowOffset row offset to use to find the first row to fill
   */
  void evalJtPrim(SparseMatrix& jt, const int& rowOffset);

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
  void initSize();

  /**
   * @copydoc NetworkComponent::init(int& yNum )
   */
  void init(int& yNum);

  /**
   * @copydoc NetworkComponent::getY0()
   */
  void getY0();

  /**
   * @copydoc NetworkComponent::setFequations(std::map<int,std::string>& fEquationIndex)
   */
  void setFequations(std::map<int, std::string>& fEquationIndex);

  /**
   * @copydoc NetworkComponent::evalStaticFType()
   */
  void evalStaticFType();

  /**
   * @copydoc NetworkComponent::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable);

  /**
   * @copydoc NetworkComponent::evalDynamicFType()
   */
  void evalDynamicFType();

  /**
   * @copydoc NetworkComponent::evalYMat()
   */
  void evalYMat();

  /**
   *  @copydoc NetworkComponent::evalStaticYType()
   */
  void evalStaticYType();

  /**
   * @copydoc NetworkComponent::evalDynamicYType()
   */
  void evalDynamicYType();

  /**
   * @copydoc NetworkComponent::evalG(const double& t)
   */
  void evalG(const double& t);

  /**
   * @copydoc NetworkComponent::setGequations(std::map<int,std::string>& gEquationIndex)
   */
  void setGequations(std::map<int, std::string>& gEquationIndex);

  /**
   * @copydoc NetworkComponent::evalZ(const double& t)
   */
  NetworkComponent::StateChange_t evalZ(const double& t);

  /**
   * @copydoc NetworkComponent::evalState(const double& time)
   */
  StateChange_t evalState(const double& time);

  /**
   * @copydoc NetworkComponent::evalNodeInjection()
   */
  void evalNodeInjection();

  /**
   * @copydoc NetworkComponent::evalDerivatives(const double cj)
   */
  void evalDerivatives(const double cj);

  /**
   * @copydoc NetworkComponent::evalDerivativesPrim()
   */
  void evalDerivativesPrim() { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalCalculatedVars()
   */
  void evalCalculatedVars();

  /**
   * @brief get the global indexes of the variables used to compute a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @param numVars vector to fill with the indexes
   *
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, std::vector<int>& numVars) const;

  /**
   * @brief evaluate the jacobian associated to a calculated variable based on the current values of continuous variables
   *
   * @param numCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned numCalculatedVar, std::vector<double>& res) const;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @return value of the calculated variable based on the current values of continuous variables
   */
  double evalCalculatedVarI(unsigned numCalculatedVar) const;

  /**
   * @copydoc NetworkComponent::instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @copydoc NetworkComponent::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params)
   */
  void setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params);

  /**
   * @copydoc NetworkComponent::defineNonGenericParameters(std::vector<ParameterModeler>& parameters)
   */
  void defineNonGenericParameters(std::vector<ParameterModeler>& parameters);

  /**
   * @copydoc NetworkComponent::defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement)
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement);

  /**
   * @copydoc NetworkComponent::addBusNeighbors()
   */
  void addBusNeighbors();

  /**
   * @copydoc NetworkComponent::setReferenceY( double* y, double* yp, double* f, const int & offsetY, const int & offsetF)
   */
  void setReferenceY(double* y, double* yp, double* f, const int& offsetY, const int& offsetF);

  /**
   * @copydoc NetworkComponent::setReferenceZ( double* z, bool* zConnected, const int & offsetZ )
   */
  void setReferenceZ(double* z, bool* zConnected, const int& offsetZ);

  /**
   * @copydoc NetworkComponent::setReferenceCalculatedVar( double* calculatedVars, const int & offsetCalculatedVars )
   */
  void setReferenceCalculatedVar(double* calculatedVars, const int& offsetCalculatedVars);

  /**
   * @copydoc NetworkComponent::setReferenceG( state_g* g, const int & offsetG )
   */
  void setReferenceG(state_g* g, const int& offsetG);

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


 private:
  /**
   * @brief build graph used by the voltage level to deal with topology change
   */
  void defineGraph();

  boost::optional<Graph> graph_;  ///< topology graph to find node connection
  std::unordered_map<std::string, float> weights1_;  ///< weight of 1 for each edge in the graph
  std::unordered_map<unsigned, std::pair<unsigned, std::vector<std::string> > > ClosestBBS_;  ///< node id -> closest bbs + shortest path
  VoltageLevelInterface::VoltageLevelTopologyKind_t topologyKind_;  ///< voltage level topology (bus breaker or node breaker)
  std::vector<boost::shared_ptr<NetworkComponent> > components_;  ///< all components in a voltage level
  std::map<int, boost::shared_ptr<ModelBus> > busesByIndex_;  ///< map of voltage level buses with their index
  std::vector<boost::shared_ptr<ModelBus> > busesWithBBS_;  ///< vector of buses that contain a bus bar section
  std::vector<boost::shared_ptr<ModelSwitch> > switches_;  ///< all switch components in a voltage level
  std::map<std::string, boost::shared_ptr<ModelSwitch> > switchesById_;  ///< map of voltage level switches with their id
  std::vector<int> componentIndexByCalculatedVar_;  ///< index of component for each calculated var
};

}  // namespace DYN
#endif  // MODELS_CPP_MODELNETWORK_DYNMODELVOLTAGELEVEL_H_
