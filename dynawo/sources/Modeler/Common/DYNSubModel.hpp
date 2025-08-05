//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
//

/**
 * @file  DYNSubModel.hpp
 *
 * @brief Implementation of template methods
 *
 */
#ifndef MODELER_COMMON_DYNSUBMODEL_HPP_
#define MODELER_COMMON_DYNSUBMODEL_HPP_

#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNParameterModeler.h"

namespace DYN {

template<typename T>
void
inline SubModel::setParameterValue(const std::string& name, const parameterOrigin_t& origin,
  const T& value, const bool isInitParam, const bool isLinearizeParam) {
  if (hasParameter(name, isInitParam, isLinearizeParam)) {
    findParameterReference(name, isInitParam, isLinearizeParam).setValue(value, origin);
  }
}

}  // namespace DYN

#endif  // MODELER_COMMON_DYNSUBMODEL_HPP_
