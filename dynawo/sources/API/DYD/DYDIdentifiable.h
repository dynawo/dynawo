//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
 * @file DYDIdentifiable.h
 * @brief Identifiable description : interface file
 */

#ifndef API_DYD_DYDIDENTIFIABLE_H_
#define API_DYD_DYDIDENTIFIABLE_H_

#include <string>

namespace dynamicdata {

/**
 * @class Identifiable
 * @brief Identifiable interface class
 *
 * Store the id of a model or unit dynamic model
 */
class Identifiable {
 public:
  /**
   * @brief constructor of an identifiable object
   *
   * @param id : id of the identifiable
   */
  explicit Identifiable(const std::string& id) : id_(id) {}

  /**
   * @brief get the id of the identifiable
   * @return the id of the identifiable
   */
  const std::string& get() const {
    return id_;
  }

 private:
  std::string id_;  ///< id of the identifiable
};
}  // namespace dynamicdata

#endif  // API_DYD_DYDIDENTIFIABLE_H_
