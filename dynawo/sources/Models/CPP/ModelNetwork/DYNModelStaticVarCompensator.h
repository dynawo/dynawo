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
 * @file  DYNModelStaticVarCompensator.h
 *
 * @brief
 *
 */
//======================================================================
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELSTATICVARCOMPENSATOR_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELSTATICVARCOMPENSATOR_H_

#include <boost/shared_ptr.hpp>
#include "DYNNetworkComponentImpl.h"
#include "DYNStaticVarCompensatorInterface.h"

namespace DYN {
class ModelBus;

class ModelStaticVarCompensator : public NetworkComponent::Impl {
 public:
  /**
   * @brief default constructor
   * @param svc : static var compensator data interface used to build the model
   */
  explicit ModelStaticVarCompensator(const boost::shared_ptr<StaticVarCompensatorInterface>& svc);

  /**
   * @brief destructor
   */
  ~ModelStaticVarCompensator() { }

  /**
   * @brief  calculated variables type
   */
  typedef enum {
    qNum_ = 0,
    nbCalculatedVariables_ = 1
  } CalculatedVariables_t;

  /**
   * @brief  index variables type
   */
  typedef enum {
    piInNum_ = 0,
    piOutNum_ = 1,
    bSvcNum_ = 2,
    feedBackNum_ = 3
  } IndexVariables_t;

  /**
   * @brief set connection status
   * @param state
   */
  void setConnected(State state) {
    connectionState_ = state;
  }

  /**
   * @brief set the bus to which the svc is connected
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
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement);

  /**
   * @brief evaluation F
   */
  void evalF();

  /**
   * @brief evaluation Z
   * @param t time
   */
  void evalZ(const double& t);

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
   * @param numCalculatedVar : index of the calculated variable
   * @param numVars : index of variables used to define the jacobian associated  to the calculated variable
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
   * @copydoc NetworkComponent::evalYType()
   */
  void evalYType();

  /**
   * @copydoc NetworkComponent::evalFType()
   */
  void evalFType();

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
   * @brief addBusNeighbors
   */
  void addBusNeighbors() { /* not needed */ }

  /**
   * @brief evaluate state
   * @param time
   * @return state change type
   */
  NetworkComponent::StateChange_t evalState(const double& time);

  /**
   * @brief init size
   */
  void initSize();

  /**
   * @brief evaluate jacobien \f$( J = @F/@x + cj * @F/@x')\f$
   * @param jt sparse matrix to fill
   * @param cj jacobian prime coefficient
   * @param rowOffset row offset to use to find the first row to fill
   */
  void evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset);

  /**
   * @brief  evaluate jacobien \f$( J =  @F/@x')\f$
   *
   * @param jt sparse matrix to fill
   * @param rowOffset row offset to use to find the first row to fill
   */
  void evalJtPrim(SparseMatrix& jt, const int& rowOffset);

  /**
   * @brief get connection status
   * @return connection status
   */
  inline State getConnected() const {
    return connectionState_;
  }

  /**
   * @brief check whether the svc is connected to the bus
   * @return @b True if the svc is connected, @b false else
   */
  inline bool isConnected() const {
    return (connectionState_ == CLOSED);
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
  double Q() const;

  /**
   * @brief compute value
   * @return value
   */
  double piIn() const;

  /**
   * @brief compute value
   * @return value
   */
  double piOut() const;

  /**
   * @brief compute value
   * @return value
   */
  double feedBack() const;

  /**
   * @brief compute value
   * @return value
   */
  double feedBackPrim() const;

  /**
   * @brief compute value
   * @return value
   */
  double bSvc() const;

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
   * @brief compute value
   * @param ui imaginary part of the voltage
   * @return value
   */
  double ir_dBSvc(const double& ui) const;

  /**
   * @brief compute value
   * @param ur real part of the voltage
   * @return value
   */
  double ii_dBSvc(const double& ur) const;

  boost::shared_ptr<ModelBus> modelBus_;  ///< model bus
  double Statism_;  ///< statism
  double kG_;  ///< global gain before the Proportional Integral
  double kP_;  ///< gain in regulator PI
  double Ti_;  ///< time constant Ti
  double bMin_;  ///< minimum susceptance
  double bMax_;  ///< maximum susceptance
  double vSetPoint_;  ///< voltage set-point
  double vNom_;  ///< nominal voltage
  State connectionState_;  ///< "internal" compensator connection status, evaluated at the end of evalZ to detect if the state was modified by another component
  bool stateModified_;  ///< true if the compensator connection state was modified
  StaticVarCompensatorInterface::RegulationMode_t mode_;  ///< regulation mode
  double uMinActivation_;  ///< voltage limit inf to activate running mode when in standby
  double uMaxActivation_;  ///< voltage limit sup to activate running mode when in standby
  double uSetPointMin_;  ///< new target when Umin has been reached
  double uSetPointMax_;  ///< new target when Umax has been reached
  double hasStandByAutomaton_;  ///< check if extension StandByAutomaton is loaded
  bool isStandBy_;  ///< svc is standby or not
  double bShunt_;  ///< constant susceptance
  double bSvc0_;  ///< initial susceptance of the svc in pu (base SNREF)
  double ir0_;  ///< initial current (real part)
  double ii0_;  ///< initial current (imaginary part)

  // variables
  double piIn0_;  ///< input regulator PI
  double piOut0_;  ///< before B limitor in regulator PI
  double feedBack0_;  ///< output of simple-lag block
  double feedBackPrim0_;  ///< derivative of output of simple-lag block
  int piInYNum_;  ///< piInYNum_
  int piOutYNum_;  ///< piOutYNum_
  int bSvcYNum_;  ///< bSvcYNum_
  int feedBackYNum_;  ///< feedBackYNum_
  bool isRunning_;  ///< svc is running or not
};  ///< class for Static Var Compensator model in network

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELSTATICVARCOMPENSATOR_H_
