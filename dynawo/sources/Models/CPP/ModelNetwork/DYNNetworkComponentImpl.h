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
 * @file  DYNNetworkComponentImpl.h
 *
 * @brief
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENTIMPL_H_
#define MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENTIMPL_H_

#include "DYNNetworkComponent.h"

namespace DYN {
class Element;
class ParameterModeler;
class SparseMatrix;

class NetworkComponent::Impl : public NetworkComponent {
 public:
  /**
   * @brief constructor
   */
  Impl();

  /**
   * @brief constructor
   * @param id id of the component
   */
  explicit Impl(const std::string& id);

  /**
   * @brief destructor
   */
  virtual ~Impl();

  /**
   * @copydoc NetworkComponent::addBusNeighbors()
   */
  virtual void addBusNeighbors() = 0;

  /**
   * @copydoc NetworkComponent::instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  virtual void instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables) = 0;

  /**
   * @copydoc NetworkComponent::defineNonGenericParameters(std::vector<ParameterModeler>& parameters)
   */
  virtual void defineNonGenericParameters(std::vector<ParameterModeler>& parameters) = 0;

  /**
   * @copydoc NetworkComponent::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement)
   */
  virtual void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) = 0;

  /**
   * @copydoc NetworkComponent::evalNodeInjection()
   */
  virtual void evalNodeInjection() = 0;

  /**
   * @copydoc NetworkComponent::evalDerivatives(const double cj)
   */
  virtual void evalDerivatives(const double cj) = 0;

  /**
   * @copydoc NetworkComponent::evalDerivativesPrim()
   */
  virtual void evalDerivativesPrim() = 0;

  /**
   * @copydoc NetworkComponent::evalF(propertyF_t type)
   */
  virtual void evalF(propertyF_t type) = 0;

  /**
   * @copydoc NetworkComponent::evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset)
   */
  virtual void evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset) = 0;

  /**
   * @copydoc NetworkComponent::evalJtPrim(SparseMatrix& jt, const int& rowOffset)
   */
  virtual void evalJtPrim(SparseMatrix& jt, const int& rowOffset) = 0;

  /**
   * @copydoc NetworkComponent::evalZ(const double& t)
   */
  virtual NetworkComponent::StateChange_t evalZ(const double& t) = 0;

  /**
   * @copydoc NetworkComponent::evalCalculatedVars()
   */
  virtual void evalCalculatedVars() = 0;

  /**
   * @brief get the global indexes of the variables used to compute a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @param numVars vector to fill with the indexes
   *
   */
  virtual void getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, std::vector<int>& numVars) const = 0;

  /**
   * @brief evaluate the jacobian associated to a calculated variable based on the current values of continuous variables
   *
   * @param numCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  virtual void evalJCalculatedVarI(unsigned numCalculatedVar, std::vector<double>& res) const = 0;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @return value of the calculated variable based on the current values of continuous variables
   */
  virtual double evalCalculatedVarI(unsigned numCalculatedVar) const = 0;

  /**
   * @copydoc NetworkComponent::evalFType()
   */
  virtual void evalFType() = 0;

  /**
   * @copydoc NetworkComponent::updateFType()
   */
  virtual void updateFType() = 0;

  /**
   * @copydoc NetworkComponent::evalYType()
   */
  virtual void evalYType() = 0;

  /**
   * @copydoc NetworkComponent::updateYType()
   */
  virtual void updateYType() = 0;

  /**
   * @copydoc NetworkComponent::evalYMat()
   */
  virtual void evalYMat() = 0;

  /**
   * @copydoc NetworkComponent::init( int & yNum )
   */
  virtual void init(int & yNum) = 0;

  /**
   * @copydoc NetworkComponent::getY0()
   */
  virtual void getY0() = 0;

  /**
   * @copydoc NetworkComponent::setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& params)
   */
  virtual void setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& params) = 0;

  /**
   * @copydoc NetworkComponent::setFequations( std::map<int,std::string>& fEquationIndex )
   */
  virtual void setFequations(std::map<int, std::string>& fEquationIndex) = 0;

  /**
   * @copydoc NetworkComponent::setGequations( std::map<int,std::string>& gEquationIndex )
   */
  virtual void setGequations(std::map<int, std::string>& gEquationIndex) = 0;

  /**
   * @copydoc NetworkComponent::evalState(const double& time)
   */
  virtual StateChange_t evalState(const double& time) = 0;

  /**
   * @copydoc NetworkComponent::initSize()
   */
  virtual void initSize() = 0;

 public:
  /**
   * @copydoc NetworkComponent::setBufferYType(propertyContinuousVar_t* yType, const unsigned int& offset)
   */
  void setBufferYType(propertyContinuousVar_t* yType, const unsigned int& offset);

  /**
   * @copydoc NetworkComponent::setBufferFType(propertyF_t* fType, const unsigned int& offset)
   */
  void setBufferFType(propertyF_t* fType, const unsigned int& offset);

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
   * @copydoc NetworkComponent::setNetwork(ModelNetwork* model)
   */
  void setNetwork(ModelNetwork* model);

  /**
   * @copydoc NetworkComponent::id()
   */
  inline std::string id() const {
    return id_;
  }

  /**
   * @copydoc NetworkComponent::sizeF()
   */
  inline int sizeF() const {
    return sizeF_;
  }

  /**
   * @copydoc NetworkComponent::sizeY()
   */
  inline int sizeY() const {
    return sizeY_;
  }

  /**
   * @copydoc NetworkComponent::sizeZ()
   */
  inline int sizeZ() const {
    return sizeZ_;
  }

  /**
   * @copydoc NetworkComponent::sizeG()
   */
  inline int sizeG() const {
    return sizeG_;
  }

  /**
   * @copydoc NetworkComponent::sizeMode()
   */
  inline int sizeMode() const {
    return sizeMode_;
  }

  /**
   * @copydoc NetworkComponent::sizeCalculatedVar()
   */
  inline int sizeCalculatedVar() const {
    return sizeCalculatedVar_;
  }

  /**
   * @copydoc NetworkComponent::getOffsetCalculatedVar()
   */
  inline unsigned int getOffsetCalculatedVar() const {
    return offsetCalculatedVar_;
  }

  /**
   * @copydoc NetworkComponent::setOffsetCalculatedVar()
   */
  inline void setOffsetCalculatedVar(unsigned int offset) {
    offsetCalculatedVar_ = offset;
  }

  /**
   * @brief true if a parameter with a given name is present in a vector of parameters
   * @param name: name of the desired parameter
   * @param params: vector of parameters
   * @return true if the parameter with the given name has been found, false otherwise
   */
  bool hasParameter(const std::string& name, const boost::unordered_map<std::string, ParameterModeler>& params) const;

  /**
   * @brief get a parameter with a given name from a vector of parameters. Will throw a ParameterNotDefined exception if not found.
   * @param name: name of the desired parameter
   * @param params: vector of parameters
   * @return parameter with the given name
   */
  ParameterModeler findParameter(const std::string& name, const boost::unordered_map<std::string, ParameterModeler>& params) const;

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
   * @param elements vector of elements to fill with new elements defined
   * @param mapElement map of elements to fill with new elements
   */
  void addElementWithValue(std::string elementName, std::vector<Element>& elements, std::map<std::string, int>& mapElement);

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
};  ///< Implementation class of Base class for network component models
}  // namespace DYN


#include "DYNNetworkComponentImpl.hpp"

#endif  // MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENTIMPL_H_
