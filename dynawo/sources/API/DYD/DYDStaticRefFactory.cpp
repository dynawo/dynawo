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
 * @file DYDStaticRefFactory.cpp
 * @brief StaticRef factory : implementation file
 *
 */

#include "DYDStaticRefFactory.h"
#include "DYDStaticRef.h"

using std::string;
using boost::shared_ptr;

namespace dynamicdata {

shared_ptr<StaticRef>
StaticRefFactory::newStaticRef() {
  return shared_ptr<StaticRef>(new StaticRef());
}

shared_ptr<StaticRef>
StaticRefFactory::newStaticRef(const string& modelVar, const string& staticVar) {
  return shared_ptr<StaticRef>(new StaticRef(modelVar, staticVar));
}

}  // namespace dynamicdata
