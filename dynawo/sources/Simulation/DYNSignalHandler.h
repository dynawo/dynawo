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
 * @file  DYNSignalHandler.h
 *
 * @brief Signal Handler header
 *
 */
#ifndef SIMULATION_DYNSIGNALHANDLER_H_
#define SIMULATION_DYNSIGNALHANDLER_H_

#include <stdexcept>

namespace DYN {

/**
 * @brief Signal handler class
 *
 * Signal handler object intercepts signal from the outside
 */
class SignalHandler {
 public:
  /**
   * @brief getter to check if one signal was intercepted
   * @return @b true if one signal was intercepted
   */
  static bool gotExitSignal();

  /**
   * @brief setter to indicate if one signal was intercepted
   * @param exitSignal @b true if one signal is intercepted
   */
  static void setExitSignal(bool exitSignal);

  /**
   * @brief declare the signal to intercept
   */
  static void setSignalHandlers();

  /**
   * @brief handler to intercept signal
   * @param signal num of the signal intercepted
   */
  static void exitSignalHandler(int signal);

 protected:
  static bool gotExitSignal_;  ///< one signal was intercepted
};
}  // namespace DYN
#endif  // SIMULATION_DYNSIGNALHANDLER_H_
