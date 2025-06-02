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
 * @file  DYNModelDanglingLine.h
 *
 * @brief Dangling line model : header file
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELDANGLINGLINE_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELDANGLINGLINE_H_

#include <boost/shared_ptr.hpp>
#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>

#include "DYNNetworkComponent.h"

namespace DYN {
class ModelBus;
class DanglingLineInterface;
class ModelCurrentLimits;

/**
 * @brief Dangling line model
 */
class ModelDanglingLine : public NetworkComponent {
 public:
  /**
   * @brief default constructor
   * @param line : dangling line data interface
   */
  explicit ModelDanglingLine(const std::shared_ptr<DanglingLineInterface>& line);

  /**
   * @brief  calculated variables type
   */
  typedef enum {
    iNum_ = 0,
    pNum_ = 1,
    qNum_ = 2,
    nbCalculatedVariables_ = 3
  } CalculatedVariables_t;

  /**
   * @brief  index variables type
   */
  typedef enum {
    urFictNum_ = 0,
    uiFictNum_ = 1
  } IndexVariables_t;

  /**
   * @brief set the bus to which the dangling line is connected
   *
   * @param model model of the bus
   */
  void setModelBus(const std::shared_ptr<ModelBus>& model) {
    modelBus_ = model;
  }

  /**
   * @brief get the bus to which the dangling line is connected
   *
   * @return model of the bus
   */
  const std::shared_ptr<ModelBus>& getModelBus() {
    return modelBus_;
  }

  /**
   * @brief get connection state
   * @return state
   */
  State getConnectionState() const {
    return connectionState_;
  }

  /**
   * @brief set connection state
   * @param state connection state
   */
  void setConnectionState(const State state) {
    connectionState_ = state;
  }

  /**
   * @brief set current limit status
   * @param desactivate currentLimitsDesactivate
   */
  void setCurrentLimitsDesactivate(const double desactivate) {
    currentLimitsDesactivate_ = desactivate;
  }

  /**
   * @brief get current limit status
   * @return currentLimitsDesactivate
   */
  double getCurrentLimitsDesactivate() const {
    return currentLimitsDesactivate_;
  }

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
   *
   * @brief evaluation F
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(propertyF_t type) override;

  /**
   * @copydoc NetworkComponent::evalZ()
   */
  NetworkComponent::StateChange_t evalZ(double t) override;

  /**
   * @brief evaluation G
   * @param t time
   */
  void evalG(double t) override;

  /**
   * @brief evaluation calculated variables (for outputs)
   */
  void evalCalculatedVars() override;

