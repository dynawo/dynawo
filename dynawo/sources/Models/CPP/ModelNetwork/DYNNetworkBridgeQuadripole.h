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
#include "DYNNetworkBridge.hpp"

namespace DYN {
/** @brief enables connection state changes propagation from dynamic quadripole models to their ModelNetwork equivalent */
class NetworkBridgeQuadripole : public ModelQuadripole, public NetworkBridge {
 public:
   /**
   * @brief constructor from a base quadripole
   * @param baseQuadripole the quadripole network component that needs bridging to its dynamic part
   * @param stateVarPrefix the prefix to prepend to the state variables of the dynamic part, depending on actual component type
   */
  explicit NetworkBridgeQuadripole(const std::shared_ptr<ModelQuadripole> & baseQuadripole, const std::string & stateVarPrefix);

  void initSize() override;
  StateChange_t evalZ(double, bool) override;
  void evalG(double) override;
  void setGequations(std::map<int, std::string>&) override;

 private:
  std::string stateVarPrefix_;                        ///< dynamic state variable model type prefix
  bool declareTopoChange_ = false;                    ///< flag indicating that evalG detected a topology change that needs to be forwarded to evalZ


// unused pure virtual methods from NetworkComponent from here on
 public :
  NetworkComponent::StateChange_t evalState(double) override {return NetworkComponent::NO_CHANGE;}
  void instantiateVariables(std::vector<boost::shared_ptr<Variable> >&) override {}
  void defineElements(std::vector<Element> &, std::map<std::string, int>&) override {}
  void collectSilentZ(BitMask*) override {}
  void evalDerivatives(double) override {}
  void evalDerivativesPrim() override {}
  void evalF(propertyF_t) override {}
  void evalJt(double, int, SparseMatrix&) override {}
  void evalJtPrim(int, SparseMatrix&) override {}
  void evalNodeInjection() override {}
  void defineNonGenericParameters(std::vector<ParameterModeler>&) override {}
  void evalCalculatedVars() override {}
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned, std::vector<int>&) const override {}
  void evalJCalculatedVarI(unsigned, std::vector<double>&) const override {}
  double evalCalculatedVarI(unsigned numCalculatedVar) const override {throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);}
  void evalStaticYType() override {}
  void evalDynamicYType() override {}
  void evalStaticFType() override {}
  void evalDynamicFType() override {}
  void evalYMat() override {}
  void init(int&) override {}
  void getY0() override {}
  void setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>&) override {}
  void setFequations(std::map<int, std::string>&) override {}
};

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNNETWORKBRIDGEQUADRIPOLE_H_
