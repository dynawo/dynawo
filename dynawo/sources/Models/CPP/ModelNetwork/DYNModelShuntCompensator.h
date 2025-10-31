//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNModelShuntCompensator.h
 *
 * @brief Shunt compensator model : header file
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELSHUNTCOMPENSATOR_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELSHUNTCOMPENSATOR_H_

#include <boost/shared_ptr.hpp>
#include <boost/weak_ptr.hpp>
#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>
#include "DYNNetworkComponent.h"

namespace DYN {
class ModelBus;
class ShuntCompensatorInterface;

/**
 * @brief Shunt compensator model
 */
class ModelShuntCompensator : public NetworkComponent {
 public:
  /**
   * @brief default constructor
   * @param shunt : shunt compensator data interface used to build the model
   */
  explicit ModelShuntCompensator(const std::shared_ptr<ShuntCompensatorInterface>& shunt);

  /**
   * @brief  calculated variables type
   */
  typedef enum {
    qNum_ = 0,  // (unit Mvar)
    nbCalculatedVariables_ = 1
  } CalculatedVariables_t;

  /**
   * @brief  shunt type (capacitor or reactance)
   */
  typedef enum {
    CAPACITOR = 0,
    REACTANCE = 1
  } ShuntType_t;

  /**
   * @brief index discrete variable
   */
  typedef enum {
    connectionStateNum_ = 0,
    isCapacitorNum_ = 1,
    isAvailableNum_ = 2,
    currentSectionNum_ = 3
  } IndexDiscreteVariable_t;

  /**
   * @brief set connection status
   * @param state connection status
   */
  void setConnected(const State state) {
    connectionState_ = state;
  }

  /**
   * @brief set the bus to which the shunt is connected
   *
   * @param model model of the bus
   */
  void setModelBus(const std::shared_ptr<ModelBus>& model);

  /**
   * @brief evaluate node injection
   */
  void evalNodeInjection() override;

  /**
   * @brief evaluate derivatives
   * @param cj Jacobian prime coefficient
   */
  void evalDerivatives(double cj) override;

  /**
   * @brief evaluate derivatives prim
   */
  void evalDerivativesPrim() override { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalF()
   */
  void evalF(propertyF_t type) override;

  /**
   * @copydoc NetworkComponent::evalJt(double cj, int rowOffset, SparseMatrix& jt)
   */
  void evalJt(double cj, int rowOffset, SparseMatrix& jt) override;

  /**
   * @copydoc NetworkComponent::evalJtPrim(int rowOffset, SparseMatrix& jtPrim)
   */
  void evalJtPrim(int rowOffset, SparseMatrix& jtPrim) override;

  /**
   * @brief define variables
   * @param variables variables
   */
  static void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @brief instantiate variables
   * @param variables variables
   */
  void instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables) override;

  /**
   * @brief define parameters
   * @param parameters vector to fill with the generic parameters
   */
  static void defineParameters(std::vector<ParameterModeler>& parameters);

  /**
   * @brief define non generic parameters
   * @param parameters vector to fill with the non generic parameters
   */
  void defineNonGenericParameters(std::vector<ParameterModeler>& parameters) override;

  /**
   * @brief define elements
   * @param elements vector of elements
   * @param mapElement map of elements
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) override;

  /**
   * @copydoc NetworkComponent::evalZ()
   */
  NetworkComponent::StateChange_t evalZ(double t) override;

  /**
   * @copydoc NetworkComponent::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;

  /**
   * @brief evaluation G
   * @param t time
   */
  void evalG(double t) override;

  /**
   * @brief evaluation of the calculated variables (for outputs)
   */
  void evalCalculatedVars() override;

  /**
   * @brief get the index of variables used to define the jacobian associated to a calculated variable
   * @param numCalculatedVar : index of the calculated variable
   * @param numVars : index of variables used to define the jacobian associated to the calculated variable
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, std::vector<int>& numVars) const override;

  /**
   * @brief evaluate the jacobian associated to a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned numCalculatedVar, std::vector<double>& res) const override;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   *
   * @return value of the calculated variable
   */
  double evalCalculatedVarI(unsigned numCalculatedVar) const override;

