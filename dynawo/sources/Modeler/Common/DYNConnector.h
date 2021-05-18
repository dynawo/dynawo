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
 * @file  DYNConnector.h
 *
 * @brief Connector header : defines a connector between two/sereval sub models (same way to works as a modelica connector)
 *
 */
#ifndef MODELER_COMMON_DYNCONNECTOR_H_
#define MODELER_COMMON_DYNCONNECTOR_H_

#include <boost/unordered_map.hpp>
#include <boost/unordered_set.hpp>
#include <vector>
#include <list>
#include <boost/shared_ptr.hpp>
#include <boost/functional/hash.hpp>
#include "DYNEnumUtils.h"
#include "DYNVariable.h"

namespace DYN {
class connectedSubModel;
}  // namespace DYN

namespace boost {

/**
 * @brief Specialization of hash for connectedSubModel in order to use boost::unordered_map
 */
template<>
struct hash<DYN::connectedSubModel> {
  /**
   * @brief action operator
   *
   * relies on hash values of shared pointers
   *
   * @param model the model to hash
   * @returns hash value
   */
  std::size_t operator()(const ::DYN::connectedSubModel& model) const;
};
}  // namespace boost

namespace DYN {
class SparseMatrix;
class SubModel;

/**
 * class connectedSubModel : define a sub model used in a connector
 */
class connectedSubModel {
 public:
  /**
   * @brief default constructor
   */
  connectedSubModel() :
  negated_(false) { }

  /**
   * @brief constructor
   *
   * @param subModel submodel connected
   * @param variable the variable to use in the connector
   * @param negated @b true if the opposite of the variable should be used in the connector's equations
   */
  connectedSubModel(const boost::shared_ptr<SubModel> & subModel, const boost::shared_ptr<Variable> variable, bool negated) :
  subModel_(subModel),
  variable_(variable),
  negated_(negated) { }

  /**
   * @brief getter of the submodel connected by the connector
   * @return the submodel connected by the connector
   */
  inline boost::shared_ptr<SubModel> subModel() const {
    return subModel_;
  }

  /**
   * @brief the variable connected by the connectord inside the sub model
   * @return the variable
   */
  inline boost::shared_ptr<Variable> variable() const {
    return variable_;
  }

  /**
   * @brief getter of the negated attribute
   * @return @b true if the opposite of the variable should be used in the connector's equations
   */
  inline bool negated() const {
    return negated_;
  }

  /**
   * @brief Equality operator
   *
   * @param other connected sub model to compare to
   * @returns @b true if the two models are considered equal, @b false if not
   */
  bool operator==(const connectedSubModel& other) const {
    return (subModel_ == other.subModel_) && (variable_ == other.variable_);
  }

  /**
   * @brief Different operator
   *
   * @param other connected sub model to compare to
   * @returns @b true if the two models are considered different, @b false if not
   */
  bool operator!=(const connectedSubModel& other) const {
    return !((*this) == other);
  }

  friend class ::boost::hash<connectedSubModel>;

 public:
  boost::shared_ptr<SubModel> subModel_;  ///< submodel connected by the connector
  boost::shared_ptr<Variable> variable_;  ///< the variable
  bool negated_;  ///< @b true if the opposite of the variable should be used in the connector's equations
};

/**
 * class Connector : defines a connection between two/severables submodels
 * works the same way as the modelica connector
 */
class Connector {
 public:
  /**
   * @brief getter of the submodels connected by the connector
   * @return submodels connected by the connector
   */
  inline std::vector<connectedSubModel>& connectedSubModels() {
    return connectedSubModels_;
  }

  /**
   * @brief add a submodel to the list of the submodel connected by the connector
   * @param subModel subModel connected by the connector
   */
  void addConnectedSubModel(const connectedSubModel& subModel);

  /**
   * @brief add a submodel to the list of the submodel connected by the connector
   * @param subModel subModel to add
   * @param variable the variable inside the subModel to use in the connector's equations
   * @param negated @b true if the opposite of the variable should be used
   */
  void addConnectedSubModel(const boost::shared_ptr<SubModel>& subModel, const boost::shared_ptr<Variable>& variable, bool negated);

  /**
   * @brief getter of the number of subModel connected by the connector
   * @return  number of subModel connected by the connector
   */
  int nbConnectedSubModels() const;

 private:
  std::vector<connectedSubModel> connectedSubModels_;  ///< submodels connected by this connector
};

/**
 * class ConnectorContainer : defines the container of all connectors
 * this class defines the interface between modelMulti and all connectors
 */
class ConnectorContainer {
 public:
  /**
   * @brief default constructor
   *
   */
  ConnectorContainer();

