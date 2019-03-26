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
 * @file JOBDynModelsEntryImpl.h
 * @brief dynamic models entries description : header file
 *
 */

#ifndef API_JOB_JOBDYNMODELSENTRYIMPL_H_
#define API_JOB_JOBDYNMODELSENTRYIMPL_H_

#include <string>
#include "JOBDynModelsEntry.h"

namespace job {

/**
 * @class DynModelsEntry::Impl
 * @brief Dynamic models entries container : implemented class
 */
class DynModelsEntry::Impl : public DynModelsEntry {
 public:
  /**
   * @brief Default constructor
   */
  Impl();

  /**
   * @brief destructor
   */
  virtual ~Impl();

  /**
   * @copydoc DynModelsEntry::setDydFile()
   */
  void setDydFile(const std::string& dydFile);

  /**
   * @copydoc DynModelsEntry::getDydFile()
   */
  std::string getDydFile() const;

 private:
  std::string dydFile_;  ///< DYD file for the current dynamic models entry
};

}  // namespace job

#endif  // API_JOB_JOBDYNMODELSENTRYIMPL_H_
