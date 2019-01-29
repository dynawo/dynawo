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
 * @file DYDConnectorImpl.cpp
 * @brief Connector description : implementation file
 *
 */

#include "DYDConnectorImpl.h"
#include "DYDModel.h"

using std::string;

using boost::shared_ptr;

namespace dynamicdata {

Connector::Impl::Impl(const string& model1, const string& var1,
        const string& model2, const string& var2) :
firstModelId_(model1),
firstVariableId_(var1),
secondModelId_(model2),
secondVariableId_(var2) {
}

Connector::Impl::~Impl() {
}

string
Connector::Impl::getFirstVariableId() const {
  return firstVariableId_;
}

string
Connector::Impl::getSecondVariableId() const {
  return secondVariableId_;
}

string
Connector::Impl::getFirstModelId() const {
  return firstModelId_;
}

string
Connector::Impl::getSecondModelId() const {
  return secondModelId_;
}


}  // namespace dynamicdata
