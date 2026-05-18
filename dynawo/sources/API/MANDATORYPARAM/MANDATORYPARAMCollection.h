//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
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
 * @file MANDATORYPARAMCollection.h
 * @brief Mandatory parameters collection : interface file
 */

#ifndef API_MANDATORYPARAM_MANDATORYPARAMCOLLECTION_H_
#define API_MANDATORYPARAM_MANDATORYPARAMCOLLECTION_H_

#include <vector>

#include "MANDATORYPARAMParameter.h"

namespace mandatoryParameters {

/**
 * @class Collection
 * @brief Collection of mandatory parameters
 */
class Collection {
 public:
  /**
   * @brief Add a parameter to the collection
   * @param name parameter name
   * @param type parameter type string
   */
  void addParameter(const std::string& name, const std::string& type);

  /**
   * @brief Parameters getter
   * @return list of parameters
   */
  const std::vector<Parameter>& getParameters() const;

 private:
  std::vector<Parameter> parameters_;  ///< list of mandatory parameters
};

}  // namespace mandatoryParameters

#endif  // API_MANDATORYPARAM_MANDATORYPARAMCOLLECTION_H_
