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
class Model;
class Variable;

/**
 * @class ModelIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class ModelIteratorImpl {
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
  ModelIteratorImpl(FinalStateCollection::Impl* iterated, bool begin);

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
  ModelIteratorImpl(Model::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~ModelIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  ModelIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  ModelIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  ModelIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  ModelIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const ModelIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const ModelIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Model pointed to by this
   */
  boost::shared_ptr<Model>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Model pointed to by this
   */
  boost::shared_ptr<Model>* operator->() const;

  /**
   * @brief Get the current iterator
   *
   * @returns Current iterator
   */
  std::vector<boost::shared_ptr<Model> >::iterator current() const;

 private:
  std::vector<boost::shared_ptr<Model> >::iterator current_;  ///< current vector iterator
};

/**
 * @class ModelConstIteratorImpl
 * @brief Implementation class for const iterators' functions
 */
class ModelConstIteratorImpl {
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
  ModelConstIteratorImpl(const FinalStateCollection::Impl* iterated, bool begin);

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
  ModelConstIteratorImpl(const Model::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the vector
   * @returns Created constant iterator
   */
  explicit ModelConstIteratorImpl(const ModelIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~ModelConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  ModelConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  ModelConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  ModelConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  ModelConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const ModelConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const ModelConstIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Model pointed to by this
   */
  const boost::shared_ptr<Model>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Model pointed to by this
   */
  const boost::shared_ptr<Model>* operator->() const;

 private:
  std::vector<boost::shared_ptr<Model> >::const_iterator current_;  ///< current vector const iterator
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
  VariableIteratorImpl(Model::Impl* iterated, bool begin);

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
  VariableConstIteratorImpl(const Model::Impl* iterated, bool begin);

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