  /**
   * @brief get the index of variables used to define the jacobian associated to a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   *
   * @param numVars index of variables used to define the jacobian
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
  void evalStaticYType() override;

  /**
   * @copydoc NetworkComponent::evalDynamicYType()
   */
  void evalDynamicYType() override { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalStaticFType()
   */
  void evalStaticFType() override;

  /**
   * @copydoc NetworkComponent::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;

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
   * @brief add a bus to the neighbours
   *
   */
  void addBusNeighbors() override { /* not needed */ }

  /**
   * @brief init size
   */
  void initSize() override;

  /**
   * @copydoc NetworkComponent::evalJt(double cj, int rowOffset, SparseMatrix& jt)
   */
  void evalJt(double cj, int rowOffset, SparseMatrix& jt) override;

  /**
   * @copydoc NetworkComponent::evalJtPrim(int rowOffset, SparseMatrix& jtPrim)
   */
  void evalJtPrim(int rowOffset, SparseMatrix& jtPrim) override;

  /**
   * @brief get p
   * @return p
   */
  inline double getP() const {
    return P_;
  }

  /**
   * @brief get q
   * @return q
   */
  inline double getQ() const {
    return Q_;
  }

  /**
   * @brief get connection status
   * @return closed
   */
  inline bool getConnected() const {
    return (connectionState_ == CLOSED);
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
  std::shared_ptr<ModelCurrentLimits> currentLimits_;  ///< current limit

  /**
   * @brief get value
   * @return value
   */
  double ur_Fict() const;

  /**
   * @brief get value
   * @return value
   */
  double ui_Fict() const;

  /**
   * @brief get ir_Load value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @return value
   */
  double ir_Load(double ur, double ui) const;

  /**
   * @brief get ii_Load value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @return value
   */
  double ii_Load(double ur, double ui) const;

  /**
   * @brief get irLoad_dUr value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @return value
   */
  double irLoad_dUr(double ur, double ui) const;

  /**
   * @brief get irLoad_dUi value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @return value
   */
  double irLoad_dUi(double ur, double ui) const;

  /**
   * @brief get iiLoad_dUr value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @return value
   */
  double iiLoad_dUr(double ur, double ui) const;

  /**
   * @brief get iiLoad_dUi value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @return value
   */
  double iiLoad_dUi(double ur, double ui) const;

  // calcul
  /**
   * @brief get ir1 value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param urFict urFict
   * @param uiFict uiFict
   * @return value
   */
  double ir1(double ur, double ui, double urFict, double uiFict) const;

  /**
   * @brief get ii1 value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param urFict urFict
   * @param uiFict uiFict
   * @return value
   */
  double ii1(double ur, double ui, double urFict, double uiFict) const;

  /**
   * @brief get ir2 value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param urFict urFict
   * @param uiFict uiFict
   * @return value
   */
  double ir2(double ur, double ui, double urFict, double uiFict) const;

  /**
   * @brief get ii2 value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param urFict urFict
   * @param uiFict uiFict
   * @return value
   */
  double ii2(double ur, double ui, double urFict, double uiFict) const;

  /**
   * @brief get value
   * @return value
   */
  double i1() const;

  /**
   * @brief get value
   * @return value
   */
  double ir1_dUr() const;

  /**
   * @brief get value
   * @return value
   */
  double ir1_dUi() const;

  /**
   * @brief get value
   * @return value
   */
  double ii1_dUr() const;

  /**
   * @brief get value
   * @return value
   */
  double ii1_dUi() const;

  /**
   * @brief get value
   * @return value
   */
  double ir1_dUrFict() const;

  /**
   * @brief get value
   * @return value
   */
  double ir1_dUiFict() const;

  /**
   * @brief get value
   * @return value
   */
  double ii1_dUrFict() const;

  /**
   * @brief get value
   * @return value
   */
  double ii1_dUiFict() const;

  /**
   * @brief get value
   * @return value
   */
  double ir2_dUr() const;

  /**
   * @brief get value
   * @return value
   */
  double ir2_dUi() const;

  /**
   * @brief get value
   * @return value
   */
  double ii2_dUr() const;

  /**
   * @brief get value
   * @return value
   */
  double ii2_dUi() const;

  /**
   * @brief get value
   * @return value
   */
  double ir2_dUrFict() const;

  /**
   * @brief get value
   * @return value
   */
  double ir2_dUiFict() const;

  /**
   * @brief get value
   * @return value
   */
  double ii2_dUrFict() const;

  /**
   * @brief get value
   * @return value
   */
  double ii2_dUiFict() const;

  std::shared_ptr<ModelBus> modelBus_;  ///< bus
  State connectionState_;  ///< "internal" line connection status, evaluated at the end of evalZ to detect if the state was modified by another component
  bool stateModified_;  ///< true if the line connection state was modified
  double currentLimitsDesactivate_;  ///< current limits
  double admittance_;  ///< admittance
  double lossAngle_;  ///< loss angle
  double suscept1_;  ///< susceptance 1
  double conduct1_;  ///< conductance  1
  double suscept2_;  ///< susceptance 2
  double conduct2_;  ///< conductance 2
  double P0_;  ///< q0
  double Q0_;  ///< p0
  double ir0_;  ///< ir0
  double ii0_;  ///< ii0
  // Injections
  // matrix value
  double ir1_dUr_;  ///< matrix value
  double ir1_dUi_;  ///< matrix value
  double ii1_dUr_;  ///< matrix value
  double ii1_dUi_;  ///< matrix value
  double ir1_dUrFict_;  ///< matrix value
  double ir1_dUiFict_;  ///< matrix value
  double ii1_dUrFict_;  ///< matrix value
  double ii1_dUiFict_;  ///< matrix value
  double ir2_dUr_;  ///< matrix value
  double ir2_dUi_;  ///< matrix value
  double ii2_dUr_;  ///< matrix value
  double ii2_dUi_;  ///< matrix value
  double ir2_dUrFict_;  ///< matrix value
  double ir2_dUiFict_;  ///< matrix value
  double ii2_dUrFict_;  ///< matrix value
  double ii2_dUiFict_;  ///< matrix value

  // indices related to the node in the Jacobian
  double urFict0_;  ///< ur
  double uiFict0_;  ///< ui
  int urFictYNum_;  ///< ur fict
  int uiFictYNum_;  ///< ui fict

  // state variables
  double P_;  ///< active p
  double Q_;  ///< reactive q

  const std::string modelType_;  ///< model Type
};  ///< class for dangling line model

}  // namespace DYN
#endif  // MODELS_CPP_MODELNETWORK_DYNMODELDANGLINGLINE_H_
