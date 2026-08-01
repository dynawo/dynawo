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
 * @file  DYNParameterModeler.cpp
 *
 * @brief Dynawo modeler parameter : implementation file
 *
 */
#include "DYNParameterModeler.h"

#include "DYNMacrosMessage.h"

using std::string;

namespace DYN {

ParameterModeler::ParameterModeler(const string& name, const typeVarC_t& valueType, const parameterScope_t& scope, const string& cardinality,
                     const string& cardinalityInformator) :
ParameterCommon(name, valueType, true),
scope_(scope),
cardinality_(cardinality),
cardinalityInformator_(cardinalityInformator),
nonUnitaryParameterInstance_(false) {
  // write rights are defined as follows
  // any parameter may have a local init value,
  // even internal parameters, because such a parameter may be set through an internal init model variable (see TapChanger.valueToMonitor0 for such an example)
  // any parameter may have a loaded value (to allow loading dumped data)
  // any parameter may have a final value (the value used during the dynamic simulation)
  // internal and shared parameters may have a .mo value (although now for internal parameters this MO origin is not written in the ParameterModeler class)
  // non-internal parameters may have .par, .iidm, local initialisation result values

  writeRights_[LOCAL_INIT] = true;
  writeRights_[FINAL] = true;
  writeRights_[LOADED_DUMP] = true;

  if ((scope_ == INTERNAL_PARAMETER) || (scope_ == SHARED_PARAMETER)) {
    writeRights_[MO] = true;
  }

  if (scope_ != INTERNAL_PARAMETER) {
    writeRights_[PAR] = true;
    writeRights_[IIDM] = true;
  }
}

void
ParameterModeler::writeChecks(const parameterOrigin_t origin) const {
  if (!isUnitary())
    throw DYNError(Error::MODELER, ParameterNotUnitary, getName());

  if (!originWriteAllowed(origin))
    throw DYNError(Error::MODELER, ParameterNoWriteRights, getName(), origin2Str(origin), paramScope2Str(getScope()));
}

void
ParameterModeler::setCardinalityInformator(const string& cardinalityInformator) {
  if (isUnitary())
    throw DYNError(Error::MODELER, ParameterUnitary, getName());

  cardinalityInformator_ = cardinalityInformator;
}

string
ParameterModeler::getCardinalityInformator() const {
  if (isUnitary()) {
    throw DYNError(Error::MODELER, ParameterUnitary, getName());
  } else if (cardinalityInformator_.empty()) {
    throw DYNError(Error::MODELER, ParameterNoCardinalityInformator, getName());
  }
  return cardinalityInformator_;
}

double
ParameterModeler::getDoubleValue() const {
  if (getValueType() == VAR_TYPE_DOUBLE)
    return getValue<double>();
  else if (getValueType() == VAR_TYPE_INT)
    return static_cast<double> (getValue<int>());
  else if (getValueType() == VAR_TYPE_BOOL)
    return fromNativeBool(getValue<bool>());
  else
    throw DYNError(Error::MODELER, ParameterUnableToConvertToDouble, getName(), typeVarC2Str(getValueType()));
}

parameterOrigin_t
ParameterModeler::getOrigin() const {
  if (!originSet())
    throw DYNError(Error::MODELER, ParameterHasNoValue, getName());

  return origin_.value();
}

void
ParameterModeler::updateOrigin(const parameterOrigin_t origin) {
  if ((!originSet()) || (getOrigin() < origin))
    setOrigin(origin);
}

bool
ParameterModeler::hasOrigin(const parameterOrigin_t origin) const {
  return (values_.find(origin) != values_.end());
}

boost::any
ParameterModeler::getAnyValue() const {
  return values_.find(getOrigin())->second;
}

Error::TypeError_t
ParameterModeler::getTypeError() const {
  return Error::MODELER;
}

}  // namespace DYN
