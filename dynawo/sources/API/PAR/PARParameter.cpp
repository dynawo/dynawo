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
 * @file PARParameter.cpp
 * @brief Dynawo parameters : implementation file
 *
 */

#include "PARParameter.h"

#include "DYNMacrosMessage.h"

using std::string;

namespace parameters {

Parameter::Parameter(const string& name, const bool boolValue) : type_(BOOL), name_(name), value_(boolValue), used_(false) {}

Parameter::Parameter(const string& name, const int intValue) : type_(INT), name_(name), value_(intValue), used_(false) {}

Parameter::Parameter(const string& name, const double doubleValue) : type_(DOUBLE), name_(name), value_(doubleValue), used_(false) {}

Parameter::Parameter(const string& name, const string& stringValue) : type_(STRING), name_(name), value_(stringValue), used_(false) {}

Parameter::ParameterType
Parameter::getType() const {
  return type_;
}

string
Parameter::getName() const {
  return name_;
}

bool
Parameter::getBool() const {
  if (type_ != BOOL)
    throw DYNError(DYN::Error::API, ParameterInvalidTypeRequested, getName(), ParameterTypeNames[type_], ParameterTypeNames[BOOL]);

  bool value;
  try {
    value = boost::any_cast<bool>(value_);
  } catch (boost::bad_any_cast&) {
    throw DYNError(DYN::Error::API, ParameterBadCast, getName(), ParameterTypeNames[type_]);
  }
  return value;
}

int
Parameter::getInt() const {
  if (type_ != INT)
    throw DYNError(DYN::Error::API, ParameterInvalidTypeRequested, getName(), ParameterTypeNames[type_], ParameterTypeNames[INT]);

  int value;
  try {
    value = boost::any_cast<int>(value_);
  } catch (boost::bad_any_cast&) {
    throw DYNError(DYN::Error::API, ParameterBadCast, getName(), ParameterTypeNames[type_]);
  }
  return value;
}

double
Parameter::getDouble() const {
  if (type_ != DOUBLE)
    throw DYNError(DYN::Error::API, ParameterInvalidTypeRequested, getName(), ParameterTypeNames[type_], ParameterTypeNames[DOUBLE]);

  double value;
  try {
    value = boost::any_cast<double>(value_);
  } catch (boost::bad_any_cast&) {
    throw DYNError(DYN::Error::API, ParameterBadCast, getName(), ParameterTypeNames[type_]);
  }
  return value;
}

string
Parameter::getString() const {
  if (type_ != STRING)
    throw DYNError(DYN::Error::API, ParameterInvalidTypeRequested, getName(), ParameterTypeNames[type_], ParameterTypeNames[STRING]);

  string value;
  try {
    value = boost::any_cast<string>(value_);
  } catch (boost::bad_any_cast&) {
    throw DYNError(DYN::Error::API, ParameterBadCast, getName(), ParameterTypeNames[type_]);
  }
  return value;
}

bool
Parameter::getUsed() const {
  return used_;
}

void
Parameter::setUsed(bool Bool) {
  used_ = Bool;
}

}  // namespace parameters
