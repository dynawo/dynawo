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

/** @file  DYNModelBusBridged.h */

#ifndef MODELS_CPP_MODELNETWORK_DYNMODELBUSBRIDGED_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELBUSBRIDGED_H_

#include "DYNModelBus.h"
#include "DYNNetworkBridge.hpp"

namespace DYN {
/** a class of bus described in static network that is actually handled by a dynamic DLL model */
class ModelBusBridged : public ModelBus, public NetworkBridge {
 public:
   /**
   * @brief constructor from BusInterface
   * @param bus the bus description from static data
   */
  explicit ModelBusBridged(const std::shared_ptr<BusInterface>& bus);

  // pure virtual methods from ModelBus that should only be called at init, throws otherwise
  double ur() const override;
  double ui() const override;

  // reset methods from ModelBus called on all buses by BusContainer at every step, unused here
  void resetNodeInjection() override {}
  void resetCurrentUStatus() override {}
  void resetDerivatives() override {}

  // unused pure virtual methods from ModelBus that do not make sense for bridge buses (without node injection), throw if called
  double getCurrentU(UType_t) override                            {throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "getCurrentU()", id());}
  double getVNom() const override                                 {throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "getVNom()", id());}
  double urp() const override                                     {throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "urp()", id());}
  double uip() const override                                     {throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "uip()", id());}
  int urYNum() const override                                     {throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "urYNum()", id());}
  int uiYNum() const override                                     {throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "uiYNum()", id());}
  void irAdd(double) override                                     {throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "irAdd()", id());}
  void iiAdd(double) override                                     {throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "iiAdd()", id());}
  boost::shared_ptr<BusDerivatives>& derivatives() override       {throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "derivatives()", id());}
  boost::shared_ptr<BusDerivatives>& derivativesPrim() override   {throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "derivativesPrim()", id());}

  // unused pure virtual methods from NetworkComponent from here on
  StateChange_t evalZ(double) override {return NetworkComponent::NO_CHANGE;}
  NetworkComponent::StateChange_t evalState(double) override {return NetworkComponent::NO_CHANGE;}
  double evalCalculatedVarI(unsigned numCalculatedVar) const override {throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);}
  void evalG(double) override {}
  void setGequations(std::map<int, std::string>&) override {}
  void defineElements(std::vector<Element> &, std::map<std::string, int>&) override {}
  void evalDerivatives(double) override {}
  void evalDerivativesPrim() override {}
  void evalF(propertyF_t) override {}
  void evalJt(double, int, SparseMatrix&) override {}
  void evalJtPrim(int, SparseMatrix&) override {}
  void evalNodeInjection() override {}
  void defineNonGenericParameters(std::vector<ParameterModeler>&) override {};
  void evalCalculatedVars() override {}
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned, std::vector<int>&) const override {}
  void evalJCalculatedVarI(unsigned, std::vector<double>&) const override {}
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

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELBUSBRIDGED_H_
