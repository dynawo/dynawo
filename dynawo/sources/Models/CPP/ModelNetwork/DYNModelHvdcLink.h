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

#include <boost/shared_ptr.hpp>
#include "DYNNetworkComponentImpl.h"
#include "DYNHvdcLineInterface.h"

namespace DYN {
class ModelBus;
class VscConverterInterface;
class LccConverterInterface;

class ModelHvdcLink : public NetworkComponent::Impl {
 public:
  /**
   * @brief default constructor for hvdc-vsc link
   * @param vsc1 vsc converter interface used to represent vsc converter 1 of the hvdc link
   * @param vsc2 vsc converter interface used to represent vsc converter 2 of the hvdc link
   * @param dcLine dc line interface used to represent the dc line of the hvdc link
   */
  ModelHvdcLink(const boost::shared_ptr<VscConverterInterface>& vsc1, const boost::shared_ptr<VscConverterInterface>& vsc2,
                const boost::shared_ptr<HvdcLineInterface>& dcLine);

  /**
   * @brief default constructor for hvdc-lcc link
   * @param lcc1 lcc converter interface used to represent lcc converter 1 of the hvdc link
   * @param lcc2 lcc converter interface used to represent lcc converter 2 of the hvdc link
   * @param dcLine dc line interface used to represent the dc line of the hvdc link
   */
  ModelHvdcLink(const boost::shared_ptr<LccConverterInterface>& lcc1, const boost::shared_ptr<LccConverterInterface>& lcc2,
                const boost::shared_ptr<HvdcLineInterface>& dcLine);

  /**
   * @brief destructor
   */
  ~ModelHvdcLink() { }

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
   * @brief set indexes of state variable
   * @param yNum : global offset in the whole vector of state variable
   */
  void init(int & yNum);

  /**
   * @brief init size
   */
  void initSize();

  /**
   * @copydoc NetworkComponent::getY0()
   */
  void getY0();

  /**
   * @copydoc NetworkComponent::evalYType()
   */
  void evalYType();

  /**
   * @copydoc NetworkComponent::evalFType()
   */
  void evalFType();

  /**
   * @brief init size
   */
  void evalYMat() { /* not needed */ }

  /**
   * @copydoc NetworkComponent::setFequations( std::map<int,std::string>& fEquationIndex )
   */
  void setFequations(std::map<int, std::string>& fEquationIndex);

  /**
   * @copydoc NetworkComponent::Impl::evalF()
   */
  void evalF();

  /**
   * @copydoc NetworkComponent::Impl::evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset)
   */
  void evalJt(SparseMatrix &jt, const double& cj, const int& rowOffset);

  /**
   * @copydoc NetworkComponent::Impl::evalJtPrim(SparseMatrix& jt, const int& rowOffset)
   */
  void evalJtPrim(SparseMatrix& jt, const int& rowOffset);

  /**
   * @copydoc NetworkComponent::Impl::evalZ()
   */
  NetworkComponent::StateChange_t evalZ(const double& t);

  /**
   * @copydoc NetworkComponent::setGequations( std::map<int,std::string>& gEquationIndex )
   */
  void setGequations(std::map<int, std::string>& gEquationIndex);

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
   * @param numCalculatedVar index of the calculated variable
   * @param numVars index of variables used to define the jacobian associated to a calculated variable
   */
  void getDefJCalculatedVarI(int numCalculatedVar, std::vector<int> & numVars);

  /**
   * @brief evaluate the jacobian associated to a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @param y value of the variable used to calculate the jacobian
   * @param yp value of the derivatives of variable used to calculate the jacobian
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(int numCalculatedVar, double* y, double* yp, std::vector<double> & res);

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
   * @brief evaluate state
   * @param time
   * @return state change type
   */
  NetworkComponent::StateChange_t evalState(const double& time);

  /**
   * @brief evaluate node injection
   */
  void evalNodeInjection();

  /**
   * @brief reset node injection
   */
  void resetNodeInjection() { /* not needed */ }

  /**
   * @brief evaluate derivatives
   */
  void evalDerivatives(const double& cj);

