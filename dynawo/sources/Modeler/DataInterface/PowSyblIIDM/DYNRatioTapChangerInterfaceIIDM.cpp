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

#include "DYNStepInterfaceIIDM.h"

using boost::shared_ptr;

namespace DYN {

RatioTapChangerInterfaceIIDM::RatioTapChangerInterfaceIIDM(powsybl::iidm::RatioTapChanger& tapChanger, const std::string& terminalRefSide) :
  tapChangerIIDM_(tapChanger),
  terminalRefSide_(terminalRefSide) {
  auto oldTapPosition = tapChanger.getTapPosition();
  for (long i = tapChanger.getLowTapPosition(); i <= tapChanger.getHighTapPosition(); i++) {
    tapChanger.setTapPosition(i);
    const auto& x = tapChanger.getStep(i);
    powsybl::iidm::RatioTapChangerStep R(x.getRho(), x.getR(), x.getX(), x.getG(), x.getB());
    steps_.push_back(std::unique_ptr<StepInterface>(new StepInterfaceIIDM(R)));
  }
  tapChanger.setTapPosition(oldTapPosition);
}

void
RatioTapChangerInterfaceIIDM::addStep(std::unique_ptr<StepInterface> step) {
  steps_.push_back(std::move(step));
}

const std::vector<std::unique_ptr<StepInterface> >&
RatioTapChangerInterfaceIIDM::getSteps() const {
  return steps_;
}

int
RatioTapChangerInterfaceIIDM::getCurrentPosition() const {
  return static_cast<int>(tapChangerIIDM_.getTapPosition());  // getTapPosition() is 'long' in powsybl
}

void
RatioTapChangerInterfaceIIDM::setCurrentPosition(const int& position) {
  tapChangerIIDM_.setTapPosition(position);
}

int
RatioTapChangerInterfaceIIDM::getLowPosition() const {
  return static_cast<int>(tapChangerIIDM_.getLowTapPosition());
}

unsigned int
RatioTapChangerInterfaceIIDM::getNbTap() const {
  return static_cast<unsigned int>(steps_.size());
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
  return terminalRefSide_;
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

double
RatioTapChangerInterfaceIIDM::getTargetDeadBand() const {
  return getRegulating() ? tapChangerIIDM_.getTargetDeadband() : 0.;
}

}  // namespace DYN
