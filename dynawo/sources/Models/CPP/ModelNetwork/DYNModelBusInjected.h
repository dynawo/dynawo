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

/** @file  DYNModelBusInjected.h */

#ifndef MODELS_CPP_MODELNETWORK_DYNMODELBUSINJECTED_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELBUSINJECTED_H_

#include <boost/optional.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>

#include "DYNModelBus.h"
#include "DYNBitMask.h"

namespace DYN {
/** class ModelBusInjected */
class ModelBusInjected : public ModelBus {  ///< Generic AC network bus
 public:
  /**
   * @brief default constructor
   * @param bus bus data interface to use for the model
   * @param isNodeBreaker true if the voltage level is in NODE BREAKER
   */
  explicit ModelBusInjected(const std::shared_ptr<BusInterface>& bus, bool isNodeBreaker);

  /**
   * @brief calculated variables type
   */
  typedef enum {
    upuNum_ = 0,
    phipuNum_ = 1,
    uNum_ = 2,
    phiNum_ = 3,
    nbCalculatedVariables_ = 4
  } CalculatedVariables_t;

  /**
   * @brief index variable type
   */
  typedef enum {
    urNum_ = 0,
    uiNum_ = 1,
    irNum_ = 2,
    iiNum_ = 3
  } IndexVariable_t;

  /**
   * @brief Flags of the U calculation status for the current time step
   */
  typedef enum {
    NoCalculation = 0x00,
    U2Pu = 0x01,
    UPu = 0x02,
    U = 0x04
  } UStatusFlags;

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

  void instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables) override;
  void defineNonGenericParameters(std::vector<ParameterModeler>& parameters) override;
  void resetNodeInjection();
  void evalDerivatives(double cj) override;
  void evalF(propertyF_t type) override;
  StateChange_t evalZ(double t, bool onlyEvaluateStateChange) override;
  void evalG(double t) override;
  void evalCalculatedVars() override;
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, std::vector<int>& numVars) const override;
  void evalJCalculatedVarI(unsigned numCalculatedVar, std::vector<double>& res) const override;
  double evalCalculatedVarI(unsigned numCalculatedVar) const override;
  void evalStaticYType() override;
  void evalDynamicYType() override;
  void evalDynamicFType() override;
  void init(int& yNum) override;
  void getY0() override;
  void setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) override;
  void setFequations(std::map<int, std::string>& fEquationIndex) override;
  void setGequations(std::map<int, std::string>& gEquationIndex) override;
  StateChange_t evalState(double time) override;
  void initSize() override;
  void irAdd(double ir) override;
  void iiAdd(double ii) override;
  double getCurrentU(UType_t currentURequested) override;
  void evalJt(double cj, int rowOffset, SparseMatrix& jt) override;
  void evalJtPrim(int rowOffset, SparseMatrix& jtPrim) override;
  void resetCurrentUStatus() override;
  double ur() const override;
  double ui() const override;
  double urp() const override;
  double uip() const override;
  void switchOff() override;
  void dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const override;
  void loadInternalVariables(boost::archive::binary_iarchive& streamVariables) override;
  void resetDerivatives() override;
  void defineElementsById(const std::string& id, std::vector<Element> &elements, std::map<std::string, int>& mapElement) override;


  inline boost::shared_ptr<BusDerivatives>& derivatives() override {return derivatives_;}
  inline boost::shared_ptr<BusDerivatives>& derivativesPrim() override {return derivativesPrim_;}
  inline int urYNum() const override {return urYNum_;}
  inline int uiYNum() const override {return uiYNum_;}
  inline double getVNom() const override {return unom_;}
  inline unsigned getNbInternalVariables() const override {return 5;}

   /**
   * @brief get initial angle of the bus
   * @return initial angle of the bus
   */
  inline double getAngle0() const {return angle0_;}

  /**
   * @brief check if bus voltage is zero
   * @return @b true if voltage (ur and ui) is 0
   */
  inline bool voltageIsZero() const {return doubleIsZero(y_[urNum_]) && doubleIsZero(y_[uiNum_]);}

  /**
   * @brief get information about the minimum voltage
   * @return current minimum voltage
   */
  inline double getUMin() const {return uMin_;}

  /**
   * @brief get information about the maximum voltage
   * @return current maximum voltage
   */
  inline double getUMax() const {return uMax_;}

 private:
  /**
   * @brief calculate the value of U² in pu
   * @return the value of U² in pu
   */
  double calculateU2Pu() const;

  /**
   * @brief calculate the value of U in S.I.
   * @return the value of U in S.I.
   */
  inline double calculateU() const {
    return UPu_ * unom_;
  }

 private:
  std::weak_ptr<BusInterface> bus_;  ///< reference to the bus interface object

  double uMin_;  ///< minimum allowed voltage
  double uMax_;  ///< maximum allowed voltage
  bool stateUmax_;  ///< whether U > UMax
  bool stateUmin_;  ///< whether U < UMin

  double U2Pu_;  ///< current value of U² (= 0 if not yet calculated)
  double UPu_;  ///< current value of U (=0 if not yet calculated)
  double U_;  ///< current value of U in S.I. unit (=0 if not yet calculated)
  BitMask currentUStatus_;  ///< Bit mask value indicating which value of U have already been calculated for the current time step

  // equivalent to z_[switchOffNum_] but with discrete variable, to be able to switch off a node thanks to an outside event
  double irConnection_;  ///< real current injected
  double iiConnection_;  ///< imaginary current injected
  boost::shared_ptr<BusDerivatives> derivatives_;  ///< derivatives
  boost::shared_ptr<BusDerivatives> derivativesPrim_;  ///< derivatives for JPrim
  double ir0_ = 0.;  ///< initial real current
  double ii0_ = 0.;  ///< initial imaginary current

  // index inside the whole Jacobian
  int urYNum_ = -1;  ///< index ur
  int uiYNum_ = -1;  ///< ui
  int iiYNum_ = -1;  ///< ii
  int irYNum_ = -1;  ///< ir

  bool hasConnection_;  ///< whether the bus has connection
  bool hasShortCircuitCapabilities_;  ///< whether a short circuit could be applied to the bus

  double unom_;  ///< nominal voltage
  double u0_;  ///< initial voltage

  std::string constraintId_;  ///< id to use in constraints
  startingPointMode_t startingPointMode_;  ///< type of starting point for the model (FLAT,WARM)
};

}  // namespace DYN
#endif  // MODELS_CPP_MODELNETWORK_DYNMODELBUSINJECTED_H_
