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
 * @file JOBDynModelsEntry.h
 * @brief dynamic models entries description : interface file
 *
 */

#ifndef API_JOB_JOBDYNMODELSENTRY_H_
#define API_JOB_JOBDYNMODELSENTRY_H_

#include <string>

namespace job {

/**
 * @class DynModelsEntry
 * @brief Dynamic models entries container class
 */
class DynModelsEntry {
 public:
  /**
   * @brief .dyd file setter
   * @param dydFile : .dyd file for the job
   */
  void setDydFile(const std::string& dydFile);

  /**
   * @brief .dyd file getter
   * @return .dyd file for the dynamic models entry
   */
  const std::string& getDydFile() const;

 private:
  std::string dydFile_;  ///< DYD file for the current dynamic models entry
};

}  // namespace job

#endif  // API_JOB_JOBDYNMODELSENTRY_H_