  /**
   * @brief destructor
   *
   */
  ~ConnectorContainer();

  /**
   * @brief get the number of continuous connectors
   * @return number of continuous connectors
   */
  inline unsigned int nbContinuousConnectors() const {
    return (nbFlowConnectors() + nbYConnectors());
  }

  /**
   * @brief get the number of flow connectors
   * @return number of flow connectors
   */
  inline unsigned int nbFlowConnectors() const {
    return flowConnectors_.size();
  }

  /**
   * @brief get the number of discrete (Z) connectors
   * @return number of discrete connectors
   */
  inline unsigned int nbZConnectors() const {
    return zConnectors_.size();
  }

  /**
   * @brief get the number of Y connectors
   *
   * @return number of Y connectors
   */
  unsigned int nbYConnectors() const;

  /**
   * @brief propagates the change of a zValue to all the variables connected to it
   *
   * @param indicesDiff index of each z variables which has changed
   * @param z vector of discrete values
   */
  void propagateZDiff(const std::vector<int>& indicesDiff, double* z);

  /**
   * @brief add a flow connector to the container
   *
   * @param connector flow connector to add
   */
  void addFlowConnector(boost::shared_ptr<Connector> & connector);

  /**
   * @brief add a continuous connector to the container
   *
   * @param connector continuous connector to add
   */
  void addContinuousConnector(boost::shared_ptr<Connector>& connector);

  /**
   * @brief add a discrete connector to the container
   *
   * @param connector discrete connector to add
   */
  void addDiscreteConnector(boost::shared_ptr<Connector>& connector);

  /**
   * @brief print informations about the connector stored in the container
   *
   */
  void printConnectors() const;

  /**
   * @brief print informations about the equations stored in the container
   *
   */
  void printEquations() const;

  /**
   * @brief get connector's information according to it global index in F matrix
   * @param globalFIndex connector's index in F matrix
   * @param subModelName type of the connector (Y, flow, or Z connector)
   * @param localFIndex local index of connector
   * @param fEquation connector's submodels
   */
  void getConnectorInfos(const int& globalFIndex, std::string& subModelName, int& localFIndex, std::string& fEquation) const;

  /**
   * @brief evaluate the residual values of each connectors
   *
   * @param t time to used during the evaluation
   */
  void evalFConnector(const double t);

  /**
   * @brief evaluate the jacobian of each connectors
   *
   * @param jt sparse matrix where the jacobian should be stored
   */
  void evalJtConnector(SparseMatrix& jt);

  /**
   * @brief evaluate the derivative jacobian of each connectors \f$( J = @F/@x' ) \f$
   *
   * @param jt sparse matrix where the jacobian should be stored
   */
  void evalJtPrimConnector(SparseMatrix& jt);

  /**
   * @brief evaluate the initial value of each variables connected to another one
   */
  void getY0Connector();

  /**
   * @brief merge the connectors after each one have been created
   *
   */
  void mergeConnectors();

  /**
   * @brief merge the connectors : no need to declare two connectors when they represent the same connection
   *
   * @param connector the connector to merge
   * @param reference the reference connector (to which to add the connector)
   * @param connectorsList the list of connectors
   * @param connectorsByVarNum the association between (global) variable index and connector
   * @param flowConnector true if the connector is a flow connector
   */
  void mergeConnectors(boost::shared_ptr<Connector> connector, boost::shared_ptr<Connector> reference,
                       std::list<boost::shared_ptr<Connector> > &connectorsList,
                       boost::unordered_map<int, boost::shared_ptr<Connector> >& connectorsByVarNum, bool flowConnector = false);


  /**
   * @brief evaluate the property of each residual functions for each connectors
   *
   */
  void evalStaticFType() const;

  /**
   * @brief defines the local buffer to fill when evaluating the type of each residual function
   *
   * @param fType global buffer
   * @param offsetFType offset to use to find the beginning of the local buffer
   */
  void setBufferFType(propertyF_t* fType, const int& offsetFType);

  /**
   * @brief defines the local buffer to fill when calculating residual function
   *
   * @param f global buffer
   * @param offsetF offset to use to find the beginning of the local buffer
   */
  void setBufferF(double* f, const int& offsetF);

  /**
   * @brief defines the local buffer to define continuous variables
   *
   * @param y local buffer
   * @param yp local buffer
   */
  void setBufferY(double* y, double* yp);

  /**
   * @brief defines the local buffer to define discrete variables and their connection status
   * @param z local buffer
   * @param zConnected local buffer of connection status
   */
  void setBufferZ(double* z, bool* zConnected);

  /**
   * @brief defines the offset to use when filling the f buffer
   *
   * @param offset offset to use
   */
  inline void setOffsetModel(int offset) {
    offsetModel_ = offset;
  }

  /**
   * @brief get the offset to use when filling the f buffer
   * @return the offset to use
   */
  inline int getOffsetModel() const {
    return offsetModel_;
  }

  /**
   * @brief defines the size of the Y buffer
   *
   * @param sizeY size of the Y buffer
   */
  inline void setSizeY(int sizeY) {
    sizeY_ = sizeY;
  }

  /**
   * @brief get the size of the Y buffer
   *
   *
   * @return size of the Y buffer
   */
  inline int getSizeY() const {
    return sizeY_;
  }

  /**
   * @brief check if a continuous variable is connected to another one
   *
   * @param numVariable index of the variable to check
   *
   * @return @b true if the variable is connected, @b false otherwise
   * WARNING : do not check whether discrete variables are not connected (in this case, they are just set to 0)
   */
  bool isConnected(const int numVariable);

  /**
   * @brief Perform external connections
   *
   * For each connection registered, connect models buffers corresponding to the external variables and its reference buffer
   * corresponding to a state variable, for y and yp
   *
   * Clear the external connections at the end
   */
  void performExternalConnections();

  /**
   * @brief Retrieve list of external connections by id
   *
   * @returns reference to the list of connections by external id
   */
  const boost::unordered_map<int, int>& externalConnectionsByVarNum() const {
    return externalConnectionsByVarNum_;
  }

  /**
   * @brief Add external variable connection
   *
   * @param fictiveVariableConnectedModel connected model corresponding to a fictive variable
   * @param externalVariableModel the external variable model corresponding to the fictive variable
   */
  void addExternalConnection(const connectedSubModel& fictiveVariableConnectedModel, const DYN::connectedSubModel& externalVariableModel) {
    // key will be created if necessary
    externalConnections_[fictiveVariableConnectedModel].insert(externalVariableModel);
  }

  /**
   * @brief Retrieve the list of full external variables connectors
   *
   * @returns the list
   */
  const std::vector<boost::shared_ptr<Connector> >& getYConnectorsFullExternal() const {
    return yConnectorsFullExternal_;
  }

   /**
   * @brief Retrieve the list of full external variables connectors for update
   *
   * @returns the list
   */
  std::vector<boost::shared_ptr<Connector> >& getYConnectorsFullExternal() {
    return yConnectorsFullExternal_;
  }

  /**
   * @brief Add a Y connector
   *
   * @param connector connector to add
   */
  void addYConnector(const boost::shared_ptr<Connector>& connector) {
    yConnectors_.push_back(connector);
  }

 private:
  /**
   * @brief Predicate functor to determine if a model do not handle an external variable
   */
  struct IsNonExternalPredicate {
    /**
     * @brief action operator
     *
     * @param cmodel the model to check
     * @return predicate status
     */
    bool operator()(const connectedSubModel& cmodel) const;
  };

 private:
  /**
   * @brief Computes the unique id for connected model
   *
   * In case the handled variable is an external continous variable, computes an unique id based on the names of the models and variable.
   *
   * In case the handled variable is a problem variable, return the global variable index
   *
   * @param cmodel the connected model
   * @returns an unique id
   */
  static int getYConnectorNumVar(const connectedSubModel& cmodel);

 private:
  /**
   * @brief get Y connector's information according to its index
   * @param index connector's index
   *
   * @return information describing the Y connector (which models are connected)
   */
  std::string getYConnectorInfos(const int index) const;

  /**
   * @brief get Flow connector's information according to its index
   * @param index connector's index
   *
   * @return information describing the Flow connector (which models are connected)
   */
  inline std::string getFlowConnectorInfos(const int index) const {
    return getConnectorInfos("Flow connector : ", flowConnectors_.at(index));
  }

  /**
   * @brief get Z connector's information according to its index
   * @param index connector's index
   *
   * @return information describing the Z connector (which models are connected)
   */
  inline std::string getZConnectorInfos(const int index) const {
    return getConnectorInfos("Z connector : ", zConnectors_.at(index));
  }

  /**
   * @brief compute the sum (using factor) of variables
   * @param index index of variables to sum
   * @param factor factor to use for each variables
   * @return result of the operation
   */
  double multiplyAndAdd(const std::vector<unsigned int>& index, const std::vector<int>& factor);

