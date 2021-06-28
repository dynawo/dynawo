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
 * @file  DYNPhaseTapChangerInterfaceIIDM.cpp
 *
 * @brief Phase tap changer data interface : implementation file for IIDM implementation
 *
 */
#include <IIDM/components/TapChanger.h>

#include "DYNPhaseTapChangerInterfaceIIDM.h"
#include "DYNStepInterfaceIIDM.h"

using std::vector;
using boost::shared_ptr;

namespace DYN {

  PhaseTapChangerInterfaceIIDM::PhaseTapChangerInterfaceIIDM(IIDM::PhaseTapChanger& tapChanger) :
  tapChangerIIDM_(tapChanger) {
  }

  PhaseTapChangerInterfaceIIDM::~PhaseTapChangerInterfaceIIDM() {
  }

  void
  PhaseTapChangerInterfaceIIDM::addStep(const shared_ptr<StepInterface>& step) {
    steps_.push_back(step);
  }

  vector<shared_ptr<StepInterface> >
  PhaseTapChangerInterfaceIIDM::getSteps() const {
    return steps_;
  }

  int
  PhaseTapChangerInterfaceIIDM::getCurrentPosition() const {
    return tapChangerIIDM_.tapPosition();
  }

  void
  PhaseTapChangerInterfaceIIDM::setCurrentPosition(const int& position) {
    tapChangerIIDM_.tapPosition(position);
  }

  int
  PhaseTapChangerInterfaceIIDM::getLowPosition() const {
    return tapChangerIIDM_.lowTapPosition();
  }

  unsigned int
  PhaseTapChangerInterfaceIIDM::getNbTap() const {
    return steps_.size();
  }

  bool
  PhaseTapChangerInterfaceIIDM::isCurrentLimiter() const {
    return tapChangerIIDM_.regulationMode() == IIDM::PhaseTapChanger::mode_current_limiter;
  }

  bool
  PhaseTapChangerInterfaceIIDM::getRegulating() const {
    if (!tapChangerIIDM_.has_regulating())
      return false;
    return tapChangerIIDM_.regulating();
  }

  double
  PhaseTapChangerInterfaceIIDM::getThresholdI() const {
    if (!tapChangerIIDM_.has_regulationValue()) {
      return 99999;
    }
    return tapChangerIIDM_.regulationValue();
  }

  double
  PhaseTapChangerInterfaceIIDM::getCurrentR() const {
    int currentStep = tapChangerIIDM_.tapPosition();
    return steps_[currentStep]->getR();
  }

  double
  PhaseTapChangerInterfaceIIDM::getCurrentX() const {
    int currentStep = tapChangerIIDM_.tapPosition();
    return steps_[currentStep]->getX();
  }

  double
  PhaseTapChangerInterfaceIIDM::getCurrentB() const {
    int currentStep = tapChangerIIDM_.tapPosition();
    return steps_[currentStep]->getB();
  }

  double
  PhaseTapChangerInterfaceIIDM::getCurrentG() const {
    int currentStep = tapChangerIIDM_.tapPosition();
    return steps_[currentStep]->getG();
  }

  double
  PhaseTapChangerInterfaceIIDM::getCurrentRho() const {
    int currentStep = tapChangerIIDM_.tapPosition();
    return steps_[currentStep]->getRho();
  }

  double
  PhaseTapChangerInterfaceIIDM::getCurrentAlpha() const {
    int currentStep = tapChangerIIDM_.tapPosition();
    return steps_[currentStep]->getAlpha();
  }

  double
  PhaseTapChangerInterfaceIIDM::getTargetDeadBand() const {
    return 0.;
  }

}  // namespace DYN
