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
 * @file PARParameterFactory.cpp
 * @brief Dynawo parameter factory : implementation file
 *
 */

#include "PARParameterFactory.h"
#include "PARParameter.h"

using std::string;

namespace parameters {

boost::shared_ptr<Parameter>
ParameterFactory::newParameter(const string& name, const bool boolValue) {
  return boost::shared_ptr<Parameter>(new Parameter(name, boolValue));
}

boost::shared_ptr<Parameter>
ParameterFactory::newParameter(const string& name, const int intValue) {
  return boost::shared_ptr<Parameter>(new Parameter(name, intValue));
}

boost::shared_ptr<Parameter>
ParameterFactory::newParameter(const string& name, const double doubleValue) {
  return boost::shared_ptr<Parameter>(new Parameter(name, doubleValue));
}

boost::shared_ptr<Parameter>
ParameterFactory::newParameter(const string& name, const string& stringValue) {
  return boost::shared_ptr<Parameter>(new Parameter(name, stringValue));
}

}  // namespace parameters
