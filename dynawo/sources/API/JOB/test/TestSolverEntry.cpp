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

/**
 * @file API/JOB/test/TestSolverEntry.cpp
 * @brief Unit tests for API_JOB/JOBSolverEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBSolverEntry.h"

namespace job {

TEST(APIJOBTest, testSolverEntry) {
  boost::shared_ptr<SolverEntry> solver = boost::shared_ptr<SolverEntry>(new SolverEntry());
  // check default attributes
  ASSERT_EQ(solver->getLib(), "");
  ASSERT_EQ(solver->getParametersFile(), "");
  ASSERT_EQ(solver->getParametersId(), "");

  solver->setLib("Solver");
  solver->setParametersFile("solver.par");
  solver->setParametersId("solver_par");

  ASSERT_EQ(solver->getLib(), "Solver");
  ASSERT_EQ(solver->getParametersFile(), "solver.par");
  ASSERT_EQ(solver->getParametersId(), "solver_par");
}

}  // namespace job
