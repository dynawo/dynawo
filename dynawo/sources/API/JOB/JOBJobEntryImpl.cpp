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
 * @file JOBJobEntryImpl.cpp
 * @brief Job entry description : implementation file
 */

#include "JOBJobEntryImpl.h"

namespace job {

JobEntry::Impl::Impl() :
modelerEntry_(),
solverEntry_(),
simulationEntry_(),
outputsEntry_(),
name_("") {
}

JobEntry::Impl::~Impl() {
}

void
JobEntry::Impl::setModelerEntry(const boost::shared_ptr<ModelerEntry> & modelerEntry) {
  modelerEntry_ = modelerEntry;
}

boost::shared_ptr<ModelerEntry>
JobEntry::Impl::getModelerEntry() const {
  return modelerEntry_;
}

void
JobEntry::Impl::setSolverEntry(const boost::shared_ptr<SolverEntry> & solverEntry) {
  solverEntry_ = solverEntry;
}

boost::shared_ptr<SolverEntry>
JobEntry::Impl::getSolverEntry() const {
  return solverEntry_;
}

void
JobEntry::Impl::setSimulationEntry(const boost::shared_ptr<SimulationEntry> & simulationEntry) {
  simulationEntry_ = simulationEntry;
}

boost::shared_ptr<SimulationEntry>
JobEntry::Impl::getSimulationEntry() const {
  return simulationEntry_;
}

void
JobEntry::Impl::setOutputsEntry(const boost::shared_ptr<OutputsEntry> & outputsEntry) {
  outputsEntry_ = outputsEntry;
}

boost::shared_ptr<OutputsEntry>
JobEntry::Impl::getOutputsEntry() const {
  return outputsEntry_;
}

void
JobEntry::Impl::setName(const std::string & name) {
  name_ = name;
}

std::string
JobEntry::Impl::getName() const {
  return name_;
}

}  // namespace job
