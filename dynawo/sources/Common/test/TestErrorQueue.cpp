//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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

#include "gtest_dynawo.h"

#include "DYNErrorQueue.h"
#include "DYNMacrosMessage.h"

namespace DYN {

TEST(CommonTest, testErrorQueue) {
  DYNErrorQueue& handler = DYNErrorQueue::instance();
  size_t maxDisplayedError = handler.getMaxDisplayedError();
  ASSERT_NO_THROW(handler.flush());

  handler.push(DYNError(DYN::Error::SIMULATION, KeyError_t::NoJobDefined));
  ASSERT_THROW_DYNAWO(handler.flush(), Error::SIMULATION, KeyError_t::NoJobDefined);
  ASSERT_NO_THROW(handler.flush());

  handler.push(DYNError(DYN::Error::SIMULATION, KeyError_t::NoJobDefined));
  handler.push(DYNError(DYN::Error::GENERAL, KeyError_t::CriteriaNotChecked));
  ASSERT_THROW_DYNAWO(handler.flush(), Error::GENERAL, KeyError_t::MultipleErrors);
  ASSERT_NO_THROW(handler.flush());

  for (unsigned int i = 0; i < maxDisplayedError; ++i) {
    handler.push(DYNError(DYN::Error::SIMULATION, KeyError_t::NoJobDefined));
  }
  ASSERT_THROW_DYNAWO(handler.flush(), Error::GENERAL, KeyError_t::MultipleErrors);
  ASSERT_NO_THROW(handler.flush());

  for (unsigned int i = 0; i < maxDisplayedError + 1; ++i) {
    handler.push(DYNError(DYN::Error::SIMULATION, KeyError_t::NoJobDefined));
  }
  ASSERT_THROW_DYNAWO(handler.flush(), Error::GENERAL, KeyError_t::MultipleAndHiddenErrors);
  ASSERT_NO_THROW(handler.flush());

  for (unsigned int i = 0; i < 2*maxDisplayedError; ++i) {
    handler.push(DYNError(DYN::Error::SIMULATION, KeyError_t::NoJobDefined));
  }
  ASSERT_THROW_DYNAWO(handler.flush(), Error::GENERAL, KeyError_t::MultipleAndHiddenErrors);
  ASSERT_NO_THROW(handler.flush());
}

}  // namespace DYN
