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
 * @file  DYNNetworkComponent.cpp
 *
 * @brief
 *
 */
#include <iostream>
#include "PARParametersSet.h"

#include "DYNNetworkComponent.h"
#include "DYNModelNetwork.h"
#include "DYNMacrosMessage.h"
#include "DYNParameter.h"
#include "DYNElement.h"
#include "DYNCommonModeler.h"
#include "DYNTrace.h"

using std::vector;
using std::string;
using std::stringstream;
using boost::shared_ptr;
using parameters::ParametersSet;


namespace DYN {

NetworkComponent::~NetworkComponent() {
  network_ = NULL;
}

NetworkComponent::NetworkComponent():
y_(NULL),
yp_(NULL),
f_(NULL),
z_(NULL),
zConnected_(NULL),
calculatedVars_(NULL),
g_(NULL),
fType_(NULL),
yType_(NULL),
sizeF_(0),
sizeY_(0),
sizeZ_(0),
sizeG_(0),
sizeMode_(0),
sizeCalculatedVar_(0),
offsetCalculatedVar_(0),
network_(NULL) { }

NetworkComponent::NetworkComponent(const string& id) :
y_(NULL),
yp_(NULL),
f_(NULL),
z_(NULL),
zConnected_(NULL),
calculatedVars_(NULL),
g_(NULL),
fType_(NULL),
yType_(NULL),
sizeF_(0),
sizeY_(0),
sizeZ_(0),
sizeG_(0),
sizeMode_(0),
sizeCalculatedVar_(0),
offsetCalculatedVar_(0),
id_(id),
network_(NULL) { }

void
NetworkComponent::resetInternalVariables() {
  // nothing to do
}

void
NetworkComponent::setBufferYType(propertyContinuousVar_t* yType, const unsigned int& offset) {
  yType_ = &(yType[offset]);
}

void
NetworkComponent::setBufferFType(propertyF_t* fType, const unsigned int& offset) {
  fType_ = &(fType[offset]);
}

void
NetworkComponent::setReferenceY(double* y, double* yp, double* f, const int& offsetY, const int& offsetF) {
  if (sizeY() != 0) {
    y_ = &(y[offsetY]);
    yp_ = &(yp[offsetY]);
  }

  if (sizeF() != 0)
    f_ = &(f[offsetF]);
}

void
NetworkComponent::setReferenceZ(double* z, bool* zConnected, const int& offsetZ) {
  if (sizeZ() != 0) {
    z_ = &(z[offsetZ]);
    zConnected_ = &(zConnected[offsetZ]);
  }
}

void
NetworkComponent::setReferenceG(state_g* g, const int& offsetG) {
  if (sizeG() != 0)
    g_ = &(g[offsetG]);
}

void
NetworkComponent::setReferenceCalculatedVar(double* calculatedVars, const int& offsetCalculatedVar) {
  if (sizeCalculatedVar() != 0)
    calculatedVars_ = &(calculatedVars[offsetCalculatedVar]);
}

void
NetworkComponent::setNetwork(ModelNetwork* model) {
  network_ = model;
}

ParameterModeler
NetworkComponent::findParameter(const string& name, const std::unordered_map<string, ParameterModeler>& params) const {
  std::unordered_map<string, ParameterModeler>:: const_iterator it = params.find(name);
  if (it != params.end()) {
    return it->second;
  }
  throw DYNError(Error::MODELER, ParameterNotDefined, name);
}

bool
NetworkComponent::hasParameter(const string& name, const std::unordered_map<string, ParameterModeler>& params) const {
  return params.find(name) != params.end();
}

template <>
double NetworkComponent::getParameterDynamicNoThrow(const std::unordered_map<std::string, ParameterModeler>& params,
      const std::string& id, bool& foundParam, const std::vector<std::string>& ids) const {
  double value = 0.;
  findParameterDynamicNoThrow<double>(params, id, foundParam, ids, value);
  return value;
}

template <>
int NetworkComponent::getParameterDynamicNoThrow(const std::unordered_map<std::string, ParameterModeler>& params,
      const std::string& id, bool& foundParam, const std::vector<std::string>& ids) const {
  int value = 0;
  findParameterDynamicNoThrow<int>(params, id, foundParam, ids, value);
  return value;
}

template <>
bool NetworkComponent::getParameterDynamicNoThrow(const std::unordered_map<std::string, ParameterModeler>& params,
      const std::string& id, bool& foundParam, const std::vector<std::string>& ids) const {
  bool value = false;
  findParameterDynamicNoThrow<bool>(params, id, foundParam, ids, value);
  return value;
}

template <>
std::string NetworkComponent::getParameterDynamicNoThrow(const std::unordered_map<std::string, ParameterModeler>& params,
      const std::string& id, bool& foundParam, const std::vector<std::string>& ids) const {
  std::string value = "";
  findParameterDynamicNoThrow<std::string>(params, id, foundParam, ids, value);
  return value;
}

void
NetworkComponent::addElementWithValue(const string& elementName, const std::string& parentType,
    vector<Element>& elements, std::map<string, int>& mapElement) {
  addElement(elementName, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", elementName, Element::TERMINAL, id(), parentType, elements, mapElement);
}

NetworkComponent::startingPointMode_t
NetworkComponent::getStartingPointMode(const std::string& startingPointMode) {
  std::map<std::string, startingPointMode_t> enumResolver = {{"flat", startingPointMode_t::FLAT},
                                                             {"warm", startingPointMode_t::WARM}};
  auto it = enumResolver.find(startingPointMode);
  if (it != enumResolver.end()) {
    return it->second;
  } else {
    Trace::warn() << DYNLog(StartingPointModeNotFound, startingPointMode) << Trace::endline;
    return startingPointMode_t::WARM;
  }
}

void
NetworkComponent::printInternalParameters(std::ofstream& /*fstream*/) const {
  // not needed
}

void
NetworkComponent::dumpInternalVariables(stringstream&) const {
  // not needed: internal variables are specific to child classes
}

void
NetworkComponent::loadInternalVariables(stringstream&) {
  // not needed: internal variables are specific to child classes
}

}  // namespace DYN
