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
 * @file  DYNModelTapChanger.cpp
 *
 * @brief Model of tap changer : implementation
 *
 */
#include "DYNModelTapChanger.h"
#include "DYNMacrosMessage.h"

using std::string;

namespace DYN {

ModelTapChanger::ModelTapChanger(const std::string& id) :
id_(id),
currentStepIndex_(0),
regulating_(false),
lowStepIndex_(0),
highStepIndex_(0),
tFirst_(60),
tNext_(10) {
}

ModelTapChanger::~ModelTapChanger() {
}

void
ModelTapChanger::addStep(int index, const TapChangerStep& step) {
  steps_[index] = step;
}

void
ModelTapChanger::setCurrentStepIndex(const int& index) {
  currentStepIndex_ = index;
}

int
ModelTapChanger::getCurrentStepIndex() const {
  return currentStepIndex_;
}

const TapChangerStep&
ModelTapChanger::getStep(int key) const {
  if (steps_.find(key) != steps_.end())
    return steps_.find(key)->second;
  else
    throw DYNError(Error::MODELER, UndefinedStep, key, id_);
}

const TapChangerStep&
ModelTapChanger::getCurrentStep() const {
  return getStep(currentStepIndex_);
}

void
ModelTapChanger::setLowStepIndex(const int& index) {
  lowStepIndex_ = index;
}

void
ModelTapChanger::setHighStepIndex(const int& index) {
  highStepIndex_ = index;
}

void
ModelTapChanger::setRegulating(bool regulating) {
  regulating_ = regulating;
}

void
ModelTapChanger::setTFirst(const double& time) {
  tFirst_ = time;
}

void
ModelTapChanger::setTNext(const double& time) {
  tNext_ = time;
}

void
ModelTapChanger::evalG(double /*t*/, double /*valueMonitored*/, bool /*nnodeOff*/, state_g* /*g*/, double /*disable*/,
                       double /*locked*/, bool /*tfoClosed*/) {
  // not needed
}

void
ModelTapChanger::evalZ(double /*t*/, state_g* /*g*/, ModelNetwork* /*network*/, double /*disable*/, bool /*nodeOff*/, double /*locked*/,
                     bool /*tfoClosed*/) {
  // not needed
}

}  // namespace DYN
