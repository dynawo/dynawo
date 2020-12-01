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

/**
 * @file  JOBSimulationEntryFactory.h
 *
 * @brief Dynawo dynamic model entry factory : header file
 *
 */
#ifndef API_JOB_JOBSIMULATIONENTRYFACTORY_H_
#define API_JOB_JOBSIMULATIONENTRYFACTORY_H_

#include "JOBSimulationEntry.h"

#include <boost/shared_ptr.hpp>

namespace job {

/**
 * @class  SimulationEntryFactory
 *
 * @brief dynamic model entry factory
 *
 */
class SimulationEntryFactory {
 public:
  /**
   * @brief create a new instance of dynamic model entry
   *
   * @return dynamic model entry
   */
  static boost::shared_ptr<SimulationEntry> newInstance();
};

}  // namespace job

#endif  // API_JOB_JOBSIMULATIONENTRYFACTORY_H_
