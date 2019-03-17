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
 * @file DYDIdentifiableImpl.h
 * @brief Identifiable description : header file
 */

#ifndef API_DYD_DYDIDENTIFIABLEIMPL_H_
#define API_DYD_DYDIDENTIFIABLEIMPL_H_

#include "DYDIdentifiable.h"

namespace dynamicdata {

/**
 * @class Identifiable::Impl
 * @brief Identifiable implementation class
 *
 * Store the id of a model or unit dynamic model
 */
class Identifiable::Impl : public Identifiable {
 public:
  /**
   * @brief constructor of an identifiable object
   *
   * @param id : id of the identifiable
   */
  explicit Impl(const std::string& id) :
  id_(id) { }

  /**
   *  @brief destructor
   */
  virtual ~Impl() { }

  /**
   * @brief get the id of the identifiable
   * @return the id of the identifiable
   */
  std::string get() const {
    return id_;
  }

 private:
  std::string id_;  ///< id of the identifiable
};
}  // namespace dynamicdata

#endif  // API_DYD_DYDIDENTIFIABLEIMPL_H_
