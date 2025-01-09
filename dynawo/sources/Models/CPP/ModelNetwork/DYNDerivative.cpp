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
 * @file  DYNDerivative.cpp
 *
 * @brief
 *
 */
#include "DYNMacrosMessage.h"

#include "DYNDerivative.h"

using std::map;

namespace DYN {

void
Derivatives::reset() {
 for (auto& value : values_)
    value.second = 0.;
  // values_.clear();
}

void
Derivatives::addValue(const int numVar, const double value) {
  values_[numVar] += value;
}

void
BusDerivatives::reset() {
  irDerivatives_.reset();
  iiDerivatives_.reset();
}

void
BusDerivatives::addDerivative(typeDerivative_t type, const int numVar, const double value) {
  switch (type) {
    case IR_DERIVATIVE:
      irDerivatives_.addValue(numVar, value);
      break;
    case II_DERIVATIVE:
      iiDerivatives_.addValue(numVar, value);
      break;
    default:
      throw DYNError(Error::MODELER, InvalidDerivativeType, type);
  }
}

const std::map<int, double>&
BusDerivatives::getValues(typeDerivative_t type) const {
  if (type == IR_DERIVATIVE)
    return irDerivatives_.getValues();
  else if (type == II_DERIVATIVE)
    return iiDerivatives_.getValues();
  throw DYNError(Error::MODELER, InvalidDerivativeType, type);
}

Derivatives& BusDerivatives::getDerivatives(typeDerivative_t type) {
  switch (type) {
    case IR_DERIVATIVE:
      return irDerivatives_;
    break;
    case II_DERIVATIVE:
      return iiDerivatives_;
    break;
    default:
      throw DYNError(Error::MODELER, InvalidDerivativeType, type);
  }
}

}  // namespace DYN
