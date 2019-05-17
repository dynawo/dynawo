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
 * @file  DYNRatioTapChangerInterfaceIIDM.cpp
 *
 * @brief Ratio tap changer data interface : implementation file for IIDM implementation
 *
 */
#include <IIDM/components/TapChanger.h>
#include <IIDM/components/TerminalReference.h>

#include "DYNRatioTapChangerInterfaceIIDM.h"
#include "DYNStepInterfaceIIDM.h"
#include "DYNMacrosMessage.h"

using std::vector;
using std::string;
using boost::shared_ptr;

namespace DYN {

RatioTapChangerInterfaceIIDM::~RatioTapChangerInterfaceIIDM() {
}

RatioTapChangerInterfaceIIDM::RatioTapChangerInterfaceIIDM(IIDM::RatioTapChanger& tapChanger, const std::string& parentName) :
tapChangerIIDM_(tapChanger) {
  sanityCheck(parentName);
}

void
RatioTapChangerInterfaceIIDM::addStep(const shared_ptr<StepInterface>& step) {
  steps_.push_back(step);
}

vector<shared_ptr<StepInterface> >
RatioTapChangerInterfaceIIDM::getSteps() const {
  return steps_;
}

int
RatioTapChangerInterfaceIIDM::getCurrentPosition() const {
  return tapChangerIIDM_.tapPosition();
}

void
RatioTapChangerInterfaceIIDM::setCurrentPosition(const int& position) {
  tapChangerIIDM_.tapPosition(position);
}

int
RatioTapChangerInterfaceIIDM::getLowPosition() const {
  return tapChangerIIDM_.lowTapPosition();
}

unsigned int
RatioTapChangerInterfaceIIDM::getNbTap() const {
  return steps_.size();
}

bool
RatioTapChangerInterfaceIIDM::getRegulating() const {
  if (!tapChangerIIDM_.has_regulating())
    return false;
  return tapChangerIIDM_.regulating();
}

double
RatioTapChangerInterfaceIIDM::getTargetV() const {
  if (!tapChangerIIDM_.has_targetV()) {
    return 99999;
  }
  return tapChangerIIDM_.targetV();
}

string
RatioTapChangerInterfaceIIDM::getTerminalRefId() const {
  if (tapChangerIIDM_.has_terminalReference())
    return tapChangerIIDM_.terminalReference().id;
  else
    return "";
}

string
RatioTapChangerInterfaceIIDM::getTerminalRefSide() const {
  if (tapChangerIIDM_.has_terminalReference()) {
    switch (tapChangerIIDM_.terminalReference().side) {
      case IIDM::side_1:
        return "ONE";
      case IIDM::side_2:
        return "TWO";
      case IIDM::side_3:
        return "THREE";
      case IIDM::side_end:
        return "";
    }
  }
  return "";
}

double
RatioTapChangerInterfaceIIDM::getCurrentR() const {
  int currentStep = tapChangerIIDM_.tapPosition();
  return steps_[currentStep]->getR();
}

double
RatioTapChangerInterfaceIIDM::getCurrentX() const {
  int currentStep = tapChangerIIDM_.tapPosition();
  return steps_[currentStep]->getX();
}

double
RatioTapChangerInterfaceIIDM::getCurrentB() const {
  int currentStep = tapChangerIIDM_.tapPosition();
  return steps_[currentStep]->getB();
}

double
RatioTapChangerInterfaceIIDM::getCurrentG() const {
  int currentStep = tapChangerIIDM_.tapPosition();
  return steps_[currentStep]->getG();
}

double
RatioTapChangerInterfaceIIDM::getCurrentRho() const {
  int currentStep = tapChangerIIDM_.tapPosition();
  return steps_[currentStep]->getRho();
}

void
RatioTapChangerInterfaceIIDM::sanityCheck(const std::string& parentName) const {
  if (tapChangerIIDM_.has_regulating() && tapChangerIIDM_.regulating()) {
    if (!tapChangerIIDM_.has_targetV())
      throw DYNError(DYN::Error::STATIC_DATA, MissingTargetVInRatioTapChanger, parentName);
    if (!tapChangerIIDM_.has_terminalReference())
      throw DYNError(DYN::Error::STATIC_DATA, MissingTerminalRefInRatioTapChanger, parentName);
    if (tapChangerIIDM_.terminalReference().side == IIDM::side_end)
      throw DYNError(DYN::Error::STATIC_DATA, MissingTerminalRefSideInRatioTapChanger, parentName);
  }
}

}  // namespace DYN
