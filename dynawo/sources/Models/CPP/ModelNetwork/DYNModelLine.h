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
 * @file  DYNModelLine.h
 *
 * @brief
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELLINE_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELLINE_H_

#include <boost/shared_ptr.hpp>
#include "DYNNetworkComponentImpl.h"

namespace DYN {
class ModelBus;
class LineInterface;
class ModelCurrentLimits;

/**
 * @brief Generic AC line model
 */
class ModelLine : public NetworkComponent::Impl {
 public:
  /**
   * @brief default constructor
   * @param line : line data interface to use to build the model
   */
  explicit ModelLine(const boost::shared_ptr<LineInterface>& line);

  /**
   * @brief destructor
   */
  ~ModelLine() { }

  /**
   * @brief indicate which modelBus are known (case of line without modelBus at one side)
   */
  typedef enum {
    BUS1_BUS2 = 0,
    BUS1 = 1,
    BUS2 = 2,
  } KnownBus_t;

  /**
   * @brief  calculated variables type
   */
  typedef enum {
    i1Num_ = 0,  // (unit p.u)
    i2Num_ = 1,  // (unit p.u)
    p1Num_ = 2,
    p2Num_ = 3,
    q1Num_ = 4,
    q2Num_ = 5,
    //  for current Automaton with side monitored
    iS1ToS2Side1Num_ = 6,  // current oriented from side 1 to side 2 at side 1 (unit A)
    iS2ToS1Side1Num_ = 7,  // current oriented from side 2 to side 1 at side 1 (unit A)
    iS1ToS2Side2Num_ = 8,  // current oriented from side 1 to side 2 at side 2 (unit A)
    iS2ToS1Side2Num_ = 9,  // current oriented from side 2 to side 1 at side 2 (unit A)
    iSide1Num_ = 10,  // I1 (unit A)
    iSide2Num_ = 11,  // I2 (unit A)
    u1Num_ = 12,  // voltage at side 1
    u2Num_ = 13,  // voltage at side 2
    lineStateNum_ = 14,  // state of the line (as a continuous variable)
    nbCalculatedVariables_ = 15
  } CalculatedVariables_t;

  /**
   * @brief set the connected state (fully connected, one end open, ...) of the line
   * @param state
   */
  void setConnectionState(State state) {
    connectionState_ = state;
  }  // set the connected state (fully connected, one end open, ...) of the line

  /**
   * @brief set CurrentLimits Desactivate
   * @param desactivate
   */
  void setCurrentLimitsDesactivate(const double& desactivate) {
    currentLimitsDesactivate_ = desactivate;
  }

  /**
   * @brief set the bus at end 1 of the line
   *
   * @param model model of the bus
   */
  void setModelBus1(const boost::shared_ptr<ModelBus>& model) {
    modelBus1_ = model;
  }

  /**
   * @brief set the bus at end 2 of the line
   *
   * @param model model of the bus
   */
  void setModelBus2(const boost::shared_ptr<ModelBus>& model) {
    modelBus2_ = model;
  }

  /**
   * @brief get the connected state (fully connected, one end open, ...) of the line
   * @return state
   */
  State getConnectionState() const {
    return connectionState_;
  }  // get the connected state (fully connected, one end open, ...) of the line

  /**
   * @brief get CurrentLimits Desactivate
   * @return currentLimitsDesactivate
   */
  double getCurrentLimitsDesactivate() const {
    return currentLimitsDesactivate_;
  }

  /**
   * @brief evaluate node injection
   */
  void evalNodeInjection();

