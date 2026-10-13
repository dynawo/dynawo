// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.

/** @file  DYNModelBusBridged.cpp */

#include "DYNModelBusBridged.h"
#include "DYNBusInterface.h"
#include "DYNModelNetwork.h"
#include "DYNCommonModeler.h"

namespace DYN {
using std::string;

void
ModelBusBridged::defineElementsById(const std::string& id, std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  ModelBus::defineElementsById(id, elements, mapElement);
  addElement(id + "_state",      Element::OVERRIDEN, elements, mapElement);
  addElement(id + "_ACPIN",      Element::OVERRIDEN, elements, mapElement);
  addElement(id + "_ACPIN_V",    Element::OVERRIDEN, elements, mapElement);
  addElement(id + "_ACPIN_V_re", Element::OVERRIDEN, elements, mapElement);
  addElement(id + "_ACPIN_V_im", Element::OVERRIDEN, elements, mapElement);
  addElement(id + "_ACPIN_i",    Element::OVERRIDEN, elements, mapElement);
  addElement(id + "_ACPIN_i_re", Element::OVERRIDEN, elements, mapElement);
  addElement(id + "_ACPIN_i_im", Element::OVERRIDEN, elements, mapElement);
  addElement(id + "_U",          Element::OVERRIDEN, elements, mapElement);
  addElement(id + "_Upu",        Element::OVERRIDEN, elements, mapElement);
  addElement(id + "_phi",        Element::OVERRIDEN, elements, mapElement);
  addElement(id + "_phipu",      Element::OVERRIDEN, elements, mapElement);
}

double
ModelBusBridged::ur() const {
  if (!network_->isInit())
    throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "ur() outside of init", id());

  // we would like something along the line of dynModel_->getVariableValue("bus_terminal_V_re") here,
  // however the modelica init has not run yet

  return getSwitchOff() ? 0. : ur0_;
}

double
ModelBusBridged::ui() const {
  if (!network_->isInit())
    throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "ui() outside of init", id());

  return getSwitchOff() ? 0. : ui0_;
}

}  // namespace DYN
