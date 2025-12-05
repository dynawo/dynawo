//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
  inputValue_(0.),
  updated_(false) {
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

}  // namespace DYN
