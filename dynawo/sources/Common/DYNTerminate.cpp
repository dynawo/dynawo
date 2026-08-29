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
 * @file  DYNTerminate.cpp
 *
 * @brief Terminate implementation
 *
 * Terminate use the message class to access the cause of model
 * interruption
 */
#include <sstream>
#include <stdio.h>
#include "DYNCommon.h"
#include "DYNTerminate.h"
#include "DYNMessage.hpp"

namespace DYN {

using std::string;

Terminate::Terminate(const Message& m) :
std::exception(),
msgToReturn_(m.str()) {
}

Terminate::Terminate(const Terminate& t) :
std::exception(t),
msgToReturn_(t.msgToReturn_) {
}

const char* Terminate::what() const noexcept {
  return (msgToReturn_.c_str());
}

}  // namespace DYN
