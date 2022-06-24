//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNDataInterfaceImpl.h
 *
 * @brief Data interface util implementation file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNDATAINTERFACEIMPL_H_
#define MODELER_DATAINTERFACE_DYNDATAINTERFACEIMPL_H_

#include "DYNDataInterface.h"

namespace DYN {

/**
 * class DataInterfaceImpl implementation of DataInterface with common utility methods
 */
class DataInterfaceImpl : public DataInterface {
 public:
  /**
  * @brief test if some network components does not have a dynamic model
  *
  * A network model will be instantiated if at least one of the static components does not have a dynamic model
  *
  * @return do we need to instantiate the network
  */
  bool instantiateNetwork() const override;
};

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNDATAINTERFACEIMPL_H_
