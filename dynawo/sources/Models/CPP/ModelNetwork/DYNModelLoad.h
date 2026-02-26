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
 * @file  DYNModelLoad.h
 *
 * @brief
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELLOAD_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELLOAD_H_

#include <boost/shared_ptr.hpp>
#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>

#include "DYNModelBus.h"
#include "DYNNetworkComponent.h"

namespace DYN {
class LoadInterface;

/**
 * @brief Load component
 */
class ModelLoad : public NetworkComponent {
 public:
  /**
   * @brief default constructor
   * @param load : load data interface used to build the model
   * @param bus : bus data-interface
   */
  explicit ModelLoad(const std::shared_ptr<LoadInterface>& load, const std::shared_ptr<ModelBus>& bus);

  /**
   * @brief  calculated variables type
   */
  typedef enum {
    pNum_ = 0,
    qNum_ = 1,
    pcNum_ = 2,
    qcNum_ = 3,
    loadStateNum_ = 4,
    nbCalculatedVariables_ = 5
  } CalculatedVariables_t;

  /**
   * @brief set the load connection status
   * @param state load connection status
   */
  void setConnected(const State state) {
    connectionState_ = state;
  }  // set the load connection status

  /**
   * @brief evaluate node injection
   */
  void evalNodeInjection() override;

  /**
   * @brief evaluate derivatives
   * @param cj Jacobian prime coefficient
   */
  void evalDerivatives(const double cj) override;

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
   * @param numCalculatedVar index of the calculated variable
   * @param numVars index of variables used to define the jacobian associated to a calculated variable
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
   * @copydoc NetworkComponent::evalDynamicFType()
   */
  void evalDynamicFType() override { /* not needed */ }

