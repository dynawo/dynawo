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

#include "DYNStepInterfaceIIDM.h"

#include "gtest_dynawo.h"

TEST(DataInterfaceTest, PhaseTapChangerStep) {
  powsybl::iidm::PhaseTapChangerStep S(1.1L, 2.2L, 3.3L, 4.4L, 5.5L, 6.6L);
  DYN::StepInterfaceIIDM Ifce(S);

  ASSERT_DOUBLE_EQ(Ifce.getAlpha(), 1.1L);
  ASSERT_DOUBLE_EQ(Ifce.getRho(), 2.2L);
  ASSERT_DOUBLE_EQ(Ifce.getR(), 3.3L);
  ASSERT_DOUBLE_EQ(Ifce.getX(), 4.4L);
  ASSERT_DOUBLE_EQ(Ifce.getG(), 5.5L);
  ASSERT_DOUBLE_EQ(Ifce.getB(), 6.6L);

}  // TEST(DataInterfaceTest, PhaseTapChangerStep)

TEST(DataInterfaceTest, RatioTapChangerStep) {
  powsybl::iidm::RatioTapChangerStep S(1.1L, 2.2L, 3.3L, 4.4L, 5.5L);
  DYN::StepInterfaceIIDM Ifce(S);

  ASSERT_DOUBLE_EQ(Ifce.getAlpha(), 0.0L);
  ASSERT_DOUBLE_EQ(Ifce.getRho(), 1.1L);
  ASSERT_DOUBLE_EQ(Ifce.getR(), 2.2L);
  ASSERT_DOUBLE_EQ(Ifce.getX(), 3.3L);
  ASSERT_DOUBLE_EQ(Ifce.getG(), 4.4L);
  ASSERT_DOUBLE_EQ(Ifce.getB(), 5.5L);

}  // TEST(DataInterfaceTest, RatioTapChangerStep)
