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

//======================================================================
/**
 * @file  DYNModelStaticVarCompensator.h
 *
 * @brief Static var compensator model : header file
 *
 */
//======================================================================
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELSTATICVARCOMPENSATOR_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELSTATICVARCOMPENSATOR_H_

#include <boost/shared_ptr.hpp>
#include <boost/weak_ptr.hpp>
#include "DYNNetworkComponent.h"
#include "DYNStaticVarCompensatorInterface.h"

namespace DYN {
class ModelBus;

/**
 * @brief Static var compensator model
 */
class ModelStaticVarCompensator : public NetworkComponent {
 public:
  /**
   * @brief default constructor
   * @param svc : static var compensator data interface used to build the model
   */
  explicit ModelStaticVarCompensator(const std::shared_ptr<StaticVarCompensatorInterface>& svc);

  /**
   * @brief  calculated variables type
   */
  typedef enum {
    pNum_ = 0,
    qNum_ = 1,
    nbCalculatedVariables_ = 2
  } CalculatedVariables_t;

  /**
   * @brief index discrete variable
   */
  typedef enum {
    modeNum_ = 0,
    connectionStateNum_ = 1
  } IndexDiscreteVariable_t;

  /**
   * @brief set connection status
   * @param state connection status
   */
  void setConnected(State state) {
    connectionState_ = state;
  }

  /**
   * @brief set the bus to which the svc is connected
   *
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
   * @brief evaluation F
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(propertyF_t type);

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
  void evalCalculatedVars();

  /**
   * @brief get the index of variables used to define the jacobian associated to a calculated variable
   * @param numCalculatedVar : index of the calculated variable
   * @param numVars : index of variables used to define the jacobian associated to the calculated variable
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
  void evalStaticYType();

  /**
   * @copydoc NetworkComponent::evalDynamicYType()
   */
  void evalDynamicYType() { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalStaticFType()
   */
  void evalStaticFType();

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
  void evalYMat();

   /**
   * @copydoc NetworkComponent::init(int& yNum)
   */
  void init(int& yNum);

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
   * @brief addBusNeighbors
   */
  void addBusNeighbors() { /* not needed */ }

  /**
   * @brief evaluate state
   * @param time time
   * @return state change type
   */
  NetworkComponent::StateChange_t evalState(const double& time);

  /**
   * @brief init size
   */
  void initSize();

  /**
   * @brief evaluate jacobian \f$( J = @F/@x + cj * @F/@x')\f$
   * @param jt sparse matrix to fill
   * @param cj jacobian prime coefficient
   * @param rowOffset row offset to use to find the first row to fill
   */
  void evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset);

  /**
   * @brief  evaluate jacobian \f$( J =  @F/@x')\f$
   *
   * @param jt sparse matrix to fill
   * @param rowOffset row offset to use to find the first row to fill
   */
  void evalJtPrim(SparseMatrix& jt, const int& rowOffset);

  /**
   * @brief get connection status
   * @return connection status
   */
  inline State getConnected() const {
    return connectionState_;
  }

  /**
   * @brief check whether the svc is connected to the bus
   * @return @b True if the svc is connected, @b false else
   */
  inline bool isConnected() const {
    return (connectionState_ == CLOSED);
  }

 private:
  /**
   * @brief compute value
   * @param ui imaginary part of the voltage
   * @return value
   */
  double ir(double ui) const;

  /**
   * @brief compute value
   * @param ur real part of the voltage
   * @return value
   */
  double ii(double ur) const;

  /**
   * @brief compute value
   * @return value
   */
  double P() const;

  /**
   * @brief compute value
   * @return value
   */
  double Q() const;

  /**
   * @brief compute value
   * @return value
   */
  double ir_dUr() const;

  /**
   * @brief compute value
   * @return value
   */
  double ii_dUr() const;

  /**
   * @brief compute value
   * @return value
   */
  double ir_dUi() const;

  /**
   * @brief compute value
   * @return value
   */
  double ii_dUi() const;

 private:
  std::weak_ptr<StaticVarCompensatorInterface> svc_;  ///< reference to the svc interface object
  double gSvc0_;  ///< initial conductance of the svc in pu (base SNREF)
  double bSvc0_;  ///< initial susceptance of the svc in pu (base SNREF)
  double ir0_;  ///< initial current (real part)
  double ii0_;  ///< initial current (imaginary part)
  StaticVarCompensatorInterface::RegulationMode_t mode_;  ///< regulation mode
  State connectionState_;  ///< "internal" compensator connection status, evaluated at the end of evalZ to detect if the state was modified by another component
  bool stateModified_;  ///< true if the compensator connection state was modified
  std::shared_ptr<ModelBus> modelBus_;  ///< model bus
  startingPointMode_t startingPointMode_;  ///< type of starting point for the model (FLAT,WARM)
};  ///< class for Static Var Compensator model in network

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELSTATICVARCOMPENSATOR_H_
