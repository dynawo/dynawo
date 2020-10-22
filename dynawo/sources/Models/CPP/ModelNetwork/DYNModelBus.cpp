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
 * @file  DYNModelBus.cpp
 *
 * @brief
 *
 */
#include <cmath>
#include <iostream>
#include <cassert>

#include <boost/algorithm/string/predicate.hpp>

#include "PARParametersSet.h"
#include "DYNModelBus.h"
#include "DYNModelSwitch.h"
#include "DYNModelConstants.h"
#include "DYNModelNetwork.h"
#include "DYNCommonModeler.h"
#include "DYNTrace.h"
#include "DYNSparseMatrix.h"
#include "DYNDerivative.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#include "DYNBusInterface.h"


using std::vector;
using boost::shared_ptr;
using boost::weak_ptr;
using std::map;
using std::string;

using parameters::ParametersSet;

namespace DYN {

ModelBusContainer::ModelBusContainer() {
}

void
ModelBusContainer::add(const shared_ptr<ModelBus>& model) {
  models_.push_back(model);
}

void
ModelBusContainer::resetCurrentUStatus() {
  for (vector<shared_ptr<ModelBus> >::const_iterator itB = models_.begin(); itB != models_.end(); ++itB)
    (*itB)->resetCurrentUStatus();
}

void
ModelBusContainer::evalF(propertyF_t type) {
  for (vector<shared_ptr<ModelBus> >::const_iterator itB = models_.begin(); itB != models_.end(); ++itB)
    (*itB)->evalF(type);
}

void
ModelBusContainer::evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset) {
  for (vector<shared_ptr<ModelBus> >::const_iterator itB = models_.begin(); itB != models_.end(); ++itB)
    (*itB)->evalJt(jt, cj, rowOffset);
}

void
ModelBusContainer::evalJtPrim(SparseMatrix& jt, const int& rowOffset) {
  for (vector<shared_ptr<ModelBus> >::const_iterator itB = models_.begin(); itB != models_.end(); ++itB)
    (*itB)->evalJtPrim(jt, rowOffset);
}

void
ModelBusContainer::resetSubNetwork() {
  subNetworks_.clear();
  for (vector<shared_ptr<ModelBus> >::iterator itModelBus = models_.begin(); itModelBus != models_.end(); ++itModelBus) {
    shared_ptr<ModelBus> bus = *itModelBus;
    bus->clearNeighbors();
    bus->clearNumSubNetwork();
  }
}

void
ModelBusContainer::resetNodeInjections() {
  for (vector<shared_ptr<ModelBus> >::iterator itModelBus = models_.begin(); itModelBus != models_.end(); ++itModelBus) {
    (*itModelBus)->resetNodeInjection();
  }
}

void
ModelBusContainer::exploreNeighbors(double t) {
  int numSubNetwork = 0;
  shared_ptr<SubNetwork> subNetwork(new SubNetwork(numSubNetwork));
  subNetworks_.push_back(subNetwork);

  for (vector<shared_ptr<ModelBus> >::iterator itModelBus = models_.begin(); itModelBus != models_.end(); ++itModelBus) {
    shared_ptr<ModelBus> bus = *itModelBus;
    if (!bus->numSubNetworkSet()) {  // Bus not yet treated
      bus->numSubNetwork(numSubNetwork);
      subNetwork->addBus(bus);
      bus->exploreNeighbors(numSubNetwork, subNetwork);

      ++numSubNetwork;
      subNetwork.reset(new SubNetwork(numSubNetwork));
      subNetworks_.push_back(subNetwork);
    }
  }

  // Erase the last subNetwork which is empty
  subNetworks_.erase(subNetworks_.end() - 1);

  Trace::debug(Trace::network()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::network()) << "SubNetworks at time " << t << Trace::endline;
  Trace::debug(Trace::network()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::network()) << DYNLog(NbSubNetwork, subNetworks_.size()) << Trace::endline;
  for (unsigned int i = 0; i < subNetworks_.size(); ++i) {
    Trace::debug(Trace::network()) << DYNLog(SubNetwork, i, subNetworks_[i]->nbBus()) << Trace::endline;
    for (unsigned int j = 0; j < subNetworks_[i]->nbBus(); ++j) {
      Trace::debug(Trace::network()) << "                " << subNetworks_[i]->bus(j)->id() << " (subNetwork " << i << ")" << Trace::endline;
    }
  }
}

void
ModelBusContainer::initRefIslands() {
  for (std::vector<boost::shared_ptr<ModelBus> >::iterator itModelBus = models_.begin(); itModelBus != models_.end(); ++itModelBus) {
    (*itModelBus)->setRefIslands(0);
  }
}

void
ModelBusContainer::initDerivatives() {
  for (std::vector<boost::shared_ptr<ModelBus> >::iterator itModelBus = models_.begin(); itModelBus != models_.end(); ++itModelBus)
    (*itModelBus)->initDerivatives();
}

ModelBus::ModelBus(const shared_ptr<BusInterface>& bus) :
Impl(bus->getID()),
stateUmax_(false),
stateUmin_(false),
U2Pu_(0.0),
UPu_(0.0),
U_(0.0),
connectionState_(CLOSED),
topologyModified_(false),
irConnection_(0.0),
iiConnection_(0.0),
refIslands_(0),
ir0_(0.0),
ii0_(0.0),
urYNum_(0),
uiYNum_(0),
iiYNum_(0),
irYNum_(0),
busIndex_(bus->getBusIndex()),
hasConnection_(bus->hasConnection()),
hasDifferentialVoltages_(false),
modelType_((boost::starts_with(bus->getID(), "calculatedBus_"))?"Bus":"Node") {
  neighbors_.clear();
  busBarSectionNames_.clear();
  busBarSectionNames_ = bus->getBusBarSectionNames();

  derivatives_.reset(new BusDerivatives());
  derivativesPrim_.reset(new BusDerivatives());

  // init data
  unom_ = bus->getVNom();
  u0_ = bus->getV0() / unom_;
  angle0_ = bus->getAngle0() * DEG_TO_RAD;

  ur0_ = u0_ * cos(angle0_);
  ui0_ = u0_ * sin(angle0_);

  uMax_ = bus->getVMax() / unom_;
  uMin_ = bus->getVMin() / unom_;

  constraintId_ = bus->getID();
  const vector<string>& busBarSections = bus->getBusBarSectionNames();
  if (boost::starts_with(bus->getID(), "calculatedBus_") && !busBarSections.empty()) {
    constraintId_ = busBarSections[0];
  }
}

bool
ModelBus::numSubNetworkSet() const {
  assert(z_ != NULL);
  return doubleNotEquals(z_[numSubNetworkNum_], -1.);
}

void
ModelBus::resetCurrentUStatus() {
  currentUStatus_.reset();
}

double
ModelBus::getCurrentU(UType_t currentURequested) {
  if (getSwitchOff())
    return 0;
  switch (currentURequested) {
    case UType_:
      if (currentUStatus_.getFlags(U)) {
        return U_;
      } else if (currentUStatus_.getFlags(UPu)) {
        U_ = calculateU();
        currentUStatus_.setFlags(U);
        return U_;
      } else if (currentUStatus_.getFlags(U2Pu)) {
        UPu_ = sqrt(U2Pu_);
        U_ = calculateU();
        currentUStatus_.setFlags(UPu | U);
        return U_;
      } else {
        U2Pu_ = calculateU2Pu();
        UPu_ = sqrt(U2Pu_);
        U_ = calculateU();
        currentUStatus_.setFlags(U2Pu | UPu | U);
        return U_;
      }
    case UPuType_:
      if (currentUStatus_.getFlags(UPu)) {
        return UPu_;
      } else if (currentUStatus_.getFlags(U2Pu)) {
        UPu_ = sqrt(U2Pu_);
        currentUStatus_.setFlags(UPu);
        return UPu_;
      } else {
        U2Pu_ = calculateU2Pu();
        UPu_ = sqrt(U2Pu_);
        currentUStatus_.setFlags(U2Pu | UPu);
        return UPu_;
      }
    case U2PuType_:
      if (currentUStatus_.getFlags(U2Pu)) {
        return U2Pu_;
      } else {
        U2Pu_ = calculateU2Pu();
        currentUStatus_.setFlags(U2Pu);
        return U2Pu_;
      }
  }
  return 0;
}

double
ModelBus::calculateU2Pu() const {
  double urPu = ur();
  double uiPu = ui();
  return urPu * urPu + uiPu * uiPu;
}

void
ModelBus::initSize() {
  if (network_->isInitModel()) {
    sizeF_ = 2;
    sizeY_ = 2;
    sizeZ_ = 0;
    sizeG_ = 0;
    sizeMode_ = 0;
    sizeCalculatedVar_ = 0;
  } else {
    sizeF_ = 2;
    sizeY_ = 2;
    if (hasConnection_)
      sizeY_ = 4;
    sizeZ_ = 3;  // numCC, switchOff, state
    sizeG_ = 2;  // U> Umax or U< Umin
    sizeMode_ = 0;
    sizeCalculatedVar_ = nbCalculatedVariables_;
  }
}

double
ModelBus::ur() const {
  if (!getSwitchOff()) {
    if (network_->isInit())
      return ur0_;
    else
      return y_[urNum_];
  } else {
    return 0.;
  }
}

double
ModelBus::ui() const {
  if (!getSwitchOff()) {
    if (network_->isInit())
      return ui0_;
    else
      return y_[uiNum_];
  } else {
    return 0.;
  }
}

double
ModelBus::urp() const {
  if (!getSwitchOff() && !network_->isInit()) {
      return yp_[urNum_];
  } else {
    return 0.;
  }
}

double
ModelBus::uip() const {
  if (!getSwitchOff() && !network_->isInit()) {
      return yp_[uiNum_];
  } else {
    return 0.;
  }
}

void
ModelBus::setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& params) {
  bool success = false;
  double value = getParameterDynamicNoThrow<double>(params, "bus_uMax", success);
  if (success)
    uMax_ = value;

  success = false;
  value = getParameterDynamicNoThrow<double>(params, "bus_uMin", success);
  if (success)
    uMin_ = value;
}

void
ModelBus::initDerivatives() {
  derivatives_->reset();
  derivativesPrim_->reset();
}

void
ModelBus::exploreNeighbors(const int& numSubNetwork, const shared_ptr<SubNetwork>& subNetwork) {
  vector<weak_ptr<ModelBus> >::iterator itModelBus;
  for (itModelBus = neighbors_.begin(); itModelBus != neighbors_.end(); ++itModelBus) {
    shared_ptr<ModelBus> bus = (*itModelBus).lock();
    if (!bus->numSubNetworkSet()) {  // Bus not yet treated
      bus->numSubNetwork(numSubNetwork);
      subNetwork->addBus(bus);
      bus->exploreNeighbors(numSubNetwork, subNetwork);
    }
  }
}

void
ModelBus::addNeighbor(boost::shared_ptr<ModelBus>& bus) {
  neighbors_.push_back(bus);
}

void
ModelBus::evalDerivatives(const double /*cj*/) {
  if (!network_->isInitModel() && hasConnection_) {
    derivatives_->addDerivative(IR_DERIVATIVE, irYNum_, -1);
    derivatives_->addDerivative(II_DERIVATIVE, iiYNum_, -1);
  }
}

void
ModelBus::evalF(propertyF_t type) {
  if (network_->isInitModel()) {
    f_[0] = ir0_;
    f_[1] = ii0_;
  } else {
    if (type == DIFFERENTIAL_EQ && !hasDifferentialVoltages_)
      return;
    if (getSwitchOff()) {
      f_[0] = y_[urNum_];
      f_[1] = y_[uiNum_];
    } else {
      f_[0] = irConnection_;
      f_[1] = iiConnection_;

      if (hasConnection_) {
        f_[0] -= y_[irNum_];
        f_[1] -= y_[iiNum_];
      }
    }
  }
}

void
ModelBus::setFequations(std::map<int, std::string>& fEquationIndex) {
  if (getSwitchOff()) {
    fEquationIndex[0] = std::string(":y_[urNum_] localModel:").append(id());
    fEquationIndex[1] = std::string(":y_[uiNum_] localModel:").append(id());
  } else {
    fEquationIndex[0] = std::string("irConnection_ localModel:").append(id());
    fEquationIndex[1] = std::string("iiConnection_ localModel:").append(id());

    if (hasConnection_) {
      fEquationIndex[0] = std::string("irConnection_ - y_[irNum_] localModel:").append(id());
      fEquationIndex[1] = std::string("iiConnection_ - y_[iiNum_] localModel:").append(id());
    }
  }

  assert(fEquationIndex.size() == (unsigned int) sizeF() && "ModelBus: fEquationIndex.size != f_.size()");
}

void
ModelBus::resetNodeInjection() {
  if (network_->isInit() || network_->isInitModel()) {
    ir0_ = 0.0;
    ii0_ = 0.0;
  } else {
    irConnection_ = 0.0;
    iiConnection_ = 0.0;
  }
}

void
ModelBus::irAdd(const double& ir) {
  if (network_->isInit() || network_->isInitModel()) {
    ir0_ += ir;
  } else {
    irConnection_ += ir;
  }
}

void
ModelBus::iiAdd(const double& ii) {
  if (network_->isInit() || network_->isInitModel()) {
    ii0_ += ii;
  } else {
    iiConnection_ += ii;
  }
}

void
ModelBus::evalYType() {
  yType_[0] = ALGEBRAIC;
  yType_[1] = ALGEBRAIC;

  if (hasDifferentialVoltages_ && !getSwitchOff()) {
    yType_[0] = DIFFERENTIAL;
    yType_[1] = DIFFERENTIAL;
  }

  if (!network_->isInitModel() && hasConnection_) {
    yType_[2] = ALGEBRAIC;
    yType_[3] = ALGEBRAIC;
  }
}

void
ModelBus::updateYType() {
  evalYType();
}

void
ModelBus::evalFType() {
  fType_[0] = ALGEBRAIC_EQ;
  fType_[1] = ALGEBRAIC_EQ;
  if (hasDifferentialVoltages_ && !getSwitchOff()) {
    fType_[0] = DIFFERENTIAL_EQ;
    fType_[1] = DIFFERENTIAL_EQ;
  }
}

void
ModelBus::updateFType() {
  evalFType();
}

void
ModelBus::collectSilentZ(BitMask* silentZTable) {
  silentZTable[numSubNetworkNum_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[connectionStateNum_].setFlags(NotUsedInDiscreteEquations);
}


void
ModelBus::evalCalculatedVars() {
  if (getSwitchOff()) {
    calculatedVars_[upuNum_] = 0.;
    calculatedVars_[phipuNum_] = 0.;
    calculatedVars_[uNum_] = 0.;
    calculatedVars_[phiNum_] = 0.;
  } else {
    calculatedVars_[uNum_] = getCurrentU(ModelBus::UType_);
    calculatedVars_[upuNum_] = getCurrentU(ModelBus::UPuType_);
    calculatedVars_[phipuNum_] = atan2(y_[uiNum_], y_[urNum_]);
    calculatedVars_[phiNum_] = calculatedVars_[phipuNum_] * RAD_TO_DEG;
  }
}

void
ModelBus::init(int& yNum) {
  if (network_->isInitModel()) {
    urYNum_ = yNum;
    ++yNum;
    uiYNum_ = yNum;
    ++yNum;
    irYNum_ = -1;
    iiYNum_ = -1;
  } else {
    urYNum_ = yNum;
    ++yNum;
    uiYNum_ = yNum;
    ++yNum;

    if (hasConnection_) {
      irYNum_ = yNum;
      ++yNum;
      iiYNum_ = yNum;
      ++yNum;
    } else {
      irYNum_ = -1;
      iiYNum_ = -1;
    }
  }
}

void
ModelBus::getY0() {
  if (network_->isInitModel()) {
    if (getSwitchOff()) {
      y_[0] = 0.0;
      y_[1] = 0.0;
    } else {
      y_[0] = ur0_;
      y_[1] = ui0_;
    }
  } else {
    if (getSwitchOff()) {
      y_[0] = 0.0;
      y_[1] = 0.0;
    } else {
      y_[0] = ur0_;
      y_[1] = ui0_;
    }

    yp_[0] = 0.0;
    yp_[1] = 0.0;
    if (hasConnection_) {
      y_[2] = ir0_;
      y_[3] = ii0_;
      yp_[2] = 0.0;
      yp_[3] = 0.0;
    }

    // We assume here that z_[numSubNetworkNum_] was already initialized!!
    if (doubleNotEquals(z_[switchOffNum_], -1.) && doubleNotEquals(z_[switchOffNum_], 1.))
      z_[switchOffNum_] = fromNativeBool(false);
    z_[connectionStateNum_] = connectionState_;
  }
}

void
ModelBus::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Upu_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_phipu_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_U_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_phi_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_PWPIN_vr", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_PWPIN_vi", CONTINUOUS));
  variables.push_back(VariableAliasFactory::create(id_ + "_ACPIN_V_re", id_ + "_PWPIN_vr"));
  variables.push_back(VariableAliasFactory::create(id_ + "_ACPIN_V_im", id_ + "_PWPIN_vi"));
  if (hasConnection_) {
    variables.push_back(VariableNativeFactory::createState(id_ + "_PWPIN_ir", FLOW));
    variables.push_back(VariableNativeFactory::createState(id_ + "_PWPIN_ii", FLOW));
    variables.push_back(VariableAliasFactory::create(id_ + "_ACPIN_i_re", id_ + "_PWPIN_ir"));
    variables.push_back(VariableAliasFactory::create(id_ + "_ACPIN_i_im", id_ + "_PWPIN_ii"));
  }
  variables.push_back(VariableNativeFactory::createState(id_ + "_numcc_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_switchOff_value", BOOLEAN));
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", DISCRETE));

  for (unsigned int i = 0; i < busBarSectionNames_.size(); ++i) {
    std::string busBarSectionId = busBarSectionNames_[i];
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_Upu_value", id_ + "_Upu_value"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_phipu_value", id_ + "_phipu_value"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_U_value", id_ + "_U_value"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_phi_value", id_ + "_phi_value"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_PWPIN_vr", id_ + "_PWPIN_vr"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_PWPIN_vi", id_ + "_PWPIN_vi"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_ACPIN_V_re", id_ + "_PWPIN_vr"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_ACPIN_V_im", id_ + "_PWPIN_vi"));
    if (hasConnection_) {
      variables.push_back(VariableAliasFactory::create(busBarSectionId + "_PWPIN_ir", id_ + "_PWPIN_ir"));
      variables.push_back(VariableAliasFactory::create(busBarSectionId + "_PWPIN_ii", id_ + "_PWPIN_ii"));
      variables.push_back(VariableAliasFactory::create(busBarSectionId + "_ACPIN_i_re", id_ + "_PWPIN_ir"));
      variables.push_back(VariableAliasFactory::create(busBarSectionId + "_ACPIN_i_im", id_ + "_PWPIN_ii"));
    }
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_numcc_value", id_ + "_numcc_value"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_switchOff_value", id_ + "_switchOff_value"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_state_value", id_ + "_state_value"));
  }
}

void
ModelBus::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("bus_uMax", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("bus_uMin", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

void
ModelBus::defineNonGenericParameters(vector<ParameterModeler>& /*parameters*/) {
  // not parameter
}

void
ModelBus::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Upu_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_phipu_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_U_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_phi_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_PWPIN_vr", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_PWPIN_vi", CONTINUOUS));
  variables.push_back(VariableAliasFactory::create("@ID@_ACPIN_V_re", "@ID@_PWPIN_vr"));
  variables.push_back(VariableAliasFactory::create("@ID@_ACPIN_V_im", "@ID@_PWPIN_vi"));
  variables.push_back(VariableNativeFactory::createState("@ID@_PWPIN_ir", FLOW));
  variables.push_back(VariableNativeFactory::createState("@ID@_PWPIN_ii", FLOW));
  variables.push_back(VariableAliasFactory::create("@ID@_ACPIN_i_re", "@ID@_PWPIN_ir"));
  variables.push_back(VariableAliasFactory::create("@ID@_ACPIN_i_im", "@ID@_PWPIN_ii"));
  variables.push_back(VariableNativeFactory::createState("@ID@_numcc_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_switchOff_value", BOOLEAN));
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", DISCRETE));
}

void
ModelBus::defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  defineElementsById(id_, elements, mapElement);
  for (unsigned int i = 0; i < busBarSectionNames_.size(); ++i)
    defineElementsById(busBarSectionNames_[i], elements, mapElement);
}

void
ModelBus::defineElementsById(const std::string& id, std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  if (hasConnection_) {
    string name = id + string("_PWPIN");
    addElement(name, Element::STRUCTURE, elements, mapElement);
    addSubElement("vr", name, Element::TERMINAL, id_, modelType_, elements, mapElement);
    addSubElement("vi", name, Element::TERMINAL, id_, modelType_, elements, mapElement);
    addSubElement("ir", name, Element::TERMINAL, id_, modelType_, elements, mapElement);
    addSubElement("ii", name, Element::TERMINAL, id_, modelType_, elements, mapElement);

    string ACName = id + string("_ACPIN");
    addElement(ACName, Element::STRUCTURE, elements, mapElement);
    string ACNameI = id + string("_ACPIN_i");
    string ACNameV = id + string("_ACPIN_V");
    addElement(ACNameI, Element::STRUCTURE, elements, mapElement);
    addElement(ACNameV, Element::STRUCTURE, elements, mapElement);
    addSubElement("i", ACName, Element::STRUCTURE, id_, modelType_, elements, mapElement);
    addSubElement("V", ACName, Element::STRUCTURE, id_, modelType_, elements, mapElement);
    addSubElement("re", ACNameI, Element::TERMINAL, id_, modelType_, elements, mapElement);
    addSubElement("im", ACNameI, Element::TERMINAL, id_, modelType_, elements, mapElement);
    addSubElement("re", ACNameV, Element::TERMINAL, id_, modelType_, elements, mapElement);
    addSubElement("im", ACNameV, Element::TERMINAL, id_, modelType_, elements, mapElement);
  }

  // Calculated variables addition
  addElementWithValue(id + string("_Upu"), modelType_, elements, mapElement);
  addElementWithValue(id + string("_phipu"), modelType_, elements, mapElement);
  addElementWithValue(id + string("_U"), modelType_, elements, mapElement);
  addElementWithValue(id + string("_phi"), modelType_, elements, mapElement);

  // Discrete variables addition
  addElementWithValue(id + string("_numcc"), modelType_, elements, mapElement);
  addElementWithValue(id + string("_switchOff"), modelType_, elements, mapElement);
  addElementWithValue(id + string("_state"), modelType_, elements, mapElement);
}

NetworkComponent::StateChange_t
ModelBus::evalZ(const double& /*t*/) {
  if (g_[0] == ROOT_UP && !stateUmax_) {
    network_->addConstraint(constraintId_, true, DYNConstraint(USupUmax), modelType_);
    stateUmax_ = true;
  } else if (g_[0] == ROOT_DOWN && stateUmax_) {
    network_->addConstraint(constraintId_, false, DYNConstraint(USupUmax), modelType_);
    stateUmax_ = false;
  }

  if (g_[1] == ROOT_UP && !stateUmin_) {
    network_->addConstraint(constraintId_, true, DYNConstraint(UInfUmin), modelType_);
    stateUmin_ = true;
  } else if (g_[1] == ROOT_DOWN && stateUmin_) {
    network_->addConstraint(constraintId_, false, DYNConstraint(UInfUmin), modelType_);
    stateUmin_ = false;
  }

  State currState = static_cast<State>(static_cast<int>(z_[connectionStateNum_]));
  if (currState != connectionState_) {
    topologyModified_ = true;
    if (currState == OPEN) {
      switchOff();
      network_->addEvent(id_, DYNTimeline(NodeOff));
      // open all switch connected to this node
      for (unsigned int i = 0; i < connectableSwitches_.size(); ++i) {
        connectableSwitches_[i].lock()->open();
      }
    } else if (currState == CLOSED) {
      switchOn();
      network_->addEvent(id_, DYNTimeline(NodeOn));
    }
    connectionState_ = static_cast<State>(static_cast<int>(z_[connectionStateNum_]));
  }
  return (topologyModified_)? NetworkComponent::TOPO_CHANGE: NetworkComponent::NO_CHANGE;
}