  void evalDerivativesPrim() {}

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
  void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement);

  /**
   * @copydoc NetworkComponent::Impl::setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& params)
   */
  void setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& params);

  /**
   * @brief addBusNeighbors
   */
  void addBusNeighbors();

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
   * @param state
   */
  void setConnected1(State state) {
    connectionState1_ = state;
  }

  /**
   * @brief set connection status
   * @param state
   */
  void setConnected2(State state) {
    connectionState2_ = state;
  }

  /**
   * @brief set the bus to which the converter1 is connected
   *
   * @param model model of the bus
   */
  void setModelBus1(const boost::shared_ptr<ModelBus>& model) {
    modelBus1_ = model;
  }

  /**
   * @brief get the bus to which the converter1 is connected
   *
   * @return model model of the bus
   */
  inline const boost::shared_ptr<ModelBus>& getModelBus1() {
    return modelBus1_;
  }

  /**
   * @brief set the bus to which the converter2 is connected
   *
   * @param model model of the bus
   */
  void setModelBus2(const boost::shared_ptr<ModelBus>& model) {
    modelBus2_ = model;
  }

  /**
   * @brief get the bus to which the converter2 is connected
   *
   * @return model model of the bus
   */
  inline const boost::shared_ptr<ModelBus>& getModelBus2() {
    return modelBus2_;
  }

 protected:
  /**
   * @brief set attributes for hvdc link
   * @param conv1 converter interface used to represent converter 1 of the hvdc link
   * @param conv2 converter interface used to represent converter 2 of the hvdc link
   * @param dcLine dc line interface used to represent the dc line of the hvdc link
   */
  template <class T> void setAttributes(const boost::shared_ptr<T>& conv1, const boost::shared_ptr<T>& conv2,
                                        const boost::shared_ptr<HvdcLineInterface>& dcLine);

  /**
   * @brief setter for the active power at the two points of common coupling
   * @param conv1 converter interface used to represent converter 1 of the hvdc link
   * @param conv2 converter interface used to represent converter 2 of the hvdc link
   */
  template <class T> void setConvertersActivePower(const boost::shared_ptr<T>& conv1, const boost::shared_ptr<T>& conv2);

 private:
  /**
   * @brief setter for the reactive power at the two points of common coupling (for VSC)
   * @param vsc1 converter interface used to represent converter 1 of the hvdc link
   * @param vsc2 converter interface used to represent converter 2 of the hvdc link
   */
  void setConvertersReactivePowerVsc(const boost::shared_ptr<VscConverterInterface>& vsc1, const boost::shared_ptr<VscConverterInterface>& vsc2);

  /**
   * @brief setter for the reactive power at the two points of common coupling (for LCC)
   * @param lcc1 converter interface used to represent converter 1 of the hvdc link
   * @param lcc2 converter interface used to represent converter 2 of the hvdc link
   */
  void setConvertersReactivePowerLcc(const boost::shared_ptr<LccConverterInterface>& lcc1, const boost::shared_ptr<LccConverterInterface>& lcc2);

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
  double ir1(const double& ur1, const double& ui1, const double& U1_2) const;

  /**
   * @brief compute value
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param U1_2 square of the voltage1
   * @return value
   */
  double ii1(const double& ur1, const double& ui1, const double& U1_2) const;

  /**
   * @brief compute value
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @param U2_2 square of the voltage2
   * @return value
   */
  double ir2(const double& ur2, const double& ui2, const double& U2_2) const;

  /**
   * @brief compute value
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @param U2_2 square of the voltage2
   * @return value
   */
  double ii2(const double& ur2, const double& ui2, const double& U2_2) const;

  /**
   * @brief compute value
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param U1_2 square of the voltage1
   * @return value
   */
  double ir1_dUr(const double& ur1, const double& ui1, const double& U1_2) const;

  /**
   * @brief compute value
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param U1_2 square of the voltage1
   * @return value
   */
  double ii1_dUr(const double& ur1, const double& ui1, const double& U1_2) const;

  /**
   * @brief compute value
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param U1_2 square of the voltage1
   * @return value
   */
  double ir1_dUi(const double& ur1, const double& ui1, const double& U1_2) const;

  /**
   * @brief compute value
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param U1_2 square of the voltage1
   * @return value
   */
  double ii1_dUi(const double& ur1, const double& ui1, const double& U1_2) const;

  /**
   * @brief compute value
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @param U2_2 square of the voltage2
   * @return value
   */
  double ir2_dUr(const double& ur2, const double& ui2, const double& U2_2) const;

  /**
   * @brief compute value
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @param U2_2 square of the voltage2
   * @return value
   */
  double ii2_dUr(const double& ur2, const double& ui2, const double& U2_2) const;

  /**
   * @brief compute value
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @param U2_2 square of the voltage2
   * @return value
   */
  double ir2_dUi(const double& ur2, const double& ui2, const double& U2_2) const;

  /**
   * @brief compute value
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @param U2_2 square of the voltage2
   * @return value
   */
  double ii2_dUi(const double& ur2, const double& ui2, const double& U2_2) const;

  boost::shared_ptr<ModelBus> modelBus1_;  ///< model bus at point of common coupling 1
  boost::shared_ptr<ModelBus> modelBus2_;  ///< model bus at point of common coupling 2

  double pSetPoint_;  ///< active power set-point for the link in MW

  double vdcNom_;  ///< nominal voltage on the dc line in kV

  double lossFactor1_;  ///< loss factor for converter 1 in pu
  double lossFactor2_;  ///< loss factor for converter 2 in pu

  HvdcLineInterface::ConverterMode_t converterMode_;  ///< mode of converters (rectifier or inverter)

  double rdc_;  ///< resistance of the dc line in Ohm

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
};  ///< class for Hvdc link model in network

