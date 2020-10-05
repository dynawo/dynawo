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
 * @file  EXTVARIteratorsImpl.h
 *
 * @brief
 *
 */
#ifndef API_EXTVAR_EXTVARITERATORSIMPL_H_
#define API_EXTVAR_EXTVARITERATORSIMPL_H_

#include <string>

#include "EXTVARVariablesCollectionImpl.h"

namespace externalVariables {

class Variable;

/**
 * @class VariablesIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class VariablesIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on VariablesCollection. Can create an implementation for
   * an iterator to the beginning of the variables' container or to the end.
   *
   * @param iterated Pointer to the models' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the variables' container.
   * @returns Created implementation object
   */
  VariablesIteratorImpl(VariablesCollection::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~VariablesIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  VariablesIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  VariablesIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  VariablesIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  VariablesIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns if iterators are equal
   */
  bool operator==(const VariablesIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns if iterators are different
   */
  bool operator!=(const VariablesIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Variable pointed to by this
   */
  boost::shared_ptr<Variable>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Variable pointed to by this
   */
  boost::shared_ptr<Variable>* operator->() const;

  /**
   * @brief Get the current iterator
   *
   * @returns Current iterator
   */
  std::map<std::string, boost::shared_ptr<Variable> >::iterator current() const;

 private:
  std::map<std::string, boost::shared_ptr<Variable> >::iterator current_;  ///< current map iterator
};

/**
 * @class VariablesConstIteratorImpl
 * @brief Implementation class for const iterators' functions
 */
class VariablesConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on VariablesCollection. Can create an implementation for
   * a const iterator to the beginning of the variables' container or to the end.
   *
   * @param iterated Pointer to the models' vector iterated
   * @param begin Flag indicating if the const iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created implementation object (as const)
   */
  VariablesConstIteratorImpl(const VariablesCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the vector
   * @returns Created constant iterator
   */
  explicit VariablesConstIteratorImpl(const VariablesIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~VariablesConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  VariablesConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  VariablesConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  VariablesConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  VariablesConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns if iterators are equal
   */
  bool operator==(const VariablesConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns if iterators are different
   */
  bool operator!=(const VariablesConstIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Variable pointed to by this
   */
  const boost::shared_ptr<Variable>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Variable pointed to by this
   */
  const boost::shared_ptr<Variable>* operator->() const;

 private:
  std::map<std::string, boost::shared_ptr<Variable> >::const_iterator current_;  ///< current vector const iterator
};


}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARITERATORSIMPL_H_
