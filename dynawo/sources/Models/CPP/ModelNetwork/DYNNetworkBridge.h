//
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
//

/**
 * @file  DYNDynamicConnection.h
 *
 * @brief  enables dynamic switchoff/on events of tfos and lines to be propagated to ModelNetwork
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNNETWORKBRIDGE_H_
#define MODELS_CPP_MODELNETWORK_DYNNETWORKBRIDGE_H_

#include "DYNNetworkComponent.h"

namespace DYN {
class ModelTwoWindingsTransformer;
class ModelLine;
class ModelBus;
class SubModel;

/**
 * @brief DYNDynamicConnection class
 */
class NetworkBridge : public NetworkComponent {
 public:
  /**
   * @brief constructor from tfo
   * @param tfo : ModelNetwork part of the link
   */
  explicit NetworkBridge(const std::shared_ptr<ModelTwoWindingsTransformer> & tfo);

  /**
   * @brief constructor from line
   * @param line : ModelNetwork part of the link
   */
  explicit NetworkBridge(const std::shared_ptr<ModelLine> & line);

  void addBusNeighbors() override;
  NetworkComponent::StateChange_t evalZ(double) override;

  void setDynPart(boost::shared_ptr<SubModel> dynModel) {dynModel_ = dynModel;}

 public:
    static const char BRIDGE_PREFIX[];

 private:
  explicit NetworkBridge(const std::string & staticId,
                         const std::shared_ptr<ModelBus> & modelBus1,
                         const std::shared_ptr<ModelBus> & modelBus2,
                         const std::string & stateVarPrefix);


  State getDynamicState();

 private:
  std::shared_ptr<ModelBus> modelBus1_;               ///< modelBus NetworkComponent on side 1
  std::shared_ptr<ModelBus> modelBus2_;               ///< modelBus NetworkComponent on side 2
  std::string stateVarPrefix_;                        ///< dynamic state variable model type prefix
  boost::shared_ptr<SubModel> dynModel_ = nullptr;    ///< dynamic model for the tfo or line
  State lastActedUponState_ = UNDEFINED_STATE;        ///< connection state used in the previous network topology computation



  // unused pure virtual methods from NetworkComponent from here on
 public :
  /** @brief unused */
  NetworkComponent::StateChange_t evalState(double) override {return NetworkComponent::NO_CHANGE;}

  /** @brief unused */
  void initSize() override {}

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
  void defineNonGenericParameters(std::vector<ParameterModeler>&) override {};

  /** @brief unused */
  void evalG(double) override {}

  /** @brief unused */
  void evalCalculatedVars() override {}

  /** @brief unused */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned, std::vector<int>&) const override {}

  /** @brief unused */
  void evalJCalculatedVarI(unsigned, std::vector<double>&) const override {}

  /** @brief unused */
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

  /** @brief unused */
  void setGequations(std::map<int, std::string>&) override {}
};

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNNETWORKBRIDGE_H_
