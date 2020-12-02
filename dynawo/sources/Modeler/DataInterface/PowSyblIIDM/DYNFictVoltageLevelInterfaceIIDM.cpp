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
 * @brief VoltageLevel data interface  : implementation file for IIDM interface
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

#include <powsybl/iidm/TopologyKind.hpp>
#include <powsybl/iidm/SwitchKind.hpp>
#include <powsybl/iidm/BusbarSection.hpp>
#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Switch.hpp>

#include <vector>
#include <string>

using boost::shared_ptr;
using std::string;
using std::vector;
using std::pair;
using std::map;
using std::set;
using std::list;
using std::stringstream;

namespace DYN {
FictVoltageLevelInterfaceIIDM::FictVoltageLevelInterfaceIIDM(const std::string& Id, const double& VNom, const string& country) {
    Id_ = Id;
    isNodeBreakerTopology_ = false;
    VNom_ = VNom;
    country_ = country;
}

FictVoltageLevelInterfaceIIDM::~FictVoltageLevelInterfaceIIDM() {
}

std::string
FictVoltageLevelInterfaceIIDM::getID() const {
    return Id_;
}

double
FictVoltageLevelInterfaceIIDM::getVNom() const {
    return VNom_;
}

void
FictVoltageLevelInterfaceIIDM::addBus(const boost::shared_ptr<BusInterface>& bus) {
    buses_.push_back(bus);
}

const vector< shared_ptr<BusInterface> >&
FictVoltageLevelInterfaceIIDM::getBuses() const {
    return buses_;
}

}  // namespace DYN
