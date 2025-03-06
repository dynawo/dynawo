//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
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
 * @file  JOBInitialStateEntryFactory.h
 *
 * @brief Dynawo initial state entry factory : header file
 *
 */
#ifndef API_JOB_JOBINITIALSTATEENTRYFACTORY_H_
#define API_JOB_JOBINITIALSTATEENTRYFACTORY_H_

#include "JOBInitialStateEntry.h"

#include <memory>


namespace job {

/**
 * @class  InitialStateEntryFactory
 *
 * @brief initial state entry factory
 *
 */
class InitialStateEntryFactory {
 public:
  /**
   * @brief create a new instance of initial state entry
   *
   * @return dynamic model entry
   */
  static std::unique_ptr<InitialStateEntry> newInstance();
};

}  // namespace job

#endif  // API_JOB_JOBINITIALSTATEENTRYFACTORY_H_
