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

//======================================================================
/**
 * @file  DYNHvdcLineInterfaceIIDM.cpp
 *
 * @brief Hvdc Line data interface : implementation file for IIDM interface
 *
 */
//======================================================================
#include <IIDM/components/HvdcLine.h>
#include <IIDM/BasicTypes.h>

#include "DYNHvdcLineInterfaceIIDM.h"
#include "DYNModelConstants.h"

using boost::shared_ptr;
using std::string;
using std::vector;

namespace DYN {

HvdcLineInterfaceIIDM::HvdcLineInterfaceIIDM(IIDM::HvdcLine& hvdcLine) :
hvdcLineIIDM_(hvdcLine) {
  setType(ComponentInterface::HVDC_LINE);
}

HvdcLineInterfaceIIDM::~HvdcLineInterfaceIIDM() {
}

void
HvdcLineInterfaceIIDM::exportStateVariablesUnitComponent() {
  // no state variable
}

void
HvdcLineInterfaceIIDM::importStaticParameters() {
  // no static parameter
}

string
HvdcLineInterfaceIIDM::getID() const {
  return hvdcLineIIDM_.id();
}

double
HvdcLineInterfaceIIDM::getResistanceDC() const {
  return hvdcLineIIDM_.r();
}

double
HvdcLineInterfaceIIDM::getVNom() const {
  return hvdcLineIIDM_.nominalV();
}

double
HvdcLineInterfaceIIDM::getActivePowerSetpoint() const {
  return hvdcLineIIDM_.activePowerSetpoint();
}

double
HvdcLineInterfaceIIDM::getPmax() const {
  return hvdcLineIIDM_.maxP();
}

HvdcLineInterfaceIIDM::ConverterMode_t
HvdcLineInterfaceIIDM::getConverterMode() const {
  IIDM::HvdcLine::mode_enum convMode = hvdcLineIIDM_.convertersMode();
  switch (convMode) {
    case IIDM::HvdcLine::mode_RectifierInverter:
      return HvdcLineInterface::RECTIFIER_INVERTER;
    case IIDM::HvdcLine::mode_InverterRectifier:
      return HvdcLineInterface::INVERTER_RECTIFIER;
    default:
      throw DYNError(Error::MODELER, ConvertersModeError, getID());
  }
}

string
HvdcLineInterfaceIIDM::getIdConverter1() const {
  return hvdcLineIIDM_.converterStation1();
}

string
HvdcLineInterfaceIIDM::getIdConverter2() const {
  return hvdcLineIIDM_.converterStation2();
}

int
HvdcLineInterfaceIIDM::getComponentVarIndex(const std::string& /*varName*/) const {
  return -1;
}

}  // namespace DYN
