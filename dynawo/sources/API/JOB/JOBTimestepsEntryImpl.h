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
 * @file JOBTimestepsEntryImpl.h
 * @brief Timesteps entries description : header file
 *
 */

#ifndef API_JOB_JOBTIMESTEPSENTRYIMPL_H_
#define API_JOB_JOBTIMESTEPSENTRYIMPL_H_

#include <string>
#include "JOBTimestepsEntry.h"

namespace job {

/**
 * @class TimestepsEntry::Impl
 * @brief Timesteps entries container class
 */
class TimestepsEntry::Impl : public TimestepsEntry {
 public:
  /**
   * @brief constructor
   */
  Impl();

  /**
   * @brief destructor
   */
  virtual ~Impl();

  /**
   * @copydoc TimestepsEntry::setStep()
   */
  void setStep(int step);

  /**
   * @copydoc TimestepsEntry::getStep()
   */
  int getStep() const;

 private:
  int step_;  ///< step to use
};

}  // namespace job

#endif  // API_JOB_JOBTIMESTEPSENTRYIMPL_H_
