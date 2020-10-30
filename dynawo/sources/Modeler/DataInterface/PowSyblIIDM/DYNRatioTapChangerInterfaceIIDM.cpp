//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#include "DYNRatioTapChangerInterfaceIIDM.h"

// #include "DYNErrorQueue.h"
// #include "DYNMacrosMessage.h"
#include "DYNStepInterfaceIIDM.h"

using boost::shared_ptr;

namespace DYN {

RatioTapChangerInterfaceIIDM::~RatioTapChangerInterfaceIIDM() {
}

RatioTapChangerInterfaceIIDM::RatioTapChangerInterfaceIIDM(powsybl::iidm::RatioTapChanger& tapChanger, const std::string& parentName) :
  isa2WindingTransformer_(false),  // --DG--
  isa3WindingTransformer_(false),  // --DG--
  tapChangerIIDM_(tapChanger) {
  //  const powsybl::iidm::TapChangerHolder rtc = tapChanger;
  //  std::cerr << "      (debug) parentName >" << parentName << "<\n";
  //  std::cerr << "      (debug) 2WT >" <<
  //           (dynamic_cast<powsybl::iidm::TapChangerHolder&>(tapChanger)).getNetwork().getTwoWindingsTransformer(parentName) << "<\n";
  //  std::cerr << "      (debug) 2WT >" << rtc.getNetwork().getTwoWindingsTransformer(parentName) << "<\n";
  //  std::cerr << "      (debug) parentName >" << tapChanger.getParent() << "<\n"; //   --> protected
  //
  // Neither parentName, neither changing to have the network as a parameter is enough to solve that point 2WT or 3WT --DG--
  // Because information from class is 'protected' within powsybl  --DG--
}

void
RatioTapChangerInterfaceIIDM::addStep(const shared_ptr<StepInterface>& step) {
  steps_.push_back(step);
}

std::vector<shared_ptr<StepInterface> >
RatioTapChangerInterfaceIIDM::getSteps() const {
  return steps_;
}

int
RatioTapChangerInterfaceIIDM::getCurrentPosition() const {
  return tapChangerIIDM_.getTapPosition();  // getTapPosition() is 'long' in powsybl
}

void
RatioTapChangerInterfaceIIDM::setCurrentPosition(const int& position) {
  tapChangerIIDM_.setTapPosition(position);
}

int
RatioTapChangerInterfaceIIDM::getLowPosition() const {
  return tapChangerIIDM_.getLowTapPosition();
}

unsigned int
RatioTapChangerInterfaceIIDM::getNbTap() const {
  return steps_.size();
}

bool
RatioTapChangerInterfaceIIDM::hasLoadTapChangingCapabilities() const {
  return tapChangerIIDM_.hasLoadTapChangingCapabilities();
}

bool
RatioTapChangerInterfaceIIDM::getRegulating() const {
  return tapChangerIIDM_.isRegulating();
}

double
RatioTapChangerInterfaceIIDM::getTargetV() const {
  if (std::isnan(tapChangerIIDM_.getTargetV())) {
    return 99999.0;
  }
  return tapChangerIIDM_.getTargetV();
}

std::string
RatioTapChangerInterfaceIIDM::getTerminalRefId() const {
  return getRegulating() ? tapChangerIIDM_.getRegulationTerminal().get().getConnectable().get().getId() : "";
}

std::string
RatioTapChangerInterfaceIIDM::getTerminalRefSide() const {
  if (getRegulating()) {
    /* --DG-- waiting to know if 2WT or 3WT: 2 distinct code must be written
    switch (tapChangerIIDM_.terminalReference().side) {
      case powsybl::iidm::side_1  : return "ONE";
      case powsybl::iidm::side_2  : return "TWO";
      case powsybl::iidm::side_3  : return "THREE";
      case powsybl::iidm::side_end: return "";
    } */
  }
  return "";
}

double
RatioTapChangerInterfaceIIDM::getCurrentR() const {
  auto currentStep = tapChangerIIDM_.getTapPosition() - tapChangerIIDM_.getLowTapPosition();
  return steps_.at(currentStep)->getR();
}

double
RatioTapChangerInterfaceIIDM::getCurrentX() const {
  auto currentStep = tapChangerIIDM_.getTapPosition() - tapChangerIIDM_.getLowTapPosition();
  return steps_.at(currentStep)->getX();
}

double
RatioTapChangerInterfaceIIDM::getCurrentB() const {
  auto currentStep = tapChangerIIDM_.getTapPosition() - tapChangerIIDM_.getLowTapPosition();
  return steps_.at(currentStep)->getB();
}

double
RatioTapChangerInterfaceIIDM::getCurrentG() const {
  auto currentStep = tapChangerIIDM_.getTapPosition() - tapChangerIIDM_.getLowTapPosition();
  return steps_.at(currentStep)->getG();
}

double
RatioTapChangerInterfaceIIDM::getCurrentRho() const {
  auto currentStep = tapChangerIIDM_.getTapPosition() - tapChangerIIDM_.getLowTapPosition();
  return steps_.at(currentStep)->getRho();
}

}  // namespace DYN
