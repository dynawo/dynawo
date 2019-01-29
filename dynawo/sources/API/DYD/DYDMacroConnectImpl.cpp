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
 * @file DYDMacroConnectImpl.cpp
 * @brief MacroConnect description : implementation file
 *
 */

#include "DYDMacroConnectImpl.h"
using std::string;

namespace dynamicdata {

MacroConnect::Impl::Impl(const string& connector, const string& model1, const string& model2) :
connectorId_(connector),
firstModelId_(model1),
secondModelId_(model2),
index1_(""),
index2_(""),
name1_(""),
name2_("") {
}

MacroConnect::Impl::~Impl() {
}

string
MacroConnect::Impl::getConnector() const {
  return connectorId_;
}

string
MacroConnect::Impl::getFirstModelId() const {
  return firstModelId_;
}

string
MacroConnect::Impl::getSecondModelId() const {
  return secondModelId_;
}

void
MacroConnect::Impl::setIndex1(const std::string& index1) {
  index1_ = index1;
}

void
MacroConnect::Impl::setIndex2(const std::string& index2) {
  index2_ = index2;
}

void
MacroConnect::Impl::setName1(const std::string& name1) {
  name1_ = name1;
}

void
MacroConnect::Impl::setName2(const std::string& name2) {
  name2_ = name2;
}

string
MacroConnect::Impl::getIndex1() const {
  return index1_;
}

string
MacroConnect::Impl::getIndex2() const {
  return index2_;
}

string
MacroConnect::Impl::getName1() const {
  return name1_;
}

string
MacroConnect::Impl::getName2() const {
  return name2_;
}

}  // namespace dynamicdata
