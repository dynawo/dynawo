// Copyright (c) 2015-2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.

/** @file  DYNModelLine.h */

#ifndef MODELS_CPP_MODELNETWORK_DYNMODELLINE_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELLINE_H_

#include <boost/shared_ptr.hpp>
#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>

#include "DYNModelQuadripole.h"

namespace DYN {
class ModelBus;
class LineInterface;
class ModelCurrentLimits;

/** @brief Generic AC line model */
class ModelLine : public ModelQuadripole {
 public:
  /**
   * @brief default constructor
   * @param line : line data interface to use to build the model
   */
  explicit ModelLine(const std::shared_ptr<LineInterface>& line);

  /** @brief calculated variables type */
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
   * @brief define variables
   * @param variables variables
   */
  static void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @brief define parameters
   * @param parameters vector to fill with the generic parameters
   */
  static void defineParameters(std::vector<ParameterModeler>& parameters);

  inline unsigned getNbInternalVariables() const override {return 4;}

  void evalNodeInjection() override;
  void evalDerivatives(double cj) override;
  void evalDerivativesPrim() override;
  void instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables) override;
  void defineNonGenericParameters(std::vector<ParameterModeler> &) override {}
  void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) override;
  void evalF(propertyF_t type) override;
  NetworkComponent::StateChange_t evalZ(double t) override;
  void evalG(double t) override;
  void evalCalculatedVars() override;
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, std::vector<int> & numVars) const override;
  void evalJCalculatedVarI(unsigned numCalculatedVar, std::vector<double> & res) const override;
  void evalJt(double cj, int rowOffset, SparseMatrix& jt) override;
  void evalJtPrim(int rowOffset, SparseMatrix& jtPrim) override;
  double evalCalculatedVarI(unsigned numCalculatedVar) const override;
  void evalStaticYType() override;
  void evalDynamicYType() override;
  void evalStaticFType() override {}
  void evalDynamicFType() override;
  void collectSilentZ(BitMask* silentZTable) override;
  void evalYMat() override;
  void init(int & yNum) override;
  void getY0() override;
  void setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) override;
  void setFequations(std::map<int, std::string>& fEquationIndex) override;
  void setGequations(std::map<int, std::string>& gEquationIndex) override;
  StateChange_t evalState(double time) override;
  void initSize() override;
  void dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const override;
  void loadInternalVariables(boost::archive::binary_iarchive& streamVariables) override;
  void printInternalParameters(std::ofstream& fstream) const override;

  /**
   * @brief set CurrentLimits Desactivate
   * @param newVal CurrentLimits Desactivate
   */
  void setCurrentLimitsDesactivate(double newVal) {currentLimitsDesactivate_ = newVal;}

  /**
   * @brief get CurrentLimits Desactivate
   * @return currentLimitsDesactivate
   */
  double getCurrentLimitsDesactivate() const {return currentLimitsDesactivate_;}

 private:
  /**
   * @brief compute the real part of the current on side 1
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the real part of the current on side 1
   */
  double ir1(double ur1, double ui1, double ur2, double ui2) const;

  /**
   * @brief compute the imaginary part of the current on side 1
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the imaginary part of the current on side 1
   */
  double ii1(double ur1, double ui1, double ur2, double ui2) const;

  /**
   * @brief compute the real part of the current on side 2
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the real part of the current on side 2
   */
  double ir2(double ur1, double ui1, double ur2, double ui2) const;

  /**
   * @brief compute the imaginary part of the current on side 2
   * @param ur1 real part of the voltage on side 1
   * @param ui1 imaginary part of the voltage on side 1
   * @param ur2 real part of the voltage on side 2
   * @param ui2 imaginary part of the voltage on side 2
   * @return the imaginary part of the current on side 2
   */
  double ii2(double ur1, double ui1, double ur2, double ui2) const;

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
  inline int globalYIndex(int localIndex) const {return yOffset_ + localIndex;}

  /**
   * @brief returns the index of the real part of voltage side 1 in the global Y vector
   * @return the index
   */
  inline int ur1YNumGlobal() const;

  /**
   * @brief returns the index of the imaginary part of voltage side 1 in the global Y vector
   * @return the index
   */
  inline int ui1YNumGlobal() const;

  /**
   * @brief returns the index of the real part of voltage side 2 in the global Y vector
   * @return the index
   */
  inline int ur2YNumGlobal() const;

  /**
   * @brief returns the index of the imaginary part of voltage side 2 in the global Y vector
   * @return the index
   */
  inline int ui2YNumGlobal() const;

  /**
   * @brief returns whether a given calculated variable depends on current side 1, 2 or neither
   * @param numCalculatedVar index defining the type of calculated variable
   * @return 1 if the variable depends on calulculated current side 1, 2 if side 2, 0 if neither
   */
  inline int varSide(unsigned int numCalculatedVar) const;

  /**
   * @brief throws if the state passed in argument is invalid for model Line
   * @param state the state to check
   */
  inline void checkValidState(State state) const;

 private :
  boost::shared_ptr<ModelCurrentLimits> currentLimits1_;  ///< current limit side 1
  boost::shared_ptr<ModelCurrentLimits> currentLimits2_;  ///< current limit side 2

  bool topologyModified_ = false;  ///< true if the line connection state was modified
  bool updateYMat_ = true;  ///< true if the YMat need to be updated(= topologyModified)
  double currentLimitsDesactivate_ = 0;  ///< current limit desactivate
  bool dynLineModel_ = false;  ///< when true, extend model with differential equations to mirror DynLine.mo
  bool dynBus1_ = false;   ///< whether the bus on side 1 has a dynamic model from DLL or is implemented by ModelNetwork
  bool dynBus2_ = false;   ///< whether the bus on side 2 has a dynamic model from DLL or is implemented by ModelNetwork

  double admittance_;  ///< admittance
  double lossAngle_;  ///< loss angle
  double suscept1_;  ///< susceptance on side 1
  double suscept2_;  ///< susceptance on side 2
  double conduct1_;  ///< conductance on side 1
  double conduct2_;  ///< conductance on side 2
  double resistance_;  ///< resistance
  double reactance_;  ///< reactance
  double factorPuToA_;  ///< factor to convert current from pu to A

  double ir1_dUr1_ = 0;  ///< injection matrix value
  double ir1_dUi1_ = 0;  ///< injection matrix value
  double ir1_dUr2_ = 0;  ///< injection matrix value
  double ir1_dUi2_ = 0;  ///< injection matrix value
  double ii1_dUr1_ = 0;  ///< injection matrix value
  double ii1_dUi1_ = 0;  ///< injection matrix value
  double ii1_dUr2_ = 0;  ///< injection matrix value
  double ii1_dUi2_ = 0;  ///< injection matrix value
  double ir2_dUr1_ = 0;  ///< injection matrix value
  double ir2_dUi1_ = 0;  ///< injection matrix value
  double ir2_dUr2_ = 0;  ///< injection matrix value
  double ir2_dUi2_ = 0;  ///< injection matrix value
  double ii2_dUr1_ = 0;  ///< injection matrix value
  double ii2_dUi1_ = 0;  ///< injection matrix value
  double ii2_dUr2_ = 0;  ///< injection matrix value
  double ii2_dUi2_ = 0;  ///< injection matrix value

  double ir01_ = 0;  ///< initial real part of the current at side 1
  double ii01_ = 0;  ///< initial imaginary part of the current at side 1
  double ir02_ = 0;  ///< initial real part of the current at side 2
  double ii02_ = 0;  ///< initial imaginary part of the current at side 2

  int yOffset_ = -1;  ///< start of local Y indexes in global Y vector
  int ur1YNum_ = -1;  ///< local Y index of real part of voltage side 1, if bus side 1 does not support node injection
  int ui1YNum_ = -1;  ///< local Y index of imaginary part of voltage side 1, if bus side 1 does not support node injection
  int ir1YNum_ = -1;  ///< local Y index of real part of current side 1, if bus side 1 does not support node injection
  int ii1YNum_ = -1;  ///< local Y index of imaginary part of current side 1, if bus side 1 does not support node injection
  int ur2YNum_ = -1;  ///< local Y index of real part of voltage side 2, if bus side 2 does not support node injection
  int ui2YNum_ = -1;  ///< local Y index of imaginary part of voltage side 2, if bus side 2 does not support node injection
  int ir2YNum_ = -1;  ///< local Y index of real part of current side 2, if bus side 2 does not support node injection
  int ii2YNum_ = -1;  ///< local Y index of imaginary part of current side 2, if bus side 2 does not support node injection
  int irbYNum_ = -1;  ///< local Y index for IBranch_re
  int iibYNum_ = -1;  ///< local Y index for IBranch_im
  int omegaRefNum_ = -1;  ///< local Y index for omegaRef

  int offsetGCl2_ = 0;  ///< start of embedded current limit 2 variables in G vector of line

  double omegaNom_;  ///< nominal angular frequency
  double omegaRef_;  ///< reference angular frequency in pu
};
}  // namespace DYN
#endif  // MODELS_CPP_MODELNETWORK_DYNMODELLINE_H_