  /**
   * @copydoc NetworkComponent::evalStaticYType()
   */
  void evalStaticYType() override { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalDynamicYType()
   */
  void evalDynamicYType() override { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalStaticFType()
   */
  void evalStaticFType() override { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalDynamicFType()
   */
  void evalDynamicFType() override { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalYMat()
   */
  void evalYMat() override;

  /**
   * @copydoc NetworkComponent::init(int& yNum)
   */
  void init(int& yNum) override;

  /**
   * @copydoc NetworkComponent::getY0()
   */
  void getY0() override;

  /**
   * @copydoc NetworkComponent::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params)
   */
  void setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) override;

  /**
   * @copydoc NetworkComponent::setFequations( std::map<int,std::string>& fEquationIndex )
   */
  void setFequations(std::map<int, std::string>& fEquationIndex) override;

  /**
   * @copydoc NetworkComponent::setGequations( std::map<int,std::string>& gEquationIndex )
   */
  void setGequations(std::map<int, std::string>& gEquationIndex) override;

  /**
   * @brief evaluate state
   * @param time time
   * @return state change type
   */
  NetworkComponent::StateChange_t evalState(double time) override;

  /**
   * @brief addBusNeighbors
   */
  void addBusNeighbors() override { /* not needed */ }

  /**
   * @brief init size
   */
  void initSize() override;

  /**
   * @brief get connection status
   * @return connection status
   */
  inline State getConnected() const {
    return connectionState_;
  }

  /**
   * @brief get currentSection
   * @return currentSection
   */
  inline int getCurrentSection() const {
    return currentSection_;
  }

  /**
   * @brief check whether the shunt is connected to the bus
   * @return @b True if the shunt is connected, @b false else
   */
  inline bool isConnected() const {
    return (connectionState_ == CLOSED);
  }

  /**
   * @brief return true if the shunt is a capacitor
   * @return capacitor or not
   */
  inline bool isCapacitor() const {
    return type_ == CAPACITOR;
  }

  /**
   * @brief get the number of internal variable of the model
   *
   * @return the number of internal variable of the model
   */
  inline unsigned getNbInternalVariables() const override {
    return 4;
  }

  /**
   * @brief append the internal variables values to a stringstream
   *
   * @param streamVariables : stream with binary formated internalVariables
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

  /**
   * @brief return true if the shunt is available to be connected
   * and the closest bus bar section is not switched off
   * @return available or not
   */
  bool isAvailable() const;

 private:
  std::weak_ptr<ShuntCompensatorInterface> shunt_;  ///< reference to the shunt interface object

  int currentSection_;  ///< The current number of connected section of the shunt compensator
  int maximumSection_;  ///< The maximum number of sections of the shunt compensator
  double suscepAtMaximumSec_;  ///< The shunt susceptance at maximum section in Siemens
  double vNom_;  ///< The nominal voltage of the bus where the shunt compensator is connected in kV
  double suscepPu_;  ///< The shunt current susceptance in pu (based SNREF)
  double tLastOpening_;  ///< Last shunt opening time
  ShuntType_t type_;  ///< The type of the shunt compensator (CAPACITOR or REACTANCE)

  std::shared_ptr<ModelBus> modelBus_;  ///< model bus

  // Parameters
  double noReclosingDelay_;  ///< The non reclosing delay of the shunt compensator in seconds

  // State variables
  State connectionState_;  ///< "internal" shunt compensator connection status, evaluated at the end of evalZ to detect if the state was modified
  bool stateModified_;  ///< true if the shunt compensator connection state was modified

  // Calculated variables
  double ir0_;  ///< initial real part of the current
  double ii0_;  ///< initial imaginary part of the current
  startingPointMode_t startingPointMode_;  ///< type of starting point for the model (FLAT,WARM)
  bool cannotBeDisconnected_;  ///< true if this shunt cannot be disconnected (due to closed not retained switches in node breaker)
};  ///< Generic model for Shunt compensator in network
}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELSHUNTCOMPENSATOR_H_
