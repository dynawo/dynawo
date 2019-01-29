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
 * @file  EXTVARIterators.h
 *
 * @brief interface for external variables iterators
 *
 */
#ifndef API_EXTVAR_EXTVARITERATORS_H_
#define API_EXTVAR_EXTVARITERATORS_H_

#include "EXTVARVariablesCollectionImpl.h"

namespace externalVariables {

class Variable;
class VariablesIteratorImpl;
class VariablesConstIteratorImpl;

/**
 * @class variable_iterator
 * @brief iterator over models
 *
 * iterator over models stored in dynamic models collection
 */
class variable_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on models. Can create an iterator to the
   * beginning of the models' container or to the end. Models
   * can be modified.
   *
   * @param iterated Pointer to the dynamic models collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created variable_iterator.
   */
  variable_iterator(VariablesCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : variable iterator to copy
   */
  variable_iterator(const variable_iterator& original);

  /**
   * @brief Destructor
   */
  ~variable_iterator();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this variable_iterator
   */
  variable_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this variable_iterator
   */
  variable_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this variable_iterator
   */
  variable_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this variable_iterator
   */
  variable_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if continuous_variable_iterators are equals, else false
   */
  bool operator==(const variable_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if continuous_variable_iterators are different, else false
   */
  bool operator!=(const variable_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns Variable pointed to by this
   */
  boost::shared_ptr<Variable>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Variable pointed to by this
   */
  boost::shared_ptr<Variable>* operator->() const;

  /**
   * @brief Get the implementation ot the iterator
   * @return the implementation ot the iterator
   */
  VariablesIteratorImpl* impl() const;

 private:
  VariablesIteratorImpl* impl_;  ///< Pointer to the implementation of the model iterator;
};

/**
 * @class variable_const_iterator
 * @brief const iterator over models
 *
 * const iterator over models stored in dynamic models collection
 */
class variable_const_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on models. Can create a const iterator to the
   * beginning of the models' container or to the end. Models
   * cannot be modified.
   *
   * @param iterated Pointer to the final states collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created variable_const_iterator.
   */
  variable_const_iterator(const VariablesCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the variable const iterator to copy
   */
  variable_const_iterator(const variable_const_iterator& original);

  /**
   * @brief Constructor
   *
   * @param original current iterator
   * @returns Created variable_const_iterator
   */
  explicit variable_const_iterator(const variable_iterator& original);

  /**
   * @brief Destructor
   */
  ~variable_const_iterator();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this variable_const_iterator
   */
  variable_const_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this variable_const_iterator
   */
  variable_const_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this variable_const_iterator
   */
  variable_const_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this variable_const_iterator
   */
  variable_const_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if continuous_variable_const_iterators are equals, else false
   */
  bool operator==(const variable_const_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if continuous_variable_const_iterators are different, else false
   */
  bool operator!=(const variable_const_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns Variable pointed to by this
   */
  const boost::shared_ptr<Variable>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Variable pointed to by this
   */
  const boost::shared_ptr<Variable>* operator->() const;

 private:
  VariablesConstIteratorImpl* impl_;  ///< Pointer to the implementation of the model const iterator;
};

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARITERATORS_H_


