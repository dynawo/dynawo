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
 * @file  DYNStaticParameter.cpp
 *
 * @brief Static parameter description : implementation file
 *
 */
#include "DYNStaticParameter.h"
#include "DYNMacrosMessage.h"

using std::string;

namespace DYN {

StaticParameter::StaticParameter():
type_(StaticParameter::DOUBLE),  // most used type
name_("") {
}

StaticParameter::StaticParameter(const string& name, const StaticParameterType& type) :
type_(type),
name_(name) {
}

string
StaticParameter::getName() const {
  return name_;
}

StaticParameter::StaticParameterType
StaticParameter::getType() const {
  return type_;
}

bool
StaticParameter::valueAffected() const {
  return value_ != boost::none;
}

string
StaticParameter::typeAsString(const StaticParameterType& type) {
  switch (type) {
    case INT:
      return "INT";
    case BOOL:
      return "BOOL";
    case DOUBLE:
      return "DOUBLE";
  }
  return "";  /// to avoid compiler warning
}

}  // namespace DYN