  /**
   * @brief get connector's information
   * @param prefix the message prefix
   * @param connector Connector object
   *
   * @return information describing the connector (which models are connected)
   */
  std::string getConnectorInfos(const std::string& prefix, const boost::shared_ptr<Connector>& connector) const;

  /**
   * @brief merge the Y connectors after each one have been created
   */
  void mergeYConnector();

  /**
   * @brief merge the flow connectors after each one have been created
   */
  void mergeFlowConnector();

  /**
   * @brief merge the Z connectors after each one have been created
   */
  void mergeZConnector();

  /**
   * @brief print informations about the Y connector stored in the container
   */
  void printYConnectors() const;

  /**
   * @brief print informations about the flow connector stored in the container
   */
  void printFlowConnectors() const;

  /**
   * @brief print informations about the Z connector stored in the container
   */
  void printZConnectors() const;

  /**
   * @brief evaluate the initial value of each variables connected to another one for y connector
   */
  void getY0ConnectorForYConnector();

  /**
   * @brief evaluate the initial value of each variables connected to another one for z connector
   */
  void getY0ConnectorForZConnector();

  /**
   * @brief Compute the variable id to use in the flow connector structures
   * @param cmodel submodel to connect
   * @param flowConnector true if the connector is a flow connector
   * @return variable unique id
   */
  int getConnectorVarNum(const connectedSubModel& cmodel, bool flowConnector = false);

  /**
   * @brief Process the connector list to extract the full external list
   *
   * Put all connectors which connect only external variables into a dedicated member and remove them from
   * the Y connectors list
   *
   * @param yConnectorsList the list of connectors to process
   */
  void processExternalConnectors(std::list<boost::shared_ptr<Connector> >& yConnectorsList);

 private:
  std::vector<boost::shared_ptr<Connector> >yConnectorsDeclared_;  ///< continuous connectors before merge
  std::vector<boost::shared_ptr<Connector> >flowConnectorsDeclared_;  ///< flow connectors before merge
  std::vector<boost::shared_ptr<Connector> >zConnectorsDeclared_;  ///< discrete connectors before merge

  std::vector<boost::shared_ptr<Connector> >yConnectors_;  ///< continuous connectors after merge
  std::vector<boost::shared_ptr<Connector> > yConnectorsFullExternal_;  ///< y connectors connecting only external variables
  std::vector<boost::shared_ptr<Connector> >flowConnectors_;  ///< flow connectors after merge
  std::vector<boost::shared_ptr<Connector> >zConnectors_;  ///< discrete connectors after merge

  boost::unordered_map<int, boost::shared_ptr<Connector> > yConnectorByVarNum_;  ///< (global) index of the variable connected -> connector
  boost::unordered_map<int, boost::shared_ptr<Connector> > flowConnectorByVarNum_;  ///< (global) index of the variable connected -> connector
  boost::unordered_map<std::string, int> flowAliasNameToFictitiousVarNum_;  ///< Alias variable name to their fictitious index
  boost::unordered_map<int, boost::shared_ptr<Connector> > zConnectorByVarNum_;  ///< (global) index of the variable connected -> connector

  int offsetModel_;  ///< offset to use when filling the residual's vector
  int sizeY_;  ///<  size of the Y buffer
  double* fLocal_;  ///< local buffer to use when filling the residual's vector
  double* yLocal_;  ///< local buffer to use for continuous variables
  double* ypLocal_;  ///< local buffer to use for derivatives of continuous variables
  double* zLocal_;  ///< local buffer to use for discrete variables
  bool* zConnectedLocal_;  ///< local buffer to use for connection status of discrete variables
  propertyF_t* fType_;  ///< local buffer to use for properties of residual functions

  std::vector< std::vector<unsigned int> > index_;  ///< global index of variables for evalF by connector;
  std::vector< std::vector<int> > factor_;  ///< factor to use for evalF by variables by connector (should be 1 or -1)

  bool connectorsMerged_;  ///< indicates if the connectors are already merged or not

  /**
   * @brief external connections: pairs (reference_model, set of models with reference variables)
   */
  boost::unordered_map<connectedSubModel, boost::unordered_set<DYN::connectedSubModel> > externalConnections_;
  boost::unordered_map<int, int> externalConnectionsByVarNum_;  ///< external connections: pairs (index_external, referenceIndex)
};

}  // namespace DYN

#endif  // MODELER_COMMON_DYNCONNECTOR_H_
