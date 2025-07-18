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

#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>
#include <boost/serialization/vector.hpp>

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
internalVariablesFoundInDump_(false),
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
internalVariablesFoundInDump_(false),
offsetCalculatedVar_(0),
id_(id),
network_(NULL) { }

void
NetworkComponent::setBufferYType(propertyContinuousVar_t* yType, const unsigned int offset) {
  yType_ = &(yType[offset]);
}

void
NetworkComponent::setBufferFType(propertyF_t* fType, const unsigned int offset) {
  fType_ = &(fType[offset]);
}

void
NetworkComponent::setReferenceY(double* y, double* yp, double* f, const int offsetY, const int offsetF) {
  if (sizeY() != 0) {
    y_ = &(y[offsetY]);
    yp_ = &(yp[offsetY]);
  }

  if (sizeF() != 0)
    f_ = &(f[offsetF]);
}

void
NetworkComponent::setReferenceZ(double* z, bool* zConnected, const int offsetZ) {
  if (sizeZ() != 0) {
    z_ = &(z[offsetZ]);
    zConnected_ = &(zConnected[offsetZ]);
  }
}

void
NetworkComponent::setReferenceG(state_g* g, const int offsetG) {
  if (sizeG() != 0)
    g_ = &(g[offsetG]);
}

void
NetworkComponent::setReferenceCalculatedVar(double* calculatedVars, const int offsetCalculatedVars) {
  if (sizeCalculatedVar() != 0)
    calculatedVars_ = &(calculatedVars[offsetCalculatedVars]);
}

void
NetworkComponent::setNetwork(ModelNetwork* model) {
  network_ = model;
}

ParameterModeler
NetworkComponent::findParameter(const string& name, const std::unordered_map<string, ParameterModeler>& params) {
  const auto it = params.find(name);
  if (it != params.end()) {
    return it->second;
  }
  throw DYNError(Error::MODELER, ParameterNotDefined, name);
}

bool
NetworkComponent::hasParameter(const string& name, const std::unordered_map<string, ParameterModeler>& params) {
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
    vector<Element>& elements, std::map<string, int>& mapElement) const {
  addElement(elementName, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", elementName, Element::TERMINAL, id(), parentType, elements, mapElement);
}

NetworkComponent::startingPointMode_t
NetworkComponent::getStartingPointMode(const std::string& startingPointMode) {
  std::map<std::string, startingPointMode_t> enumResolver = {{"flat", startingPointMode_t::FLAT},
                                                             {"warm", startingPointMode_t::WARM}};
  const auto it = enumResolver.find(startingPointMode);
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
NetworkComponent::dumpInternalVariables(boost::archive::binary_oarchive&) const {
  // not needed: internal variables are specific to child classes
}

void
NetworkComponent::loadInternalVariables(boost::archive::binary_iarchive&) {
  // not needed: internal variables are specific to child classes
}

unsigned
NetworkComponent::getNbInternalVariables() const {
  return 0;
}

void
NetworkComponent::dumpVariables(boost::archive::binary_oarchive& streamVariables) const {
  vector<double> y(y_, y_ + sizeY());
  vector<double> yp(yp_, yp_ + sizeY());
  vector<double> z(z_, z_ + sizeZ());
  vector<double> g(g_, g_ + sizeG());

  streamVariables << y;
  streamVariables << yp;
  streamVariables << z;
  streamVariables << g;

  streamVariables << getNbInternalVariables();
  dumpInternalVariables(streamVariables);
}

bool
NetworkComponent::loadVariables(boost::archive::binary_iarchive& streamVariables, const std::string&) {
  vector<double> yValues;
  vector<double> ypValues;
  vector<double> zValues;
  vector<double> gValues;
  streamVariables >> yValues;
  streamVariables >> ypValues;
  streamVariables >> zValues;
  streamVariables >> gValues;

  unsigned readNbInternalVariables;
  streamVariables >> readNbInternalVariables;

  if (yValues.size() != static_cast<size_t>(sizeY()) || ypValues.size() != static_cast<size_t>(sizeY()) ||
      zValues.size() != static_cast<size_t>(sizeZ()) || gValues.size() != static_cast<size_t>(sizeG()) ||
      readNbInternalVariables != getNbInternalVariables()) {
    Trace::debug() << DYNLog(WrongParameterNum, id_) << Trace::endline;
    double dummyValueD;
    bool dummyValueB;
    int dummyValueI;
    char type;
    for (unsigned j = 0; j < readNbInternalVariables; ++j) {
      streamVariables >> type;
      if (type == 'B')
        streamVariables >> dummyValueB;
      else if (type == 'D')
        streamVariables >> dummyValueD;
      else if (type == 'I')
        streamVariables >> dummyValueI;
    }
    // Fall back on default initialization for this component
    getY0();
    return false;
  }
  setInternalVariablesFoundInDump(true);
  loadInternalVariables(streamVariables);

  // loading values
  std::copy(yValues.begin(), yValues.end(), y_);
  std::copy(ypValues.begin(), ypValues.end(), yp_);
  std::copy(zValues.begin(), zValues.end(), z_);
  std::copy(gValues.begin(), gValues.end(), g_);
  return true;
}

}  // namespace DYN
