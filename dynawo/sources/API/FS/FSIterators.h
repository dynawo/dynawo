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
#ifndef API_FS_FSITERATORS_H_
#define API_FS_FSITERATORS_H_

#include "FSFinalStateCollectionImpl.h"
#include "FSModelImpl.h"

namespace finalState {
class Model;
class Variable;
class ModelConstIteratorImpl;
class ModelIteratorImpl;
class VariableConstIteratorImpl;
class VariableIteratorImpl;

/**
 * @class finalStateModel_const_iterator
 * @brief const iterator over models
 *
 * const iterator over models stored in final state collection or in models
 */
class finalStateModel_const_iterator {
 public:
  /**
   * @brief this
   */
  typedef finalStateModel_const_iterator THIS;
  /**
   * @brief Constructor
   *
   * Constructor based on models. Can create a const iterator to the
   * beginning of the finalstateCollections' container or to the end. Models
   * cannot be modified.
   *
   * @param iterated Pointer to the final states collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created model_const_iterator.
   */
  finalStateModel_const_iterator(const FinalStateCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * Constructor based on models. Can create a const iterator to the
   * beginning of the models' container or to the end. Models
   * cannot be modified.
   *
   * @param iterated Pointer to the model iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created model_const_iterator.
   */
  finalStateModel_const_iterator(const Model::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : model const iterator to copy
   */
  finalStateModel_const_iterator(const finalStateModel_const_iterator& original);

  /**
   * @brief Constructor
   *
   * @param original current iterator
   * @returns Created model_const_iterator
   */
  explicit finalStateModel_const_iterator(const finalStateModel_iterator& original);

  /**
   * @brief Destructor
   */
  ~finalStateModel_const_iterator();

  /**
   * @brief assignment
   * @param other : model_const_iterator to assign
   *
   * @returns Reference to this model_const_iterator
   */
  THIS& operator=(const THIS& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this model_const_iterator
   */
  THIS& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this model_const_iterator
   */
  THIS operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this model_const_iterator
   */
  THIS& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this model_const_iterator
   */
  THIS operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if model_const_iterators are equals, else false
   */
  bool operator==(const THIS& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if model_const_iterators are different, else false
   */
  bool operator!=(const THIS& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns Model pointed to by this
   */
  const boost::shared_ptr<Model>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Model pointed to by this
   */
  const boost::shared_ptr<Model>* operator->() const;

 private:
  ModelConstIteratorImpl* impl_;  ///< Pointer to the implementation of the model const iterator;
};

/**
 * @class finalStateModel_iterator
 * @brief iterator over models
 *
 * iterator over models stored in final state collection or in models
 */
class finalStateModel_iterator {
 public:
  /**
   * @brief this
   */
  typedef finalStateModel_iterator THIS;
  /**
   * @brief Constructor
   *
   * Constructor based on models. Can create an iterator to the
   * beginning of the finalstateCollections' container or to the end. Models
   * can be modified.
   *
   * @param iterated Pointer to the final states collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created model_iterator.
   */
  finalStateModel_iterator(FinalStateCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * Constructor based on models. Can create an iterator to the
   * beginning of the models' container or to the end. Models
   * can be modified.
   *
   * @param iterated Pointer to the model iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created model_iterator.
   */
  finalStateModel_iterator(Model::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original: model iterator to copy
   */
  finalStateModel_iterator(const finalStateModel_iterator& original);

  /**
   * @brief Destructor
   */
  ~finalStateModel_iterator();

  /**
   * @brief assignment
   * @param other : model_iterator to assign
   *
   * @returns Reference to this model_iterator
   */
  THIS& operator=(const THIS& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this model_iterator
   */
  THIS& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this model_iterator
   */
  THIS operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this model_iterator
   */
  THIS& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this model_iterator
   */
  THIS operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if model_iterators are equals, else false
   */
  bool operator==(const THIS& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if model_iterators are different, else false
   */
  bool operator!=(const THIS& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns Model pointed to by this
   */
  boost::shared_ptr<Model>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Model pointed to by this
   */
  boost::shared_ptr<Model>* operator->() const;

  /**
   * @brief Get the implementation ot the iterator
   * @return the implementation ot the iterator
   */
  ModelIteratorImpl* impl() const;

 private:
  ModelIteratorImpl* impl_;  ///< Pointer to the implementation of the model iterator;
};

/**
 * @class finalStateVariable_const_iterator
 * @brief const iterator over variables
 *
 * const iterator over variables stored in final state collection or in models
 */
class finalStateVariable_const_iterator {
 public:
  /**
   * @brief this
   */
  typedef finalStateVariable_const_iterator THIS;
  /**
   * @brief Constructor
   *
   * Constructor based on variables. Can create a const iterator to the
   * beginning of the finalstateCollections' container or to the end. Variables
   * cannot be modified.
   *
   * @param iterated Pointer to the final states collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the variables' container.
   * @returns Created variable_const_iterator.
   */
  finalStateVariable_const_iterator(const FinalStateCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * Constructor based on variables. Can create a const iterator to the
   * beginning of the variables' container or to the end. Variables
   * cannot be modified.
   *
   * @param iterated Pointer to the model iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the variables' container.
   * @returns Created variable_const_iterator.
   */
  finalStateVariable_const_iterator(const Model::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : variable const iterator to copy
   */
  finalStateVariable_const_iterator(const finalStateVariable_const_iterator& original);

  /**
   * @brief Constructor
   *
   * @param original current iterator
   * @returns Created model_const_iterator
   */
  explicit finalStateVariable_const_iterator(const finalStateVariable_iterator& original);

  /**
   * @brief Destructor
   */
  ~finalStateVariable_const_iterator();

  /**
   * @brief assignment
   * @param other : variable_const_iterator to assign
   *
   * @returns Reference to this variable_const_iterator
   */
  THIS& operator=(const THIS& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this variable_const_iterator
   */
  THIS& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this variable_const_iterator
   */
  THIS operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this variable_const_iterator
   */
  THIS& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this variable_const_iterator
   */
  THIS operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if variable_const_iterators are equals, else false
   */
  bool operator==(const THIS& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if variable_const_iterators are different, else false
   */
  bool operator!=(const THIS& other) const;

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
  VariableConstIteratorImpl* impl_;  ///< Pointer to the implementation of the variable const iterator;
};

/**
 * @class finalStateVariable_iterator
 * @brief iterator over variables
 *
 * iterator over variables stored in final state collection or in models
 */
class finalStateVariable_iterator {
 public:
  /**
   * @brief this
   */
  typedef finalStateVariable_iterator THIS;
  /**
   * @brief Constructor
   *
   * Constructor based on variables. Can create an iterator to the
   * beginning of the finalstateCollections' container or to the end. Variables
   * can be modified.
   *
   * @param iterated Pointer to the final states collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the variables' container.
   * @returns Created variable_iterator.
   */
  finalStateVariable_iterator(FinalStateCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * Constructor based on variables. Can create an iterator to the
   * beginning of the variables' container or to the end. Variables
   * can be modified.
   *
   * @param iterated Pointer to the model iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the variables' container.
   * @returns Created variable_iterator.
   */
  finalStateVariable_iterator(Model::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : variable iterator to copy
   */
  finalStateVariable_iterator(const finalStateVariable_iterator& original);

  /**
   * @brief Destructor
   */
  ~finalStateVariable_iterator();

  /**
   * @brief assignment
   * @param other : variable_iterator to assign
   *
   * @returns Reference to this variable_iterator
   */
  THIS& operator=(const THIS& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this variable_iterator
   */
  THIS& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this variable_iterator
   */
  THIS operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this variable_iterator
   */
  THIS& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this variable_iterator
   */
  THIS operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if variable_iterators are equals, else false
   */
  bool operator==(const THIS& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if variable_iterators are different, else false
   */
  bool operator!=(const THIS& other) const;

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
   * @return the implementation of the iterator
   */
  VariableIteratorImpl* impl() const;

 private:
  VariableIteratorImpl* impl_;  ///< Pointer to the implementation of the variable iterator;
};

}  // namespace finalState

#endif  // API_FS_FSITERATORS_H_
