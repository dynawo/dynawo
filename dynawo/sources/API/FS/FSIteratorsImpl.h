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
 * @file  FSIterators.h
 *
 * @brief
 *
 */
#ifndef API_FS_FSITERATORSIMPL_H_
#define API_FS_FSITERATORSIMPL_H_

#include "FSFinalStateCollectionImpl.h"
#include "FSModelImpl.h"

namespace finalState {
class FinalStateModel;
class Variable;

/**
 * @class FinalStateModelIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class FinalStateModelIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on finalStateCollection. Can create an implementation for
   * an iterator to the beginning of the models' container or to the end.
   *
   * @param iterated Pointer to the models' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created implementation object
   */
  FinalStateModelIteratorImpl(FinalStateCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * Constructor based on model. Can create an implementation for
   * an iterator to the beginning of the models' container or to the end.
   *
   * @param iterated Pointer to the models' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created implementation object
   */
  FinalStateModelIteratorImpl(FinalStateModel::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~FinalStateModelIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  FinalStateModelIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  FinalStateModelIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  FinalStateModelIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  FinalStateModelIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const FinalStateModelIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const FinalStateModelIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Model pointed to by this
   */
  boost::shared_ptr<FinalStateModel>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Model pointed to by this
   */
  boost::shared_ptr<FinalStateModel>* operator->() const;

  /**
   * @brief Get the current iterator
   *
   * @returns Current iterator
   */
  std::vector<boost::shared_ptr<FinalStateModel> >::iterator current() const;

 private:
  std::vector<boost::shared_ptr<FinalStateModel> >::iterator current_;  ///< current vector iterator
};

/**
 * @class FinalStateModelConstIteratorImpl
 * @brief Implementation class for const iterators' functions
 */
class FinalStateModelConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on finalStateCollection. Can create an implementation for
   * a const iterator to the beginning of the models' container or to the end.
   *
   * @param iterated Pointer to the models' vector iterated
   * @param begin Flag indicating if the const iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created implementation object
   */
  FinalStateModelConstIteratorImpl(const FinalStateCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * Constructor based on model. Can create an implementation for
   * a const iterator to the beginning of the models' container or to the end.
   *
   * @param iterated Pointer to the models' vector iterated
   * @param begin Flag indicating if the const iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created implementation object
   */
  FinalStateModelConstIteratorImpl(const FinalStateModel::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the vector
   * @returns Created constant iterator
   */
  explicit FinalStateModelConstIteratorImpl(const FinalStateModelIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~FinalStateModelConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  FinalStateModelConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  FinalStateModelConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  FinalStateModelConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  FinalStateModelConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const FinalStateModelConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const FinalStateModelConstIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Model pointed to by this
   */
  const boost::shared_ptr<FinalStateModel>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Model pointed to by this
   */
  const boost::shared_ptr<FinalStateModel>* operator->() const;

 private:
  std::vector<boost::shared_ptr<FinalStateModel> >::const_iterator current_;  ///< current vector const iterator
};

/**
 * @class VariableIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class VariableIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on finalStateCollection. Can create an implementation for
   * an iterator to the beginning of the variables' container or to the end.
   *
   * @param iterated Pointer to the variables' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the variables' container.
   * @returns Created implementation object
   */
  VariableIteratorImpl(FinalStateCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * Constructor based on model. Can create an implementation for
   * an iterator to the beginning of the variables' container or to the end.
   *
   * @param iterated Pointer to the variables' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the variables' container.
   * @returns Created implementation object
   */
  VariableIteratorImpl(FinalStateModel::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~VariableIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  VariableIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  VariableIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  VariableIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  VariableIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const VariableIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const VariableIteratorImpl& other)const;

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
  std::vector<boost::shared_ptr<Variable> >::iterator current() const;

 private:
  std::vector<boost::shared_ptr<Variable> >::iterator current_;  ///< current vector iterator
};

/**
 * @class VariableConstIteratorImpl
 * @brief Implementation class for constant iterators' functions
 */
class VariableConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on finalStateCollection. Can create an implementation for
   * a const iterator to the beginning of the variables' container or to the end.
   *
   * @param iterated Pointer to the variables' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the variables' container.
   * @returns Created implementation object
   */
  VariableConstIteratorImpl(const FinalStateCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * Constructor based on model. Can create an implementation for
   * a const iterator to the beginning of the variables' container or to the end.
   *
   * @param iterated Pointer to the variables' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the variables' container.
   * @returns Created implementation object
   */
  VariableConstIteratorImpl(const FinalStateModel::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the vector
   * @returns Created constant iterator
   */
  explicit VariableConstIteratorImpl(const VariableIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~VariableConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  VariableConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  VariableConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  VariableConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  VariableConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const VariableConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const VariableConstIteratorImpl& other)const;

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
  std::vector<boost::shared_ptr<Variable> >::const_iterator current_;  ///< current vector const iterator
};

}  // namespace finalState

#endif  // API_FS_FSITERATORSIMPL_H_
