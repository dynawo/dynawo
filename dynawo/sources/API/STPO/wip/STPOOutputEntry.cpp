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
 * @file  STPOOutputEntry.cpp
 *
 * @brief Dynawo OutputEntry : implementation file
 *
 */
#include "STPOOutputEntry.h"

#include <iostream>
#include <limits>

#include "make_unique.hpp"

using std::string;

namespace stepOutputs {

std::unique_ptr<OutputEntry>
OutputEntryFactory::newOutputEntry() {
  return DYN::make_unique<OutputEntry>();
}

OutputEntry::OutputEntry::OutputEntry() :
      variable_(""),
      alias_("") {}

void
OutputEntry::setVariable(const string& variable) {
  variable_ = variable;
}

void
OutputEntry::setAlias(const string& alias) {
  alias_ = alias;
}

const string&
OutputEntry::getVariable() const {
  return variable_;
}

const string&
OutputEntry::getAlias() const {
  return alias_;
}
}  // namespace stepOutputs
