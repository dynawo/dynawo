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
 * @file DYDBlackBoxModel.cpp
 * @brief Blackbox model description : implementation file
 *
 */

#include "DYDBlackBoxModel.h"

using std::string;


namespace dynamicdata {

BlackBoxModel::BlackBoxModel(const string& id) : Model(id, Model::BLACK_BOX_MODEL) {}

BlackBoxModel::~BlackBoxModel() {}

const std::string&
BlackBoxModel::getLib() const {
  return lib_;
}

BlackBoxModel&
BlackBoxModel::setLib(const string& lib) {
  lib_ = lib;
  return *this;
}

const string&
BlackBoxModel::getStaticId() const {
  return staticId_;
}

BlackBoxModel&
BlackBoxModel::setStaticId(const string& staticId) {
  staticId_ = staticId;
  return *this;
}

BlackBoxModel&
BlackBoxModel::setParFile(const string& parFile) {
  parFile_ = parFile;
  return *this;
}

BlackBoxModel&
BlackBoxModel::setParId(const string& parId) {
  parId_ = parId;
  return *this;
}

const string&
BlackBoxModel::getParFile() const {
  return parFile_;
}

const string&
BlackBoxModel::getParId() const {
  return parId_;
}

}  // namespace dynamicdata
