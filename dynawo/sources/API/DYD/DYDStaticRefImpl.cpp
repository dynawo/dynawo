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
 * @file DYDStaticRefImpl.cpp
 * @brief StaticRef description : implementation file
 *
 */

#include "DYDStaticRefImpl.h"

namespace dynamicdata {

StaticRef::Impl::Impl(const std::string& modelVar, const std::string& staticVar) :
modelVar_(modelVar),
staticVar_(staticVar) {
}

StaticRef::Impl::~Impl() {
}

void
StaticRef::Impl::setModelVar(const std::string& modelVar) {
  modelVar_ = modelVar;
}

void
StaticRef::Impl::setStaticVar(const std::string& staticVar) {
  staticVar_ = staticVar;
}

std::string
StaticRef::Impl::getModelVar() const {
  return modelVar_;
}

std::string
StaticRef::Impl::getStaticVar() const {
  return staticVar_;
}


}  // namespace dynamicdata
