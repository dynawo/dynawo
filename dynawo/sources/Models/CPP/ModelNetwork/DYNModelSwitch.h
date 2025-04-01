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
 * @file  DYNModelSwitch.h
 *
 * @brief
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELSWITCH_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELSWITCH_H_

#include <boost/shared_ptr.hpp>
#include <boost/enable_shared_from_this.hpp>
#include "DYNNetworkComponent.h"
#include "DYNModelBus.h"

namespace DYN {
class SwitchInterface;

/**
 * @brief Generic AC switch model
 */
class ModelSwitch : public boost::enable_shared_from_this<ModelSwitch>, public NetworkComponent {
 public:
  /**
   * @brief default constructor
   * @param sw : switch data interface used to build the model
   */
  explicit ModelSwitch(const boost::shared_ptr<SwitchInterface>& sw);

  /**
   * @brief  calculated variables type
   */
  typedef enum {
    swStateNum_ = 0,  // state of the switch as as continuous variable
    nbCalculatedVariables_ = 1
  } CalculatedVariables_t;

  /**
   * @brief  index variables type
   */
  typedef enum {
    irNum_ = 0,
    iiNum_ = 1
  } IndexVariables_t;

  /**
   * @brief set the switch connection state
   * @param state connection state
   */
  void setConnectionState(State state) {
    connectionState_ = state;
  }

  /**
   * @brief set the bus at end 1 of the switch
   *
   * @param model model of the bus
   */
  void setModelBus1(const boost::shared_ptr<ModelBus>& model) {
    modelBus1_ = model;
    modelBus1_->addSwitch(shared_from_this());
  }

  /**
   * @brief set the bus at end 2 of the switch
   *
   * @param model model of the bus
   */
  void setModelBus2(const boost::shared_ptr<ModelBus>& model) {
    modelBus2_ = model;
    modelBus2_->addSwitch(shared_from_this());
  }

  /**
   * @brief  retrieve the switch connection state
   * @return connection status
   */
  State getConnectionState() const {
    return connectionState_;
  }

  /**
   * @brief inLoop or not
   * @param inLoop inLoop
   */
  void inLoop(bool inLoop) {
    inLoop_ = inLoop;
  }

  /**
   * @brief get inLoop
   * @return inLoop
   */
  bool isInLoop() const {
    return inLoop_;
  }

  /**
   * @brief compute value
   * @return value
   */

  int iiYNum() const {
    return iiYNum_;
  }

  /**
   * @brief compute value
   * @return value
   */
  int irYNum() const {
    return irYNum_;
  }

  /**
   * @brief return false if this switch is initially open and cannot be closed
   * @return false if this switch is initially open and cannot be closed
   */
  bool canBeClosed() const {
    return canBeClosed_;
  }

  /**
   * @brief retrieve the bus at end 1 of the switch
   * @return bus 1
   */
  boost::shared_ptr<ModelBus> getModelBus1() const;

  /**
   * @brief retrieve the bus at end 2 of the switch
   * @return bus 2
   */
  boost::shared_ptr<ModelBus> getModelBus2() const;

  /**
   * @brief evaluate node injection
   */
  void evalNodeInjection();

  /**
   * @brief add bus neighbors
   */
  void addBusNeighbors();
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
   * @brief evaluate F
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(propertyF_t type);  ///< compute the local F function

  /**
  * @copydoc NetworkComponent::evalZ()
  */
  NetworkComponent::StateChange_t evalZ(const double& t);

  /**
   * @brief evaluate G
   * @param t time
   */
  void evalG(const double& t);

  /**
   * @brief evaluate calculated variables (for outputs)
   */
  void evalCalculatedVars();  ///< compute calculated variables (for outputs)

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
   * @copydoc NetworkComponent::setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& params)
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
   * @param time time
   * @return state change type
   */
  NetworkComponent::StateChange_t evalState(const double& time);

  /**
   * @copydoc NetworkComponent::evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset)
   */
  void evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset);

  /**
   * @copydoc NetworkComponent::evalJtPrim(SparseMatrix& jt, const int& rowOffset)
   */
  void evalJtPrim(SparseMatrix& jt, const int& rowOffset);

  /**
   * @brief init size
   */
  void initSize();

  /**
   * @brief open a switch without event (used by model bus)
   */
  void open();

  /**
   * @brief close a switch without event (used by model voltage level)
   */
  void close();

  /**
   * @brief set the initial current of the switch
   */
  void setInitialCurrents();

 private:
  boost::shared_ptr<ModelBus> modelBus1_;  ///< bus at end 1 of the switch
  boost::shared_ptr<ModelBus> modelBus2_;  ///< bus at end 2 of the switch
  State connectionState_;  ///< "internal" switch connection status, evaluated at the end of evalZ to detect if the state was modified by another component
  bool topologyModified_;  ///< true if the switch connection state was modified
  bool inLoop_;  ///< inLoop
  double ir0_;  ///< initial current (real part)
  double ii0_;  ///< initial current (imaginary part)
  // index use for filling the Jacobian
  int irYNum_;  ///< irYNum
  int iiYNum_;  ///< iiYNum
  bool canBeClosed_;   ///< false if this switch is initially open and cannot be closed
};

}  // namespace DYN
#endif  // MODELS_CPP_MODELNETWORK_DYNMODELSWITCH_H_
