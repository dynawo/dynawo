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
 * @file JOBInitValuesEntry.h
 * @brief InitValues entries description : interface file
 *
 */

#ifndef API_JOB_JOBINITVALUESENTRY_H_
#define API_JOB_JOBINITVALUESENTRY_H_

#include "JOBExport.h"

namespace job {

/**
 * @brief InitValuesEntry
 * @brief Init values entries container class
 */
class __DYNAWO_JOB_EXPORT InitValuesEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~InitValuesEntry() {}

  /**
   * @brief whether to write local init values setter
   * @param dumpLocalInitValues : whether to dump the local init values for the job
   */
  virtual void setDumpLocalInitValues(const bool dumpLocalInitValues) = 0;

  /**
   * @brief whether to write local init values getter
   * @return whether to dump the local init values for the job
   */
  virtual bool getDumpLocalInitValues() const = 0;

  /**
   * @brief whether to write global init values setter
   * @param dumpGlobalInitValues : whether to dump the global init values for the job
   */
  virtual void setDumpGlobalInitValues(const bool dumpGlobalInitValues) = 0;

  /**
   * @brief whether to dump the global init values getter
   * @return whether to dump the global init values for the job
   */
  virtual bool getDumpGlobalInitValues() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBINITVALUESENTRY_H_