void
ModelBus::evalG(const double& /*t*/) {
  double upu = getCurrentU(ModelBus::UPuType_);
  g_[0] = (upu - uMax_ > 0) ? ROOT_UP : ROOT_DOWN;  // U > Umax
  g_[1] = (uMin_ - upu > 0 && !getSwitchOff()) ? ROOT_UP : ROOT_DOWN;  // U < Umin
}

void
ModelBus::setGequations(std::map<int, std::string>& gEquationIndex) {
  gEquationIndex[0] = "U > UMax";
  gEquationIndex[1] = "U < UMin";

  assert(gEquationIndex.size() == (unsigned int) sizeG() && "Model Bus: gEquationIndex.size() != g_.size()");
}

void
ModelBus::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, vector<int>& numVars) const {
  switch (numCalculatedVar) {
    case upuNum_:
    case phipuNum_:
    case uNum_:
    case phiNum_:
      numVars.push_back(urYNum_);
      numVars.push_back(uiYNum_);
      break;
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

void
ModelBus::evalJCalculatedVarI(unsigned numCalculatedVar, vector<double>& res) const {
  double ur = y_[urNum_];
  double ui = y_[uiNum_];
  switch (numCalculatedVar) {
    case upuNum_: {
      if (getSwitchOff()) {
        res[0] = 0.0;
        res[1] = 0.0;
      } else {
        res[0] = ur * 1 / sqrt(ur * ur + ui * ui);
        res[1] = ui * 1 / sqrt(ur * ur + ui * ui);
      }
      break;
    }
    case phipuNum_: {
      if (getSwitchOff()) {
        res[0] = 0.0;
        res[1] = 0.0;
      } else {
        double v3 = 1 / ur;
        double v2 = 1 / (1 + pow(ui / ur, 2));
        res[0] = -ui * pow(ur, -2) * v2;
        res[1] = v3*v2;
      }
      break;
    }
    case uNum_: {
      if (getSwitchOff()) {
        res[0] = 0.0;
        res[1] = 0.0;
      } else {
        res[0] = ur * 1 / sqrt(ur * ur + ui * ui) * unom_;
        res[1] = ui * 1 / sqrt(ur * ur + ui * ui) * unom_;
      }
      break;
    }
    case phiNum_: {
      if (getSwitchOff()) {
        res[0] = 0.0;
        res[1] = 0.0;
      } else {
        double v3 = 1 / ur;
        double v2 = 1 / (1 + pow(ui / ur, 2));
        res[0] = -ui * pow(ur, -2) * v2*RAD_TO_DEG;
        res[1] = v3 * v2*RAD_TO_DEG;
      }
      break;
    }
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

double
ModelBus::evalCalculatedVarI(unsigned numCalculatedVar) const {
  double output = 0.0;
  double ur = y_[urNum_];
  double ui = y_[uiNum_];
  switch (numCalculatedVar) {
    case upuNum_:
      if (getSwitchOff())
        output = 0.0;
      else
        output = sqrt(ur * ur + ui * ui);  // Voltage module in pu
      break;
    case phipuNum_:
      if (getSwitchOff())
        output = 0.0;
      else
        output = atan2(ui, ur);  // Voltage angle in pu
      break;
    case uNum_:
      if (getSwitchOff())
        output = 0.0;
      else
        output = sqrt(ur * ur + ui * ui) * unom_;  // Voltage module in kV
      break;
    case phiNum_:
      if (getSwitchOff())
        output = 0.0;
      else
        output = atan2(ui, ur) * RAD_TO_DEG;  // Voltage angle in degree
      break;
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);
  }
  return output;
}

void
ModelBus::evalJt(SparseMatrix& jt, const double& /*cj*/, const int& rowOffset) {
  if (getSwitchOff()) {
    jt.changeCol();
    jt.addTerm(urYNum() + rowOffset, 1.0);
    jt.changeCol();
    jt.addTerm(uiYNum() + rowOffset, 1.0);
  } else if (derivatives_->empty()) {  // Disconnected bus
    jt.changeCol();
    jt.changeCol();
  } else {
    // Column for the real part of the node current
    // ----------------------------------
    // Switching column
    jt.changeCol();
    const map<int, double>& irDerivativesValues = derivatives_->getValues(IR_DERIVATIVE);
    map<int, double>::const_iterator iter = irDerivativesValues.begin();
    for (; iter != irDerivativesValues.end(); ++iter) {
      jt.addTerm(iter->first + rowOffset, iter->second);
    }

    // Column for the imaginary part of the node current
    // ---------------------------------------
    // Switching column
    jt.changeCol();
    const map<int, double>& iiDerivativesValues = derivatives_->getValues(II_DERIVATIVE);
    iter = iiDerivativesValues.begin();
    for (; iter != iiDerivativesValues.end(); ++iter) {
      jt.addTerm(iter->first + rowOffset, iter->second);
    }
  }
}

void
ModelBus::evalJtPrim(SparseMatrix& jt, const int& rowOffset) {
  // y' in network equations - differential voltages
  if (hasDifferentialVoltages_ && !getSwitchOff() && !derivativesPrim_->empty()) {
    jt.changeCol();
    const map<int, double>& irDerivativesValues = derivativesPrim_->getValues(IR_DERIVATIVE);
    for (map<int, double>::const_iterator iter = irDerivativesValues.begin(); iter != irDerivativesValues.end(); ++iter) {
      jt.addTerm(iter->first + rowOffset, iter->second);
    }

    jt.changeCol();
    const map<int, double>& iiDerivativesValues = derivativesPrim_->getValues(II_DERIVATIVE);
    for (map<int, double>::const_iterator iter = iiDerivativesValues.begin(); iter != iiDerivativesValues.end(); ++iter) {
      jt.addTerm(iter->first + rowOffset, iter->second);
    }
  } else {
    // no y' in network equations, we only change the column index in Jacobian
    // column change - real part of the node current
    jt.changeCol();
    // column change - imaginary part of the node current
    jt.changeCol();
  }
}

NetworkComponent::StateChange_t
ModelBus::evalState(const double& /*time*/) {
  StateChange_t state = NetworkComponent::NO_CHANGE;
  if (topologyModified_) {
    topologyModified_ = false;
    state = NetworkComponent::TOPO_CHANGE;
  }
  return state;
}

void
ModelBus::switchOff() {
  assert(z_!= NULL);
  z_[switchOffNum_] = fromNativeBool(true);
  // force Ur and Ui to be equals to zero (easier to solve)
  if (y_ != NULL) {
    y_[urNum_] = 0.0;
    y_[uiNum_] = 0.0;
  }
}

void
SubNetwork::shutDownNodes() {
  for (unsigned int i = 0; i < bus_.size(); ++i) {
    if (!bus_[i]->getSwitchOff()) {
      bus_[i]->switchOff();
      Trace::info() << DYNLog(SwitchOffBus, bus_[i]->id()) << Trace::endline;
    }
  }
}

void
SubNetwork::turnOnNodes() {
  for (unsigned int i = 0; i < bus_.size(); ++i) {
    if (bus_[i]->getSwitchOff()) {
      bus_[i]->switchOn();
      Trace::info() << DYNLog(SwitchOnBus, bus_[i]->id()) << Trace::endline;
    }
  }
}


}  // namespace DYN
