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

Reference::Reference(const string& name) : type_(""), name_(name), origName_(""), componentId_("") {}

void
Reference::setType(const string& type) {
  type_ = type;
}

void
Reference::setOrigData(const string& origData) {
  if (origData == ReferenceOriginNames[Reference::IIDM]) {
    setOrigData(Reference::IIDM);
    return;
  }
  throw DYNError(Error::API, ReferenceUnknownOriginData, origData);
}

void
Reference::setOrigData(const OriginData& origData) {
  origData_ = origData;
}

void
Reference::setOrigName(const string& origName) {
  origName_ = origName;
}

void
Reference::setComponentId(const string& id) {
  componentId_ = id;
}

string
Reference::getType() const {
  return type_;
}

string
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

string
Reference::getOrigName() const {
  return origName_;
}

string
Reference::getComponentId() const {
  return componentId_;
}

}  // namespace parameters
