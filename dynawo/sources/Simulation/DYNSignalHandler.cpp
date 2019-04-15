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
 * @file  DYNSignalHandler.cpp
 *
 * @brief Signal Handler implementation
 *
 */
#include <csignal>
#include <cerrno>
#include <iostream>

#include "DYNSignalHandler.h"

namespace DYN {

bool SignalHandler::gotExitSignal_ = false;

bool
SignalHandler::gotExitSignal() {
  return gotExitSignal_;
}

void
SignalHandler::setExitSignal(bool exitSignal) {
  gotExitSignal_ = exitSignal;
}

void
SignalHandler::exitSignalHandler(int signal) {
  switch (signal) {
    case SIGTERM:
      setExitSignal(true);
      break;
    case SIGINT:
      setExitSignal(true);
      break;
    case SIGQUIT:
      setExitSignal(true);
      break;
  }
}

void
SignalHandler::setSignalHandlers() {
  signal(SIGTERM, SignalHandler::exitSignalHandler);
  signal(SIGINT, SignalHandler::exitSignalHandler);
  signal(SIGQUIT, SignalHandler::exitSignalHandler);
}

}  // namespace DYN
