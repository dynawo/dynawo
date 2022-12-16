//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  DYNStateVariable.cpp
 *
 * @brief State variable description : implementation file
 *
 */


#include "DYNDataInterfaceFactory.h"
#include "DYNDataInterfaceIIDM.h"

using std::string;
using boost::shared_ptr;

namespace DYN {
shared_ptr<DataInterface>
DataInterfaceFactory::build(dataInterfaceType_t type, const string& filepath, unsigned int nbVariants) {
  switch (type) {
  case DATAINTERFACE_IIDM:
    return DataInterfaceIIDM::build(filepath, nbVariants);
  }
  return boost::shared_ptr<DataInterface>();
}
}  // namespace DYN
