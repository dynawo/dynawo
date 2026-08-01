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
 * @file DYDStaticRef.cpp
 * @brief StaticRef description : implementation file
 *
 */

#include "DYDStaticRef.h"

namespace dynamicdata {

StaticRef::StaticRef(const std::string& modelVar, const std::string& staticVar) : modelVar_(modelVar), staticVar_(staticVar) {}

void
StaticRef::setModelVar(const std::string& modelVar) {
  modelVar_ = modelVar;
}

void
StaticRef::setStaticVar(const std::string& staticVar) {
  staticVar_ = staticVar;
}

const std::string&
StaticRef::getModelVar() const {
  return modelVar_;
}

const std::string&
StaticRef::getStaticVar() const {
  return staticVar_;
}

}  // namespace dynamicdata
