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
 * @file  DYNModelShuntCompensator.h
 *
 * @brief
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELSHUNTCOMPENSATOR_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELSHUNTCOMPENSATOR_H_

#include <boost/shared_ptr.hpp>
#include "DYNNetworkComponentImpl.h"

namespace DYN {
class ModelBus;
class ShuntCompensatorInterface;

class ModelShuntCompensator : public NetworkComponent::Impl {
 public:
  /**
   * @brief default constructor
   * @param shunt : shunt compensator data interface used to build the model
   */
  explicit ModelShuntCompensator(const boost::shared_ptr<ShuntCompensatorInterface>& shunt);

  /**
   * @brief destructor
   */
  ~ModelShuntCompensator() { }

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
   * @param state
   */
  void setConnected(State state) {
    connectionState_ = state;
  }

  /**
   * @brief set the bus to which the shunt is connected
   *
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
   * @param cj Jacobian prime coefficient
   */
  void evalDerivatives(const double cj);

  /**
   * @brief evaluate derivatives prim
   */
  void evalDerivativesPrim() { /* not needed */ }

  /**
   * @copydoc NetworkComponent::Impl::evalF()
   */
  void evalF() { /* no F equation */ }

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
   * @copydoc NetworkComponent::Impl::evalZ()
   */
  NetworkComponent::StateChange_t evalZ(const double& t);

  /**
   * @brief evaluation G
   * @param t time
   */
  void evalG(const double& t);

  /**
   * @brief evaluation of the calculated variables (for outputs)
   */
  void evalCalculatedVars();

  /**
   * @brief get the index of variables used to define the jacobian associated to a calculated variable
   * @param numCalculatedVar : index of the calculated variable
   * @param numVars : index of variables used to define the jacobian associated to the calculated variable
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

  /**
   * @copydoc NetworkComponent::evalYMat()
   */
  void evalYMat();

  /**
   * @copydoc NetworkComponent::init(int& yNum)
   */
  void init(int& yNum);

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

 private:
  /**
   * @brief compute value
   * @param ui imaginary part of the voltage
   * @return value
   */
  double ir(const double& ui) const;
  /**
   * @brief compute value
   * @param ur real part of the voltage
   * @return value
   */
  double ii(const double& ur) const;
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
   * @brief return true if the shunt is available to be connected (i.e : time > last time disconnection + noReclosingdelay)
   * and the closest bus bar section is not switched off)
   * @param time
   * @return available or not
   */
  bool isAvailable(const double& time) const;

  double suscepPerSect_;  ///< The shunt susceptance per section in Siemens
  int currentSection_;  ///< The current number of connected section of the shunt compensator
  int maximumSection_;  ///< The maximum number of sections of the shunt compensator
  double vNom_;  ///< The nominal voltage of the bus where the shunt compensator is connected in kV
  double suscepPu_;  ///< The shunt current susceptance in pu (based SNREF)
  double tLastOpening_;  ///< Last shunt opening time
  ShuntType_t type_;  ///< The type of the shunt compensator (CAPACITOR or REACTANCE)

  boost::shared_ptr<ModelBus> modelBus_;  ///< model bus

  // Parameters
  double noReclosingDelay_;  ///< The non reclosing delay of the shunt compensator in seconds

  // State variables
  State connectionState_;  ///< "internal" shunt compensator connection status, evaluated at the end of evalZ to detect if the state was modified
  bool stateModified_;  ///< true if the shunt compensator connection state was modified

  // Calculated variables
  double ir0_;  ///< initial real part of the current
  double ii0_;  ///< initial imaginary part of the current
};  ///< Generic model for Shunt compensator in network
}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELSHUNTCOMPENSATOR_H_
