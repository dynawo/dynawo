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
#include "DYNNetworkComponent.h"


namespace DYN {
class ModelBus;
class GeneratorInterface;

/**
 * class ModelGenerator
 */
class ModelGenerator : public NetworkComponent {
 public:
  /**
   * @brief default constructor
   * @param generator : generator data interface
   */
  explicit ModelGenerator(const std::shared_ptr<GeneratorInterface>& generator);

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
   * @param state connection status
   */
  void setConnected(State state) {
    connectionState_ = state;
  }

  /**
   * @brief set the model bus where the generator is connected
   * @param model model of the bus
   */
  void setModelBus(const std::shared_ptr<ModelBus>& model) {
    modelBus_ = model;
  }

  /**
   * @brief evaluate node injection
   */
  void evalNodeInjection();

  /**
   * @brief evaluate derivatives
   * @param cj Jacobian prime coefficient
   */
  void evalDerivatives(const double cj);

  /**
   * @brief evaluate derivatives prim
   */
  void evalDerivativesPrim() { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalF()
   */
  void evalF(propertyF_t type);

  /**
   * @copydoc NetworkComponent::evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset)
   */
  void evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset);

  /**
   * @copydoc NetworkComponent::evalJtPrim(SparseMatrix& jt, const int& rowOffset)
   */
  void evalJtPrim(SparseMatrix& jt, const int& rowOffset);

  /**
   * @brief define variables
   * @param variables variables
   */
  static void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @brief instantiate variables
   * @param variables variables
   */
  void instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @brief define parameters
   * @param parameters vector to fill with the generic parameters
   */
  static void defineParameters(std::vector<ParameterModeler>& parameters);

  /**
   * @brief define non generic parameters
   * @param parameters vector to fill with the non generic parameters
   */
  void defineNonGenericParameters(std::vector<ParameterModeler>& parameters);

  /**
   * @brief define elements
   * @param elements vector of elements
   * @param mapElement map of elements
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement);

  /**
   * @copydoc NetworkComponent::evalZ()
   */
  NetworkComponent::StateChange_t evalZ(const double& t, bool deactivateRootFunctions);

  /**
   * @brief evaluation G
   * @param t time
   */
  void evalG(const double& t);

  /**
   * @brief evaluation calculated variables (for outputs)
   */
  void evalCalculatedVars();  ///< compute calculated variables (for outputs)
  /**
   * @brief get the index of variables used to define the jacobian associated to a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   *
   * @param numVars index of variables used to define the jacobian
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, std::vector<int>& numVars) const;
  /**
   * @brief evaluate the jacobian associated to a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned numCalculatedVar, std::vector<double>& res) const;
  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   *
   * @return value of the calculated variable
   */
  double evalCalculatedVarI(unsigned numCalculatedVar) const;

  /**
   * @copydoc NetworkComponent::evalStaticYType()
   */
  void evalStaticYType() { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalDynamicYType()
   */
  void evalDynamicYType() { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalStaticFType()
   */
  void evalStaticFType() { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalDynamicFType()
   */
  void evalDynamicFType() { /* not needed */ }

  /**
   * @copydoc NetworkComponent::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable);

  /**
   * @copydoc NetworkComponent::evalYMat()
   */
  void evalYMat() { /* not needed*/ }

  /**
   * @copydoc NetworkComponent::init(int& yNum)
   */
  void init(int & yNum);

  /**
   * @copydoc NetworkComponent::getY0()
   */
  void getY0();

  /**
   * @copydoc NetworkComponent::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params)
   */
  void setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params);

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
   * @param time time
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

  /**
   * @brief calculate the active power set point in pu (SNREF)
   * @return the active power set point in pu (SNREF)
   */
  inline double PcPu() const {
    return Pc_ / SNREF;
  }

  /**
   * @brief calculate the reactive power set point in pu (SNREF)
   * @return the reactive power set point in pu (SNREF)
   */
  inline double QcPu() const {
    return Qc_ / SNREF;
  }

 private:
  /**
   * @brief get the real part of the current
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @param Pc active power set point
   * @param Qc reactive power set point
   * @return the real part of the current
   */
  inline double ir(double ur, double ui, double U2, double Pc, double Qc) const {
    return (-Pc * ur - Qc * ui) / U2;
  }

  /**
   * @brief get the imaginary part of the current
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @param Pc active power set point
   * @param Qc reactive power set point
   * @return the imaginary part of the current
   */
  inline double ii(double ur, double ui, double U2, double Pc, double Qc) const {
    return (-Pc * ui + Qc * ur) / U2;
  }

 /**
   * @brief calculated value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U voltage
   * @param U2 voltage square
   * @return value
   */
 double P_dUr(double ur, double ui, double U, double U2) const;
 /**
  * @brief calculated value
  * @param ur real part of the voltage
  * @param ui imaginary part of the voltage
  * @param U voltage
  * @param U2 voltage square
  * @return value
  */
 double Q_dUr(double ur, double ui, double U, double U2) const;
 /**
  * @brief calculated value
  * @param ur real part of the voltage
  * @param ui imaginary part of the voltage
  * @param U voltage
  * @param U2 voltage square
  * @return value
  */
 double P_dUi(double ur, double ui, double U, double U2) const;
 /**
  * @brief calculated value
  * @param ur real part of the voltage
  * @param ui imaginary part of the voltage
  * @param U voltage
  * @param U2 voltage square
  * @return value
  */
 double Q_dUi(double ur, double ui, double U, double U2) const;

  /**
   * @brief get the partial derivative of ir with respect to Ur
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @param Pc active power set point
   * @param Qc reactive power set point
   * @return the partial derivative of ir with respect to Ur
   */
  inline double ir_dUr(double ur, double ui, double U2, double Pc, double Qc) const {
    return (-Pc - 2. * ur * (-Pc * ur - Qc * ui) / U2) / U2;
  }

  /**
   * @brief get the partial derivative of ir with respect to Ui
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @param Pc active power set point
   * @param Qc reactive power set point
   * @return the partial derivative of ir with respect to Ui
   */
  inline double ir_dUi(double ur, double ui, double U2, double Pc, double Qc) const {
    return (-Qc - 2. * ui * (-Pc * ur - Qc * ui) / U2) / U2;
  }

  /**
   * @brief get the partial derivative of ii with respect to Ur
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @param Pc active power set point
   * @param Qc reactive power set point
   * @return the partial derivative of ii with respect to Ur
   */
  inline double ii_dUr(const double& ur, const double& ui, const double& U2, const double& Pc, const double& Qc) const {
    return (Qc - 2. * ur * (-Pc * ui + Qc * ur) / U2) / U2;
  }

  /**
   * @brief get the partial derivative of ii with respect to Ui
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @param Pc active power set point
   * @param Qc reactive power set point
   * @return the partial derivative of ii with respect to Ui
   */
  inline double ii_dUi(double ur, double ui, double U2, double Pc, double Qc) const {
    return (-Pc - 2 * ui * (-Pc * ui + Qc * ur) / U2) / U2;
  }

 private:
  std::weak_ptr<GeneratorInterface> generator_;  ///< reference to the generator interface object
  double Pc_;  ///< active power target in MW
  double Qc_;  ///< reactive power target in Mvar
  double P0_;  ///< initial active power
  double Q0_;  ///< initial reactive power
  double u0_;  ///< initial voltage
  double U0Pu_square_;
  double ir0_;  ///< initial current real part
  double ii0_;  ///< initial current imaginary part
  double alpha_;  ///< active power exponential sensitivity to voltage
  double beta_;  ///< reactive power exponential sensitivity to voltage
  double halfAlpha_;
  double halfBeta_;
  bool isVoltageDependant_;  ///< whether the produced energy remains constant
  State connectionState_;  ///< "internal" generator connection status, evaluated at the end of evalZ to detect if the state was modified by another component
  bool stateModified_;  ///< true if the generator connection state was modified
  std::shared_ptr<ModelBus> modelBus_;  ///< model bus
  startingPointMode_t startingPointMode_;  ///< type of starting point for the model (FLAT,WARM)
};
}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELGENERATOR_H_
