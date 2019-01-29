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
 * @file DYDUnitDynamicModelImpl.cpp
 * @brief Modelica dynamic models description : implementation file
 *
 */

#include "DYDUnitDynamicModelImpl.h"

using std::string;

namespace dynamicdata {

UnitDynamicModel::Impl::Impl(const string& id, const string& name) :
id_(id),
parFile_(),
parId_(),
dynamicModelName_(name),
dynamicFileName_(),
initModelName_(),
initFileName_() {
}

UnitDynamicModel::Impl::~Impl() {
}

string
UnitDynamicModel::Impl::getId() const {
  return id_;
}

string
UnitDynamicModel::Impl::getParFile() const {
  return parFile_;
}

string
UnitDynamicModel::Impl::getParId() const {
  return parId_;
}

string
UnitDynamicModel::Impl::getDynamicModelName() const {
  return dynamicModelName_;
}

string
UnitDynamicModel::Impl::getDynamicFileName() const {
  return dynamicFileName_;
}

string
UnitDynamicModel::Impl::getInitModelName() const {
  return initModelName_;
}

string
UnitDynamicModel::Impl::getInitFileName() const {
  return initFileName_;
}

UnitDynamicModel&
UnitDynamicModel::Impl::setParFile(const string& parFile) {
  parFile_ = parFile;
  return *this;
}

UnitDynamicModel&
UnitDynamicModel::Impl::setParId(const string& parId) {
  parId_ = parId;
  return *this;
}

UnitDynamicModel&
UnitDynamicModel::Impl::setDynamicFileName(const string& name) {
  dynamicFileName_ = name;
  return *this;
}

UnitDynamicModel&
UnitDynamicModel::Impl::setInitModelName(const string& name) {
  initModelName_ = name;
  return *this;
}

UnitDynamicModel&
UnitDynamicModel::Impl::setInitFileName(const string& path) {
  initFileName_ = path;
  return *this;
}

}  // namespace dynamicdata
