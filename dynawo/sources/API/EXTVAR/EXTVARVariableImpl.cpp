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

#include "EXTVARVariableImpl.h"

using std::string;

namespace externalVariables {

Variable::Impl::Impl(const string& id, const Type type) :
id_(id),
type_(type),
size_(boost::none),
optional_(boost::none) {
  defaultValue_.clear();
}

Variable::Impl::~Impl() {
}

string
Variable::Impl::getId() const {
  return id_;
}

Variable::Type
Variable::Impl::getType() const {
  return type_;
}

Variable&
Variable::Impl::setId(const string & id) {
  id_ = id;
  return *this;
}

Variable&
Variable::Impl::setDefaultValue(const string& value) {
  defaultValue_ = value;
  return *this;
}

bool
Variable::Impl::hasSize() const {
  return (size_ != boost::none);
}

Variable&
Variable::Impl::setSize(unsigned int size) {
  if (type_ != CONTINUOUS_ARRAY && type_ != DISCRETE_ARRAY)
    throw DYNError(DYN::Error::API, ExternalVariableAttributeOnlyForArray, id_, "size");
  size_ = size;
  return *this;
}

unsigned int
Variable::Impl::getSize() const {
  if (size_ == boost::none)
    throw DYNError(DYN::Error::API, ExternalVariableAttributeNotDefined, id_, "size");
  return *size_;
}

bool
Variable::Impl::hasOptional() const {
  return (optional_ != boost::none);
}

Variable&
Variable::Impl::setOptional(bool optional) {
  if (type_ != CONTINUOUS_ARRAY && type_ != DISCRETE_ARRAY)
    throw DYNError(DYN::Error::API, ExternalVariableAttributeOnlyForArray, id_, "optional");
  optional_ = optional;
  return *this;
}

bool
Variable::Impl::getOptional() const {
  if (optional_ == boost::none)
    throw DYNError(DYN::Error::API, ExternalVariableAttributeNotDefined, id_, "optional");
  return *optional_;
}

bool Variable::Impl::hasDefaultValue() const {
  return !defaultValue_.empty();
}

string
Variable::Impl::getDefaultValue() const {
  if (!hasDefaultValue()) {
    throw DYNError(DYN::Error::API, ExternalVariableAttributeNotDefined, id_, "defaultValue");
  }
  return defaultValue_;
}


}  // namespace externalVariables
