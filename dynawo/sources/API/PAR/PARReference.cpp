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
 * @file PARReferenceImpl.cpp
 * @brief Dynawo references : implementation file
 *
 */

#include "PARReference.h"

#include "DYNMacrosMessage.h"

using DYN::Error;

using std::string;

namespace parameters {

Reference::Reference(const string& name, OriginData origData) :
  name_(name),
  origData_(origData) {}

void
Reference::setType(const string& type) {
  type_ = type;
}

void
Reference::setOrigName(const string& origName) {
  origName_ = origName;
}

void
Reference::setComponentId(const string& id) {
  componentId_ = id;
}

void
Reference::setParId(const string& parId) {
  parId_ = parId;
}

void
Reference::setParFile(const string& parFile) {
  parFile_ = parFile;
}

const string&
Reference::getType() const {
  return type_;
}

const string&
Reference::getName() const {
  return name_;
}

Reference::OriginData
Reference::getOrigData() const {
  return origData_;
}

string
Reference::getOrigDataStr() const {
  return ReferenceOriginNames[origData_];
}

const string&
Reference::getOrigName() const {
  return origName_;
}

const string&
Reference::getComponentId() const {
  return componentId_;
}

const string&
Reference::getParId() const {
  return parId_;
}

const string&
Reference::getParFile() const {
  return parFile_;
}

}  // namespace parameters
