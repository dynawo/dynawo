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
 * @file DYDIdentifiable.h
 * @brief Identifiable description : interface file
 */

#ifndef API_DYD_DYDIDENTIFIABLE_H_
#define API_DYD_DYDIDENTIFIABLE_H_

#include <string>

#include "DYDExport.h"

namespace dynamicdata {

/**
 * @class Identifiable
 * @brief Identifiable interface class
 *
 * Store the id of a model or unit dynamic model
 */
class __DYNAWO_DYD_EXPORT Identifiable {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Identifiable() {}
  /**
   * @brief Get the id of the identifiable object
   * @return Id of the identifiable
   */
  virtual std::string get() const = 0;

  /**
   * @brief implementation class
   */
  class Impl;  // Implementation class
};
}  // namespace dynamicdata

#endif  // API_DYD_DYDIDENTIFIABLE_H_
