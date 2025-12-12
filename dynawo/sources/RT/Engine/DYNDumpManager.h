//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNDumpManager.h
 *
 * @brief DumpManager header
 *
 */
#ifndef RT_ENGINE_DYNDUMPMANAGER_H_
#define RT_ENGINE_DYNDUMPMANAGER_H_

#include <boost/shared_ptr.hpp>
#include <atomic>
#include "DYNRTInputCommon.h"

namespace DYN {

/**
 * @brief DumpManager class
 *
 * class including dump related RT functions
 *
 */
class DumpManager {
 public:
  /**
   * @brief constructor
   */
  DumpManager();

  /**
   * @brief handle a received state dump message
   * @param dumpTriggerMessage state trigger message
   */
  void handleMessage(DumpTriggerMessage& dumpTriggerMessage);

  /**
   * @brief get the dumpSignalReceived value
   * @return true if dump signal was received
   */
  bool hasReceivedDumpSignal();

  /**
   * @brief reset the dump signal reception flag to false
   */
  void resetDumpSignal();

 private:
  std::atomic<bool> dumpSignalReceived_;      ///< true if dump signal was received
};

}  // end of namespace DYN

#endif  // RT_ENGINE_DYNDUMPMANAGER_H_
