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
 * @file JOBInitValuesEntryImpl.h
 * @brief InitValues entries description : header file
 *
 */

#ifndef API_JOB_JOBINITVALUESENTRYIMPL_H_
#define API_JOB_JOBINITVALUESENTRYIMPL_H_

#include "JOBInitValuesEntry.h"

namespace job {

/**
 * @class InitValuesEntry::Impl
 * @brief InitValuesEntry implemented class
 */
class InitValuesEntry::Impl : public InitValuesEntry {
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
   * @copydoc InitValuesEntry::setDumpLocalInitValues()
   */
  void setDumpLocalInitValues(const bool dumpLocalInitValues);

  /**
   * @copydoc InitValuesEntry::getDumpLocalInitValues()
   */
  bool getDumpLocalInitValues() const;

  /**
   * @copydoc InitValuesEntry::setDumpGlobalInitValues()
   */
  void setDumpGlobalInitValues(const bool dumpGlobalInitValues);

  /**
   * @copydoc InitValuesEntry::getDumpGlobalInitValues()
   */
  bool getDumpGlobalInitValues() const;

 private:
  bool dumpLocalInitValues_;  ///< boolean indicating whether to write the local init values in the outputs directory
  bool dumpGlobalInitValues_;  ///< boolean indicating whether to write the global init values in the outputs directory
};

}  // namespace job

#endif  // API_JOB_JOBINITVALUESENTRYIMPL_H_
