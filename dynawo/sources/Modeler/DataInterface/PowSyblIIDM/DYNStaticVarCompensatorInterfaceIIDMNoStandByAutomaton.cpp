//
// Copyright (c) 2020, RTE (http://www.rte-france.com)
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

//======================================================================
/**
 * @file  DYNStaticVarCompensatorInterfaceIIDMNoStandByAutomaton.cpp
 *
 * @brief Static Var Compensator data interface extension with no stand by automaton
 *
 */
//======================================================================

#include "DYNStaticVarCompensatorInterfaceIIDMNoStandByAutomaton.h"

extern "C" DYN::StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton*
createStaticVarCompensatorInterfaceIIDMExtension(powsybl::iidm::StaticVarCompensator& svc) {
  return (new DYN::StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton(svc));
}

extern "C" void
destroyStaticVarCompensatorInterfaceIIDMExtension(DYN::StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton* p) {
  delete p;
}

namespace DYN {

StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton::~StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton() {
}

StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton::
StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton(powsybl::iidm::StaticVarCompensator& svc) :
  staticVarCompensatorIIDM_(svc) {
}
void StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton::exportStandByMode(bool /*standByMode*/) {
  // not needed
}

double
StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton::getUMinActivation() const {
  return 0.;
}

double
StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton::getUMaxActivation() const {
  return 0.;
}

double
StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton::getUSetPointMin() const {
  return 0.;
}

double
StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton::getUSetPointMax() const {
  return 0.;
}

bool
StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton::hasStandbyAutomaton() const {
  return false;
}

bool
StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton::isStandBy() const {
  return false;
}

double
StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton::getB0() const {
  return 0.;
}

}  // namespace DYN
