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
 * @file  DYNStepInterfaceIIDM.cpp
 *
 * @brief Step data interface : implementation file for IIDM implementation
 *
 */
#include <IIDM/components/TapChanger.h>

#include "DYNStepInterfaceIIDM.h"

using boost::shared_ptr;

namespace DYN {

  StepInterfaceIIDM::~StepInterfaceIIDM() {
  }

  StepInterfaceIIDM::StepInterfaceIIDM(const IIDM::PhaseTapChangerStep& step) :
  phaseStep_(step),
  isPhaseStep_(true) {
  }

  StepInterfaceIIDM::StepInterfaceIIDM(const IIDM::RatioTapChangerStep& step) :
  ratioStep_(step),
  isPhaseStep_(false) {
  }

  double
  StepInterfaceIIDM::getR() const {
    return isPhaseStep_ ? phaseStep_->r : ratioStep_->r;
  }

  double
  StepInterfaceIIDM::getX() const {
    return isPhaseStep_ ? phaseStep_->x : ratioStep_->x;
  }

  double
  StepInterfaceIIDM::getG() const {
    return isPhaseStep_ ? phaseStep_->g : ratioStep_->g;
  }

  double
  StepInterfaceIIDM::getB() const {
    return isPhaseStep_ ? phaseStep_->b : ratioStep_->b;
  }

  double
  StepInterfaceIIDM::getRho() const {
    return isPhaseStep_ ? phaseStep_->rho : ratioStep_->rho;
  }

  double
  StepInterfaceIIDM::getAlpha() const {
    return isPhaseStep_ ? phaseStep_->alpha : 0;
  }

}  // namespace DYN

