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

#include <boost/shared_ptr.hpp>
#include <vector>

#include "DYNModelNetwork.h"
#include "DYNModelTapChangerStep.h"
#include "DYNModelTapChanger.h"
#include "DYNModelPhaseTapChanger.h"
#include "DYNModelRatioTapChanger.h"
#include "TLTimelineFactory.h"
#include "gtest_dynawo.h"

namespace DYN {
TEST(ModelsModelNetwork, ModelNetworkTapChangerStep) {
  TapChangerStep tcs;
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs.getRho(), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs.getAlpha(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs.getR(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs.getX(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs.getG(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs.getB(), 0.);

  TapChangerStep tcs2(3., 4., 5., 6., 7., 8.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs2.getRho(), 3.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs2.getAlpha(), 4.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs2.getR(), 5.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs2.getX(), 6.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs2.getG(), 7.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs2.getB(), 8.);
}

TEST(ModelsModelNetwork, ModelNetworkTapChanger) {
  ModelTapChanger ptc("MyModelTapChanger", 0);
  ASSERT_EQ(ptc.id(), "MyModelTapChanger");
  ASSERT_EQ(ptc.size(), 0);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 0);
  ASSERT_FALSE(ptc.getRegulating());
  ASSERT_EQ(ptc.getLowStepIndex(), 0);
  ASSERT_EQ(ptc.getHighStepIndex(), 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(ptc.getTFirst(), 60);
  ASSERT_DOUBLE_EQUALS_DYNAWO(ptc.getTNext(), 10);

  ptc.setCurrentStepIndex(2);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 2);
  ptc.setRegulating(true);
  ASSERT_TRUE(ptc.getRegulating());
  ptc.setHighStepIndex(10);
  ASSERT_EQ(ptc.getHighStepIndex(), 10);
  ptc.setTFirst(100.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(ptc.getTFirst(), 100.);
  ptc.setTNext(20.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(ptc.getTNext(), 20);

  ASSERT_THROW_DYNAWO(ptc.getCurrentStep(), Error::MODELER, KeyError_t::UndefinedStep);
  ASSERT_THROW_DYNAWO(ptc.getStep(3), Error::MODELER, KeyError_t::UndefinedStep);

  ptc.addStep(TapChangerStep(1., 1., 1., 1., 1., 1.));
  ptc.addStep(TapChangerStep(10., 10., 10., 10., 10., 10.));
  ptc.addStep(TapChangerStep(2., 2., 2., 2., 2., 2.));

  const TapChangerStep& tcs = ptc.getCurrentStep();
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs.getRho(), 2.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs.getAlpha(), 2.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs.getR(), 2.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs.getX(), 2.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs.getG(), 2.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs.getB(), 2.);

  const TapChangerStep& tcs2 = ptc.getStep(1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs2.getRho(), 10.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs2.getAlpha(), 10.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs2.getR(), 10.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs2.getX(), 10.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs2.getG(), 10.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs2.getB(), 10.);

  const TapChangerStep& tcs3 = ptc.getStep(0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs3.getRho(), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs3.getAlpha(), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs3.getR(), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs3.getX(), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs3.getG(), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tcs3.getB(), 1.);
}

TEST(ModelsModelNetwork, ModelNetworkPhaseTapChanger) {
  ModelPhaseTapChanger ptc("MyModelPhaseTapChanger", 0);
  ASSERT_EQ(ptc.sizeG(), 6);
  ASSERT_EQ(ptc.sizeZ(), 0);

  ptc.setThresholdI(5.);
  ptc.setRegulating(true);
  ptc.setHighStepIndex(10);
  ptc.setTFirst(100.);
  ptc.setTNext(20.);

  std::vector<state_g> states(ptc.sizeG(), NO_ROOT);

  double t = 5.;
  double iValue = 6.;
  const bool nodeOff = false;
  double disable = -1.;
  double locked = 0.;
  bool tfoClosed = true;
  ptc.evalG(t, iValue, nodeOff, disable, locked, tfoClosed, &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ASSERT_EQ(states[4], ROOT_DOWN);
  ASSERT_EQ(states[5], ROOT_DOWN);

  ModelNetwork network;
  network.setTimeline(timeline::TimelineFactory::newInstance("Test"));
  bool P1SupP2 = true;
  ptc.evalZ(t, &states[0], disable, P1SupP2, locked, tfoClosed, &network);
  iValue = 3.;
  disable = 0.;
  tfoClosed = false;
  ptc.evalG(t, iValue, nodeOff, disable, locked, tfoClosed,  &states[0]);
  ASSERT_EQ(states[0], ROOT_DOWN);
  ASSERT_EQ(states[1], ROOT_UP);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ASSERT_EQ(states[4], ROOT_DOWN);
  ASSERT_EQ(states[5], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, P1SupP2, locked, tfoClosed, &network);

  t = 110.;
  iValue = 6.;
  tfoClosed = true;
  ptc.evalG(t, iValue, nodeOff, disable, locked, tfoClosed, &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_UP);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ASSERT_EQ(states[4], ROOT_DOWN);
  ASSERT_EQ(states[5], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, P1SupP2, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 1);
  t = 135.;
  ptc.evalG(t, iValue, nodeOff, disable, locked, tfoClosed,  &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_UP);
  ASSERT_EQ(states[4], ROOT_DOWN);
  ASSERT_EQ(states[5], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, P1SupP2, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 2);

  P1SupP2 = false;
  iValue = 3.;
  ptc.evalG(t, iValue, nodeOff, disable, locked, tfoClosed,  &states[0]);
  ASSERT_EQ(states[0], ROOT_DOWN);
  ASSERT_EQ(states[1], ROOT_UP);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ASSERT_EQ(states[4], ROOT_DOWN);
  ASSERT_EQ(states[5], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, P1SupP2, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 2);
  iValue = 6.;
  ptc.evalG(t, iValue, nodeOff, disable, locked, tfoClosed,  &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ASSERT_EQ(states[4], ROOT_DOWN);
  ASSERT_EQ(states[5], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, P1SupP2, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 2);
  t = 235.;
  ptc.evalG(t, iValue, nodeOff, disable, locked, tfoClosed,  &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ASSERT_EQ(states[4], ROOT_UP);
  ASSERT_EQ(states[5], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, P1SupP2, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 1);
  t = 255.;
  ptc.evalG(t, iValue, nodeOff, disable, locked, tfoClosed,  &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ASSERT_EQ(states[4], ROOT_DOWN);
  ASSERT_EQ(states[5], ROOT_UP);
  ptc.evalZ(t, &states[0], disable, P1SupP2, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 0);
}

TEST(ModelsModelNetwork, ModelNetworkRatioTapChanger) {
  ModelRatioTapChanger ptc("MyModelRatioTapChanger", "TWO", 0);
  ASSERT_EQ(ptc.sizeG(), 4);
  ASSERT_EQ(ptc.sizeZ(), 0);

  ptc.setTolV(0.1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(ptc.getTolV(), 0.1);
  ptc.setTargetV(10.);
  ptc.setRegulating(true);
  ptc.setHighStepIndex(10);
  ptc.setTFirst(100.);
  ptc.setTNext(20.);

  std::vector<state_g> states(ptc.sizeG(), NO_ROOT);

  double t = 5.;
  double uValue = 11.2;
  const bool nodeOff = false;
  double disable = -1.;
  double locked = -1.;
  bool tfoClosed = true;
  double deltaUTarget = 0.;
  ptc.evalG(t, uValue, nodeOff, disable, locked, tfoClosed, deltaUTarget, &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);

  ModelNetwork network;
  network.setTimeline(timeline::TimelineFactory::newInstance("Test"));
  ptc.evalZ(t, &states[0], disable, nodeOff, locked, tfoClosed, &network);
  uValue = 3.;
  ptc.evalG(t, uValue, nodeOff, disable, locked, tfoClosed, deltaUTarget,  &states[0]);
  ASSERT_EQ(states[0], ROOT_DOWN);
  ASSERT_EQ(states[1], ROOT_UP);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, nodeOff, locked, tfoClosed, &network);

  uValue = 10.01;
  ptc.evalG(t, uValue, nodeOff, disable, locked, tfoClosed, deltaUTarget,  &states[0]);
  ASSERT_EQ(states[0], ROOT_DOWN);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, nodeOff, locked, tfoClosed, &network);

  uValue = 11.2;
  tfoClosed = true;
  ptc.evalG(t, uValue, nodeOff, disable, locked, tfoClosed, deltaUTarget,  &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, nodeOff, locked, tfoClosed, &network);

  t = 110.;
  ptc.evalG(t, uValue, nodeOff, disable, locked, tfoClosed, deltaUTarget, &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_UP);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, nodeOff, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 1);

  t = 135.;
  ptc.evalG(t, uValue, nodeOff, disable, locked, tfoClosed, deltaUTarget,  &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_UP);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, nodeOff, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 2);

  deltaUTarget = 1.;
  uValue = 10.;
  ptc.evalG(t, uValue, nodeOff, disable, locked, tfoClosed, deltaUTarget,  &states[0]);
  ASSERT_EQ(states[0], ROOT_DOWN);
  ASSERT_EQ(states[1], ROOT_UP);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, nodeOff, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 2);

  deltaUTarget = -1.;
  uValue = 10.;
  ptc.evalG(t, uValue, nodeOff, disable, locked, tfoClosed, deltaUTarget,  &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, nodeOff, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 2);

  ptc.setSide("ONE");
  uValue = 3.;
  ptc.evalG(t, uValue, nodeOff, disable, locked, tfoClosed, deltaUTarget,  &states[0]);
  ASSERT_EQ(states[0], ROOT_DOWN);
  ASSERT_EQ(states[1], ROOT_UP);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, nodeOff, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 2);
  uValue = 11.2;
  ptc.evalG(t, uValue, nodeOff, disable, locked, tfoClosed, deltaUTarget,  &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_DOWN);
  ptc.evalZ(t, &states[0], disable, nodeOff, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 2);
  t = 235.;
  ptc.evalG(t, uValue, nodeOff, disable, locked, tfoClosed, deltaUTarget, &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_UP);
  ptc.evalZ(t, &states[0], disable, nodeOff, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 1);
  t = 255.;
  ptc.evalG(t, uValue, nodeOff, disable, locked, tfoClosed, deltaUTarget, &states[0]);
  ASSERT_EQ(states[0], ROOT_UP);
  ASSERT_EQ(states[1], ROOT_DOWN);
  ASSERT_EQ(states[2], ROOT_DOWN);
  ASSERT_EQ(states[3], ROOT_UP);
  ptc.evalZ(t, &states[0], disable, nodeOff, locked, tfoClosed, &network);
  ASSERT_EQ(ptc.getCurrentStepIndex(), 0);
}
}  // namespace DYN
