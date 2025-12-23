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
 * @file DYDMacroConnect.cpp
 * @brief MacroConnect description : implementation file
 *
 */

#include "DYDMacroConnect.h"
using std::string;

namespace dynamicdata {

MacroConnect::MacroConnect(const string& connector, const string& model1, const string& model2) :
    connectorId_(connector),
    firstModelId_(model1),
    secondModelId_(model2),
    index1_(""),
    index2_(""),
    name1_(""),
    name2_("") {}

const string&
MacroConnect::getConnector() const {
  return connectorId_;
}

const string&
MacroConnect::getFirstModelId() const {
  return firstModelId_;
}

const string&
MacroConnect::getSecondModelId() const {
  return secondModelId_;
}

void
MacroConnect::setIndex1(const std::string& index1) {
  index1_ = index1;
}

void
MacroConnect::setIndex2(const std::string& index2) {
  index2_ = index2;
}

void
MacroConnect::setName1(const std::string& name1) {
  name1_ = name1;
}

void
MacroConnect::setName2(const std::string& name2) {
  name2_ = name2;
}

void
MacroConnect::setComponentId(const std::string& componentId) {
  componentId_ = componentId;
}

const string&
MacroConnect::getIndex1() const {
  return index1_;
}

const string&
MacroConnect::getIndex2() const {
  return index2_;
}

const string&
MacroConnect::getName1() const {
  return name1_;
}

const string&
MacroConnect::getName2() const {
  return name2_;
}

const string&
MacroConnect::getComponentId() const {
  return componentId_;
}

}  // namespace dynamicdata
