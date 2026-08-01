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
 * @file  JOBJobsCollectionFactory.h
 *
 * @brief Dynawo jobs collection factory : header file
 *
 */
#ifndef API_JOB_JOBJOBSCOLLECTIONFACTORY_H_
#define API_JOB_JOBJOBSCOLLECTIONFACTORY_H_

#include "JOBJobsCollection.h"

#include <memory>


namespace job {

/**
 * @brief Factory for jobs collection
 */
class JobsCollectionFactory {
 public:
  /**
   * @brief create a new instance of jobs collection
   *
   * @return Final state collection
   */
  static std::unique_ptr<JobsCollection> newInstance();
};  ///< Class for creation of jobs collection

}  // namespace job

#endif  // API_JOB_JOBJOBSCOLLECTIONFACTORY_H_
