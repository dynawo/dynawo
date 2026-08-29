//
// Copyright (c) 2024, RTE (http://www.rte-france.com)
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
 * @file DYNModelSwitchFactory.h
 *
 * @brief switch model factory : header file
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELSWITCHFACTORY_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELSWITCHFACTORY_H_

#include "DYNModelSwitch.h"

namespace DYN {

/**
 * @class ModelSwitchFactory
 *
 * @brief switch model factory
 *
 */
class ModelSwitchFactory {
 public:
  /**
   * @brief create a new instance of switch model
   * @param sw : switch data interface used to build the model
   *
   * @return shared pointer to new switch model
   */
  static std::shared_ptr<ModelSwitch> newInstance(const std::shared_ptr<SwitchInterface>& sw);
};

}  // namespace DYN
#endif  // MODELS_CPP_MODELNETWORK_DYNMODELSWITCHFACTORY_H_
