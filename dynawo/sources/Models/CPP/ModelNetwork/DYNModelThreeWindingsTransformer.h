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
 * @file  DYNModelThreeWindingsTransformer.h
 *
 * @brief
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELTHREEWINDINGSTRANSFORMER_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELTHREEWINDINGSTRANSFORMER_H_

#include <boost/shared_ptr.hpp>
#include "DYNNetworkComponent.h"

namespace DYN {
class ModelBus;
class ThreeWTransformerInterface;

/**
 * class Three Windings Transformer Model
 */
class ModelThreeWindingsTransformer : public NetworkComponent {
 public:
  /**
   * @brief default constructor
   * @param tfo three windings transformer data interface used to build the model
   */
  explicit ModelThreeWindingsTransformer(const std::shared_ptr<ThreeWTransformerInterface>& tfo);

  /**
   * @brief  calculated variables type
   */
  void init() { /* not needed */ }

  /**
   * @brief  calculated variables type
   */
  typedef enum {
    nbCalculatedVariables_ = 0
  } CalculatedVariables_t;

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
   * @brief set the bus at end 3 of the transformer
   *
   * @param model model of the bus
   */
  void setModelBus3(const std::shared_ptr<ModelBus>& model) {
    modelBus3_ = model;
  }

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
   * @brief evaluate node injection
   *
   */
  void evalNodeInjection() override { /* not needed */ }

  /**
   * @brief evaluate derivatives
   */
  void evalDerivatives(const double /*cj*/) override { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalDerivativesPrim()
   */
  void evalDerivativesPrim() override { /* not needed */ }

  /**
   * @copydoc NetworkComponent::evalF()
   */
  void evalF(propertyF_t type) override;

  /**
   * @copydoc NetworkComponent::evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset)
   */
  void evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset) override;

  /**
   * @copydoc NetworkComponent::evalJtPrim(SparseMatrix& jt, const int& rowOffset)
   */
  void evalJtPrim(SparseMatrix& jt, const int& rowOffset) override;

  /**
   * @copydoc NetworkComponent::defineElements()
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) override;

  /**
   * @copydoc NetworkComponent::evalZ()
   */
  NetworkComponent::StateChange_t evalZ(const double& t) override;

  /**
   * @copydoc NetworkComponent::evalG()
   */
  void evalG(const double& t) override;

  /**
   * @brief evaluation calculated variables (for outputs)
   */
  void evalCalculatedVars() override;

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
  void getY0() override { /* not needed */ }

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
   * @copydoc NetworkComponent::evalState(const double& time);
   */
  NetworkComponent::StateChange_t evalState(const double& time) override;

  /**
   * @brief addBusNeighbors
   */
  void addBusNeighbors() override { /* not needed */ }
  /**
   * @brief init size
   */
  void initSize() override;

 private:
  std::shared_ptr<ModelBus> modelBus1_;  ///< model bus 1
  std::shared_ptr<ModelBus> modelBus2_;  ///< model bus 2
  std::shared_ptr<ModelBus> modelBus3_;  ///< model bus 3
};
}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELTHREEWINDINGSTRANSFORMER_H_
