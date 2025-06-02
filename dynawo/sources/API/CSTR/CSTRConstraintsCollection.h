// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
//
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
 * @file  CSTRConstraintsCollection.h
 *
 * @brief Dynawo constraints : interface file
 *
 */

#ifndef API_CSTR_CSTRCONSTRAINTSCOLLECTION_H_
#define API_CSTR_CSTRCONSTRAINTSCOLLECTION_H_

#include "CSTRConstraint.h"

#include <map>
#include <string>
#include <vector>
#include <memory>

namespace constraints {

/**
 * @class ConstraintsCollection
 * @brief contraints interface class
 *
 * Interface class for ContraintsCollection object. This a container for constraints
 */
class ConstraintsCollection {
 public:
  /**
   * @brief constructor
   *
   * @param id ConstraintsCollection's id
   */
  explicit ConstraintsCollection(const std::string& id);

  /**
   * @brief Add a constraint to the collection
   *
   * @param modelName model where the constraint occurs
   * @param description description of the constraint
   * @param time time when the constraint occurs
   * @param type begin/end
   * @param modelType type of the model
   * @param data the constraint data to add
   */
  void addConstraint(const std::string& modelName, const std::string& description,
    const double& time, Type_t type,
    const std::string& modelType = "",
    const boost::optional<ConstraintData>& data = boost::none);

  /**
   * @brief filter the constraint collection by removing constraints cancelled during the simulation
   *
   */
  void filter();

 public:
  /**
   * @class const_iterator
   * @brief Const iterator over constraints
   *
   * Const iterator over constraints stored in the collection
   */
  class const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on constraints. Can create an iterator to the
     * beginning of the constraints' container or to the end. Constraints
     * cannot be modified.
     *
     * @param iterated Pointer to the constraints' map iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the constraints' container.
     */
    const_iterator(const ConstraintsCollection* iterated, bool begin);

    /**
     * @brief Prefix-increment operator
     *
     * @returns Reference to this const_iterator
     */
    const_iterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this const_iterator
     */
    const_iterator operator++(int);

    /**
     * @brief Prefix-decrement operator
     *
     * @returns Reference to this const_iterator
     */
    const_iterator& operator--();

    /**
     * @brief Postfix-decrement operator
     *
     * @returns Copy of this const_iterator
     */
    const_iterator operator--(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are equals, else false
     */
    bool operator==(const const_iterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are different, else false
     */
    bool operator!=(const const_iterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns Constraint pointed to by this
     */
    const std::shared_ptr<Constraint>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the Constraint pointed to by this
     */
    const std::shared_ptr<Constraint>* operator->() const;

   private:
    std::map<std::string, std::shared_ptr<Constraint> >::const_iterator current_;  ///< current map iterator
  };

  /**
   * @brief Get a const_iterator to the beginning of the constraints' map
   * @return beginning
   */
  const_iterator cbegin() const;

  /**
   * @brief Get a const_iterator to the end of the constraints' map
   * @return end
   */
  const_iterator cend() const;

 private:
  std::string id_;                                                                          ///< ConstraintCollection's id
  std::map<std::string, std::vector<std::shared_ptr<Constraint> > > constraintsByModel_;  ///< constraint sorted by model
  std::map<std::string, std::shared_ptr<Constraint> > constraintsById_;                   ///< constraint sorted by id
};

}  // end of namespace constraints

#endif  // API_CSTR_CSTRCONSTRAINTSCOLLECTION_H_
