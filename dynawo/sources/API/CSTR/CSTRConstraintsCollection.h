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
 * @file  CSTRConstraintsCollection.h
 *
 * @brief Dynawo constraints : interface file
 *
 */

#ifndef API_CSTR_CSTRCONSTRAINTSCOLLECTION_H_
#define API_CSTR_CSTRCONSTRAINTSCOLLECTION_H_

#include <string>
#include <boost/shared_ptr.hpp>

#include "CSTRConstraintCommon.h"

namespace constraints {
class Constraint;

/**
 * @class ConstraintsCollection
 * @brief contraints interface class
 *
 * Interface class for ContraintsCollection object. This a container for constraints
 */
class ConstraintsCollection {
 public:
  /**
   * @brief Destructor
   */
  virtual ~ConstraintsCollection() { }

  /**
   * @brief Add a constraint to the collection
   *
   * @param modelName model where the constraint occurs
   * @param description description of the constraint
   * @param time time when the constraint occurs
   * @param type begin/end
   * @param modelType type of the model
   * @param side side on which the constraint occurs
   */
  virtual void addConstraint(const std::string& modelName, const std::string& description, const double& time, Type_t type,
      const std::string& modelType = "", const std::string& side = "") = 0;

  class Impl;

 protected:
  class BaseIteratorImpl;  // Abstract class, for the interface

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
     * @returns Created const_iterator.
     */
    const_iterator(const ConstraintsCollection::Impl* iterated, bool begin);

    /**
     * @brief Copy constructor
     * @param original : iterator to copy
     */
    const_iterator(const const_iterator& original);

    /**
     * @brief Destructor
     */
    ~const_iterator();

    /**
     * @brief assignment
     * @param other : const_iterator to assign
     *
     * @returns Reference to this const_iterator
     */
    const_iterator& operator=(const const_iterator& other);

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
    const boost::shared_ptr<Constraint>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the Constraint pointed to by this
     */
    const boost::shared_ptr<Constraint>* operator->() const;

   private:
    BaseIteratorImpl* impl_; /**< Pointer to the implementation of iterator */
  };

  /**
   * @brief Get a const_iterator to the beginning of the constraints' map
   * @return beginning
   */
  virtual const_iterator cbegin() const = 0;

  /**
   * @brief Get a const_iterator to the end of the constraints' map
   * @return end
   */
  virtual const_iterator cend() const = 0;
};

}  // end of namespace constraints

#endif  // API_CSTR_CSTRCONSTRAINTSCOLLECTION_H_
