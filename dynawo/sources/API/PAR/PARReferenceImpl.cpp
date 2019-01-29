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

#include "DYNMacrosMessage.h"

#include "PARReferenceImpl.h"

using DYN::Error;

using std::string;

namespace parameters {

Reference::Impl::Impl(const string& name) :
type_(""),
name_(name),
origName_(""),
componentId_("") {
}

Reference::Impl::~Impl() {
}

void
Reference::Impl::setType(const string& type) {
  type_ = type;
}

void
Reference::Impl::setOrigData(const string& origData) {
  if (origData == ReferenceOriginNames[Reference::IIDM]) {
    setOrigData(Reference::IIDM);
    return;
  }
  throw DYNError(Error::API, ReferenceUnknownOriginData, origData);
}

void
Reference::Impl::setOrigData(const OriginData& origData) {
  origData_ = origData;
}

void
Reference::Impl::setOrigName(const string& origName) {
  origName_ = origName;
}

void
Reference::Impl::setComponentId(const string& id) {
  componentId_ = id;
}

string
Reference::Impl::getType() const {
  return type_;
}

string
Reference::Impl::getName() const {
  return name_;
}

Reference::OriginData
Reference::Impl::getOrigData() const {
  return origData_;
}

string
Reference::Impl::getOrigDataStr() const {
  return ReferenceOriginNames[origData_];
}

string
Reference::Impl::getOrigName() const {
  return origName_;
}

string
Reference::Impl::getComponentId() const {
  return componentId_;
}



}  // namespace parameters