  /**
   * @brief  add bus neighbours
   *
   */
  void addBusNeighbors();
  /**
   * @brief evaluate derivatives
   */
  void evalDerivatives();
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
   * @brief evalution F
   */
  void evalF() { /* not needed */ }  // get the (empty) local F function
  /**
   * @brief evalution Z
   * @param t time
   */
  void evalZ(const double& t);  // get the local Z function for time t
  /**
   * @brief evalution G
   * @param t time
   */
  void evalG(const double& t);  // get the local G function for time G
  /**
   * @brief evalution calculated variables (for outpus)
   */
  void evalCalculatedVars();  // compute calculated variables (for outputs)

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
   * @copydoc NetworkComponent::Impl::evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset)
   */
  void evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset);

  /**
   * @copydoc NetworkComponent::Impl::evalJtPrim(SparseMatrix& jt, const int& rowOffset)
   */
  void evalJtPrim(SparseMatrix& jt, const int& rowOffset);

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

  void evalYMat();

  void init(int& yNum);

  /**
   * @copydoc NetworkComponent::Impl::getY0()
   */
  void getY0();

  /**
   * @copydoc NetworkComponent::Impl::setSubModelParameters(const std::tr1::unordered_map<std::string, ParameterModeler>& params)
   */
  void setSubModelParameters(const std::tr1::unordered_map<std::string, ParameterModeler>& params);

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
  NetworkComponent::StateChange_t evalState(const double& time);  // check whether a discrete event happened
  /**
   * @brief update data
   */
  void initSize();

 private:
  KnownBus_t knownBus_;  ///< known bus
  boost::shared_ptr<ModelCurrentLimits> currentLimits1_;  ///< current limit side 1
  boost::shared_ptr<ModelCurrentLimits> currentLimits2_;  ///< current limit side 2

  /**
   * @brief compute the real part of the current on side 1
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the real part of the current on side 1
   */
  double ir1(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const;

  /**
   * @brief compute the imaginary part of the current on side 1
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the imaginary part of the current on side 1
   */
  double ii1(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const;

  /**
   * @brief compute the real part of the current on side 2
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the real part of the current on side 2
   */
  double ir2(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const;

  /**
   * @brief compute the imaginary part of the current on side 2
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the imaginary part of the current on side 2
   */
  double ii2(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const;

  /**
   * @brief comppute the magnitude of the current on side 1
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the magnitude of the current on side 1
   */
  double i1(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const;

  /**
   * @brief comppute the magnitude of the current on side 2
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the magnitude of the current on side 2
   */
  double i2(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const;

  /**
   * @brief get the partial derivative of ir1 with respect to Ur1
   * @return the partial derivative of ir1 with respect to Ur1
   */
  double ir1_dUr1() const;

  /**
   * @brief get the partial derivative of ir1 with respect to Ui1
   * @return the partial derivative of ir1 with respect to Ui1
   */
  double ir1_dUi1() const;

  /**
   * @brief get the partial derivative of ir1 with respect to Ur2
   * @return the partial derivative of ir1 with respect to Ur2
   */
  double ir1_dUr2() const;

  /**
   * @brief get the partial derivative of ir1 with respect to Ui2
   * @return the partial derivative of ir1 with respect to Ui2
   */
  double ir1_dUi2() const;

  /**
   * @brief get the partial derivative of ii1 with respect to Ur1
   * @return the partial derivative of ii1 with respect to Ur1
   */
  double ii1_dUr1() const;

  /**
   * @brief get the partial derivative of ii1 with respect to Ui1
   * @return the partial derivative of ii1 with respect to Ui1
   */
  double ii1_dUi1() const;

  /**
   * @brief get the partial derivative of ii1 with respect to Ur2
   * @return the partial derivative of ii1 with respect to Ur2
   */
  double ii1_dUr2() const;

  /**
   * @brief get the partial derivative of ii1 with respect to Ui2
   * @return the partial derivative of ii1 with respect to Ui2
   */
  double ii1_dUi2() const;

  /**
   * @brief get the partial derivative of ir2 with respect to Ur1
   * @return the partial derivative of ir2 with respect to Ur1
   */
  double ir2_dUr1() const;

  /**
   * @brief get the partial derivative of ir2 with respect to Ui1
   * @return the partial derivative of ir2 with respect to Ui1
   */
  double ir2_dUi1() const;

  /**
   * @brief get the partial derivative of ir2 with respect to Ur2
   * @return the partial derivative of ir2 with respect to Ur2
   */
  double ir2_dUr2() const;

  /**
   * @brief get the partial derivative of ir2 with respect to Ui2
   * @return the partial derivative of ir2 with respect to Ui2
   */
  double ir2_dUi2() const;

  /**
   * @brief get the partial derivative of ii2 with respect to Ur1
   * @return the partial derivative of ii2 with respect to Ur1
   */
  double ii2_dUr1() const;

  /**
   * @brief get the partial derivative of ii2 with respect to Ui1
   * @return the partial derivative of ii2 with respect to Ui1
   */
  double ii2_dUi1() const;

  /**
   * @brief get the partial derivative of ii2 with respect to Ur2
   * @return the partial derivative of ii2 with respect to Ur2
   */
  double ii2_dUr2() const;

  /**
   * @brief get the partial derivative of ii2 with respect to Ui2
   * @return the partial derivative of ii2 with respect to Ui2
   */
  double ii2_dUi2() const;

  /**
   * @brief get the real part of the voltage at side 1
   * @return  real part of the voltage at side 1
   */
  double ur1() const;

  /**
   * @brief get the imaginary part of the voltage at side 1
   * @return  imaginary part of the voltage at side 1
   */
  double ui1() const;

   /**
   * @brief get the real part of the voltage at side 2
   * @return  real part of the voltage at side 2
   */
  double ur2() const;

  /**
   * @brief get the imaginary part of the voltage at side 2
   * @return  imaginary part of the voltage at side 2
   */
  double ui2() const;

  boost::shared_ptr<ModelBus> modelBus1_;  ///< model bus  1
  boost::shared_ptr<ModelBus> modelBus2_;  ///< model bus 2
  State connectionState_;  ///< connection status
  double currentLimitsDesactivate_;  ///< current limit desactivate

  double admittance_;  ///< admittance
  double lossAngle_;  ///< loss angle
  double suscept1_;  ///< susceptance on side 1
  double suscept2_;  ///< susceptance on side 2
  double conduct1_;  ///< conductance on side 1
  double conduct2_;  ///< conductance on side 2
  // Injections
  double ir1_dUr1_;  ///< injection matrix value
  double ir1_dUi1_;  ///< injection matrix value
  double ir1_dUr2_;  ///< injection matrix value
  double ir1_dUi2_;  ///< injection matrix value
  double ii1_dUr1_;  ///< injection matrix value
  double ii1_dUi1_;  ///< injection matrix value
  double ii1_dUr2_;  ///< injection matrix value
  double ii1_dUi2_;  ///< injection matrix value
  double ir2_dUr1_;  ///< injection matrix value
  double ir2_dUi1_;  ///< injection matrix value
  double ir2_dUr2_;  ///< injection matrix value
  double ir2_dUi2_;  ///< injection matrix value
  double ii2_dUr1_;  ///< injection matrix value
  double ii2_dUi1_;  ///< injection matrix value
  double ii2_dUr2_;  ///< injection matrix value
  double ii2_dUi2_;  ///< injection matrix value
  double factorPuToA_;  ///< factor to convert current from p.u. to A

  double ir01_;  ///< initial real part of the current at side 1
  double ii01_;  ///< initial imaginary part of the current at side 1
  double ir02_;  ///< initial real part of the current at side 2
  double ii02_;  ///< initial imaginary part of the current at side 2
};
}  // namespace DYN
#endif  // MODELS_CPP_MODELNETWORK_DYNMODELLINE_H_
