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
 * @file DYDUnitDynamicModel.cpp
 * @brief Modelica dynamic models description : implementation file
 *
 */

#include "DYDUnitDynamicModel.h"

using std::string;

namespace dynamicdata {

UnitDynamicModel::UnitDynamicModel(const string& id, const string& name) : id_(id), dynamicModelName_(name) {}

const string&
UnitDynamicModel::getId() const {
  return id_;
}

const string&
UnitDynamicModel::getParFile() const {
  return parFile_;
}

const string&
UnitDynamicModel::getParId() const {
  return parId_;
}

const string&
UnitDynamicModel::getDynamicModelName() const {
  return dynamicModelName_;
}

const string&
UnitDynamicModel::getDynamicFileName() const {
  return dynamicFileName_;
}

const string&
UnitDynamicModel::getInitModelName() const {
  return initModelName_;
}

const string&
UnitDynamicModel::getInitFileName() const {
  return initFileName_;
}

UnitDynamicModel&
UnitDynamicModel::setParFile(const string& parFile) {
  parFile_ = parFile;
  return *this;
}

UnitDynamicModel&
UnitDynamicModel::setParId(const string& parId) {
  parId_ = parId;
  return *this;
}

UnitDynamicModel&
UnitDynamicModel::setDynamicFileName(const string& name) {
  dynamicFileName_ = name;
  return *this;
}

UnitDynamicModel&
UnitDynamicModel::setInitModelName(const string& name) {
  initModelName_ = name;
  return *this;
}

UnitDynamicModel&
UnitDynamicModel::setInitFileName(const string& path) {
  initFileName_ = path;
  return *this;
}

}  // namespace dynamicdata
