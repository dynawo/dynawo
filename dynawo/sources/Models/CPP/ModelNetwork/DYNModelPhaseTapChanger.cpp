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
 * @file  DYNModelPhaseTapChanger.cpp
 *
 * @brief Model of phase tap changer : implementation
 *
 */
#include "DYNModelPhaseTapChanger.h"
#include "DYNModelConstants.h"
#include "DYNModelNetwork.h"
#include "DYNMacrosMessage.h"

namespace DYN {

ModelPhaseTapChanger::ModelPhaseTapChanger(const std::string& id) :
ModelTapChanger(id),
thresholdI_(0) {
  whenUp_ = VALDEF;
  whenDown_ = VALDEF;
  whenLastTap_ = VALDEF;
  moveUp_ = false;
  moveDown_ = false;
  tapRefDown_ = -1;
  tapRefUp_ = -1;
  currentOverThresholdState_ = false;
}

ModelPhaseTapChanger::~ModelPhaseTapChanger() {
}

void
ModelPhaseTapChanger::setThresholdI(const double& threshold) {
  thresholdI_ = threshold;
}

int
ModelPhaseTapChanger::sizeG() const {
  return 6;
}

int
ModelPhaseTapChanger::sizeZ() const {
  return 0;
}

bool
ModelPhaseTapChanger::getIncreaseTap(bool P1SupP2) {
  // decide whether we should increase/decrease tap depending on tap description and power flow
  bool increaseTap = false;
  bool increasePhase = false;
  if (steps_.size() > 1)
    increasePhase = (steps_[lowStepIndex_].getAlpha() < steps_[lowStepIndex_ + 1].getAlpha());

  if (!P1SupP2) {
    if (increasePhase)
      increaseTap = true;
    else
      increaseTap = false;
  } else {
    if (increasePhase)
      increaseTap = false;
    else
      increaseTap = true;
  }
  return increaseTap;
}

void
ModelPhaseTapChanger::evalG(const double& t, const double& iValue, bool /*nodeOff*/, state_g* g, const double& disable, const double& locked, bool tfoClosed) {
  g[0] = (iValue >= thresholdI_ && !(disable > 0.) && tfoClosed) ? ROOT_UP : ROOT_DOWN;  // I > IThreshold
  g[1] = (iValue < thresholdI_) ? ROOT_UP : ROOT_DOWN;


  g[2] = (moveUp_ && (t - whenUp_ >= tFirst_) && currentStepIndex_ < highStepIndex_ && !(locked > 0.) && regulating_ && currentStepIndex_ == tapRefUp_
          && tfoClosed) ? ROOT_UP : ROOT_DOWN;  // first tap Up
  g[3] = (moveUp_ && (t - whenLastTap_ >= tNext_) && currentStepIndex_ < highStepIndex_ && !(locked > 0.) && regulating_ && currentStepIndex_ != tapRefUp_
          && tfoClosed) ? ROOT_UP : ROOT_DOWN;  // next tap Up

  g[4] = (moveDown_ && (t - whenDown_ >= tFirst_) && currentStepIndex_ > lowStepIndex_ && !(locked > 0.) && regulating_ && currentStepIndex_ == tapRefDown_
          && tfoClosed) ? ROOT_UP : ROOT_DOWN;  // first tap down
  g[5] = (moveDown_ && (t - whenLastTap_ >= tNext_) && currentStepIndex_ > lowStepIndex_ && !(locked > 0.) && regulating_ && currentStepIndex_ != tapRefDown_
          && tfoClosed) ? ROOT_UP : ROOT_DOWN;  // next tap down
}

void
ModelPhaseTapChanger::evalZ(const double& t, state_g* g, ModelNetwork* network, const double& disable, bool P1SupP2, const double& locked, bool tfoClosed) {
  if (!(disable > 0.) && !(locked > 0.) && tfoClosed) {
    if (g[0] == ROOT_UP && !currentOverThresholdState_) {  // I > IThreshold
      if (getIncreaseTap(P1SupP2)) {
        whenUp_ = t;
        moveUp_ = true;
        tapRefUp_ = currentStepIndex_;
        whenDown_ = VALDEF;
        moveDown_ = false;
        tapRefDown_ = highStepIndex_;
      } else {
        whenDown_ = t;
        moveDown_ = true;
        tapRefDown_ = currentStepIndex_;
        whenUp_ = VALDEF;
        moveUp_ = false;
        tapRefUp_ = lowStepIndex_;
      }
      currentOverThresholdState_ = true;
    }

    if (g[1] == ROOT_UP && currentOverThresholdState_) {  // I < IThreshold
      whenUp_ = VALDEF;
      moveUp_ = false;
      tapRefUp_ = lowStepIndex_;
      whenDown_ = VALDEF;
      moveDown_ = false;
      tapRefDown_ = highStepIndex_;
      currentOverThresholdState_ = false;
    }

    if (g[2] == ROOT_UP || g[3] == ROOT_UP) {  // increase tap
      currentStepIndex_ += 1;
      whenLastTap_ = t;
      network->addEvent(id_, DYNTimeline(TapUp));
    }

    if (g[4] == ROOT_UP || g[5] == ROOT_UP) {  // decrease tap
      currentStepIndex_ -= 1;
      whenLastTap_ = t;
      network->addEvent(id_, DYNTimeline(TapDown));
    }
  }
}

}  // namespace DYN
