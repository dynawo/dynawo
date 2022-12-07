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
 * @file JOBJobEntry.cpp
 * @brief Job entry description : implementation file
 */

#include "JOBJobEntry.h"
#include "DYNClone.hpp"

namespace job {

JobEntry::JobEntry() {}

JobEntry::~JobEntry() {}

JobEntry::JobEntry(const JobEntry& other) :
    modelerEntry_(DYN::clone(other.modelerEntry_)),
    solverEntry_(DYN::clone(other.solverEntry_)),
    simulationEntry_(DYN::clone(other.simulationEntry_)),
    outputsEntry_(DYN::clone(other.outputsEntry_)),
    localInitEntry_(DYN::clone(other.localInitEntry_)),
    name_(other.name_)
{}

JobEntry&
JobEntry::operator=(const JobEntry& other) {
  modelerEntry_ = DYN::clone(other.modelerEntry_);
  solverEntry_ = DYN::clone(other.solverEntry_);
  simulationEntry_ = DYN::clone(other.simulationEntry_);
  outputsEntry_ = DYN::clone(other.outputsEntry_);
  localInitEntry_ = DYN::clone(other.localInitEntry_);
  name_ = other.name_;
  return *this;
}

void
JobEntry::setModelerEntry(const boost::shared_ptr<ModelerEntry> & modelerEntry) {
  modelerEntry_ = modelerEntry;
}

boost::shared_ptr<ModelerEntry>
JobEntry::getModelerEntry() const {
  return modelerEntry_;
}

void
JobEntry::setSolverEntry(const boost::shared_ptr<SolverEntry> & solverEntry) {
  solverEntry_ = solverEntry;
}

boost::shared_ptr<SolverEntry>
JobEntry::getSolverEntry() const {
  return solverEntry_;
}

void
JobEntry::setSimulationEntry(const boost::shared_ptr<SimulationEntry> & simulationEntry) {
  simulationEntry_ = simulationEntry;
}

boost::shared_ptr<SimulationEntry>
JobEntry::getSimulationEntry() const {
  return simulationEntry_;
}

void
JobEntry::setOutputsEntry(const boost::shared_ptr<OutputsEntry> & outputsEntry) {
  outputsEntry_ = outputsEntry;
}

boost::shared_ptr<OutputsEntry>
JobEntry::getOutputsEntry() const {
  return outputsEntry_;
}

void
JobEntry::setLocalInitEntry(const boost::shared_ptr<LocalInitEntry> & localInitEntry) {
  localInitEntry_ = localInitEntry;
}

boost::shared_ptr<LocalInitEntry>
JobEntry::getLocalInitEntry() const {
  return localInitEntry_;
}

void
JobEntry::setName(const std::string & name) {
  name_ = name;
}

const std::string&
JobEntry::getName() const {
  return name_;
}

}  // namespace job
