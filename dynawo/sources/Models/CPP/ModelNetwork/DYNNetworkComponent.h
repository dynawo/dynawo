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
 * @file  DYNNetworkComponent.h
 *
 * @brief
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENT_H_
#define MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENT_H_
#include <vector>
#include <map>
#include <string>
#include <boost/unordered_map.hpp>

#include <boost/shared_ptr.hpp>
#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>

#include "DYNEnumUtils.h"
#include "DYNBitMask.h"
#include "DYNModelConstants.h"
#include "DYNParameterModeler.h"

namespace parameters {
class ParametersSet;
}

namespace DYN {
class Element;
class SparseMatrix;
class Variable;
class ModelNetwork;

/**
 * @brief class network component
 *
 *
 */
class NetworkComponent {  ///< Base class for network component models
 public:
  /**
   * @brief state change type
   */
  typedef enum {
    NO_CHANGE = 0,
    STATE_CHANGE = 1,
    TOPO_CHANGE = 2
  } StateChange_t;

  /**
   * @brief starting point type
   */
  typedef enum {
    FLAT = 0,
    WARM = 1
  } startingPointMode_t;

 public:
  /**
   * @brief destructor
   */
  virtual ~NetworkComponent();

  /**
   * @brief constructor
   */
  NetworkComponent();

  /**
   * @brief constructor
   * @param id id of the component
   */
  explicit NetworkComponent(const std::string& id);

  /**
   * @brief add bus neighbors
   */
  virtual void addBusNeighbors() = 0;

  /**
   * @brief define variables
   * @param variables vector of variables
   */
  virtual void instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables) = 0;

  /**
   * @brief define non generic parameters
   * @param parameters vector to fill with the non generic parameters
   */
  virtual void defineNonGenericParameters(std::vector<ParameterModeler>& parameters) = 0;

