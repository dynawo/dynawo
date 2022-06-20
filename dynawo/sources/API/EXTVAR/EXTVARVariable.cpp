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
 * @file EXTVARVariableImpl.cpp
 * @brief Variable description : implementation file
 *
 */

#include "DYNMacrosMessage.h"

#include "EXTVARVariable.h"

using std::string;

namespace externalVariables {

Variable::Variable(const string& id, const Type type) :
id_(id),
type_(type),
size_(boost::none),
optional_(boost::none) {
  defaultValue_.clear();
}

string
Variable::getId() const {
  return id_;
}

Variable::Type
Variable::getType() const {
  return type_;
}

Variable&
Variable::setId(const string & id) {
  id_ = id;
  return *this;
}

Variable&
Variable::setDefaultValue(const string& value) {
  defaultValue_ = value;
  return *this;
}

bool
Variable::hasSize() const {
  return (size_ != boost::none);
}

Variable&
Variable::setSize(unsigned int size) {
  if (type_ != Type::CONTINUOUS_ARRAY && type_ != Type::DISCRETE_ARRAY)
    throw DYNError(DYN::Error::API, ExternalVariableAttributeOnlyForArray, id_, "size");
  size_ = size;
  return *this;
}

unsigned int
Variable::getSize() const {
  if (size_ == boost::none)
    throw DYNError(DYN::Error::API, ExternalVariableAttributeNotDefined, id_, "size");
  return *size_;
}

bool
Variable::hasOptional() const {
  return (optional_ != boost::none);
}

Variable&
Variable::setOptional(bool optional) {
  if (type_ != Type::CONTINUOUS_ARRAY && type_ != Type::DISCRETE_ARRAY && type_ != Type::CONTINUOUS)
    throw DYNError(DYN::Error::API, ExternalVariableAttributeOnlyForArrayAndContinuous, id_, "optional");
  optional_ = optional;
  return *this;
}

bool
Variable::getOptional() const {
  if (optional_ == boost::none)
    throw DYNError(DYN::Error::API, ExternalVariableAttributeNotDefined, id_, "optional");
  return *optional_;
}

bool Variable::hasDefaultValue() const {
  return !defaultValue_.empty();
}

string
Variable::getDefaultValue() const {
  if (!hasDefaultValue()) {
    throw DYNError(DYN::Error::API, ExternalVariableAttributeNotDefined, id_, "defaultValue");
  }
  return defaultValue_;
}


}  // namespace externalVariables
