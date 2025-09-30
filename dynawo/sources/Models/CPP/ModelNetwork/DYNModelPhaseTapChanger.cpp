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
#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>

#include "DYNModelPhaseTapChanger.h"
#include "DYNModelConstants.h"
#include "DYNModelNetwork.h"

using std::stringstream;

namespace DYN {

ModelPhaseTapChanger::ModelPhaseTapChanger(const std::string& id, int lowIndex)
    : ModelTapChanger(id, lowIndex),
      thresholdI_(0),
      latestIValue_(0.),
      whenUp_(VALDEF),
      whenDown_(VALDEF),
      whenLastTap_(VALDEF),
      moveUp_(false),
      moveDown_(false),
      tapRefDown_(-1),
      tapRefUp_(-1),
      currentOverThresholdState_(false) {}

ModelPhaseTapChanger::~ModelPhaseTapChanger() {}

void ModelPhaseTapChanger::resetInternalVariables() {
  whenUp_ = VALDEF;
  whenDown_ = VALDEF;
  whenLastTap_ = VALDEF;
  moveUp_ = false;
  moveDown_ = false;
  tapRefDown_ = -1;
  tapRefUp_ = -1;
  currentOverThresholdState_ = false;
}

bool ModelPhaseTapChanger::getIncreaseTap(bool P1SupP2) const {
  // decide whether we should increase/decrease tap depending on tap description
  // and power flow
  bool increaseTap = false;
  bool increasePhase = false;
  if (size() > 1)
    increasePhase = (getStep(getLowStepIndex()).getAlpha() <
                     getStep(getLowStepIndex() + 1).getAlpha());

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

void ModelPhaseTapChanger::evalG(double t, double iValue, bool /*nodeOff*/,
                                 state_g* g, double disable, double locked,
                                 bool tfoClosed) {
  g[0] = (iValue >= thresholdI_ && !(disable > 0.) && tfoClosed)
             ? ROOT_UP
             : ROOT_DOWN;  // I > IThreshold
  g[1] = (iValue < thresholdI_) ? ROOT_UP : ROOT_DOWN;

  g[2] = (moveUp_ && (t - whenUp_ >= getTFirst()) &&
          getCurrentStepIndex() < getHighStepIndex() && !(locked > 0.) &&
          getRegulating() && getCurrentStepIndex() == tapRefUp_ && tfoClosed)
             ? ROOT_UP
             : ROOT_DOWN;  // first tap Up
  g[3] = (moveUp_ && (t - whenLastTap_ >= getTNext()) &&
          getCurrentStepIndex() < getHighStepIndex() && !(locked > 0.) &&
          getRegulating() && getCurrentStepIndex() != tapRefUp_ && tfoClosed)
             ? ROOT_UP
             : ROOT_DOWN;  // next tap Up

  g[4] = (moveDown_ && (t - whenDown_ >= getTFirst()) &&
          getCurrentStepIndex() > getLowStepIndex() && !(locked > 0.) &&
          getRegulating() && getCurrentStepIndex() == tapRefDown_ && tfoClosed)
             ? ROOT_UP
             : ROOT_DOWN;  // first tap down
  g[5] = (moveDown_ && (t - whenLastTap_ >= getTNext()) &&
          getCurrentStepIndex() > getLowStepIndex() && !(locked > 0.) &&
          getRegulating() && getCurrentStepIndex() != tapRefDown_ && tfoClosed)
             ? ROOT_UP
             : ROOT_DOWN;  // next tap down

  latestIValue_ = iValue;
}

void ModelPhaseTapChanger::evalZ(double t, state_g* g, ModelNetwork* network,
                                 double disable, bool P1SupP2, double locked,
                                 bool tfoClosed) {
  if (!(disable > 0.) && !(locked > 0.) && tfoClosed) {
    if (g[0] == ROOT_UP && !currentOverThresholdState_) {  // I > IThreshold
      if (getIncreaseTap(P1SupP2)) {
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
      currentOverThresholdState_ = true;
    }

    if (g[1] == ROOT_UP && currentOverThresholdState_) {  // I < IThreshold
      whenUp_ = VALDEF;
      moveUp_ = false;
      tapRefUp_ = getLowStepIndex();
      whenDown_ = VALDEF;
      moveDown_ = false;
      tapRefDown_ = getHighStepIndex();
      currentOverThresholdState_ = false;
    }

    if (g[2] == ROOT_UP || g[3] == ROOT_UP) {  // increase tap
      setCurrentStepIndex(getCurrentStepIndex() + 1);
      whenLastTap_ = t;
      DYNAddTimelineEvent(network, id(), TapUp, latestIValue_, "A");
    }

    if (g[4] == ROOT_UP || g[5] == ROOT_UP) {  // decrease tap
      setCurrentStepIndex(getCurrentStepIndex() - 1);
      whenLastTap_ = t;
      DYNAddTimelineEvent(network, id(), TapDown, latestIValue_, "A");
    }
  }
}

unsigned ModelPhaseTapChanger::getNbInternalVariables() const {
  return 8;
}

void ModelPhaseTapChanger::dumpInternalVariables(boost::archive::binary_oarchive& os) const {
  dumpInternalVariable(os, whenUp_);
  dumpInternalVariable(os, whenDown_);
  dumpInternalVariable(os, whenLastTap_);
  dumpInternalVariable(os, moveUp_);
  dumpInternalVariable(os, moveDown_);
  dumpInternalVariable(os, tapRefDown_);
  dumpInternalVariable(os, tapRefUp_);
  dumpInternalVariable(os, currentOverThresholdState_);
}

void ModelPhaseTapChanger::loadInternalVariables(boost::archive::binary_iarchive& is) {
  char c;
  is >> c;
  is >> whenUp_;
  is >> c;
  is >> whenDown_;
  is >> c;
  is >> whenLastTap_;
  is >> c;
  is >> moveUp_;
  is >> c;
  is >> moveDown_;
  is >> c;
  is >> tapRefDown_;
  is >> c;
  is >> tapRefUp_;
  is >> c;
  is >> currentOverThresholdState_;
}

}  // namespace DYN
