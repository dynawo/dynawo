//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNStepInterfaceIIDM.cpp
 *
 * @brief Step data interface : implementation file for IIDM implementation
 *
 */

#include "DYNStepInterfaceIIDM.h"

#include <powsybl/iidm/TapChanger.hpp>

namespace DYN {

StepInterfaceIIDM::StepInterfaceIIDM(const powsybl::iidm::PhaseTapChangerStep& step) : phaseStep_(step),
                                                                                       isPhaseStep_(true) {
}

StepInterfaceIIDM::StepInterfaceIIDM(const powsybl::iidm::RatioTapChangerStep& step) : ratioStep_(step),
                                                                                       isPhaseStep_(false) {
}

double
StepInterfaceIIDM::getR() const {
  return isPhaseStep_ ? phaseStep_->getR() : ratioStep_->getR();
}

double
StepInterfaceIIDM::getX() const {
  return isPhaseStep_ ? phaseStep_->getX() : ratioStep_->getX();
}

double
StepInterfaceIIDM::getG() const {
  return isPhaseStep_ ? phaseStep_->getG() : ratioStep_->getG();
}

double
StepInterfaceIIDM::getB() const {
  return isPhaseStep_ ? phaseStep_->getB() : ratioStep_->getB();
}

double
StepInterfaceIIDM::getRho() const {
  return isPhaseStep_ ? phaseStep_->getRho() : ratioStep_->getRho();
}

double
StepInterfaceIIDM::getAlpha() const {
  return isPhaseStep_ ? phaseStep_->getAlpha() : 0.0;
}

}  // namespace DYN
