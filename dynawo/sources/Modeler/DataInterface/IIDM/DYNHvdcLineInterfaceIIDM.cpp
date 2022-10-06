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
  switch (conv1_->getConverterType()) {
    case ConverterInterface::VSC_CONVERTER:
      {
      shared_ptr<VscConverterInterfaceIIDM> vsc1 = dynamic_pointer_cast<VscConverterInterfaceIIDM>(conv1_);
      shared_ptr<VscConverterInterfaceIIDM> vsc2 = dynamic_pointer_cast<VscConverterInterfaceIIDM>(conv2_);
      (vsc1->getVscIIDM()).p(-1 * getValue<double>(VAR_P1) * SNREF);
      (vsc1->getVscIIDM()).q(-1 * getValue<double>(VAR_Q1) * SNREF);
      (vsc2->getVscIIDM()).p(-1 * getValue<double>(VAR_P2) * SNREF);
      (vsc2->getVscIIDM()).q(-1 * getValue<double>(VAR_Q2) * SNREF);
      bool connected1 = (getValue<int>(VAR_STATE1) == CLOSED);
      bool connected2 = (getValue<int>(VAR_STATE2) == CLOSED);

      if ((vsc1->getVscIIDM()).has_connection()) {
        if ((vsc1->getVscIIDM()).connectionPoint()->is_bus()) {
          if (connected1)
            (vsc1->getVscIIDM()).connect();
          else
            (vsc1->getVscIIDM()).disconnect();
        } else  {  // is node()
          // should be removed once a solution has been found to propagate switches (de)connection
          // following component (de)connection (only Modelica models)
          if (connected1 && !(vsc1->getInitialConnected()))
            vsc1->getVoltageLevelInterface()->connectNode((vsc1->getVscIIDM()).node());
          else if (!connected1 && vsc1->getInitialConnected())
            vsc1->getVoltageLevelInterface()->disconnectNode((vsc1->getVscIIDM()).node());
        }
      }
      if ((vsc2->getVscIIDM()).has_connection()) {
        if ((vsc2->getVscIIDM()).connectionPoint()->is_bus()) {
          if (connected2)
            (vsc2->getVscIIDM()).connect();
          else
            (vsc2->getVscIIDM()).disconnect();
        } else  {  // is node()
          // should be removed once a solution has been found to propagate switches (de)connection
          // following component (de)connection (only Modelica models)
          if (connected2 && !(vsc2->getInitialConnected()))
            vsc2->getVoltageLevelInterface()->connectNode((vsc2->getVscIIDM()).node());
          else if (!connected2 && vsc2->getInitialConnected())
            vsc2->getVoltageLevelInterface()->disconnectNode((vsc2->getVscIIDM()).node());
        }
      }
      break;
      }
    case ConverterInterface::LCC_CONVERTER:
      {
      shared_ptr<LccConverterInterfaceIIDM> lcc1 = dynamic_pointer_cast<LccConverterInterfaceIIDM>(conv1_);
      shared_ptr<LccConverterInterfaceIIDM> lcc2 = dynamic_pointer_cast<LccConverterInterfaceIIDM>(conv2_);
      (lcc1->getLccIIDM()).p(-1 * getValue<double>(VAR_P1) * SNREF);
      (lcc1->getLccIIDM()).q(-1 * getValue<double>(VAR_Q1) * SNREF);
      (lcc2->getLccIIDM()).p(-1 * getValue<double>(VAR_P2) * SNREF);
      (lcc2->getLccIIDM()).q(-1 * getValue<double>(VAR_Q2) * SNREF);
      bool connected1 = (getValue<int>(VAR_STATE1) == CLOSED);
      bool connected2 = (getValue<int>(VAR_STATE2) == CLOSED);

      if ((lcc1->getLccIIDM()).has_connection()) {
        if ((lcc1->getLccIIDM()).connectionPoint()->is_bus()) {
          if (connected1)
            (lcc1->getLccIIDM()).connect();
          else
            (lcc1->getLccIIDM()).disconnect();
        } else  {  // is node()
          // should be removed once a solution has been found to propagate switches (de)connection
          // following component (de)connection (only Modelica models)
          if (connected1 && !(lcc1->getInitialConnected()))
            lcc1->getVoltageLevelInterface()->connectNode((lcc1->getLccIIDM()).node());
          else if (!connected1 && lcc1->getInitialConnected())
            lcc1->getVoltageLevelInterface()->disconnectNode((lcc1->getLccIIDM()).node());
        }
      }
      if ((lcc2->getLccIIDM()).has_connection()) {
        if ((lcc2->getLccIIDM()).connectionPoint()->is_bus()) {
          if (connected2)
            (lcc2->getLccIIDM()).connect();
          else
            (lcc2->getLccIIDM()).disconnect();
        } else  {  // is node()
          // should be removed once a solution has been found to propagate switches (de)connection
          // following component (de)connection (only Modelica models)
          if (connected2 && !(lcc2->getInitialConnected()))
            lcc2->getVoltageLevelInterface()->connectNode((lcc2->getLccIIDM()).node());
          else if (!connected2 && lcc2->getInitialConnected())
            lcc2->getVoltageLevelInterface()->disconnectNode((lcc2->getLccIIDM()).node());
        }
      }
      break;
      }
  }
}

void
HvdcLineInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("pMax", StaticParameter("pMax", StaticParameter::DOUBLE).setValue(getPmax())));
  staticParameters_.insert(std::make_pair("pMax_pu", StaticParameter("pMax_pu", StaticParameter::DOUBLE).setValue(getPmax() / SNREF)));
  staticParameters_.insert(std::make_pair("p1_pu", StaticParameter("p1_pu", StaticParameter::DOUBLE).setValue(conv1_->getP() / SNREF)));
  staticParameters_.insert(std::make_pair("q1_pu", StaticParameter("q1_pu", StaticParameter::DOUBLE).setValue(conv1_->getQ() / SNREF)));
  staticParameters_.insert(std::make_pair("p1", StaticParameter("p1", StaticParameter::DOUBLE).setValue(conv1_->getP())));
  staticParameters_.insert(std::make_pair("q1", StaticParameter("q1", StaticParameter::DOUBLE).setValue(conv1_->getQ())));
  staticParameters_.insert(std::make_pair("p2_pu", StaticParameter("p2_pu", StaticParameter::DOUBLE).setValue(conv2_->getP() / SNREF)));
  staticParameters_.insert(std::make_pair("q2_pu", StaticParameter("q2_pu", StaticParameter::DOUBLE).setValue(conv2_->getQ() / SNREF)));
  staticParameters_.insert(std::make_pair("p2", StaticParameter("p2", StaticParameter::DOUBLE).setValue(conv2_->getP())));
  staticParameters_.insert(std::make_pair("q2", StaticParameter("q2", StaticParameter::DOUBLE).setValue(conv2_->getQ())));
  if (conv1_->getBusInterface()) {
    double U10 = conv1_->getBusInterface()->getV0();
    double U1Nom = conv1_->getVNom();
    double theta1 = conv1_->getBusInterface()->getAngle0();
    staticParameters_.insert(std::make_pair("v1", StaticParameter("v1", StaticParameter::DOUBLE).setValue(U10)));
    staticParameters_.insert(std::make_pair("angle1", StaticParameter("angle1", StaticParameter::DOUBLE).setValue(theta1)));
    staticParameters_.insert(std::make_pair("v1_pu", StaticParameter("v1_pu", StaticParameter::DOUBLE).setValue(U10 / U1Nom)));
    staticParameters_.insert(std::make_pair("angle1_pu", StaticParameter("angle1_pu", StaticParameter::DOUBLE).setValue(theta1 * M_PI / 180)));
  } else {
    staticParameters_.insert(std::make_pair("v1", StaticParameter("v1", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle1", StaticParameter("angle1", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v1_pu", StaticParameter("v1_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle1_pu", StaticParameter("angle1_pu", StaticParameter::DOUBLE).setValue(0.)));
  }
  if (conv2_->getBusInterface()) {
    double U20 = conv2_->getBusInterface()->getV0();
    double U2Nom = conv2_->getVNom();
    double theta2 = conv2_->getBusInterface()->getAngle0();
    staticParameters_.insert(std::make_pair("v2", StaticParameter("v2", StaticParameter::DOUBLE).setValue(U20)));
    staticParameters_.insert(std::make_pair("angle2", StaticParameter("angle2", StaticParameter::DOUBLE).setValue(theta2)));
    staticParameters_.insert(std::make_pair("v2_pu", StaticParameter("v2_pu", StaticParameter::DOUBLE).setValue(U20 / U2Nom)));
    staticParameters_.insert(std::make_pair("angle2_pu", StaticParameter("angle2_pu", StaticParameter::DOUBLE).setValue(theta2 * M_PI / 180)));

  } else {
    staticParameters_.insert(std::make_pair("v2", StaticParameter("v2", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle2", StaticParameter("angle2", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v2_pu", StaticParameter("v2_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle2_pu", StaticParameter("angle2_pu", StaticParameter::DOUBLE).setValue(0.)));
  }
}

bool
HvdcLineInterfaceIIDM::isConnected() const {
  return conv1_->isConnected() && conv2_->isConnected();
}

bool
HvdcLineInterfaceIIDM::isPartiallyConnected() const {
  return conv1_->isConnected() || conv2_->isConnected();
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
