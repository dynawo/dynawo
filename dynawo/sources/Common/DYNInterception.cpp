//
// Copyright (c) 2015-2024, RTE (http://www.rte-france.com)
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
 * @file  DYNInterception.cpp
 *
 * @brief Interception implementation
 *
 * Interception use the message class to access to the cause of model
 * interruption
 */
#include <sstream>
#include <stdio.h>
#include "DYNCommon.h"
#include "DYNInterception.h"
#include "DYNMessage.hpp"

namespace DYN {

using std::string;

Interception::Interception(const Message& m) :
std::exception(),
msgToReturn_(m.str()) {
}

Interception::Interception(const Interception& i) :
std::exception(i),
msgToReturn_(i.msgToReturn_) {
}

const char* Interception::what() const noexcept {
  return (msgToReturn_.c_str());
}

}  // namespace DYN
