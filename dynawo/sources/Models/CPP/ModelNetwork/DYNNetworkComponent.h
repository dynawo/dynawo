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

#include "DYNEnumUtils.h"
#include "DYNBitMask.h"
#include "DYNModelConstants.h"

namespace parameters {
class ParametersSet;
}

namespace DYN {
class Element;
class SparseMatrix;
class Variable;
class ParameterModeler;
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

 public:
  /**
   * @brief destructor
   */
  virtual ~NetworkComponent();

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
  virtual void setBufferYType(propertyContinuousVar_t* yType, const unsigned int& offset) = 0;

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
  virtual void setBufferFType(propertyF_t* fType, const unsigned int& offset) = 0;

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
  virtual void setReferenceY(double* y, double* yp, double* f, const int & offsetY, const int& offsetF) = 0;

  /**
   * @brief set the local buffer for discretes variables
   *
   * @param z global buffer for the discretes variables
   * @param zConnected global buffer for the discretes variables connection status
   * @param offsetZ offset to use to find the beginning of the local buffer
   */
  virtual void setReferenceZ(double* z, bool* zConnected, const int& offsetZ) = 0;

  /**
   * @brief set the local buffer for calculated variables
   *
   * @param calculatedVars global buffer for the calculated variables
   * @param offsetCalculatedVars offset to use to find the beginning of the local buffer
   */
  virtual void setReferenceCalculatedVar(double* calculatedVars, const int& offsetCalculatedVars) = 0;

  /**
   * @brief set the local buffer for root values
   *
   * @param g global buffer for the root values
   * @param offsetG offset to use to find the beginning of the local buffer
   */
  virtual void setReferenceG(state_g *g, const int& offsetG) = 0;

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
  virtual ParameterModeler findParameter(const std::string& name, const boost::unordered_map<std::string, ParameterModeler>& params) const = 0;

  /**
   * @brief true if a parameter with a given name is present in a vector of parameters
   * @param name name of the desired parameter
   * @param params vector of parameters
   * @return true if the parameter with the given name has been found, false otherwise
   */
  virtual bool hasParameter(const std::string& name, const boost::unordered_map<std::string, ParameterModeler>& params) const = 0;

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
  virtual void setNetwork(ModelNetwork* model) = 0;

  /**
   * @brief get size f
   * @return size f
   */
  virtual int sizeF() const = 0;

  /**
   * @brief get size y
   * @return size y
   */
  virtual int sizeY() const = 0;

  /**
   * @brief get size z
   * @return size z
   */
  virtual int sizeZ() const = 0;

  /**
   * @brief get size g
   * @return size g
   */
  virtual int sizeG() const = 0;

  /**
   * @brief get size mode
   * @return size mode
   */
  virtual int sizeMode() const = 0;

  /**
   * @brief get size calculated variables
   * @return size calculated variables
   */
  virtual int sizeCalculatedVar() const = 0;

   /**
   * @brief get offset to find the beginning of calculated var of the model in the global vector
   * @return offset to find the beginning of calculated var of the model in the global vector
   */
  virtual unsigned int getOffsetCalculatedVar() const = 0;

  /**
   * @brief set the offset to find the beginning of calculated var of the model in the global vector
   * @param offset to find the beginning of calculated var of the model in the global vector
   */
  virtual void setOffsetCalculatedVar(unsigned int offset) = 0;

  /**
   * @brief init size
   */
  virtual void initSize() = 0;

  /**
   * @brief id
   * @return id
   */
  virtual std::string id() const = 0;

  /**
   * @brief class implementation
   */
  class Impl;
};



}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENT_H_
