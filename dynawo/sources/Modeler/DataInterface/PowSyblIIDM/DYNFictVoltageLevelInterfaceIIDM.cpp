//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  DYNFictVoltageLevelInterfaceIIDM.cpp
 *
 * @brief Fictitious Voltage Level : implementation file to create VoltageLevel from scratch
 *
 */
#include "DYNFictVoltageLevelInterfaceIIDM.h"
#include "DYNSwitchInterface.h"
#include "DYNLoadInterface.h"
#include "DYNBusInterface.h"
#include "DYNDanglingLineInterface.h"
#include "DYNVscConverterInterface.h"
#include "DYNShuntCompensatorInterface.h"
#include "DYNStaticVarCompensatorInterface.h"
#include "DYNGeneratorInterface.h"
#include "DYNLccConverterInterface.h"
#include "DYNModelConstants.h"
#include "DYNTrace.h"

#include <vector>
#include <string>

using boost::shared_ptr;
using std::string;
using std::vector;
using std::pair;
using std::map;
using std::set;
using std::list;

namespace DYN {
FictVoltageLevelInterfaceIIDM::FictVoltageLevelInterfaceIIDM(const std::string& Id, const double& VNom, const string& country) :
                                                            Id_(Id), VNom_(VNom), country_(country) {
}

std::string
FictVoltageLevelInterfaceIIDM::getID() const {
    return Id_;
}

double
FictVoltageLevelInterfaceIIDM::getVNom() const {
    return VNom_;
}

VoltageLevelInterface::VoltageLevelTopologyKind_t
FictVoltageLevelInterfaceIIDM::getVoltageLevelTopologyKind() const {
  return VoltageLevelInterface::BUS_BREAKER;
}

void
FictVoltageLevelInterfaceIIDM::connectNode(const unsigned int& /*node*/) {
  /* not needed */
}

void
FictVoltageLevelInterfaceIIDM::disconnectNode(const unsigned int& /*node*/) {
  /* not needed */
}

bool
FictVoltageLevelInterfaceIIDM::isNodeConnected(const unsigned int& /*node*/) {
    static bool b(false);
    return b;
}

void
FictVoltageLevelInterfaceIIDM::addSwitch(const boost::shared_ptr<SwitchInterface>& /*sw*/) {
  /* not needed */
}

void
FictVoltageLevelInterfaceIIDM::addBus(const boost::shared_ptr<BusInterface>& bus) {
    buses_.push_back(bus);
}

void
FictVoltageLevelInterfaceIIDM::addGenerator(const boost::shared_ptr<GeneratorInterface>& /*generator*/) {
  /* not needed */
}

void
FictVoltageLevelInterfaceIIDM::addLoad(const boost::shared_ptr<LoadInterface>& /*load*/) {
  /* not needed */
}

void
FictVoltageLevelInterfaceIIDM::addShuntCompensator(const boost::shared_ptr<ShuntCompensatorInterface>& /*shunt*/) {
  /* not needed */
}

void
FictVoltageLevelInterfaceIIDM::addDanglingLine(const boost::shared_ptr<DanglingLineInterface>& /*danglingLine*/) {
  /* not needed */
}

void
FictVoltageLevelInterfaceIIDM::addStaticVarCompensator(const boost::shared_ptr<StaticVarCompensatorInterface>& /*svc*/) {
  /* not needed */
}

void
FictVoltageLevelInterfaceIIDM::addVscConverter(const boost::shared_ptr<VscConverterInterface>& /*vsc*/) {
  /* not needed */
}

void
FictVoltageLevelInterfaceIIDM::addLccConverter(const boost::shared_ptr<LccConverterInterface>& /*lcc*/) {
  /* not needed */
}

const vector< shared_ptr<BusInterface> >&
FictVoltageLevelInterfaceIIDM::getBuses() const {
    return buses_;
}

}  // namespace DYN
