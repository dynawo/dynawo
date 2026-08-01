//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
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

#include "DYNCommon.h"

#include "DYNHvdcLineInterfaceIIDM.h"

#include <powsybl/iidm/HvdcLine.hpp>

#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNModelConstants.h"
#include "DYNVscConverterInterfaceIIDM.h"

#include <string>

using std::dynamic_pointer_cast;
using std::shared_ptr;
using std::string;

namespace DYN {

HvdcLineInterfaceIIDM::HvdcLineInterfaceIIDM(powsybl::iidm::HvdcLine& hvdcLine,
                                             const shared_ptr<ConverterInterface>& conv1,
                                             const shared_ptr<ConverterInterface>& conv2) : hvdcLineIIDM_(hvdcLine),
                                                                                            conv1_(conv1),
                                                                                            conv2_(conv2) {
  setType(ComponentInterface::HVDC_LINE);
  stateVariables_.resize(6);
  stateVariables_[VAR_P1] = StateVariable("p1", StateVariable::DOUBLE);       // P1
  stateVariables_[VAR_P2] = StateVariable("p2", StateVariable::DOUBLE);       // P2
  stateVariables_[VAR_Q1] = StateVariable("q1", StateVariable::DOUBLE);       // Q1
  stateVariables_[VAR_Q2] = StateVariable("q2", StateVariable::DOUBLE);       // Q2
  stateVariables_[VAR_STATE1] = StateVariable("state1", StateVariable::INT);  // connectionState1
  stateVariables_[VAR_STATE2] = StateVariable("state2", StateVariable::INT);  // connectionState2

  hvdcActivePowerControl_ = hvdcLine.findExtension<powsybl::iidm::extensions::iidm::HvdcAngleDroopActivePowerControl>();
  hvdcActivePowerRange_ = hvdcLine.findExtension<powsybl::iidm::extensions::iidm::HvdcOperatorActivePowerRange>();
}

HvdcLineInterfaceIIDM::~HvdcLineInterfaceIIDM() {
}

void HvdcLineInterfaceIIDM::exportStateVariablesUnitComponent() {
  switch (conv1_->getConverterType()) {
    case ConverterInterface::VSC_CONVERTER: {
      shared_ptr<VscConverterInterfaceIIDM> vsc1 = dynamic_pointer_cast<VscConverterInterfaceIIDM>(conv1_);
      shared_ptr<VscConverterInterfaceIIDM> vsc2 = dynamic_pointer_cast<VscConverterInterfaceIIDM>(conv2_);
      bool connected1 = (getValue<int>(VAR_STATE1) == CLOSED);
      bool connected2 = (getValue<int>(VAR_STATE2) == CLOSED);

      if (!connected1 && doubleIsZero(getValue<double>(VAR_P1))) {
        vsc1->getVscIIDM().getTerminal().setP(std::numeric_limits<double>::quiet_NaN());
      } else {
        vsc1->getVscIIDM().getTerminal().setP(-1 * getValue<double>(VAR_P1) * SNREF);
      }

      if (!connected1 && doubleIsZero(getValue<double>(VAR_Q1))) {
        vsc1->getVscIIDM().getTerminal().setQ(std::numeric_limits<double>::quiet_NaN());
      } else {
        vsc1->getVscIIDM().getTerminal().setQ(-1 * getValue<double>(VAR_Q1) * SNREF);
      }

      if (!connected2 && doubleIsZero(getValue<double>(VAR_P2))) {
        vsc2->getVscIIDM().getTerminal().setP(std::numeric_limits<double>::quiet_NaN());
      } else {
        vsc2->getVscIIDM().getTerminal().setP(-1 * getValue<double>(VAR_P2) * SNREF);
      }

      if (!connected2 && doubleIsZero(getValue<double>(VAR_Q2))) {
        vsc2->getVscIIDM().getTerminal().setQ(std::numeric_limits<double>::quiet_NaN());
      } else {
        vsc2->getVscIIDM().getTerminal().setQ(-1 * getValue<double>(VAR_Q2) * SNREF);
      }

      if (vsc1->getVoltageLevelInterfaceInjector()->isNodeBreakerTopology()) {
        // should be removed once a solution has been found to propagate switches (de)connection
        // following component (de)connection (only Modelica models)
        if (connected1 && !vsc1->getInitialConnected())
          vsc1->getVoltageLevelInterfaceInjector()->connectNode(static_cast<unsigned int>(vsc1->getVscIIDM().getTerminal().getNodeBreakerView().getNode()));
        else if (!connected1 && vsc1->getInitialConnected())
          vsc1->getVoltageLevelInterfaceInjector()->disconnectNode(static_cast<unsigned int>(vsc1->getVscIIDM().getTerminal().getNodeBreakerView().getNode()));
      } else {
        if (connected1)
          (vsc1->getVscIIDM()).getTerminal().connect();
        else
          (vsc1->getVscIIDM()).getTerminal().disconnect();
      }

      if (vsc2->getVoltageLevelInterfaceInjector()->isNodeBreakerTopology()) {
        // should be removed once a solution has been found to propagate switches (de)connection
        // following component (de)connection (only Modelica models)
        if (connected2 && !vsc2->getInitialConnected())
          vsc2->getVoltageLevelInterfaceInjector()->connectNode(static_cast<unsigned int>(vsc2->getVscIIDM().getTerminal().getNodeBreakerView().getNode()));
        else if (!connected2 && vsc2->getInitialConnected())
          vsc2->getVoltageLevelInterfaceInjector()->disconnectNode(static_cast<unsigned int>(vsc2->getVscIIDM().getTerminal().getNodeBreakerView().getNode()));
      } else {
        if (connected2)
          (vsc2->getVscIIDM()).getTerminal().connect();
        else
          (vsc2->getVscIIDM()).getTerminal().disconnect();
      }
      break;
    }
    case ConverterInterface::LCC_CONVERTER: {
      shared_ptr<LccConverterInterfaceIIDM> lcc1 = dynamic_pointer_cast<LccConverterInterfaceIIDM>(conv1_);
      shared_ptr<LccConverterInterfaceIIDM> lcc2 = dynamic_pointer_cast<LccConverterInterfaceIIDM>(conv2_);
      bool connected1 = (getValue<int>(VAR_STATE1) == CLOSED);
      bool connected2 = (getValue<int>(VAR_STATE2) == CLOSED);

      if (!connected1 && doubleIsZero(getValue<double>(VAR_P1))) {
        lcc1->getLccIIDM().getTerminal().setP(std::numeric_limits<double>::quiet_NaN());
      } else {
        lcc1->getLccIIDM().getTerminal().setP(-1 * getValue<double>(VAR_P1) * SNREF);
      }

      if (!connected1 && doubleIsZero(getValue<double>(VAR_Q1))) {
        lcc1->getLccIIDM().getTerminal().setQ(std::numeric_limits<double>::quiet_NaN());
      } else {
        lcc1->getLccIIDM().getTerminal().setQ(-1 * getValue<double>(VAR_Q1) * SNREF);
      }

      if (!connected2 && doubleIsZero(getValue<double>(VAR_P2))) {
        lcc2->getLccIIDM().getTerminal().setP(std::numeric_limits<double>::quiet_NaN());
      } else {
        lcc2->getLccIIDM().getTerminal().setP(-1 * getValue<double>(VAR_P2) * SNREF);
      }

      if (!connected2 && doubleIsZero(getValue<double>(VAR_Q2))) {
        lcc2->getLccIIDM().getTerminal().setQ(std::numeric_limits<double>::quiet_NaN());
      } else {
        lcc2->getLccIIDM().getTerminal().setQ(-1 * getValue<double>(VAR_Q2) * SNREF);
      }

      if (lcc1->getVoltageLevelInterfaceInjector()->isNodeBreakerTopology()) {
        // should be removed once a solution has been found to propagate switches (de)connection
        // following component (de)connection (only Modelica models)
        if (connected1 && !lcc1->getInitialConnected())
          lcc1->getVoltageLevelInterfaceInjector()->connectNode(static_cast<unsigned int>(lcc1->getLccIIDM().getTerminal().getNodeBreakerView().getNode()));
        else if (!connected1 && lcc1->getInitialConnected())
          lcc1->getVoltageLevelInterfaceInjector()->disconnectNode(static_cast<unsigned int>(lcc1->getLccIIDM().getTerminal().getNodeBreakerView().getNode()));
      } else {
        if (connected1)
          (lcc1->getLccIIDM()).getTerminal().connect();
        else
          (lcc1->getLccIIDM()).getTerminal().disconnect();
      }
      if (lcc2->getVoltageLevelInterfaceInjector()->isNodeBreakerTopology()) {
        // should be removed once a solution has been found to propagate switches (de)connection
        // following component (de)connection (only Modelica models)
        if (connected2 && !lcc2->getInitialConnected())
          lcc2->getVoltageLevelInterfaceInjector()->connectNode(static_cast<unsigned int>(lcc2->getLccIIDM().getTerminal().getNodeBreakerView().getNode()));
        else if (!connected2 && lcc2->getInitialConnected())
          lcc2->getVoltageLevelInterfaceInjector()->disconnectNode(static_cast<unsigned int>(lcc2->getLccIIDM().getTerminal().getNodeBreakerView().getNode()));
      } else {
        if (connected2)
          (lcc2->getLccIIDM()).getTerminal().connect();
        else
          (lcc2->getLccIIDM()).getTerminal().disconnect();
      }
      break;
    }
  }
}

void HvdcLineInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();

  bool isACEmulationEnabled = hvdcActivePowerControl_ && hvdcActivePowerControl_.get().isEnabled();
  double p0ACEmulationPu = 0.;
  double droop = 0.;
  if (isACEmulationEnabled) {
    double p0ACEmulation = hvdcActivePowerControl_.get().getP0();
    p0ACEmulationPu = p0ACEmulation / SNREF;
    droop = hvdcActivePowerControl_.get().getDroop();
  }
  staticParameters_.insert(std::make_pair("isACEmulationEnabled", StaticParameter("isACEmulationEnabled",
                             StaticParameter::BOOL).setValue(isACEmulationEnabled)));
  staticParameters_.insert(std::make_pair("p0ACEmulationPu", StaticParameter("p0ACEmulationPu",
                             StaticParameter::DOUBLE).setValue(p0ACEmulationPu)));
  staticParameters_.insert(std::make_pair("droop", StaticParameter("droop",
                             StaticParameter::DOUBLE).setValue(droop)));
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
    staticParameters_.insert(std::make_pair("v1Nom", StaticParameter("v1Nom", StaticParameter::DOUBLE).setValue(U1Nom)));
  } else {
    staticParameters_.insert(std::make_pair("v1", StaticParameter("v1", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle1", StaticParameter("angle1", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v1_pu", StaticParameter("v1_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle1_pu", StaticParameter("angle1_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v1Nom", StaticParameter("v1Nom", StaticParameter::DOUBLE).setValue(1.)));
  }
  if (conv2_->getBusInterface()) {
    double U20 = conv2_->getBusInterface()->getV0();
    double U2Nom = conv2_->getVNom();
    double theta2 = conv2_->getBusInterface()->getAngle0();
    staticParameters_.insert(std::make_pair("v2", StaticParameter("v2", StaticParameter::DOUBLE).setValue(U20)));
    staticParameters_.insert(std::make_pair("angle2", StaticParameter("angle2", StaticParameter::DOUBLE).setValue(theta2)));
    staticParameters_.insert(std::make_pair("v2_pu", StaticParameter("v2_pu", StaticParameter::DOUBLE).setValue(U20 / U2Nom)));
    staticParameters_.insert(std::make_pair("angle2_pu", StaticParameter("angle2_pu", StaticParameter::DOUBLE).setValue(theta2 * M_PI / 180)));
    staticParameters_.insert(std::make_pair("v2Nom", StaticParameter("v2Nom", StaticParameter::DOUBLE).setValue(U2Nom)));
  } else {
    staticParameters_.insert(std::make_pair("v2", StaticParameter("v2", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle2", StaticParameter("angle2", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v2_pu", StaticParameter("v2_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle2_pu", StaticParameter("angle2_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v2Nom", StaticParameter("v2Nom", StaticParameter::DOUBLE).setValue(1.)));
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

const std::string&
HvdcLineInterfaceIIDM::getID() const {
  return hvdcLineIIDM_.getId();
}

double
HvdcLineInterfaceIIDM::getResistanceDC() const {
  return hvdcLineIIDM_.getR();
}

double
HvdcLineInterfaceIIDM::getVNom() const {
  return hvdcLineIIDM_.getNominalV();
}

double
HvdcLineInterfaceIIDM::getActivePowerSetpoint() const {
  return hvdcLineIIDM_.getActivePowerSetpoint();
}

double
HvdcLineInterfaceIIDM::getPmax() const {
  return hvdcLineIIDM_.getMaxP();
}

HvdcLineInterfaceIIDM::ConverterMode_t
HvdcLineInterfaceIIDM::getConverterMode() const {
  return hvdcLineIIDM_.getConvertersMode() ==
      powsybl::iidm::HvdcLine::ConvertersMode::SIDE_1_RECTIFIER_SIDE_2_INVERTER ? HvdcLineInterface::RECTIFIER_INVERTER : HvdcLineInterface::INVERTER_RECTIFIER;
}

string
HvdcLineInterfaceIIDM::getIdConverter1() const {
  return hvdcLineIIDM_.getConverterStation1().get().getId();
}

string
HvdcLineInterfaceIIDM::getIdConverter2() const {
  return hvdcLineIIDM_.getConverterStation2().get().getId();
}

int HvdcLineInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if (varName == "p1")
    index = VAR_P1;
  else if (varName == "q1")
    index = VAR_Q1;
  else if (varName == "p2")
    index = VAR_P2;
  else if (varName == "q2")
    index = VAR_Q2;
  else if (varName == "state1")
    index = VAR_STATE1;
  else if (varName == "state2")
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

boost::optional<double>
HvdcLineInterfaceIIDM::getDroop() const {
  return hvdcActivePowerControl_ ? hvdcActivePowerControl_.get().getDroop() : boost::optional<double>();
}

boost::optional<double>
HvdcLineInterfaceIIDM::getP0() const {
  return hvdcActivePowerControl_ ? hvdcActivePowerControl_.get().getP0() : boost::optional<double>();
}

boost::optional<bool>
HvdcLineInterfaceIIDM::isActivePowerControlEnabled() const {
  return hvdcActivePowerControl_ ? hvdcActivePowerControl_.get().isEnabled() : boost::optional<bool>();
}

boost::optional<double>
HvdcLineInterfaceIIDM::getOprFromCS1toCS2() const {
  return hvdcActivePowerRange_ ? hvdcActivePowerRange_.get().getOprFromCS1toCS2() : boost::optional<double>();
}

boost::optional<double>
HvdcLineInterfaceIIDM::getOprFromCS2toCS1() const {
  return hvdcActivePowerRange_ ? hvdcActivePowerRange_.get().getOprFromCS2toCS1() : boost::optional<double>();
}


}  // namespace DYN
