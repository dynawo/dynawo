//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
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
 * @file JOBLocalInitEntry.h
 * @brief Local init entries description : interface file
 *
 */

#ifndef API_JOB_JOBLOCALINITENTRY_H_
#define API_JOB_JOBLOCALINITENTRY_H_

#include <string>

namespace job {

/**
 * @class LocalInitEntry
 * @brief Local init entries container class
 */
class LocalInitEntry {
 public:
  /**
   * @brief setter of the local initialization solver parameters file
   * @param initParFile : local initialization solver parameters file
   */
  void setParFile(const std::string& initParFile);

  /**
   * @brief getter of the local initialization solver parameters file
   * @return local initialization solver parameters file
   */
  const std::string& getParFile() const;

  /**
   * @brief id of the parameters set in parameters file setter
   * @param parId : id of the parameters set in parameters file
   */
  void setParId(const std::string& parId);

  /**
   * @brief id of the parameters set in parameters file getter
   * @return id of the parameters set in parameters file
   */
  const std::string& getParId() const;

 private:
  std::string initParFile_;  ///< Parameters file of the local initialization solver parameters
  std::string initParId_;    ///< id of the parameters set in parameters file
};

}  // namespace job

#endif  // API_JOB_JOBLOCALINITENTRY_H_
