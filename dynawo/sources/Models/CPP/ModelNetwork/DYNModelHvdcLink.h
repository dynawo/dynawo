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
 * @file  DYNModelHvdcLink.h
 *
 * @brief HVDC link simple model where the converters act like PQ injectors
 *
 */
//======================================================================
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELHVDCLINK_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELHVDCLINK_H_

#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>

#include "DYNNetworkComponent.h"
#include "DYNHvdcLineInterface.h"

namespace DYN {
class ModelBus;
class VscConverterInterface;
class LccConverterInterface;

/**
 * @brief HVDC link component
 */
class ModelHvdcLink : public NetworkComponent {
 public:
  /**
   * @brief default constructor for hvdc-vsc link
   * @param dcLine dc line interface used to represent the dc line of the hvdc link
   */
  explicit ModelHvdcLink(const std::shared_ptr<HvdcLineInterface>& dcLine);

  /**
   * @brief list of calculated variables indexes
   */
  typedef enum {
    p1Num_ = 0,  // index of calculated variable P1_
    q1Num_ = 1,  // index of calculated variable Q1_
    p2Num_ = 2,  // index of calculated variable P2_
    q2Num_ = 3,  // index of calculated variable Q2_
    nbCalculatedVariables_ = 4
  } CalculatedVariables_t;

  /**
   * @brief index discrete variable
   */
  typedef enum {
    state1Num_ = 0,
    state2Num_ = 1
  } IndexDiscreteVariable_t;

  /**
   * @brief set indexes of state variable
   * @param yNum : global offset in the whole vector of state variable
   */
  void init(int& yNum) override;

  /**
   * @brief init size
   */
  void initSize() override;

  /**
   * @copydoc NetworkComponent::getY0()
   */
  void getY0() override;

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
   * @copydoc NetworkComponent::evalDynamicFType()
   */
  void evalDynamicFType() override { /* not needed */ }

  /**
   * @copydoc NetworkComponent::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;

  /**
   * @brief init size
   */
  void evalYMat() override { /* not needed */ }

  /**
   * @copydoc NetworkComponent::setFequations( std::map<int,std::string>& fEquationIndex )
   */
  void setFequations(std::map<int, std::string>& fEquationIndex) override;

  /**
   * @copydoc NetworkComponent::evalF(propertyF_t type)
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
   * @copydoc NetworkComponent::evalZ()
   */
  NetworkComponent::StateChange_t evalZ(double t, bool deactivateRootFunctions) override;

  /**
   * @copydoc NetworkComponent::setGequations( std::map<int,std::string>& gEquationIndex )
   */
  void setGequations(std::map<int, std::string>& gEquationIndex) override;

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
   * @param numCalculatedVar index of the calculated variable
   * @param numVars index of variables used to define the jacobian associated to a calculated variable
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, std::vector<int> & numVars) const override;

  /**
   * @brief evaluate the jacobian associated to a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned numCalculatedVar, std::vector<double> & res) const override;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   *
   * @return value of the calculated variable
   */
  double evalCalculatedVarI(unsigned numCalculatedVar) const override;

  /**
   * @brief evaluate state
   * @param time time
   * @return state change type
   */
  NetworkComponent::StateChange_t evalState(double time) override;

  /**
   * @brief evaluate node injection
   */
  void evalNodeInjection() override;

