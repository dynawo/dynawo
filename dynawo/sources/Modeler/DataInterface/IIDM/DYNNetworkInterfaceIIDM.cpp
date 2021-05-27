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
 * @file  DYNNetworkInterfaceIIDM.cpp
 *
 * @brief Network data interface : implementation file for IIDM implementation
 *
 */
#include <IIDM/Network.h>

#include "DYNNetworkInterfaceIIDM.h"
#include "DYNLineInterface.h"
#include "DYNTwoWTransformerInterface.h"
#include "DYNThreeWTransformerInterface.h"
#include "DYNVoltageLevelInterface.h"
#include "DYNHvdcLineInterface.h"

using std::string;
using std::vector;
using boost::shared_ptr;

namespace DYN {

NetworkInterfaceIIDM::NetworkInterfaceIIDM(IIDM::Network& network) :
networkIIDM_(network) {
}

NetworkInterfaceIIDM::~NetworkInterfaceIIDM() {
}

void
NetworkInterfaceIIDM::addLine(const shared_ptr<LineInterface>& line) {
  lines_.push_back(line);
}

void
NetworkInterfaceIIDM::addTwoWTransformer(const shared_ptr<TwoWTransformerInterface>& tfo) {
  twoWTransformers_.push_back(tfo);
}

void
NetworkInterfaceIIDM::addThreeWTransformer(const shared_ptr<ThreeWTransformerInterface>& tfo) {
  threeWTransformers_.push_back(tfo);
}

void
NetworkInterfaceIIDM::addVoltageLevel(const shared_ptr<VoltageLevelInterface>& voltageLevel) {
  voltageLevels_.push_back(voltageLevel);
}

void
NetworkInterfaceIIDM::addHvdcLine(const shared_ptr<HvdcLineInterface>& hvdc) {
  hvdcs_.push_back(hvdc);
}

const vector<shared_ptr<LineInterface> >&
NetworkInterfaceIIDM::getLines() const {
  return lines_;
}

const vector<shared_ptr<TwoWTransformerInterface> >&
NetworkInterfaceIIDM::getTwoWTransformers() const {
  return twoWTransformers_;
}

const vector<shared_ptr<ThreeWTransformerInterface> >&
NetworkInterfaceIIDM::getThreeWTransformers() const {
  return threeWTransformers_;
}

const vector<shared_ptr<VoltageLevelInterface> >&
NetworkInterfaceIIDM::getVoltageLevels() const {
  return voltageLevels_;
}

const vector<shared_ptr<HvdcLineInterface> >&
NetworkInterfaceIIDM::getHvdcLines() const {
  return hvdcs_;
}

}  // namespace DYN
