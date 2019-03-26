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
 * @file  DYNNetworkComponentImpl.cpp
 *
 * @brief
 *
 */
#include <iostream>
#include "PARParametersSet.h"

#include "DYNNetworkComponentImpl.h"
#include "DYNModelNetwork.h"
#include "DYNMacrosMessage.h"
#include "DYNParameter.h"

using std::vector;
using std::string;
using boost::shared_ptr;
using parameters::ParametersSet;


namespace DYN {

NetworkComponent::Impl::Impl() :
id_("") {
  y_ = NULL;
  yp_ = NULL;
  f_ = NULL;
  z_ = NULL;
  g_ = NULL;
  yType_ = NULL;
  fType_ = NULL;
  calculatedVars_ = NULL;
  sizeG_ = 0;
  sizeZ_ = 0;
  sizeF_ = 0;
  sizeY_ = 0;
  sizeCalculatedVar_ = 0;
  offsetCalculatedVar_ = 0;
  sizeMode_ = 0;
  network_ = NULL;
}

NetworkComponent::Impl::Impl(const string& id) :
id_(id) {
  y_ = NULL;
  yp_ = NULL;
  f_ = NULL;
  z_ = NULL;
  g_ = NULL;
  yType_ = NULL;
  fType_ = NULL;
  calculatedVars_ = NULL;
  sizeG_ = 0;
  sizeZ_ = 0;
  sizeY_ = 0;
  sizeCalculatedVar_ = 0;
  offsetCalculatedVar_ = 0;
  sizeMode_ = 0;
  sizeF_ = 0;
  network_ = NULL;
}

NetworkComponent::Impl::~Impl() {
}

void
NetworkComponent::Impl::setBufferYType(propertyContinuousVar_t* yType, const unsigned int& offset) {
  yType_ = &(yType[offset]);
}

void
NetworkComponent::Impl::setBufferFType(propertyF_t* fType, const unsigned int& offset) {
  fType_ = &(fType[offset]);
}

void
NetworkComponent::Impl::setReferenceY(double* y, double* yp, double* f, const int& offsetY, const int& offsetF) {
  if (sizeY() != 0) {
    y_ = &(y[offsetY]);
    yp_ = &(yp[offsetY]);
  }

  if (sizeF() != 0)
    f_ = &(f[offsetF]);
}

void
NetworkComponent::Impl::setReferenceZ(double* z, const int& offsetZ) {
  if (sizeZ() != 0)
    z_ = &(z[offsetZ]);
}

void
NetworkComponent::Impl::setReferenceG(state_g* g, const int& offsetG) {
  if (sizeG() != 0)
    g_ = &(g[offsetG]);
}

void
NetworkComponent::Impl::setReferenceCalculatedVar(double* calculatedVars, const int& offsetCalculatedVar) {
  if (sizeCalculatedVar() != 0)
    calculatedVars_ = &(calculatedVars[offsetCalculatedVar]);
}

void
NetworkComponent::Impl::setNetwork(ModelNetwork* model) {
  network_ = model;
}

ParameterModeler
NetworkComponent::Impl::findParameter(const string& name, const boost::unordered_map<string, ParameterModeler>& params) const {
  boost::unordered_map<string, ParameterModeler>:: const_iterator it = params.find(name);
  if (it != params.end()) {
    return it->second;
  }
  throw DYNError(Error::MODELER, ParameterNotDefined, name);
}

bool
NetworkComponent::Impl::hasParameter(const string& name, const boost::unordered_map<string, ParameterModeler>& params) const {
  return params.find(name) != params.end();
}

template <>
double NetworkComponent::Impl::getParameterDynamicNoThrow(const boost::unordered_map<std::string, ParameterModeler>& params,
      const std::string& id, bool& foundParam, const std::vector<std::string>& ids) const {
  double value = 0.;
  findParameterDynamicNoThrow<double>(params, id, foundParam, ids, value);
  return value;
}

template <>
int NetworkComponent::Impl::getParameterDynamicNoThrow(const boost::unordered_map<std::string, ParameterModeler>& params,
      const std::string& id, bool& foundParam, const std::vector<std::string>& ids) const {
  int value = 0;
  findParameterDynamicNoThrow<int>(params, id, foundParam, ids, value);
  return value;
}

template <>
bool NetworkComponent::Impl::getParameterDynamicNoThrow(const boost::unordered_map<std::string, ParameterModeler>& params,
      const std::string& id, bool& foundParam, const std::vector<std::string>& ids) const {
  bool value = false;
  findParameterDynamicNoThrow<bool>(params, id, foundParam, ids, value);
  return value;
}

template <>
std::string NetworkComponent::Impl::getParameterDynamicNoThrow(const boost::unordered_map<std::string, ParameterModeler>& params,
      const std::string& id, bool& foundParam, const std::vector<std::string>& ids) const {
  std::string value = "";
  findParameterDynamicNoThrow<std::string>(params, id, foundParam, ids, value);
  return value;
}

}  // namespace DYN
