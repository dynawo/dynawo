// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.

/**
 * @file  DYNNetworkBridgeQuadripole.h
 * @brief  enables dynamic switchoff/on events of tfos and lines to be propagated to ModelNetwork
 */

#ifndef MODELS_CPP_MODELNETWORK_DYNNETWORKBRIDGEQUADRIPOLE_H_
#define MODELS_CPP_MODELNETWORK_DYNNETWORKBRIDGEQUADRIPOLE_H_

#include "DYNModelQuadripole.h"

namespace DYN {
class SubModel;

/** @brief enables connection state changes propagation from dynamic quadripole models to their ModelNetwork equivalent */
class NetworkBridgeQuadripole : public ModelQuadripole {
 public:
   /**
   * @brief constructor from a base quadripole
   * @param baseQuadripole the quadripole network component that needs bridging to its dynamic part
   * @param stateVarPrefix the prefix to prepend to the state variables of the dynamic part, depending on actual component type
   * @param network the ModelNetwork, required for isInit checking
   */
  explicit NetworkBridgeQuadripole(const std::shared_ptr<ModelQuadripole> & baseQuadripole,
                                   const std::string & stateVarPrefix,
                                   ModelNetwork * network);

  /**
   * @brief sets the pointer to the dynamic model overriding the ModelNetwork component passed at instanciation
   * @param dynModel the pointer to the dynamic model
   */
  void setDynPart(boost::shared_ptr<SubModel> dynModel) {dynModel_ = dynModel;}

  /** @copydoc NetworkComponent */
  void initSize() override;

  /**
   * @copydoc NetworkComponent
   * @return TOPO_CHANGE if connection state variable has changed to or from CLOSED on dynamic model, NO_CHANGE otherwise
  */
  StateChange_t evalZ(double) override;

  /** @copydoc NetworkComponent */
  void evalG(double) override;

  /** @copydoc NetworkComponent */
  void setGequations(std::map<int, std::string>&) override;

 public:
    static const char BRIDGE_PREFIX[];  ///< prefix added to static ID to build NetworkBridgeQuadripole ID,
                                        ///< preventing confusion when listing ModelNetwork components

 private:
   /**
   * @brief retrieves the actual current connection state from the dynamic model
   * @returns the connection state in the form of the CPP enum
   */
  State getDynamicState();

 private:
  std::string stateVarPrefix_;                        ///< dynamic state variable model type prefix
  boost::shared_ptr<SubModel> dynModel_ = nullptr;    ///< dynamic model for the quadripole ModelNetwork component
  bool declareTopoChange_ = false;                    ///< flag indicating that evalG detected a topology change that needs to be forwarded to evalZ



  // unused pure virtual methods from NetworkComponent from here on
 public :
  /** @brief unused
   *  @returns NO_CHANGE in all circumstances
   */
  NetworkComponent::StateChange_t evalState(double) override {return NetworkComponent::NO_CHANGE;}

  /** @brief unused */
  void instantiateVariables(std::vector<boost::shared_ptr<Variable> >&) override {}

  /** @brief unused */
  void defineElements(std::vector<Element> &, std::map<std::string, int>&) override {}

  /** @brief unused */
  void collectSilentZ(BitMask*) override {}

  /** @brief unused */
  void evalDerivatives(double) override {}

  /** @brief unused */
  void evalDerivativesPrim() override {}

  /** @brief unused */
  void evalF(propertyF_t) override {}

  /** @brief unused */
  void evalJt(double, int, SparseMatrix&) override {}

  /** @brief unused */
  void evalJtPrim(int, SparseMatrix&) override {}

  /** @brief unused */
  void evalNodeInjection() override {}

  /** @brief unused */
  void defineNonGenericParameters(std::vector<ParameterModeler>&) override {}

  /** @brief unused */
  void evalCalculatedVars() override {}

  /** @brief unused */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned, std::vector<int>&) const override {}

  /** @brief unused */
  void evalJCalculatedVarI(unsigned, std::vector<double>&) const override {}

  /** @brief unused, throws an error if called
   * @param numCalculatedVar index of the non-existant variable being evaled
   * @returns nothing, since it throws in all cases if called
  */
  double evalCalculatedVarI(unsigned numCalculatedVar) const override {throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);}

  /** @brief unused */
  void evalStaticYType() override {}

  /** @brief unused */
  void evalDynamicYType() override {}

  /** @brief unused */
  void evalStaticFType() override {}

  /** @brief unused */
  void evalDynamicFType() override {}

  /** @brief unused */
  void evalYMat() override {}

  /** @brief unused */
  void init(int&) override {}

  /** @brief unused */
  void getY0() override {}

  /** @brief unused */
  void setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>&) override {}

  /** @brief unused */
  void setFequations(std::map<int, std::string>&) override {}
};

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNNETWORKBRIDGEQUADRIPOLE_H_
