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
 * @file  DYNModelTwoWindingsTransformer.h
 *
 * @brief Model used for two windings transformer : header file
 *
 *  The equivalent π model used is:
 *
 * 1                            2
 * o-----ρejα-----+-----r+jx-----o
 *                |
 *               g+jb
 *                |
 *                v
 *
 * b, g, r, x shall be specified at the side 2 voltage.
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELTWOWINDINGSTRANSFORMER_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELTWOWINDINGSTRANSFORMER_H_
#include <sstream>

#include <boost/shared_ptr.hpp>
#include "DYNNetworkComponent.h"

namespace DYN {
class ModelBus;
class ModelRatioTapChanger;
class ModelPhaseTapChanger;
class ModelTapChanger;
class TwoWTransformerInterface;
class ModelCurrentLimits;

/**
 * @brief ModelTwoWindingsTransformer class
 */
class ModelTwoWindingsTransformer : public NetworkComponent {
 public:
  /**
   * @brief default constructor
   * @param tfo : two windings transformer data interface used to build the model
   */
  explicit ModelTwoWindingsTransformer(const std::shared_ptr<TwoWTransformerInterface>& tfo);

  /**
   * @brief  indicate which modelBus are known (case of line without modelBus at one side)
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
    iSide1Num_ = 10,  // (max I1 and -1*I1, unit A => equivalent of the absolute value of I1)
    iSide2Num_ = 11,  // (max I2 and -1*I2, unit A => equivalent of the absolute value of I2)
    twtStateNum_ = 12,  // state of the 2wt (as a continuous variable)
    nbCalculatedVariables_ = 13
  } CalculatedVariables_t;  // enumeration of calculated variables which can be retrieved for this model

  /**
   * @brief index discrete variable
   */
  typedef enum {
    connectionStateNum_ = 0,
    currentStepIndexNum_ = 1,
    currentLimitsDesactivateNum_ = 2,
    disableInternalTapChangerNum_ = 3,
    tapChangerLockedNum_ = 4,
    deltaUTarget = 5
  } IndexDiscreteVariable_t;

  /**
   * @brief set the connection state (open, closed on one side, ...)
   * @param state connection state
   */
  void setConnectionState(const State state) {
    connectionState_ = state;
  }  // set the connection state (open, closed on one side, ...)

  /**
   * @brief set the tap-changer model used along with the transformer
   * @param model tap-changer model
   */
  void setModelTapChanger(const boost::shared_ptr<ModelTapChanger>& model) {
    modelTapChanger_ = model;
  }  // set the tap-changer model used along with the transformer

  /**
   * @brief set the bus at end 1 of the transformer
   *
   * @param model model of the bus
   */
  void setModelBus1(const std::shared_ptr<ModelBus>& model) {
    modelBus1_ = model;
  }

  /**
   * @brief set the bus at end 2 of the transformer
   *
   * @param model model of the bus
   */
  void setModelBus2(const std::shared_ptr<ModelBus>& model) {
    modelBus2_ = model;
  }

  /**
   * @brief set monitoring bus
   * @param modelBus monitored bus model
   */
  void setBusMonitored(const std::shared_ptr<ModelBus>& modelBus) {
    modelBusMonitored_ = modelBus;
  }

  /**
   * @brief get the connection state (open, closed on one side, ...)
   * @return state
   */
  State getConnectionState() const {
    return connectionState_;
  }  ///< get the connection state (open, closed on one side, ...)

  /**
   * @brief get the ratio tap-changer model used along with the transformer
   * @return the ratio tap changer model used if it exists
   */
  const boost::shared_ptr<ModelRatioTapChanger>& getModelRatioTapChanger() const {
    return modelRatioChanger_;
  }

  /**
   * @brief get the phase tap-changer model used along with the transformer
   * @return the phase tap changer model used if it exists
   */
  const boost::shared_ptr<ModelPhaseTapChanger>& getModelPhaseTapChanger() const {
    return modelPhaseChanger_;
  }

  /**
   * @brief get the generic tap-changer model used along with the transformer
   * @return generic model of  tap changer
   */
  const boost::shared_ptr<ModelTapChanger>& getModelTapChanger() const {
    return modelTapChanger_;
  }

  /**
   * @brief set whether the current limit automaton is deactivated
   * @param desactivate whether the current limit automaton is deactivated
   */
  void setCurrentLimitsDesactivate(const double& desactivate) {
    currentLimitsDesactivate_ = desactivate;
  }  // set whether the current limit automaton is deactivated

  /**
   * @brief get whether the current limit automaton is deactivated
   * @return currentLimitsDesactivate
   */
  double getCurrentLimitsDesactivate() const {
    return currentLimitsDesactivate_;
  }  // get whether the current limit automaton is deactivated

