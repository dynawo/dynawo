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

#include "FSVariable.h"

#include <boost/shared_ptr.hpp>
#include <vector>

namespace finalState {

class FinalStateModel;
class FinalStateCollection;

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
  finalStateModel_const_iterator(const FinalStateCollection* iterated, bool begin);

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
  finalStateModel_const_iterator(const FinalStateModel* iterated, bool begin);

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
  const boost::shared_ptr<FinalStateModel>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Model pointed to by this
   */
  const boost::shared_ptr<FinalStateModel>* operator->() const;

 private:
  std::vector<boost::shared_ptr<FinalStateModel> >::const_iterator current_;  ///< current vector const iterator
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
  finalStateModel_iterator(FinalStateCollection* iterated, bool begin);

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
  finalStateModel_iterator(FinalStateModel* iterated, bool begin);

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
  boost::shared_ptr<FinalStateModel>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Model pointed to by this
   */
  boost::shared_ptr<FinalStateModel>* operator->() const;

 private:
  std::vector<boost::shared_ptr<FinalStateModel> >::iterator current_;  ///< current vector iterator
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
  finalStateVariable_const_iterator(const FinalStateCollection* iterated, bool begin);

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
  finalStateVariable_const_iterator(const FinalStateModel* iterated, bool begin);

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
  std::vector<boost::shared_ptr<Variable> >::const_iterator current_;  ///< current vector const iterator
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
  finalStateVariable_iterator(FinalStateCollection* iterated, bool begin);

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
  finalStateVariable_iterator(FinalStateModel* iterated, bool begin);

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

 private:
  std::vector<boost::shared_ptr<Variable> >::iterator current_;  ///< current vector iterator
};

}  // namespace finalState

#endif  // API_FS_FSITERATORS_H_
