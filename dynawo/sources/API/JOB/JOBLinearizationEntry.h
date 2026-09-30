//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
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
 * @file JOBLinearizationEntry.h
 * @brief Linearization entries description : interface file
 *
 */

#ifndef API_JOB_JOBLINEARIZATIONENTRY_H_
#define API_JOB_JOBLINEARIZATIONENTRY_H_

namespace job {

/**
 * @class LinearizationEntry
 * @brief Linearization entries container class
 */
class LinearizationEntry {
 public:
  /**
   * @brief constructor
   */
  LinearizationEntry();

  /**
   * @brief time getter
   * @return time at which the linearization is done
   */
  double getTime() const;

  /**
   * @brief time setter
   * @param time time at which the linearization is done
   */
  void setTime(double time);

 private:
  double time_;  ///< time at which the linearization is done
};

}  // namespace job

#endif  // API_JOB_JOBLINEARIZATIONENTRY_H_
