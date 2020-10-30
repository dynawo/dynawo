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
 * @file  DYNVoltageLevelInterfaceIIDM.cpp
 *
 * @brief VoltageLevel data interface  : implementation file for IIDM interface
 *
 */
#include "DYNVoltageLevelInterfaceIIDM.h"
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

#include <powsybl/iidm/TopologyKind.hpp>

#include <vector>
#include <string>

using boost::shared_ptr;
using std::string;
using std::vector;

namespace DYN {

VoltageLevelInterfaceIIDM::VoltageLevelInterfaceIIDM(powsybl::iidm::VoltageLevel& voltageLevel) :
voltageLevelIIDM_(voltageLevel) {
  isNodeBreakerTopology_ = (voltageLevelIIDM_.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER);
}

VoltageLevelInterfaceIIDM::~VoltageLevelInterfaceIIDM() {
}

string
VoltageLevelInterfaceIIDM::getID() const {
  return voltageLevelIIDM_.getId();
}

double
VoltageLevelInterfaceIIDM::getVNom() const {
  return voltageLevelIIDM_.getNominalVoltage();
}

VoltageLevelInterface::VoltageLevelTopologyKind_t
VoltageLevelInterfaceIIDM::getVoltageLevelTopologyKind() const {
  return isNodeBreakerTopology_?VoltageLevelInterface::NODE_BREAKER:VoltageLevelInterface::BUS_BREAKER;
}

void
VoltageLevelInterfaceIIDM::addSwitch(const shared_ptr<SwitchInterface>& sw) {
  switches_.push_back(sw);
}

void
VoltageLevelInterfaceIIDM::addBus(const shared_ptr<BusInterface>& bus) {
  buses_.push_back(bus);
}

void
VoltageLevelInterfaceIIDM::addGenerator(const shared_ptr<GeneratorInterface>& generator) {
  generators_.push_back(generator);
}

void
VoltageLevelInterfaceIIDM::addLoad(const shared_ptr<LoadInterface>& load) {
  loads_.push_back(load);
}

void
VoltageLevelInterfaceIIDM::addShuntCompensator(const shared_ptr<ShuntCompensatorInterface>& shunt) {
  shunts_.push_back(shunt);
}

void
VoltageLevelInterfaceIIDM::addDanglingLine(const shared_ptr<DanglingLineInterface>& line) {
  danglingLines_.push_back(line);
}

void
VoltageLevelInterfaceIIDM::addStaticVarCompensator(const shared_ptr<StaticVarCompensatorInterface>& svc) {
  staticVarCompensators_.push_back(svc);
}

void
VoltageLevelInterfaceIIDM::addVscConverter(const shared_ptr<VscConverterInterface>& vsc) {
  vscConverters_.push_back(vsc);
}

void
VoltageLevelInterfaceIIDM::addLccConverter(const shared_ptr<LccConverterInterface>& lcc) {
  lccConverters_.push_back(lcc);
}

const vector< shared_ptr<BusInterface> >&
VoltageLevelInterfaceIIDM::getBuses() const {
  return buses_;
}

const vector< shared_ptr<SwitchInterface> >&
VoltageLevelInterfaceIIDM::getSwitches() const {
  return switches_;
}

const vector< shared_ptr<LoadInterface> >&
VoltageLevelInterfaceIIDM::getLoads() const {
  return loads_;
}

const vector< shared_ptr<ShuntCompensatorInterface> >&
VoltageLevelInterfaceIIDM::getShuntCompensators() const {
  return shunts_;
}

const vector< shared_ptr<StaticVarCompensatorInterface> >&
VoltageLevelInterfaceIIDM::getStaticVarCompensators() const {
  return staticVarCompensators_;
}

const vector< shared_ptr<GeneratorInterface> >&
VoltageLevelInterfaceIIDM::getGenerators() const {
  return generators_;
}

const vector< shared_ptr<DanglingLineInterface> >&
VoltageLevelInterfaceIIDM::getDanglingLines() const {
  return danglingLines_;
}

const vector< shared_ptr<VscConverterInterface> >&
VoltageLevelInterfaceIIDM::getVscConverters() const {
  return vscConverters_;
}

const vector< shared_ptr<LccConverterInterface> >&
VoltageLevelInterfaceIIDM::getLccConverters() const {
  return lccConverters_;
}

void
VoltageLevelInterfaceIIDM::mapConnections() {
  vector<shared_ptr<LoadInterface> >::const_iterator iLoad;
  for (iLoad = loads_.begin(); iLoad != loads_.end(); ++iLoad) {
    if ((*iLoad)->hasDynamicModel()) {
      (*iLoad)->getBusInterface()->hasConnection(true);
    }
  }

  vector<shared_ptr<SwitchInterface> >::const_iterator iSwitch;
  for (iSwitch = switches_.begin(); iSwitch != switches_.end(); ++iSwitch) {
    if ((*iSwitch)->hasDynamicModel()) {
      (*iSwitch)->getBusInterface1()->hasConnection(true);
      (*iSwitch)->getBusInterface2()->hasConnection(true);
    }
  }

  vector<shared_ptr<ShuntCompensatorInterface> >::const_iterator iShunt;
  for (iShunt = shunts_.begin(); iShunt != shunts_.end(); ++iShunt) {
    if ((*iShunt)->hasDynamicModel()) {
      (*iShunt)->getBusInterface()->hasConnection(true);
    }
  }

  vector<shared_ptr<StaticVarCompensatorInterface> >::const_iterator iSvc;
  for (iSvc = staticVarCompensators_.begin(); iSvc != staticVarCompensators_.end(); ++iSvc) {
    if ((*iSvc)->hasDynamicModel()) {
      (*iSvc)->getBusInterface()->hasConnection(true);
    }
  }

  vector<shared_ptr<GeneratorInterface> >::const_iterator iGen;
  for (iGen = generators_.begin(); iGen != generators_.end(); ++iGen) {
    if ((*iGen)->hasDynamicModel()) {
      (*iGen)->getBusInterface()->hasConnection(true);
    }
  }

  vector<shared_ptr<DanglingLineInterface> >::const_iterator iDangling;
  for (iDangling = danglingLines_.begin(); iDangling != danglingLines_.end(); ++iDangling) {
    if ((*iDangling)->hasDynamicModel()) {
      (*iDangling)->getBusInterface()->hasConnection(true);
    }
  }

  vector<shared_ptr<VscConverterInterface> >::const_iterator iVsc;
  for (iVsc = vscConverters_.begin(); iVsc != vscConverters_.end(); ++iVsc) {
    if ((*iVsc)->hasDynamicModel()) {
      (*iVsc)->getBusInterface()->hasConnection(true);
    }
  }

  vector<shared_ptr<LccConverterInterface> >::const_iterator iLcc;
  for (iLcc = lccConverters_.begin(); iLcc != lccConverters_.end(); ++iLcc) {
    if ((*iLcc)->hasDynamicModel()) {
      (*iLcc)->getBusInterface()->hasConnection(true);
    }
  }
}

}  // namespace DYN
