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
#include "DYNVscConverterInterfaceIIDM.h"
#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNInjectorInterfaceIIDM.h"

using boost::shared_ptr;
using boost::dynamic_pointer_cast;
using std::string;
using std::vector;

namespace DYN {

HvdcLineInterfaceIIDM::HvdcLineInterfaceIIDM(IIDM::HvdcLine& hvdcLine,
                                             const shared_ptr<ConverterInterface>& conv1,
                                             const shared_ptr<ConverterInterface>& conv2) :
hvdcLineIIDM_(hvdcLine),
conv1_(conv1),
conv2_(conv2) {
  setType(ComponentInterface::HVDC_LINE);
  stateVariables_.resize(6);
  stateVariables_[VAR_P1] = StateVariable("p1", StateVariable::DOUBLE);  // P1
  stateVariables_[VAR_P2] = StateVariable("p2", StateVariable::DOUBLE);  // P2
  stateVariables_[VAR_Q1] = StateVariable("q1", StateVariable::DOUBLE);  // Q1
  stateVariables_[VAR_Q2] = StateVariable("q2", StateVariable::DOUBLE);  // Q2
  stateVariables_[VAR_STATE1] = StateVariable("state1", StateVariable::INT);   // connectionState1
  stateVariables_[VAR_STATE2] = StateVariable("state2", StateVariable::INT);   // connectionState2
}

HvdcLineInterfaceIIDM::~HvdcLineInterfaceIIDM() {
}

void
HvdcLineInterfaceIIDM::exportStateVariablesUnitComponent() {
  switch (conv1_->getType()) {
    case ComponentInterface::VSC_CONVERTER:
      {
      shared_ptr<VscConverterInterfaceIIDM>& vsc1 = dynamic_pointer_cast<VscConverterInterfaceIIDM>(conv1_);
      shared_ptr<VscConverterInterfaceIIDM>& vsc2 = dynamic_pointer_cast<VscConverterInterfaceIIDM>(conv2_);
      // je pense que j'aimerais écrire un truc comme ça pour les puissances (et pour les states j'avoue que je ne sais pas trop encore)
      (vsc1->getVscIIDM()).p(-1 * getValue<double>(VAR_P1) * SNREF);
      (vsc1->getVscIIDM()).q(-1 * getValue<double>(VAR_Q1) * SNREF);
      (vsc2->getVscIIDM()).p(-1 * getValue<double>(VAR_P2) * SNREF);
      (vsc2->getVscIIDM()).q(-1 * getValue<double>(VAR_Q2) * SNREF);
      break;
      }
    case ComponentInterface::LCC_CONVERTER:
      {
      shared_ptr<LccConverterInterfaceIIDM>& lcc1 = dynamic_pointer_cast<LccConverterInterfaceIIDM>(conv1_);
      shared_ptr<LccConverterInterfaceIIDM>& lcc2 = dynamic_pointer_cast<LccConverterInterfaceIIDM>(conv2_);
      (lcc1->getLccIIDM()).p(-1 * getValue<double>(VAR_P1) * SNREF);
      (lcc1->getLccIIDM()).q(-1 * getValue<double>(VAR_Q1) * SNREF);
      (lcc2->getLccIIDM()).p(-1 * getValue<double>(VAR_P2) * SNREF);
      (lcc2->getLccIIDM()).q(-1 * getValue<double>(VAR_Q2) * SNREF);
      break;
      }
  }
}

void
HvdcLineInterfaceIIDM::importStaticParameters() {
  // to do
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
HvdcLineInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if ( varName == "p1" )
    index = VAR_P1;
  else if ( varName == "q1" )
    index = VAR_Q1;
  else if ( varName == "p2" )
    index = VAR_P2;
  else if ( varName == "q2" )
    index = VAR_Q2;
  else if ( varName == "state1" )
    index = VAR_STATE1;
  else if ( varName == "state2" )
    index = VAR_STATE2;
  return index;
}

const shared_ptr<ConverterInterface>&
HvdcLineInterfaceIIDM::getConverter1() const {
  return conv1_;
}

const shared_ptr<ConverterInterface>&
HvdcLineInterfaceIIDM::getConverter2() const {
  return conv2_;
}

}  // namespace DYN
