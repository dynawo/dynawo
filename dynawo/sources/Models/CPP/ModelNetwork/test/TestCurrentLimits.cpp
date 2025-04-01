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

#include "DYNModelCurrentLimits.h"
#include "CSTRConstraintsCollectionFactory.h"
#include "CSTRConstraintsCollection.h"
#include "TLTimelineFactory.h"
#include "CSTRConstraint.h"
#include "DYNModelNetwork.h"
#include "gtest_dynawo.h"

namespace DYN {

TEST(ModelsModelNetwork, ModelNetworkCurrentLimits) {
  ModelCurrentLimits mcl;
  ASSERT_EQ(mcl.sizeZ(), 0);
  ASSERT_EQ(mcl.sizeG(), 0);

  double t = 0.;
  double current = 4.;
  std::vector<state_g> states(mcl.sizeG(), NO_ROOT);
  const double desactivate = 0.;
  const std::string modelType = "Whatever";

  mcl.addLimit(8., 5.);
  ASSERT_EQ(mcl.sizeZ(), 0);
  ASSERT_EQ(mcl.sizeG(), 2);
  mcl.addLimit(std::numeric_limits<double>::quiet_NaN(), std::numeric_limits<int>::max());
  ASSERT_EQ(mcl.sizeZ(), 0);
  ASSERT_EQ(mcl.sizeG(), 2);
  mcl.addLimit(10., std::numeric_limits<int>::max());
  ASSERT_EQ(mcl.sizeZ(), 0);
  ASSERT_EQ(mcl.sizeG(), 4);
  states.resize(mcl.sizeG(), NO_ROOT);
  mcl.setMaxTimeOperation(10.);
  mcl.setSide(ModelCurrentLimits::SIDE_2);

  boost::shared_ptr<constraints::ConstraintsCollection> constraints =
      constraints::ConstraintsCollectionFactory::newInstance("MyConstaintsCollection");
  ModelNetwork network;
  network.setConstraints(constraints);
  network.setTimeline(timeline::TimelineFactory::newInstance("Test"));

  mcl.evalG(t, current, &states[0], desactivate);
  for (size_t i = 0; i < states.size(); ++i) {
    if (i == 3)
      ASSERT_EQ(states[i], NO_ROOT);
    else
      ASSERT_EQ(states[i], ROOT_DOWN);
  }
  current = 9.;
  mcl.evalG(t, current, &states[0], desactivate);
  for (size_t i = 0; i < states.size(); ++i) {
    if (i == 0)
      ASSERT_EQ(states[i], ROOT_UP);
    else if (i == 3)
      ASSERT_EQ(states[i], NO_ROOT);
    else
      ASSERT_EQ(states[i], ROOT_DOWN);
  }
  mcl.evalZ("MY COMP", t, &states[0], &network, desactivate, modelType);

  current = 11.;
  mcl.evalG(t, current, &states[0], desactivate);
  for (size_t i = 0; i < states.size(); ++i) {
    if (i == 0 || i == 2) {
      ASSERT_EQ(states[i], ROOT_UP);
    } else if (i == 3) {
      ASSERT_EQ(states[i], NO_ROOT);
    }
  }
  mcl.evalZ("MY COMP", t, &states[0], &network, desactivate, modelType);

  unsigned n = 0;
  for (constraints::ConstraintsCollection::const_iterator it = constraints->cbegin(),
      itEnd = constraints->cend(); it != itEnd; ++it) {
    boost::shared_ptr<constraints::Constraint> constraint = (*it);
    if (n == 1) {
      ASSERT_EQ(constraint->getModelName(), "MY COMP");
      ASSERT_EQ(constraint->getDescription(), "PATL 2");
      ASSERT_DOUBLE_EQUALS_DYNAWO(constraint->getTime(), 0.);
      ASSERT_EQ(constraint->getType(), constraints::CONSTRAINT_BEGIN);
      ASSERT_EQ(constraint->getModelType(), modelType);
    } else if (n == 0) {
      ASSERT_EQ(constraint->getModelName(), "MY COMP");
      ASSERT_EQ(constraint->getDescription(), "OverloadUp 5 2");
      ASSERT_DOUBLE_EQUALS_DYNAWO(constraint->getTime(), 0.);
      ASSERT_EQ(constraint->getType(), constraints::CONSTRAINT_BEGIN);
      ASSERT_EQ(constraint->getModelType(), modelType);
    } else {
      assert(0);
    }
    ++n;
  }
  ASSERT_EQ(n, 2);
  current = 4.;
  t = 5.1;
  mcl.evalG(t, current, &states[0], desactivate);
  for (size_t i = 0; i < states.size(); ++i) {
    if (i == 0 || i == 2)
      ASSERT_EQ(states[i], ROOT_DOWN);
    else if (i == 3)
      ASSERT_EQ(states[i], NO_ROOT);
    else
      ASSERT_EQ(states[i], ROOT_UP);
  }
  network.setCurrentTime(5.1);
  mcl.evalZ("MY COMP", t, &states[0], &network, desactivate, modelType);

  n = 0;
  for (constraints::ConstraintsCollection::const_iterator it = constraints->cbegin(),
      itEnd = constraints->cend(); it != itEnd; ++it) {
    boost::shared_ptr<constraints::Constraint> constraint = (*it);
    if (n == 0) {
      ASSERT_EQ(constraint->getModelName(), "MY COMP");
      ASSERT_EQ(constraint->getDescription(), "OverloadOpen 5 2");
      ASSERT_DOUBLE_EQUALS_DYNAWO(constraint->getTime(), 5.1);
      ASSERT_EQ(constraint->getType(), constraints::CONSTRAINT_BEGIN);
      ASSERT_EQ(constraint->getModelType(), modelType);
    } else {
      assert(0);
    }
    ++n;
  }
  ASSERT_EQ(n, 1);
}
}  // namespace DYN
