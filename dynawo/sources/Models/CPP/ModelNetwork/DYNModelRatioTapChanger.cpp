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
 * @file  DYNModelRatioTapChanger.cpp
 *
 * @brief Model of ratio tap changer : implementation
 *
 */

#include "DYNModelRatioTapChanger.h"
#include "DYNModelConstants.h"
#include "DYNModelNetwork.h"
#include "DYNMacrosMessage.h"

namespace DYN {

ModelRatioTapChanger::ModelRatioTapChanger(const std::string& id, const std::string& side) :
ModelTapChanger(id),
side_(side),
tolV_(0.015),
targetV_(0),
moveUp_(false),
moveDown_(false),
tapRefDown_(-1),
tapRefUp_(-1),
uMaxState_(false),
uMinState_(false),
uTargetState_(true) {
  whenUp_ = VALDEF;
  whenDown_ = VALDEF;
  whenLastTap_ = VALDEF;
}

ModelRatioTapChanger::~ModelRatioTapChanger() {
}

bool
ModelRatioTapChanger::getUpIncreaseTargetU() {
  // decide whether we should increase/decrease tap
  bool increaseRate = false;
  bool upIncreaseTargetU = false;
  if (size() > 1)
    increaseRate = (getStep(getLowStepIndex()).getRho() < getStep(getLowStepIndex() + 1).getRho());

  // in tfo, the main equation is U2 = rho*U1
  if (side_ == "ONE") {
    if (increaseRate) {
      upIncreaseTargetU = false;
    } else {
      upIncreaseTargetU = true;
    }
  } else if (side_ == "TWO") {
    if (increaseRate) {
      upIncreaseTargetU = true;
    } else {
      upIncreaseTargetU = false;
    }
  }
  return upIncreaseTargetU;
}

void
ModelRatioTapChanger::setTolV(const double& tolerance) {
  tolV_ = tolerance;
}

void
ModelRatioTapChanger::setTargetV(const double& target) {
  targetV_ = target;
}

double
ModelRatioTapChanger::getTolV() const {
  return tolV_;
}

int
ModelRatioTapChanger::sizeG() const {
  return 7;
}

int
ModelRatioTapChanger::sizeZ() const {
  return 0;
}

void
ModelRatioTapChanger::evalG(double t, double uValue, bool nodeOff, state_g* g, double disable, double locked, bool tfoClosed) {
  g[0] = (uValue > targetV_ + tolV_ && doubleNotEquals(uValue, targetV_ + tolV_)
  && !(disable > 0) && !(nodeOff) && tfoClosed) ? ROOT_UP : ROOT_DOWN;  // U > Uc + deadBand
  g[1] = (uValue < targetV_ - tolV_ && doubleNotEquals(uValue, targetV_ - tolV_)
  && !(disable > 0) && !(nodeOff) && tfoClosed) ? ROOT_UP : ROOT_DOWN;  // U < Uc - deadBand
  g[2] = (uValue <= targetV_ + tolV_ && uValue >= targetV_ - tolV_) ? ROOT_UP : ROOT_DOWN;  // U-deadBand < U < U + deadBand
  g[3] = (moveUp_ && (t - whenUp_ >= getTFirst()) && getCurrentStepIndex() < getHighStepIndex()
      && !(locked > 0) && getRegulating() && getCurrentStepIndex() == tapRefUp_
          && !(nodeOff) && tfoClosed) ? ROOT_UP : ROOT_DOWN;  // first tap Up
  g[4] = (moveUp_ && (t - whenLastTap_ >= getTNext()) && getCurrentStepIndex() < getHighStepIndex()
      && !(locked > 0) && getRegulating() && getCurrentStepIndex() != tapRefUp_
          && !(nodeOff) && tfoClosed) ? ROOT_UP : ROOT_DOWN;  // next tap Up

  g[5] = (moveDown_ && (t - whenDown_ >= getTFirst()) && getCurrentStepIndex() > getLowStepIndex()
      && !(locked > 0) && getRegulating() && getCurrentStepIndex() == tapRefDown_
          && !(nodeOff) && tfoClosed) ? ROOT_UP : ROOT_DOWN;  // first tap down
  g[6] = (moveDown_ && (t - whenLastTap_ >= getTNext()) && getCurrentStepIndex() > getLowStepIndex()
      && !(locked > 0) && getRegulating() && getCurrentStepIndex() != tapRefDown_
          && !(nodeOff) && tfoClosed) ? ROOT_UP : ROOT_DOWN;  // next tap down
}

void
ModelRatioTapChanger::evalZ(double t, state_g* g, ModelNetwork* network, double disable, bool nodeOff, double locked, bool tfoClosed) {
  if (!(disable > 0) && !(nodeOff) && !(locked > 0) && tfoClosed) {
    if (g[0] == ROOT_UP && !uMaxState_) {  // U > UMax
      if (!getUpIncreaseTargetU()) {
        whenUp_ = t;
        moveUp_ = true;
        tapRefUp_ = getCurrentStepIndex();
        whenDown_ = VALDEF;
        moveDown_ = false;
        tapRefDown_ = getHighStepIndex();
      } else {
        whenDown_ = t;
        moveDown_ = true;
        tapRefDown_ = getCurrentStepIndex();
        whenUp_ = VALDEF;
        moveUp_ = false;
        tapRefUp_ = getLowStepIndex();
      }
      uMaxState_ = true;
      uMinState_ = false;
      uTargetState_ = false;
    }

    if (g[1] == ROOT_UP && !uMinState_) {  // U< UMin
      if (!getUpIncreaseTargetU()) {
        whenDown_ = t;
        moveDown_ = true;
        tapRefDown_ = getCurrentStepIndex();
        whenUp_ = VALDEF;
        moveUp_ = false;
        tapRefUp_ = getLowStepIndex();
      } else {
        whenUp_ = t;
        moveUp_ = true;
        tapRefUp_ = getCurrentStepIndex();
        whenDown_ = VALDEF;
        moveDown_ = false;
        tapRefDown_ = getHighStepIndex();
      }
      uMinState_ = true;
      uMaxState_ = false;
      uTargetState_ = false;
    }

    if (g[2] == ROOT_UP && !uTargetState_) {
      whenUp_ = VALDEF;
      moveUp_ = false;
      tapRefUp_ = getLowStepIndex();
      whenDown_ = VALDEF;
      moveDown_ = false;
      tapRefDown_ = getHighStepIndex();
      uTargetState_ = true;
      uMaxState_ = false;
      uMinState_ = false;
    }

    if (g[3] == ROOT_UP || g[4] == ROOT_UP) {
      setCurrentStepIndex(getCurrentStepIndex() + 1);
      whenLastTap_ = t;
      network->addEvent(id(), DYNTimeline(TapUp));
    }

    if (g[5] == ROOT_UP || g[6] == ROOT_UP) {
      setCurrentStepIndex(getCurrentStepIndex() - 1);
      whenLastTap_ = t;
      network->addEvent(id(), DYNTimeline(TapDown));
    }
  }
}

}  // namespace DYN