  /**
   * @copydoc NetworkComponent::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;

  /**
   * @copydoc NetworkComponent::evalYMat()
   */
  void evalYMat() override { /* not needed*/ }

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
   * @brief evaluate jacobien \f$( J = @F/@x + cj * @F/@x')\f$
   * @param cj jacobian prime coefficient
   * @param rowOffset row offset to use to find the first row to fill
   * @param jt sparse matrix to fill
   */
  void evalJt(double cj, int rowOffset, SparseMatrix& jt) override;

  /**
   * @brief  evaluate jacobien \f$( J =  @F/@x')\f$
   *
   * @param rowOffset row offset to use to find the first row to fill
   * @param jtPrim sparse matrix to fill
   */
  void evalJtPrim(int rowOffset, SparseMatrix& jtPrim) override;

  /**
   * @brief get the connection status of the load
   * @return connection status
   */
  inline State getConnected() const {
    return connectionState_;
  }

  /**
   * @brief check whether the load is connected to the bus
   * @return @b True if the load is connected, @b false else
   */
  inline bool isConnected() const {
    return (connectionState_ == CLOSED);
  }

  /**
   * @brief check whether the load is running (i.e. whether current is flowing)
   * @return @b whether the load is running
   */
  inline bool isRunning() const {
    return (isConnected() && !modelBus_->getSwitchOff());
  }

  /**
   * @brief get the number of internal variable of the model
   *
   * @return the number of internal variable of the model
   */
  inline unsigned getNbInternalVariables() const override {
    return 5;
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
   * @brief calculated value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U voltage
   * @param U2 voltage square
   * @return value
   */
  double P_dUr(double ur, double ui, double U, double U2) const;

  /**
   * @brief calculated value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U voltage
   * @param U2 voltage square
   * @return value
   */
  double Q_dUr(double ur, double ui, double U, double U2) const;

  /**
   * @brief calculated value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U voltage
   * @param U2 voltage square
   * @return value
   */
  double P_dUi(double ur, double ui, double U, double U2) const;

  /**
   * @brief calculated value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U voltage
   * @param U2 voltage square
   * @return value
   */
  double Q_dUi(double ur, double ui, double U, double U2) const;

  /**
   * @brief compute the active power in pu (SNREF)
   * @param U voltage
   * @return value
   */
  double P(double U) const;  // compute the active power in pu (SNREF)

  /**
   * @brief compute the reactive power in pu (SNREF)
   * @param U voltage
   * @return value
   */
  double Q(double U) const;  // compute the reactive power in pu (SNREF)

  /**
   * @brief compute value
   * @return value
   */
  double zP() const;

  /**
   * @brief compute value
   * @return value
   */
  double zQ() const;

  /**
   * @brief compute value
   * @return value
   */
  double zQPrim() const;

  /**
   * @brief compute value
   * @return value
   */
  double zPPrim() const;

  /**
   * @brief compute value
   * @return value
   */
  double deltaQc() const;

  /**
   * @brief compute value
   * @return value
   */
  double deltaPc() const;

  /**
   * @brief compute the current real and imaginary values
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U voltage
   * @param U2 voltage square
   * @param ir output: real current
   * @param ii output: imaginary current
   */
  void getI(double ur, double ui, double U, double U2, double& ir, double& ii) const;  // compute the real current

  /**
   * @brief compute value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @param p active power
   * @param q reactive power
   * @param PdUr partial derivative of active power with respect to ur
   * @param QdUr partial derivative of reactive power with respect to ur
   * @return value
   */
  inline static double ir_dUr(const double ur, const double ui, const double U2,
                       const double p, const double q, const double PdUr, const double QdUr) {
    return ((PdUr * ur + p) + (QdUr * ui) - 2. * ur * (p * ur + q * ui) / U2) / U2;
  }

  /**
   * @brief compute value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @param p active power
   * @param q reactive power
   * @param PdUr partial derivative of active power with respect to ur
   * @param QdUr partial derivative of reactive power with respect to ur
   * @return value
   */
  inline static double ii_dUr(const double ur, const double ui, const double U2,
                       const double p, const double q, const double PdUr, const double QdUr) {
    return ((PdUr * ui) - (QdUr * ur + q) - 2. * ur * (p * ui - q * ur) / U2) / U2;
  }

  /**
   * @brief compute value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @param p active power
   * @param q reactive power
   * @param PdUi partial derivative of active power with respect to ui
   * @param QdUi partial derivative of reactive power with respect to ui
   * @return value
   */
  inline static double ir_dUi(const double ur, const double ui, const double U2,
                       const double p, const double q, const double PdUi, const double QdUi) {
    return ((PdUi * ur) + (QdUi * ui + q) - 2. * ui * (p * ur + q * ui) / U2) / U2;
  }

  /**
   * @brief compute value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U2 voltage square
   * @param p active power
   * @param q reactive power
   * @param PdUi partial derivative of active power with respect to ui
   * @param QdUi partial derivative of reactive power with respect to ui
   * @return value
   */
  inline static double ii_dUi(const double ur, const double ui, const double U2,
                       const double p, const double q, const double PdUi, const double QdUi) {
    return ((PdUi * ui + p) - (QdUi * ur) - 2. * ui * (p * ui - q * ur) / U2) / U2;
  }

  /**
   * @brief compute value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U voltage
   * @param U2 voltage square
   * @return value
   */
  double ir_dZp(double ur, double ui, double U, double U2) const;

  /**
   * @brief compute value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U voltage
   * @param U2 voltage square
   * @return value
   */
  double ir_dZq(double ur, double ui, double U, double U2) const;

  /**
   * @brief compute value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U voltage
   * @param U2 voltage square
   * @return value
   */
  double ii_dZp(double ur, double ui, double U, double U2) const;

  /**
   * @brief compute value
   * @param ur real part of the voltage
   * @param ui imaginary part of the voltage
   * @param U voltage
   * @param U2 voltage square
   * @return value
   */
  double ii_dZq(double ur, double ui, double U, double U2) const;

  /**
   * @brief compute the global Y index inside the Y matrix
   * @param localIndex the local variable index inside the model
   * @return the global variable index
   */
  inline unsigned int globalYIndex(const unsigned int& localIndex) {
    return yOffset_ + localIndex;
  }

 private:
  std::weak_ptr<LoadInterface> load_;  ///< reference to the load interface object
  std::shared_ptr<ModelBus> modelBus_;  ///< model bus
  State connectionState_;  ///< "internal" load connection status, evaluated at the end of evalZ to detect if the state was modified by another component
  bool stateModified_;  ///< true if the load connection state was modified
  double kp_;  ///< gain kp
  double kq_;  ///< gain kq
  double P0_;  ///< initial active power
  double Q0_;  ///< initial reactive power
  double ir0_;  ///< initial real part of the current
  double ii0_;  ///< initial imaginary part of the current

  // Parameters
  double alpha_;  ///< active power exponential sensitivity to voltage
  double beta_;  ///< reactive power exponential sensitivity to voltage
  bool isRestorative_;  ///< whether the consumed energy remains constant
  bool isPControllable_;  ///< whether the load can be controlled on P
  bool isQControllable_;  ///< whether the load can be controlled on Q
  bool isControllable_;  ///< whether the load can be controlled
  double Tp_;  ///< time constant Tp
  bool TpIsZero_;  ///< true if Tp == 0
  double Tq_;  ///< time constant Tq
  bool TqIsZero_;  ///< true if Tq == 0
  double zPMax_;  ///< zPmax
  double zQMax_;  ///< zQMax
  double alphaLong_;  ///< alpha
  double betaLong_;  ///< beta
  double u0_;  ///< initial voltage

  // Variables
  double DeltaPc0_;  ///< delta pc0
  double DeltaQc0_;  ///< delta qc0
  double zP0_;  ///< zP0
  double zQ0_;  ///< zQ0
  double zPprim0_;  ///< zPprim0
  double zQprim0_;  ///< zQprim0
  unsigned int yOffset_;  ///< global Y offset at the beginning of the load model
  unsigned int DeltaPcYNum_;  ///< local Y index for DeltaPc
  unsigned int DeltaQcYNum_;  ///< local Y index for DeltaQc
  unsigned int zPYNum_;  ///< local Y index for zP
  unsigned int zQYNum_;  ///< local Y index for zQ
  startingPointMode_t startingPointMode_;  ///< type of starting point for the model (FLAT,WARM)
};  ///< class for Load model

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELLOAD_H_