  /**
   * @brief set whether to rely on an internal (or external) tap-changer model
   * @param disable whether to rely on an internal (or external) tap-changer model
   */
  void setDisableInternalTapChanger(const double& disable) {
    disableInternalTapChanger_ = disable;
  }  // set whether to rely on an internal (or external) tap-changer model

  /**
   * @brief get whether to rely on an internal (or external) tap-changer model
   * @return whether to rely on an internal (or external) tap-changer model
   */
  double getDisableInternalTapChanger() const {
    return disableInternalTapChanger_;
  }  // get whether to rely on an internal (or external) tap-changer model

  /**
   * @brief  set whether the tap-changer is locked (and cannot change taps)
   * @param  locked whether the tap-changer is locked
   */
  void setTapChangerLocked(const double& locked) {
    tapChangerLocked_ = locked;
  }   // set whether the tap-changer is locked (and cannot change taps)

  /**
   * @brief get whether the tap-changer is locked (and cannot change taps)
   * @return tap changer locked or not
   */
  double getTapChangerLocked() const {
    return tapChangerLocked_;
  }

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
   * @brief evaluate node injection
   */
  void evalNodeInjection() override;

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
   * @copydoc NetworkComponent::evalZ(double t)
   */
  NetworkComponent::StateChange_t evalZ(double t, bool deactivateRootFunctions) override;  // compute the Z function

  /**
   * @brief evaluation G
   * @param t time
   */
  void evalG(double t) override;  // compute the G function

  /**
   * @brief evaluation calculated variables (for outputs)
   */
  void evalCalculatedVars() override;  // compute calculated variables (for outputs)

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
   * @copydoc NetworkComponent::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;

  /**
   * @brief evaluate the term of the jacobian
   */
  void evalYMat() override;

  /**
   * @brief init
   * @param yNum yNum
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
  void addBusNeighbors() override;

  /**
   * @brief init size
   */
  void initSize() override;

  /**
   * @brief  get the current tap-changer tap index
   * @return value
   */
  inline int getTapChangerIndex() const {
    return tapChangerIndex_;
  }

  /**
   * @brief  get the id of the terminal where the voltage is measured (used for ratio tap changer model)
   * @return name of the terminal where the voltage is measured
   */
  inline std::string getTerminalRefId() const {
    return terminalRefId_;
  }

  /**
   * @brief  get side of the terminal where the voltage is measured
   * @return side of the terminal
   */
  inline std::string getSide() const {
    return side_;
  }

  /**
  * @brief write initial values internal parameters of a model in a file
  *
  * @param fstream the file to stream parameters to
  */
  void printInternalParameters(std::ofstream& fstream) const override;

  /**
   * @brief get the number of internal variable of the model
   *
   * @return the number of internal variable of the model
   */
  unsigned getNbInternalVariables() const override;

  /**
   * @brief append the internal variables values to a stringstream
   *
   * @param streamVariables : stringstream with binary formated internalVariables
   */
  void dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const override;

  /**
   * @brief import the internal variables values of the component from stringstream
   *
   * @param streamVariables : stringstream with binary formated internalVariables
   */
  void loadInternalVariables(boost::archive::binary_iarchive& streamVariables) override;

 private:
  /**
   * @brief  get the current ratio of the transformer
   * @return the value of the ratio of the transformer
   */
  double getRho() const;

  /**
   * @brief  get the current phase shift of the transformer
   * @return the value of the phase shift
   */
  double getAlpha() const;

  /**
   * @brief  get the current resistance of the tap used
   * @return the current resistance
   */
  double getR() const;

  /**
   * @brief  get the current reactance of the tap used
   * @return the current reactance
   */
  double getX() const;

  /**
   * @brief  get the current conductance of the tap used
   * @return the current conductance
   */
  double getB() const;

  /**
   * @brief  get the current susceptance of the tap used
   * @return the current susceptance
   */
  double getG() const;

  /**
   * @brief  get the index of the tap used
   * @return the index of the tap used
   */
  int getCurrentStepIndex() const;

  /**
   * @brief  set the index of the tap used
   * @param stepIndex index of the tap used
   */
  void setCurrentStepIndex(int stepIndex);

  /**
   * @brief  get the current value of the active power at side 1
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the value of the active power at side 1
   */
  double P1(double ur1, double ui1, double ur2, double ui2) const;

  /**
   * @brief  get the current value of the active power at side 2
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the value of the active power at side 2
   */
  double P2(double ur1, double ui1, double ur2, double ui2) const;

  /**
   * @brief compute value
   * @return value
   */
  double ir1_dUr1() const;

  /**
   * @brief compute value
   * @return value
   */
  double ir1_dUi1() const;

  /**
   * @brief compute value
   * @return value
   */
  double ir1_dUr2() const;