  /**
   * @brief reset node injection
   */
  void resetNodeInjection() { /* not needed */ }

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
  void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) override;

  /**
   * @copydoc NetworkComponent::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params)
   */
  void setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) override;

  /**
   * @brief addBusNeighbors
   */
  void addBusNeighbors() override { /* not needed */ }

  /**
   * @brief get connection status
   * @return connection status
   */
  inline State getConnected1() const {
    return connectionState1_;
  }

  /**
   * @brief get connection status
   * @return connection status
   */
  inline State getConnected2() const {
    return connectionState2_;
  }

  /**
   * @brief check whether the svc is connected to the bus
   * @return @b True if the svc is connected, @b false else
   */
  inline bool isConnected1() const {
    return (connectionState1_ == CLOSED);
  }

  /**
   * @brief check whether the svc is connected to the bus
   * @return @b True if the svc is connected, @b false else
   */
  inline bool isConnected2() const {
    return (connectionState2_ == CLOSED);
  }

  /**
   * @brief set connection status
   * @param state connection status
   */
  void setConnected1(const State state) {
    connectionState1_ = state;
  }

  /**
   * @brief set connection status
   * @param state connection status
   */
  void setConnected2(const State state) {
    connectionState2_ = state;
  }

  /**
   * @brief set the bus to which the converter1 is connected
   *
   * @param model model of the bus
   */
  void setModelBus1(const std::shared_ptr<ModelBus>& model) {
    modelBus1_ = model;
  }

  /**
   * @brief get the bus to which the converter1 is connected
   *
   * @return model model of the bus
   */
  inline const std::shared_ptr<ModelBus>& getModelBus1() {
    return modelBus1_;
  }

  /**
   * @brief set the bus to which the converter2 is connected
   *
   * @param model model of the bus
   */
  void setModelBus2(const std::shared_ptr<ModelBus>& model) {
    modelBus2_ = model;
  }

  /**
   * @brief get the bus to which the converter2 is connected
   *
   * @return model model of the bus
   */
  inline const std::shared_ptr<ModelBus>& getModelBus2() {
    return modelBus2_;
  }

  /**
   * @brief get the number of internal variable of the model
   *
   * @return the number of internal variable of the model
   */
  inline unsigned getNbInternalVariables() const override {
    return 8;
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
   * @brief set attributes for hvdc link
   * @param dcLine dc line interface used to represent the dc line of the hvdc link
   */
  void setAttributes(const std::shared_ptr<HvdcLineInterface>& dcLine);

  /**
   * @brief setter for the active power at the two points of common coupling
   * @param dcLine dc line interface used to represent the dc line of the hvdc link
   */
  void setConvertersActivePower(const std::shared_ptr<HvdcLineInterface>& dcLine);

  /**
   * @brief setter for the reactive power at the two points of common coupling (for VSC)
   * @param dcLine dc line interface used to represent the dc line of the hvdc link
   */
  void setConvertersReactivePower(const std::shared_ptr<HvdcLineInterface>& dcLine);

  /**
   * @brief getter for the active power value at the point of common coupling 1
   * @return active power value at the point of common coupling 1
   */
  double getP1() const;

  /**
   * @brief getter for active power value at the point of common coupling 2
   * @return active power value at the point of common coupling 2
   */
  double getP2() const;

  /**
   * @brief getter for the reactive power value at the point of common coupling 1
   * @return reactive power value at the point of common coupling 1
   */
  double getQ1() const;

  /**
   * @brief getter for reactive power value at the point of common coupling 2
   * @return reactive power value at the point of common coupling 2
   */
  double getQ2() const;

  /**
   * @brief compute value
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param U1_2 square of the voltage1
   * @return value
   */
  double ir1(double ur1, double ui1, double U1_2) const;

  /**
   * @brief compute value
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param U1_2 square of the voltage1
   * @return value
   */
  double ii1(double ur1, double ui1, double U1_2) const;

  /**
   * @brief compute value
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @param U2_2 square of the voltage2
   * @return value
   */
  double ir2(double ur2, double ui2, double U2_2) const;

  /**
   * @brief compute value
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @param U2_2 square of the voltage2
   * @return value
   */
  double ii2(double ur2, double ui2, double U2_2) const;

  /**
   * @brief compute value
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param U1_2 square of the voltage1
   * @return value
   */
  double ir1_dUr(double ur1, double ui1, double U1_2) const;

  /**
   * @brief compute value
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param U1_2 square of the voltage1
   * @return value
   */
  double ii1_dUr(double ur1, double ui1, double U1_2) const;

  /**
   * @brief compute value
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param U1_2 square of the voltage1
   * @return value
   */
  double ir1_dUi(double ur1, double ui1, double U1_2) const;

  /**
   * @brief compute value
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param U1_2 square of the voltage1
   * @return value
   */
  double ii1_dUi(double ur1, double ui1, double U1_2) const;

  /**
   * @brief compute value
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @param U2_2 square of the voltage2
   * @return value
   */
  double ir2_dUr(double ur2, double ui2, double U2_2) const;

  /**
   * @brief compute value
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @param U2_2 square of the voltage2
   * @return value
   */
  double ii2_dUr(double ur2, double ui2, double U2_2) const;

  /**
   * @brief compute value
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @param U2_2 square of the voltage2
   * @return value
   */
  double ir2_dUi(double ur2, double ui2, double U2_2) const;

  /**
   * @brief compute value
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @param U2_2 square of the voltage2
   * @return value
   */
  double ii2_dUi(double ur2, double ui2, double U2_2) const;

 private:
  std::weak_ptr<HvdcLineInterface> dcLine_;  ///< reference to the hvdc line interface object

  std::shared_ptr<ModelBus> modelBus1_;  ///< model bus at point of common coupling 1
  std::shared_ptr<ModelBus> modelBus2_;  ///< model bus at point of common coupling 2

  double pSetPoint_;  ///< active power set-point for the link in MW

  double vdcNom_;  ///< nominal voltage on the dc line in kV

  double lossFactor1_;  ///< loss factor for converter 1 in pu
  double lossFactor2_;  ///< loss factor for converter 2 in pu

  HvdcLineInterface::ConverterMode_t converterMode_;  ///< mode of converters (rectifier or inverter)

  double rdc_;  ///< resistance of the dc line in ohm

  State connectionState1_;  ///< "internal" link connection status at point of common coupling 1
  State connectionState2_;  ///< "internal" link connection status at point of common coupling 2
  bool stateModified_;  ///< true if at least one of the link connection states was modified

  double P01_;  ///< initial active power at point of common coupling 1 in pu (generator convention)
  double P02_;  ///< initial active power at point of common coupling 2 in pu (generator convention)
  double Q01_;  ///< initial reactive power at point of common coupling 1 in pu (generator convention)
  double Q02_;  ///< initial reactive power at point of common coupling 1 in pu (generator convention)
  double ir01_;  ///< initial current real part at point of common coupling 1
  double ii01_;  ///< initial current imaginary part at point of common coupling 1
  double ir02_;  ///< initial current real part at point of common coupling 2
  double ii02_;  ///< initial current imaginary part at point of common coupling 2
  startingPointMode_t startingPointMode_;  ///< type of starting point for the model (FLAT,WARM)
};  ///< class for Hvdc link model in network

}  // namespace DYN


#endif  // MODELS_CPP_MODELNETWORK_DYNMODELHVDCLINK_H_
