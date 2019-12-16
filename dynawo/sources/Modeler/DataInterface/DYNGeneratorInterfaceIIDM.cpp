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
 * @file  DYNGeneratorInterfaceIIDM.cpp
 *
 * @brief Generator data interface : implementation file for IIDM interface
 *
 */
//======================================================================

#include <IIDM/components/Generator.h>

#include "DYNGeneratorInterfaceIIDM.h"

using std::string;
using boost::shared_ptr;

namespace DYN {

GeneratorInterfaceIIDM::~GeneratorInterfaceIIDM() {
}

GeneratorInterfaceIIDM::GeneratorInterfaceIIDM(IIDM::Generator& generator) :
InjectorInterfaceIIDM<IIDM::Generator>(generator, generator.id()),
generatorIIDM_(generator) {
  setType(ComponentInterface::GENERATOR);
  stateVariables_.resize(3);
  stateVariables_[VAR_P] = StateVariable("p", StateVariable::DOUBLE);  // P
  stateVariables_[VAR_Q] = StateVariable("q", StateVariable::DOUBLE);  // Q
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);   // connectionState
}

int
GeneratorInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if ( varName == "p" )
    index = VAR_P;
  else if ( varName == "q" )
    index = VAR_Q;
  else if ( varName == "state" )
    index = VAR_STATE;
  return index;
}

void
GeneratorInterfaceIIDM::exportStateVariablesUnitComponent() {
  bool connected = (getValue<int>(VAR_STATE) == CLOSED);
  generatorIIDM_.p(-1 * getValue<double>(VAR_P) * SNREF);
  generatorIIDM_.q(-1 * getValue<double>(VAR_Q) * SNREF);

  if (generatorIIDM_.has_connection()) {
    if (generatorIIDM_.connectionPoint()->is_bus()) {
      if (connected)
        generatorIIDM_.connect();
      else
        generatorIIDM_.disconnect();
    } else {  // is node()
      // should be removed once a solution has been found to propagate switches (de)connection
      // following component (de)connection (only Modelica models)
      if (connected && !getInitialConnected())
        getVoltageLevelInterface()->connectNode(generatorIIDM_.node());
      else if (!connected && getInitialConnected())
        getVoltageLevelInterface()->disconnectNode(generatorIIDM_.node());
    }
  }
}

bool
GeneratorInterfaceIIDM::checkCriteria(bool /*checkEachIter*/) {
  return true;
}

void
GeneratorInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("p_pu", StaticParameter("p_pu", StaticParameter::DOUBLE).setValue(getP() / SNREF)));
  staticParameters_.insert(std::make_pair("q_pu", StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(getQ() / SNREF)));
  staticParameters_.insert(std::make_pair("p", StaticParameter("p", StaticParameter::DOUBLE).setValue(getP())));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(getQ())));
  if (busInterface_) {
    double U0 = busInterface_->getV0();
    double vNom;
    if (generatorIIDM_.voltageLevel().nominalV() > 0)
      vNom = generatorIIDM_.voltageLevel().nominalV();
    else
      throw DYNError(Error::MODELER, UndefinedNominalV, generatorIIDM_.voltageLevel().id());

    double teta = busInterface_->getAngle0();
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(U0 / vNom)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(teta * M_PI / 180)));
    staticParameters_.insert(std::make_pair("uc_pu", StaticParameter("uc", StaticParameter::DOUBLE).setValue(U0 / vNom)));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(U0)));
    staticParameters_.insert(std::make_pair("uc", StaticParameter("uc", StaticParameter::DOUBLE).setValue(U0)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(teta)));
  } else {
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("uc_pu", StaticParameter("uc", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("uc", StaticParameter("uc", StaticParameter::DOUBLE).setValue(0.)));
  }
}

void
GeneratorInterfaceIIDM::setBusInterface(const shared_ptr<BusInterface>& busInterface) {
  InjectorInterfaceIIDM<IIDM::Generator>::setBusInterface(busInterface);
}

void
GeneratorInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  InjectorInterfaceIIDM<IIDM::Generator>::setVoltageLevelInterface(voltageLevelInterface);
}

shared_ptr<BusInterface>
GeneratorInterfaceIIDM::getBusInterface() const {
  return InjectorInterfaceIIDM<IIDM::Generator>::getBusInterface();
}

bool
GeneratorInterfaceIIDM::getInitialConnected() {
  return InjectorInterfaceIIDM<IIDM::Generator>::getInitialConnected();
}

double
GeneratorInterfaceIIDM::getP() {
  return InjectorInterfaceIIDM<IIDM::Generator>::getP();
}

double
GeneratorInterfaceIIDM::getQ() {
  return InjectorInterfaceIIDM<IIDM::Generator>::getQ();
}

string
GeneratorInterfaceIIDM::getID() const {
  return generatorIIDM_.id();
}

}  // namespace DYN