  /**
   * @brief compute value
   * @return value
   */
  double ir1_dUi2() const;

  /**
   * @brief compute value
   * @return value
   */
  double ii1_dUr1() const;

  /**
   * @brief compute value
   * @return value
   */
  double ii1_dUi1() const;

  /**
   * @brief compute value
   * @return value
   */
  double ii1_dUr2() const;

  /**
   * @brief compute value
   * @return value
   */
  double ii1_dUi2() const;

  /**
   * @brief compute value
   * @return value
   */
  double ir2_dUr1() const;

  /**
   * @brief compute value
   * @return value
   */
  double ir2_dUi1() const;

  /**
   * @brief compute value
   * @return value
   */
  double ir2_dUr2() const;

  /**
   * @brief compute value
   * @return value
   */
  double ir2_dUi2() const;

  /**
   * @brief compute value
   * @return value
   */
  double ii2_dUr1() const;

  /**
   * @brief compute value
   * @return value
   */
  double ii2_dUi1() const;

  /**
   * @brief compute value
   * @return value
   */
  double ii2_dUr2() const;

  /**
   * @brief compute value
   * @return value
   */
  double ii2_dUi2() const;

  /**
   * @brief compute the real part of the current on side 1
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the real part of the current on side 1
   */
 double ir1(const double ur1, const double ui1, const double ur2, const double ui2) const;

  /**
   * @brief compute the imaginary part of the current on side 1
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the imaginary part of the current on side 1
   */
 double ii1(const double ur1, const double ui1, const double ur2, const double ui2) const;

  /**
   * @brief compute the real part of the current on side 2
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the real part of the current on side 2
   */
 double ir2(const double ur1, const double ui1, const double ur2, const double ui2) const;

  /**
   * @brief compute the imaginary part of the current on side 2
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the imaginary part of the current on side 2
   */
 double ii2(const double ur1, const double ui1, const double ur2, const double ui2) const;

  /**
   * @brief compute the absolute current entering side 1
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return value of the current
   */
  double i1(double ur1, double ui1, double ur2, double ui2) const;

  /**
   * @brief compute the absolute current entering side 2
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return value of the current
   */
  double i2(double ur1, double ui1, double ur2, double ui2) const;

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

 private:
  KnownBus_t knownBus_;  ///< bus known

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
  double ir01_;  ///< initial real part of the current at side 1
  double ii01_;  ///< initial imaginary part of the current at side 1
  double ir02_;  ///< initial real part of the current at side 2
  double ii02_;  ///< initial imaginary part of the current at side 2
  std::shared_ptr<ModelBus> modelBus1_;  ///< model for the bus on side 1
  std::shared_ptr<ModelBus> modelBus2_;  ///< model for the bus on side 2

  // evaluated at the end of evalZ to detect if the state was modified by another component
  State connectionState_;  ///< "internal" 2wt connection state for the transformer
  bool topologyModified_;  ///< true if the 2wt connection state was modified
  bool stateIndexModified_;  ///< true if the 2wt state index was modified
  bool updateYMat_;  ///< true if YMat needs to be updated (= topologyModified or stateIndexModified on this 2wt)
  double currentLimitsDesactivate_;  ///< whether the current limit automaton is deactivated
  double disableInternalTapChanger_;  ///< whether an external (or internal) model is used for the tap-changer
  double tapChangerLocked_;  ///< whether the tap-changer is locked
  boost::shared_ptr<ModelRatioTapChanger> modelRatioChanger_;  ///< model used for the ratio tap-changer
  std::string terminalRefId_;  ///< id of the terminal where the voltage is measured
  std::string side_;  ///< side of the terminal where the voltage is measured
  std::shared_ptr<ModelBus> modelBusMonitored_;  ///< model of the bus where the voltage is measured

  boost::shared_ptr<ModelPhaseTapChanger> modelPhaseChanger_;  ///< model used for the phase tap changer
  boost::shared_ptr<ModelTapChanger> modelTapChanger_;  ///< generic model used for the tap changer (when there is only one tap)

  boost::shared_ptr<ModelCurrentLimits> currentLimits1_;  ///< current limit side 1
  boost::shared_ptr<ModelCurrentLimits> currentLimits2_;  ///< current limit side 2

  double factorPuToASide1_;  ///< factor to convert current side 1 from pu to A
  double factorPuToASide2_;  ///< factor to convert current side 1 from pu to A

  // state variables
  double vNom1_;  ///< nominal voltage on side 1
  double vNom2_;  ///< nominal voltage on side 2
  int tapChangerIndex_;  ///< current tap index (for tap-changer)

  const std::string modelType_;  ///< model Type
};
}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELTWOWINDINGSTRANSFORMER_H_
