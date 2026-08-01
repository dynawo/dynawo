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
SignalHandler::setExitSignal(const bool exitSignal) {
  gotExitSignal_ = exitSignal;
}

void
SignalHandler::exitSignalHandler(const int signal) {
  switch (signal) {
#ifdef SIGTERM
    case SIGTERM:
      setExitSignal(true);
      break;
#endif
#ifdef SIGINT
    case SIGINT:
      setExitSignal(true);
      break;
#endif
#ifdef SIGQUIT
    case SIGQUIT:
      setExitSignal(true);
      break;
#endif
  }
}

void
SignalHandler::setSignalHandlers() {
#ifdef SIGTERM
  signal(SIGTERM, SignalHandler::exitSignalHandler);
#endif
#ifdef SIGINT
  signal(SIGINT, SignalHandler::exitSignalHandler);
#endif
#ifdef SIGQUIT
  signal(SIGQUIT, SignalHandler::exitSignalHandler);
#endif
}

}  // namespace DYN
