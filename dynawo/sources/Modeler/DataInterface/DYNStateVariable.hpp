//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
//

/**
 * @file  DYNStateVariable.hpp
 *
 * @brief Implementation of template methods
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNSTATEVARIABLE_HPP_
#define MODELER_DATAINTERFACE_DYNSTATEVARIABLE_HPP_

#include "DYNMacrosMessage.h"

namespace DYN {

template<typename T>
T StateVariable::getValue() const {
  T value;
  try {
    value = boost::any_cast<T>(*value_);
  }
  catch (boost::bad_any_cast&)  {
    throw DYNError(Error::MODELER, StateVariableBadCast, name_, typeAsString(type_));
  }
  return value;
}

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNSTATEVARIABLE_HPP_
