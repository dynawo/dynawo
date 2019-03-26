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
 * @file  DYNModelGenerator.h
 *
 * @brief
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELGENERATOR_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELGENERATOR_H_

#include <boost/shared_ptr.hpp>
#include "DYNNetworkComponentImpl.h"

namespace DYN {
class ModelBus;
class GeneratorInterface;

/**
 * class ModelGenerator
 */
class ModelGenerator : public NetworkComponent::Impl {
 public:
  /**
   * @brief default constructor
   * @param generator : generator data interface
   */
  explicit ModelGenerator(const boost::shared_ptr<GeneratorInterface>& generator);

  /**
   * @brief destructor
   */
  ~ModelGenerator() { }

  /**
   * @brief  calculated variables type
   */

  typedef enum {
    pNum_ = 0,
    qNum_ = 1,
    genStateNum_ = 2,
    nbCalculatedVariables_ = 3
  } CalculatedVariables_t;

  /**
   * @brief set connection status of the generator
   * @param state
   */
  void setConnected(State state) {
    connectionState_ = state;
  }

  /**
   * @brief set the model bus where the generator is connected
   * @param model model of the bus
   */
  void setModelBus(const boost::shared_ptr<ModelBus>& model) {
    modelBus_ = model;
  }

  /**
   * @brief evaluate node injection
   */
  void evalNodeInjection();

  /**
   * @brief evaluate derivatives
   */
  void evalDerivatives();

  /**
   * @copydoc NetworkComponent::Impl::evalF()
   */
  void evalF() { /* not needed */ }

  /**
   * @copydoc NetworkComponent::Impl::evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset)
   */
  void evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset);

  /**
   * @copydoc NetworkComponent::Impl::evalJtPrim(SparseMatrix& jt, const int& rowOffset)
   */
  void evalJtPrim(SparseMatrix& jt, const int& rowOffset);

  /**
   * @brief define variables
   * @param variables
   */
  static void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @brief instantiate variables
   * @param variables
   */
  void instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @brief define parameters
   * @param parameters: vector to fill with the generic parameters
   */
  static void defineParameters(std::vector<ParameterModeler>& parameters);

  /**
   * @brief define non generic parameters
   * @param parameters: vector to fill with the non generic parameters
   */
  void defineNonGenericParameters(std::vector<ParameterModeler>& parameters);

  /**
   * @brief define elements
   * @param elements
   * @param mapElement map of elements
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement);

  /**
   * @brief evalution Z
   * @param t time
   */
  void evalZ(const double& t);  ///< compute local Z function

  /**
   * @brief evalution G
   * @param t time
   */
  void evalG(const double& t);

  /**
   * @brief evalution calculated variables (for outpus)
   */
  void evalCalculatedVars();  ///< compute calculated variables (for outputs)
  /**
   * @brief get the index of variables used to define the jacobian associated to a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   *
   * @param numVars index of variables used to define the jacobian
   */
  void getDefJCalculatedVarI(int numCalculatedVar, std::vector<int>& numVars);
  /**
   * @brief evaluate the jacobian associated to a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @param y value of the variable used to calculate the jacobian
   * @param yp value of the derivatives of variable used to calculate the jacobian
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(int numCalculatedVar, double* y, double* yp, std::vector<double>& res);
  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @param y values of the variables used to calculate the variable
   * @param yp values of the derivatives used to calculate the variable
   *
   * @return value of the calculated variable
   */
  double evalCalculatedVarI(int numCalculatedVar, double* y, double* yp);

  /**
   * @copydoc NetworkComponent::evalYType()
   */
  void evalYType() { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalFType()
   */
  void evalFType() { /* not needed */ }

  void evalYMat() { /* not needed */ }

  void init(int & yNum);

  /**
   * @copydoc NetworkComponent::Impl::getY0()
   */
  void getY0();

  /**
   * @copydoc NetworkComponent::Impl::setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& params)
   */
  void setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& params);

   /**
   * @copydoc NetworkComponent::setFequations( std::map<int,std::string>& fEquationIndex )
   */
  void setFequations(std::map<int, std::string>& fEquationIndex);

  /**
   * @copydoc NetworkComponent::setGequations( std::map<int,std::string>& gEquationIndex )
   */
  void setGequations(std::map<int, std::string>& gEquationIndex);

  /**
   * @brief evaluate state
   * @param time
   * @return state change type
   */
  NetworkComponent::StateChange_t evalState(const double& time);

  /**
   * @brief addBusNeighbors
   */
  void addBusNeighbors() { /* not needed */ }
  /**
   * @brief init size
   */
  void initSize();

  /**
   * @brief get p
   * @return p
   */
  inline double getP() const {
    return P_;
  }  ///< get active power

  /**
   * @brief get q
   * @return q
   */
  inline double getQ() const {
    return Q_;
  }  ///< get reactive power

  /**
   * @brief  check whether the generator is connected to the network
   * @return connection state
   */
  inline State getConnected() const {
    return connectionState_;
  }  ///< check whether the generator is connected to the network

  /**
   * @brief check whether the generator is connected to the bus
   * @return @b True if the generator is connected, @b false else
   */
  inline bool isConnected() const {
    return (connectionState_ == CLOSED);
  }

 private:
  /**
   * @brief calculate the active power setpoint in pu (SNREF)
   * @return the active power setpoint in pu (SNREF)
   */
  double Pc() const;

  /**
   * @brief calculate the reactive power setpoint in pu (SNREF)
   * @return the reactive power setpoint in pu (SNREF)
   */
  double Qc() const;

  /**
   * @brief get the real part of the current
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @return the real part of the current
   */
  double ir(const double& ur, const double& ui, const double& U2) const;

  /**
   * @brief get the imaginary part of the current
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @return the imaginary part of the current
   */
  double ii(const double& ur, const double& ui, const double& U2) const;

  /**
   * @brief get the partial derivative of ir with respect to Ur
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @return the partial derivative of ir with respect to Ur
   */
  double ir_dUr(const double& ur, const double& ui, const double& U2) const;

  /**
   * @brief get the partial derivative of ii with respect to Ur
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @return the partial derivative of ii with respect to Ur
   */
  double ii_dUr(const double& ur, const double& ui, const double& U2) const;  ///< matrix value

  /**
   * @brief get the partial derivative of ir with respect to Ui
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @return the partial derivative of ir with respect to Ui
   */
  double ir_dUi(const double& ur, const double& ui, const double& U2) const;  ///< matrix value

  /**
   * @brief get the partial derivative of ii with respect to Ui
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @return the partial derivative of ii with respect to Ui
   */
  double ii_dUi(const double& ur, const double& ui, const double& U2) const;  ///< matrix value

  double Pc_;  ///< active power target in MW
  double Qc_;  ///< reactive power target in MVar
  double ir0_;  ///< initial current real part
  double ii0_;  ///< initial current imaginary part
  double P_;  ///< active power in pu (SNREF)
  double Q_;  ///< reactive power in pu (SNREF)
  State connectionState_;  ///< whether the generator is connected to the network
  boost::shared_ptr<ModelBus> modelBus_;  ///< model bus
};
}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELGENERATOR_H_
