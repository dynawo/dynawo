// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.

/**
 * @file  DYNNetworkBridge.hpp
 * @brief  interface enabling linking with dynamic model by ModelNetwork
 */

#ifndef MODELS_CPP_MODELNETWORK_DYNNETWORKBRIDGE_HPP_
#define MODELS_CPP_MODELNETWORK_DYNNETWORKBRIDGE_HPP_

#include <boost/shared_ptr.hpp>
#include <string>

namespace DYN {
class SubModel;

/** interface allowing linking a NetworkComponent to its dynamic model, for requests forwarding purposes */
class NetworkBridge {
 public:
  /**
   * @brief sets the pointer to the dynamic model overriding the ModelNetwork component passed at instanciation
   * @param dynModel the pointer to the dynamic model
   */
  inline void setDynPart(boost::shared_ptr<SubModel> dynModel) {dynModel_ = dynModel;}

 protected:
  boost::shared_ptr<SubModel> dynModel_ = nullptr;    ///< dynamic model for the ModelNetwork component
};

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNNETWORKBRIDGE_HPP_
