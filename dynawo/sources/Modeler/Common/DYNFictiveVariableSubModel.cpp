//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file DYNFictiveVariableSubModel.cpp
 * @brief Sub model for external variable implementation file
 */

#include "DYNFictiveVariableSubModel.h"

#include "DYNVariableNative.h"
#include "DYNVariableNativeFactory.h"

namespace DYN {
FictiveVariableSubModel::FictiveVariableSubModel(const connectedSubModel& connectedModel) : referenceConnectedModel_(connectedModel) {}

void
FictiveVariableSubModel::getSize() {
  sizeY_ = 1;
  // others are at 0 by default
}

void
FictiveVariableSubModel::getY0() {
  // we initialize the fictive variable with the value that the external variable would have been initialized to if
  // it was a regular native variable of the model. This information is given by the sub model

  referenceConnectedModel_.subModel()->getY0External(referenceConnectedModel_.variable()->getIndex(), yLocal_[0]);
  ypLocal_[0] = 0.;  // derivative for external variables are always initialized to 0
}

void
FictiveVariableSubModel::getY0External(unsigned int numVarEx, double&) const {
  throw DYNError(Error::MODELER, UndefExternalVar, numVarEx);
}

void
FictiveVariableSubModel::evalStaticYType() {
  yType_[0] = ALGEBRAIC;
}

double
FictiveVariableSubModel::evalCalculatedVarI(unsigned) const {
  throw DYNError(Error::MODELER, FuncNotYetCoded);
}

void
FictiveVariableSubModel::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) {
  boost::shared_ptr<Variable> referenceVar = referenceConnectedModel_.variable();
  variables.push_back(VariableNativeFactory::createState("fict_" + referenceVar->getName(), referenceVar->getType(), referenceVar->getNegated()));
}

}  // namespace DYN
