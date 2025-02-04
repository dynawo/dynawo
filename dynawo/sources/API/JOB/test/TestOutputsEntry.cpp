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
 * @file API/JOB/test/TestModelerEntry.cpp
 * @brief Unit tests for API_JOB/JOBModelerEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBOutputsEntry.h"
#include "JOBInitValuesEntry.h"
#include "JOBConstraintsEntry.h"
#include "JOBTimelineEntry.h"
#include "JOBFinalStateEntry.h"
#include "JOBCurvesEntry.h"
#include "JOBLostEquipmentsEntry.h"
#include "JOBLogsEntry.h"

#include "DYNClone.hpp"

namespace job {

TEST(APIJOBTest, testOutputsEntry) {
  std::shared_ptr<OutputsEntry> outputs = std::make_shared<OutputsEntry>();
  // check default attributes
  ASSERT_EQ(outputs->getOutputsDirectory(), "");
  ASSERT_EQ(outputs->getInitValuesEntry(), std::shared_ptr<InitValuesEntry>());
  ASSERT_EQ(outputs->getFinalValuesEntry(), std::shared_ptr<FinalValuesEntry>());
  ASSERT_EQ(outputs->getConstraintsEntry(), std::shared_ptr<ConstraintsEntry>());
  ASSERT_EQ(outputs->getTimelineEntry(), std::shared_ptr<TimelineEntry>());
  ASSERT_EQ(outputs->getFinalStateEntries().empty(), true);
  ASSERT_EQ(outputs->getCurvesEntry(), std::shared_ptr<CurvesEntry>());
  ASSERT_EQ(outputs->getLostEquipmentsEntry(), std::shared_ptr<LostEquipmentsEntry>());
  ASSERT_EQ(outputs->getLogsEntry(), std::shared_ptr<LogsEntry>());

  outputs->setOutputsDirectory("/tmp/outputs");

  std::shared_ptr<InitValuesEntry> initValues = std::make_shared<InitValuesEntry>();
  outputs->setInitValuesEntry(initValues);

  std::shared_ptr<FinalValuesEntry> finalValues = std::make_shared<FinalValuesEntry>();
  outputs->setFinalValuesEntry(finalValues);

  std::shared_ptr<ConstraintsEntry> constraints = std::make_shared<ConstraintsEntry>();
  outputs->setConstraintsEntry(constraints);

  std::shared_ptr<TimelineEntry> timeline = std::make_shared<TimelineEntry>();
  outputs->setTimelineEntry(timeline);

  std::shared_ptr<FinalStateEntry> finalState = std::make_shared<FinalStateEntry>();
  outputs->addFinalStateEntry(finalState);

  std::shared_ptr<CurvesEntry> curves = std::make_shared<CurvesEntry>();
  outputs->setCurvesEntry(curves);

  std::shared_ptr<LostEquipmentsEntry> lostEquipments = std::make_shared<LostEquipmentsEntry>();
  outputs->setLostEquipmentsEntry(lostEquipments);

  std::shared_ptr<LogsEntry> logs = std::make_shared<LogsEntry>();
  outputs->setLogsEntry(logs);


  ASSERT_EQ(outputs->getOutputsDirectory(), "/tmp/outputs");
  ASSERT_EQ(outputs->getInitValuesEntry(), initValues);
  ASSERT_EQ(outputs->getFinalValuesEntry(), finalValues);
  ASSERT_EQ(outputs->getConstraintsEntry(), constraints);
  ASSERT_EQ(outputs->getTimelineEntry(), timeline);
  ASSERT_EQ(outputs->getFinalStateEntries().size(), 1);
  ASSERT_EQ(outputs->getFinalStateEntries().front(), finalState);
  ASSERT_EQ(outputs->getCurvesEntry(), curves);
  ASSERT_EQ(outputs->getLostEquipmentsEntry(), lostEquipments);
  ASSERT_EQ(outputs->getLogsEntry(), logs);

  std::shared_ptr<OutputsEntry> outputs_bis = DYN::clone(outputs);
  ASSERT_EQ(outputs_bis->getOutputsDirectory(), "/tmp/outputs");
  ASSERT_NE(outputs_bis->getInitValuesEntry(), initValues);
  ASSERT_NE(outputs_bis->getFinalValuesEntry(), finalValues);
  ASSERT_NE(outputs_bis->getConstraintsEntry(), constraints);
  ASSERT_NE(outputs_bis->getTimelineEntry(), timeline);
  ASSERT_EQ(outputs_bis->getFinalStateEntries().size(), 1);
  ASSERT_NE(outputs_bis->getFinalStateEntries().front(), finalState);
  ASSERT_NE(outputs_bis->getCurvesEntry(), curves);
  ASSERT_NE(outputs_bis->getLostEquipmentsEntry(), lostEquipments);
  ASSERT_NE(outputs_bis->getLogsEntry(), logs);

  OutputsEntry outputs_bis2 = *outputs;
  ASSERT_EQ(outputs_bis2.getOutputsDirectory(), "/tmp/outputs");
  ASSERT_NE(outputs_bis2.getInitValuesEntry(), initValues);
  ASSERT_NE(outputs_bis2.getFinalValuesEntry(), finalValues);
  ASSERT_NE(outputs_bis2.getConstraintsEntry(), constraints);
  ASSERT_NE(outputs_bis2.getTimelineEntry(), timeline);
  ASSERT_EQ(outputs_bis2.getFinalStateEntries().size(), 1);
  ASSERT_NE(outputs_bis2.getFinalStateEntries().front(), finalState);
  ASSERT_NE(outputs_bis2.getCurvesEntry(), curves);
  ASSERT_NE(outputs_bis2.getLostEquipmentsEntry(), lostEquipments);
  ASSERT_NE(outputs_bis2.getLogsEntry(), logs);
}

}  // namespace job