template <class T>
void ModelHvdcLink::setAttributes(const boost::shared_ptr<T>& conv1, const boost::shared_ptr<T>& conv2, const boost::shared_ptr<HvdcLineInterface>& dcLine) {
  // retrieve data from VscConverterInterface or LccConverterInterface (IIDM)
  lossFactor1_ = conv1->getLossFactor() / 100.;
  lossFactor2_ = conv2->getLossFactor() / 100.;
  connectionState1_ = conv1->getInitialConnected() ? CLOSED : OPEN;
  connectionState2_ = conv2->getInitialConnected() ? CLOSED : OPEN;

  // retrieve data from HvdcLineInterface (IIDM)
  vdcNom_ = dcLine->getVNom();
  pSetPoint_ = dcLine->getActivePowerSetpoint();
  converterMode_ = dcLine->getConverterMode();
  rdc_ = dcLine->getResistanceDC();
}

template <class T>
void ModelHvdcLink::setConvertersActivePower(const boost::shared_ptr<T>& conv1, const boost::shared_ptr<T>& conv2) {
  if (conv1->hasP() && conv2->hasP()) {
    // retrieve active power at the two points of common coupling from load flow data in IIDM file
    P01_ = -conv1->getP() / SNREF;
    P02_ = -conv2->getP() / SNREF;
  } else {
    // calculate losses on dc line
    double PdcLoss = rdc_ * (pSetPoint_ / vdcNom_) * (pSetPoint_ / vdcNom_) / SNREF;  // in pu

    // calculate active power at the two points of common coupling (generator convention)
    double P0dc = pSetPoint_ / SNREF;  // in pu
    if (converterMode_ == HvdcLineInterface::RECTIFIER_INVERTER) {
      P01_ = -P0dc;  // RECTIFIER (absorbs power from the grid)
      P02_ = ((P0dc * (1 - lossFactor1_)) - PdcLoss) * (1. - lossFactor2_);  // INVERTER (injects power to the grid)
    } else {   // converterMode_ == HvdcLineInterface::INVERTER_RECTIFIER
      P01_ = ((P0dc * (1 - lossFactor2_)) - PdcLoss) * (1. - lossFactor1_);  // INVERTER (injects power to the grid)
      P02_ = -P0dc;  // RECTIFIER (absorbs power from the grid)
    }
  }
}
}  // namespace DYN


#endif  // MODELS_CPP_MODELNETWORK_DYNMODELHVDCLINK_H_