  /**
   * @brief define elements
   * @param elements vector of elements
   * @param mapElement map of elements
   */
  virtual void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) = 0;

  /**
   * @brief evaluate node injection
   */
  virtual void evalNodeInjection() = 0;

  /**
   * @brief evaluate derivatives
   * @param cj Jacobian prime coefficient
   */
  virtual void evalDerivatives(const double cj) = 0;

  /**
   * @brief evaluate derivatives
   */
  virtual void evalDerivativesPrim() = 0;

  /**
   * @brief evaluate F
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  virtual void evalF(propertyF_t type) = 0;

  /**
   * @brief evaluate jacobian \f$( J = @F/@x + cj * @F/@x')\f$
   * @param jt sparse matrix to fill
   * @param cj jacobian prime coefficient
   * @param rowOffset row offset to use to find the first row to fill
   */
  virtual void evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset) = 0;

  /**
   * @brief evaluate jacobian \f$( J =  @F/@x')\f$
   * @param jt sparse matrix to fill
   * @param rowOffset row offset to use to find the first row to fill
   */
  virtual void evalJtPrim(SparseMatrix& jt, const int& rowOffset) = 0;

  /**
   * @brief evaluation G
   * @param t time
   */
  virtual void evalG(const double& t) = 0;

  /**
   * @brief evaluation Z
   * @param t time
   * @return the potential state change type
   */
  virtual NetworkComponent::StateChange_t evalZ(const double& t) = 0;

  /**
   * @brief evaluation calculated variables (for outputs)
   */
  virtual void evalCalculatedVars() = 0;

  /**
   * @brief get the index of variables used to define the jacobian associated to a calculated variable
   * @param numCalculatedVar index of the calculated variable
   * @param numVars index of variables used to define the jacobian
   */
  virtual void getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, std::vector<int>& numVars) const = 0;

  /**
   * @brief evaluate the jacobian associated to a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  virtual void evalJCalculatedVarI(unsigned numCalculatedVar, std::vector<double>& res) const = 0;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   *
   * @return value of the calculated variable
   */
  virtual double evalCalculatedVarI(unsigned numCalculatedVar) const = 0;

  /**
   * @brief evaluate the continuous variable property
   */
  virtual void evalStaticYType() = 0;

  /**
   * @brief update during the simulation the continuous variable property
   */
  virtual void evalDynamicYType() = 0;

  /**
   * @brief set the local buffer for continuous variables properties
   *
   * @param yType global buffer for variable properties
   * @param offset offset to know the beginning position for the component's variable properties
   */
  void setBufferYType(propertyContinuousVar_t* yType, const unsigned int& offset);

  /**
   * @brief evaluate the residual function property
   */
  virtual void evalStaticFType() = 0;

  /**
   * @brief update during the simulation the residual function property
   */
  virtual void evalDynamicFType() = 0;

  /**
   * @brief set the silent flag for discrete variables
   * @param silentZTable flag table
   */
  virtual void collectSilentZ(BitMask* silentZTable) = 0;

  /**
   * @brief set the local buffer for residual function properties
   *
   * @param fType global buffer for residual function properties
   * @param offset offset to know the beginning position for the component's residual function properties
   */
  void setBufferFType(propertyF_t* fType, const unsigned int& offset);

  /**
   * @brief evalYMat
   */
  virtual void evalYMat() = 0;

  /**
   * @brief init
   * @param yNum yNum
   */
  virtual void init(int& yNum) = 0;

  /**
   * @brief set the local buffer for continuous variables and their derivatives
   *
   * @param y global buffer for the continuous variables
   * @param yp global buffer for the derivatives of the continuous variables
   * @param f global buffer for the residual values
   * @param offsetY offset to use to find the beginning of the local buffer
   * @param offsetF offset to use to find the beginning of the local buffer for residual functions
   */
  virtual void setReferenceY(double* y, double* yp, double* f, const int & offsetY, const int& offsetF);

  /**
   * @brief set the local buffer for discrete variables
   *
   * @param z global buffer for the discrete variables
   * @param zConnected global buffer for the discrete variables connection status
   * @param offsetZ offset to use to find the beginning of the local buffer
   */
  virtual void setReferenceZ(double* z, bool* zConnected, const int& offsetZ);

  /**
   * @brief set the local buffer for calculated variables
   *
   * @param calculatedVars global buffer for the calculated variables
   * @param offsetCalculatedVars offset to use to find the beginning of the local buffer
   */
  virtual void setReferenceCalculatedVar(double* calculatedVars, const int& offsetCalculatedVars);

  /**
   * @brief set the local buffer for root values
   *
   * @param g global buffer for the root values
   * @param offsetG offset to use to find the beginning of the local buffer
   */
  virtual void setReferenceG(state_g *g, const int& offsetG);

  /**
   * @brief get the initial values for discrete/continuous variables
   */
  virtual void getY0() = 0;

  /**
   * @brief network submodels parameters setter
   * @param params vector of parameters used to set network submodels parameters
   */
  virtual void setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& params) = 0;

  /**
   * @brief get a parameter with a given name from a vector of parameters
   * @param name name of the desired parameter
   * @param params vector of parameters
   * @return parameter with the given name
   */
  ParameterModeler findParameter(const std::string& name, const boost::unordered_map<std::string, ParameterModeler>& params) const;

  /**
   * @brief true if a parameter with a given name is present in a vector of parameters
   * @param name name of the desired parameter
   * @param params vector of parameters
   * @return true if the parameter with the given name has been found, false otherwise
   */
  bool hasParameter(const std::string& name, const boost::unordered_map<std::string, ParameterModeler>& params) const;

  /**
   * @brief set equation's formula
   * @param fEquationIndex equation's formula map
   */
  virtual void setFequations(std::map<int, std::string>& fEquationIndex) = 0;

  /**
   * @brief set root equation's formula
   * @param gEquationIndex equation's formula map
   */
  virtual void setGequations(std::map<int, std::string>& gEquationIndex) = 0;

  /**
   * @brief evaluate state
   * @param time time
   * @return state change type
   */
  virtual StateChange_t evalState(const double& time) = 0;

  /**
   * @brief set network
   * @param model model
   */
  void setNetwork(ModelNetwork* model);

  /**
   * @brief get size f
   * @return size f
   */
  inline int sizeF() const {
    return sizeF_;
  }

  /**
   * @brief get size y
   * @return size y
   */
  inline int sizeY() const {
    return sizeY_;
  }

  /**
   * @brief get size z
   * @return size z
   */
  inline int sizeZ() const {
    return sizeZ_;
  }

  /**
   * @brief get size g
   * @return size g
   */
  inline int sizeG() const {
    return sizeG_;
  }

  /**
   * @brief get size mode
   * @return size mode
   */
  inline int sizeMode() const {
    return sizeMode_;
  }

  /**
   * @brief get size calculated variables
   * @return size calculated variables
   */
  inline int sizeCalculatedVar() const {
    return sizeCalculatedVar_;
  }

   /**
   * @brief get offset to find the beginning of calculated var of the model in the global vector
   * @return offset to find the beginning of calculated var of the model in the global vector
   */
  inline unsigned int getOffsetCalculatedVar() const {
    return offsetCalculatedVar_;
  }

  /**
   * @brief set the offset to find the beginning of calculated var of the model in the global vector
   * @param offset to find the beginning of calculated var of the model in the global vector
   */
  inline void setOffsetCalculatedVar(unsigned int offset) {
    offsetCalculatedVar_ = offset;
  }

  /**
   * @brief init size
   */
  virtual void initSize() = 0;

  /**
   * @brief id
   * @return id
   */
  inline std::string id() const {
    return id_;
  }

  /**
   * @brief Get the Starting Point Mode
   *
   * @param startingPointMode parameter string
   * @return the Starting Point Mode
   */
  static startingPointMode_t getStartingPointMode(const std::string& startingPointMode);

  /**
  * @brief write initial values internal parameters of a model in a file
  *
  * @param fstream the file to stream parameters to
  */
  virtual void printInternalParameters(std::ofstream& fstream) const;

  /**
   * @brief get the number of internal variable of the model
   *
   * @return the number of internal variable of the model
   */
  virtual unsigned getNbInternalVariables() const;

  /**
   * @brief append the internal variables values to a stringstream
   *
   * @param streamVariables : stringstream with binary formated internalVariables
   */
  virtual void dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const;

  /**
   * @brief import the internal variables values of the component from stringstream
   *
   * @param streamVariables : stringstream with binary formated internalVariables
   */
  virtual void loadInternalVariables(boost::archive::binary_iarchive& streamVariables);

  /**
   * @brief export the variables values of the sub model for dump
   *
   * @param streamVariables : map associating the file where values should be dumped with the stream of values
   */
  virtual void dumpVariables(boost::archive::binary_oarchive& streamVariables) const;

  /**
   * @brief load the variables values from a previous dump
   *
   * @param streamVariables : stream of values where the variables were dumped
   * @param variablesFileName source of the data
   * @return success
   */
  virtual bool loadVariables(boost::archive::binary_iarchive& streamVariables, const std::string& variablesFileName);

  /**
   * @brief id getter
   *
   * @return the id of this component
   */
  inline const std::string& getId() const { return id_;}

 protected:
  /**
   * @brief get the value of a given parameter.  Will throw a ParameterNotReadInPARFile exception if not found.
   * @param params parameters of the model
   * @param id id of the parameter to find
   * @param ids id of the parameters
   * @return value of the parameter
   */
  template <typename T> T getParameterDynamic(const boost::unordered_map<std::string, ParameterModeler>& params,
      const std::string& id, const std::vector<std::string>& ids) const;

  /**
   * @brief get the value of a given parameter
   * @param params parameters of the model
   * @param id id of the parameter to find
   * @param foundParam boolean to indicate if the parameter was found
   * @param ids prefix of the parameters
   * @return value of the parameter if foundParam==true, a default value if foundParam==false
   */
  template <typename T> T getParameterDynamicNoThrow(const boost::unordered_map<std::string, ParameterModeler>& params,
      const std::string& id, bool& foundParam, const std::vector<std::string>& ids = std::vector<std::string>()) const;

  /**
   * @brief add an element along a value subelement
   * @param elementName element to add
   * @param parentType type of the parent model
   * @param elements vector of elements to fill with new elements defined
   * @param mapElement map of elements to fill with new elements
   */
  void addElementWithValue(const std::string& elementName, const std::string& parentType,
      std::vector<Element>& elements, std::map<std::string, int>& mapElement);

 private:
  /**
   * @brief get the value of a given parameter
   * @param params parameters of the model
   * @param id id of the parameter to find
   * @param foundParam boolean to indicate if the parameter was found
   * @param ids prefix of the parameters
   * @param value value of the parameter
   */
  template <typename T> void findParameterDynamicNoThrow(const boost::unordered_map<std::string, ParameterModeler>& params,
      const std::string& id, bool& foundParam, const std::vector<std::string>& ids, T& value) const;

  /**
   * @brief copy constructor
   * @param other NetworkComponent to copy
   */
  explicit NetworkComponent(const NetworkComponent& other) = delete;
  /**
   * @brief assignment
   * @param other NetworkComponent to copy
   * @return current modified instance
   */
  NetworkComponent& operator=(const NetworkComponent& other) = delete;

 protected:
  double* y_;  ///< continuous variable
  double* yp_;  ///< derivative of y
  double* f_;  ///< residual functions
  double* z_;  ///< discrete variable
  bool* zConnected_;  ///< discrete variable connection status
  double* calculatedVars_;  ///< calculated variables
  state_g* g_;  ///< state

  propertyF_t* fType_;  ///< property of each residual function (algebraic / differential)
  propertyContinuousVar_t* yType_;  ///< property of each variable (algebraic / differential / external)

  int sizeF_;  ///< size of F
  int sizeY_;  ///< size of Y
  int sizeZ_;  ///< size of Z
  int sizeG_;  ///< size of G
  int sizeMode_;  ///< size of Mode
  int sizeCalculatedVar_;  ///< size of calculated variables
  unsigned int offsetCalculatedVar_;  ///< offset to find the begin of calculated var of the model in the global vector
  std::string id_;  ///< id of the component
  ModelNetwork* network_;  ///< model network
};
}  // namespace DYN

#include "DYNNetworkComponent.hpp"

#endif  // MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENT_H_
