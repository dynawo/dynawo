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
 * @file  CSTRConstraintsCollectionFactory.h
 *
 * @brief Dynawo constraints factory: header file
 *
 */
#ifndef API_CSTR_CSTRCONSTRAINTSCOLLECTIONFACTORY_H_
#define API_CSTR_CSTRCONSTRAINTSCOLLECTIONFACTORY_H_

#include <memory>
#include <string>


namespace constraints {
class ConstraintsCollection;

/**
 * @class ConstraintsCollectionFactory
 * @brief ConstraintsCollection factory class
 *
 * ConstraintsFactory encapsulate methods for creating new
 * @p ConstraintsCollection objects.
 */
class ConstraintsCollectionFactory {
 public:
  /**
   * @brief Create new ConstraintsCollection instance
   *
   * @param id id of the new instance
   *
   * @return unique pointer to a new empty @p ConstraintsCollection
   */
  static std::unique_ptr<ConstraintsCollection> newInstance(const std::string& id);

  /**
   * @brief Create new ConstraintsCollection instance as a clone of given instance
   *
   * @param[in] original ConstraintsCollection to be cloned
   *
   * @return Unique pointer to a new @p ConstraintsCollection copied from original
   */
  static std::unique_ptr<ConstraintsCollection> copyInstance(const std::shared_ptr<ConstraintsCollection>& original);

  /**
   * @brief Create new ConstraintsCollection instance as a clone of given instance
   *
   * @param[in] original ConstraintsCollection to be cloned
   *
   * @return Unique pointer to a new @p ConstraintsCollection copied from original
   */
  static std::unique_ptr<ConstraintsCollection> copyInstance(const ConstraintsCollection& original);
};
}  // namespace constraints

#endif  // API_CSTR_CSTRCONSTRAINTSCOLLECTIONFACTORY_H_
