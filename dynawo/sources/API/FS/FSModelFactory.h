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
 * @file  FSModelFactory.h
 *
 * @brief Dynawo final state model factory : header file
 *
 */
#ifndef API_FS_FSMODELFACTORY_H_
#define API_FS_FSMODELFACTORY_H_

#include <boost/shared_ptr.hpp>

#include "FSModel.h"

namespace finalState {

/**
 * @class ModelFactory
 * @brief Model factory class
 *
 * ModelFactory encapsulates methods for creating new
 * @p Model objects
 */
class ModelFactory {
 public:
  /**
   * @brief create a new Model instance
   *
   * @param[in] id model's id
   * @return shared pointer to a new @p Model
   */
  static boost::shared_ptr<FinalStateModel> newModel(const std::string& id);
};

}  // namespace finalState

#endif  // API_FS_FSMODELFACTORY_H_
