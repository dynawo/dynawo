//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  DYNComponentInterfaceIIDM.cpp
 *
 * @brief IIDM Component data interface : implementation
 */

#include "DYNComponentInterfaceIIDM.h"

namespace DYN {

ComponentInterfaceIIDM::~ComponentInterfaceIIDM() = default;

void
ComponentInterfaceIIDM::hasDynamicModel(bool hasDynamicModel) {
  auto thread_id = std::this_thread::get_id();
  if (dynamicDef_.map().count(thread_id) == 0) {
    dynamicDef_.insert({thread_id, DynamicModelDef(hasDynamicModel, nullptr)});
    return;
  }
  dynamicDef_.at(thread_id).hasDynamicModel_ = hasDynamicModel;
}

bool
ComponentInterfaceIIDM::hasDynamicModel() const {
  auto thread_id = std::this_thread::get_id();
  if (dynamicDef_.map().count(thread_id) == 0) {
    return false;
  }
  return dynamicDef_.at(thread_id).hasDynamicModel_;
}

void
ComponentInterfaceIIDM::setModelDyn(const boost::shared_ptr<SubModel>& model) {
  auto thread_id = std::this_thread::get_id();
  if (dynamicDef_.map().count(thread_id) == 0) {
    dynamicDef_.insert({thread_id, DynamicModelDef(false, model)});
    return;
  }
  dynamicDef_.at(thread_id).modelDyn_ = model;
}

boost::shared_ptr<SubModel>
ComponentInterfaceIIDM::getModelDyn() const {
  auto thread_id = std::this_thread::get_id();
  if (dynamicDef_.map().count(thread_id) == 0) {
    return nullptr;
  }
  return dynamicDef_.map().at(thread_id).modelDyn_;
}
}  // namespace DYN
