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
 * @file  DYNModelCPPImpl.cpp
 *
 * @brief
 *
 */

#include "DYNModelUpdatable.h"

namespace DYN {
ModelUpdatable::ModelUpdatable(const std::string& modelType):
  ModelCPP(modelType),
  inputValue_(0.) {
    setIsUpdatable(true);}

void
ModelUpdatable::init(const double /*t0*/) { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::evalF(double /*t*/, propertyF_t /*type*/) { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::evalZ(const double /*t*/) { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::collectSilentZ(BitMask* /*silentZTable*/) { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::evalCalculatedVars() { /* not needed for DYNModelUpdatable */}

double
ModelUpdatable::evalCalculatedVarI(unsigned iCalculatedVar) const {
  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
}
void
ModelUpdatable::evalJt(double /*t*/, double /*cj*/, int /*rowOffset*/, SparseMatrix& /*jt*/) { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::evalJtPrim(const double /*t*/, const double /*cj*/, const int /*rowOffset*/, SparseMatrix& /*jtPrim*/) {
  /* not needed for DYNModelUpdatable */ }

void
ModelUpdatable::evalStaticFType() { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::evalDynamicFType() { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::getY0() { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::evalStaticYType() { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::evalDynamicYType() { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  /* not needed for DYNModelUpdatable */ }

void
ModelUpdatable::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<double>& /*res*/) const {
  /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::initializeStaticData() { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::setFequations() { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::initParams() { /* not needed for DYNModelUpdatable */}

void
ModelUpdatable::evalG(const double /*t*/) {
  // Supposing the updatable value is set before the next time step t: a single
  // ROOT_UP is raised at time t, which should be OK both for solver SIM and IDA
  // in the case of a single event (for IDA, time will go back until t+eps
  // without raising ROOT_UP again, which makes the event occur at time t).
  // Further evaluation is needed for multiple events with IDA, as only the
  // first time step after an event has ROOT_UP, and multiple evaluations of a
  // single time step will not raise ROOT_UP again.

  gLocal_[0] = (updated_) ? ROOT_UP : ROOT_DOWN;
  updated_ = false;
}

void
ModelUpdatable::setGequations() {
  gEquationIndex_[0] = std::string("parameter update");
}

modeChangeType_t
ModelUpdatable::evalMode(const double /*t*/) {
  // Mode change should be handled by the connected variable
  return NO_MODE;
}

void
ModelUpdatable::dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const {
  ModelCPP::dumpInStream(streamVariables, inputValue_);
}

void
ModelUpdatable::loadInternalVariables(boost::archive::binary_iarchive& streamVariables) {
  char c;
  streamVariables >> c;
  streamVariables >> inputValue_;
}

}  // namespace DYN
