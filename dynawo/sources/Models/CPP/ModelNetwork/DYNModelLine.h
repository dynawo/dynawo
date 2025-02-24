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
#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>

#include "DYNNetworkComponent.h"

namespace DYN {
class ModelBus;
class LineInterface;
class ModelCurrentLimits;

/**
 * @brief Generic AC line model
 */
class ModelLine : public NetworkComponent {
 public:
  /**
   * @brief default constructor
   * @param line : line data interface to use to build the model
   */
  explicit ModelLine(const std::shared_ptr<LineInterface>& line);

  /**
   * @brief indicate which modelBus are known (case of line without modelBus at one side)
   */
  typedef enum {
    BUS1_BUS2 = 0,
    BUS1 = 1,
    BUS2 = 2
  } KnownBus_t;

  /**
   * @brief  calculated variables type
   */
  typedef enum {
    i1Num_ = 0,  // (unit pu)
    i2Num_ = 1,  // (unit pu)
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
   * @param state connected state
   */
  void setConnectionState(const State state) {
    connectionState_ = state;
  }  // set the connected state (fully connected, one end open, ...) of the line

  /**
   * @brief set CurrentLimits Desactivate
   * @param desactivate CurrentLimits Desactivate
   */
  void setCurrentLimitsDesactivate(const double desactivate) {
    currentLimitsDesactivate_ = desactivate;
  }

  /**
   * @brief set the bus at end 1 of the line
   *
   * @param model model of the bus
   */
  void setModelBus1(const std::shared_ptr<ModelBus>& model) {
    modelBus1_ = model;
  }

  /**
   * @brief set the bus at end 2 of the line
   *
   * @param model model of the bus
   */
  void setModelBus2(const std::shared_ptr<ModelBus>& model) {
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
  void evalNodeInjection() override;

  /**
   * @brief  add bus neighbors
   *
   */
  void addBusNeighbors() override;

  /**
   * @brief evaluate derivatives
   * @param cj Jacobian prime coefficient
   */
  void evalDerivatives(double cj) override;

  /**
   * @brief evaluate derivatives prim
   */
  void evalDerivativesPrim() override;

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
   * @brief evaluation F
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(propertyF_t type) override;

  /**
  * @copydoc NetworkComponent::evalZ()
  */
  NetworkComponent::StateChange_t evalZ(double t, bool deactivateRootFunctions) override;  // get the local Z function for time t

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
   * @copydoc NetworkComponent::evalJt(double cj, int rowOffset, SparseMatrix& jt)
   */
  void evalJt(double cj, int rowOffset, SparseMatrix& jt) override;

  /**
   * @copydoc NetworkComponent::evalJtPrim(int rowOffset, SparseMatrix& jtPrim)
   */
  void evalJtPrim(int rowOffset, SparseMatrix& jtPrim) override;

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
  void evalDynamicYType() override;

  /**
   * @copydoc NetworkComponent::evalStaticFType()
   */
  void evalStaticFType() override;

  /**
   * @copydoc NetworkComponent::evalDynamicFType()
   */
  void evalDynamicFType() override;

  /**
   * @copydoc NetworkComponent::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;

  /**
   * @copydoc NetworkComponent::evalYMat()
   */
  void evalYMat() override;

  /**
   * @copydoc NetworkComponent::init(int& yNum)
   */
  void init(int & yNum) override;

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
  StateChange_t evalState(double time) override;  // check whether a discrete event happened

  /**
   * @brief update data
   */
  void initSize() override;

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

  /**
  * @brief write initial values internal parameters of a model in a file
  *
  * @param fstream the file to stream parameters to
  */
  void printInternalParameters(std::ofstream& fstream) const override;

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
  inline double ir1(double ur1, double ui1, double ur2, double ui2) const {
   return ir1_dUr1_ * ur1 + ir1_dUi1_ * ui1 + ir1_dUr2_ * ur2 + ir1_dUi2_ * ui2;
 }

  /**
   * @brief compute the imaginary part of the current on side 1
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the imaginary part of the current on side 1
   */
 double ii1(const double ur1, const double ui1, const double ur2, const double ui2) const {
   return ii1_dUr1_ * ur1 + ii1_dUi1_ * ui1 + ii1_dUr2_ * ur2 + ii1_dUi2_ * ui2;
  }

  /**
   * @brief compute the real part of the current on side 2
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the real part of the current on side 2
   */
 double ir2(const double ur1, const double ui1, const double ur2, const double ui2) const {
   return ir2_dUr1_ * ur1 + ir2_dUi1_ * ui1 + ir2_dUr2_ * ur2 + ir2_dUi2_ * ui2;
  }

  /**
   * @brief compute the imaginary part of the current on side 2
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the imaginary part of the current on side 2
   */
 double ii2(const double ur1, const double ui1, const double ur2, const double ui2) const {
   return ii2_dUr1_ * ur1 + ii2_dUi1_ * ui1 + ii2_dUr2_ * ur2 + ii2_dUi2_ * ui2;
  }

  /**
   * @brief compute the magnitude of the current on side 1
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the magnitude of the current on side 1
   */
  double i1(double ur1, double ui1, double ur2, double ui2) const;

  /**
   * @brief compute the magnitude of the current on side 2
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the magnitude of the current on side 2
   */
  double i2(double ur1, double ui1, double ur2, double ui2) const;

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
   * @return real part of the voltage at side 1
   */
  double ur1() const;

  /**
   * @brief get the imaginary part of the voltage at side 1
   * @return imaginary part of the voltage at side 1
   */
  double ui1() const;

  /**
   * @brief get the real part of the voltage derivative at side 1
   * @return real part of the voltage derivative at side 1
   */
  double urp1() const;

  /**
   * @brief get the imaginary part of the voltage derivative at side 1
   * @return imaginary part of the voltage derivative at side 1
   */
  double uip1() const;

   /**
   * @brief get the real part of the voltage at side 2
   * @return real part of the voltage at side 2
   */
  double ur2() const;

  /**
   * @brief get the imaginary part of the voltage at side 2
   * @return imaginary part of the voltage at side 2
   */
  double ui2() const;

  /**
   * @brief get the real part of the voltage derivative at side 2
   * @return real part of the voltage derivative at side 2
   */
  double urp2() const;

  /**
   * @brief get the imaginary part of the voltage derivative at side 2
   * @return imaginary part of the voltage derivative at side 2
   */
  double uip2() const;

  /**
   * @brief compute the global Y index inside the Y matrix
   * @param localIndex the local variable index inside the model
   * @return the global variable index
   */
  inline unsigned int globalYIndex(const unsigned int localIndex) const {
    return yOffset_ + localIndex;
  }

  std::shared_ptr<ModelBus> modelBus1_;  ///< model bus 1
  std::shared_ptr<ModelBus> modelBus2_;  ///< model bus 2
  State connectionState_;  ///< "internal" line connection status, evaluated at the end of evalZ to detect if the state was modified by another component
  bool topologyModified_;  ///< true if the line connection state was modified
  bool updateYMat_;  ///< true if the YMat need to be updated(= topologyModified)
  double currentLimitsDesactivate_;  ///< current limit desactivate
  bool isDynamic_;  ///< true if the line model is dynamic

  double admittance_;  ///< admittance
  double lossAngle_;  ///< loss angle
  double suscept1_;  ///< susceptance on side 1
  double suscept2_;  ///< susceptance on side 2
  double conduct1_;  ///< conductance on side 1
  double conduct2_;  ///< conductance on side 2
  double resistance_;  ///< resistance
  double reactance_;  ///< reactance
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
  double factorPuToA_;  ///< factor to convert current from pu to A

  double ir01_;  ///< initial real part of the current at side 1
  double ii01_;  ///< initial imaginary part of the current at side 1
  double ir02_;  ///< initial real part of the current at side 2
  double ii02_;  ///< initial imaginary part of the current at side 2

  unsigned int yOffset_;  ///< global Y offset at the beginning of the line model
  unsigned int IbReNum_;  ///< local Y index for IBranch_re
  unsigned int IbImNum_;  ///< local Y index for IBranch_im
  unsigned int omegaRefNum_;  ///< local Y index for omegaRef

  double omegaNom_;  ///< nominal angular frequency
  double omegaRef_;  ///< reference angular frequency in pu
  const std::string modelType_;  ///< model Type
};
}  // namespace DYN
#endif  // MODELS_CPP_MODELNETWORK_DYNMODELLINE_H_
