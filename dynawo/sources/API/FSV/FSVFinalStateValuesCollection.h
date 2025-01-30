//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  FSVFinalStateValuesCollection.h
 *
 * @brief Final state values collection description : interface file
 *
 */

#ifndef API_FSV_FSVFINALSTATEVALUESCOLLECTION_H_
#define API_FSV_FSVFINALSTATEVALUESCOLLECTION_H_

#include "FSVFinalStateValue.h"

#include <string>
#include <vector>
#include <memory>


namespace finalStateValues {

/**
 * @class FinalStateValuesCollection
 * @brief Final state values collection interface class
 *
 * Interface class for final state values collection object. This is a container for final state values
 */
class FinalStateValuesCollection {
 public:
  /**
   * @brief constructor
   *
   * @param id finalStateValuesCollection's id
   */
  explicit FinalStateValuesCollection(const std::string& id);

  /**
   * @brief add a final state value to the collection
   *
   * @param finalStateValue state value final state value to add to the collection
   */
  void add(const std::shared_ptr<FinalStateValue>& finalStateValue);

  /**
   * @brief add a new point for each final state value
   *
   * @param time time of the new point
   */
  void updateFinalStateValues(double time);

 public:
  /**
   * @class iterator
   * @brief iterator over final state values
   *
   * iterator over final state values stored in final state values collection
   */
  class iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on final state values. Can create an iterator to the
     * beginning of the final state values' container or to the end. Final state
     * values can be modified.
     *
     * @param iterated Pointer to the final state values' collection iterated
     * @param begin Flag indicating if the iterator point to the beginning
     * (true) or the end of the final state values' container.
     */
    iterator(FinalStateValuesCollection* iterated, bool begin);

    /**
     * @brief Prefix-increment operator
     *
     * @returns Reference to this iterator
     */
    iterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this iterator
     */
    iterator operator++(int);

    /**
     * @brief Prefix-decrement operator
     *
     * @returns Reference to this iterator
     */
    iterator& operator--();

    /**
     * @brief Postfix-decrement operator
     *
     * @returns Copy of this iterator
     */
    iterator operator--(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are equals, else false
     */
    bool operator==(const iterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are different, else false
     */
    bool operator!=(const iterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns Final state value pointed to by this
     */
    std::shared_ptr<FinalStateValue>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns FinalStateValue pointed to by this
     */
    std::shared_ptr<FinalStateValue>* operator->() const;

   private:
    std::vector<std::shared_ptr<FinalStateValue> >::iterator current_;  ///< current vector iterator
  };

  /**
   * @class const_iterator
   * @brief Const iterator over final state values
   *
   * Const iterator over final state values stored in collection
   */
  class const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on final state values. Can create a const iterator to
     * the beginning of the final state values' container or to the end. Final
     * state values cannot be modified.
     *
     * @param iterated Pointer to the final state values' collection iterated
     * @param begin Flag indicating if the iterator point to the beginning
     * (true) or the end of the final state values' container.
     */
    const_iterator(const FinalStateValuesCollection* iterated, bool begin);

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
     * @returns true if const_iterators are equals, else false
     */
    bool operator==(const const_iterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if const_iterators are different, else false
     */
    bool operator!=(const const_iterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns FinalStateValue pointed to by this
     */
    const std::shared_ptr<FinalStateValue>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns FinalStateValue pointed to by this
     */
    const std::shared_ptr<FinalStateValue>* operator->() const;

   private:
    std::vector<std::shared_ptr<FinalStateValue> >::const_iterator current_;  ///< current vector const iterator
  };

  /**
   * @brief Get a const_iterator to the beginning of the final state values' vector
   * @return a const_iterator to the beginning of the final state values' vector
   */
  const_iterator cbegin() const;

  /**
   * @brief Get a const_iterator to the end of the final state values' vector
   * @return a const_iterator to the end of the final state values' vector
   */
  const_iterator cend() const;

  /**
   * @brief Get an iterator to the beginning of the final state values' vector
   * @return an iterator to the beginning of the final state values' vector
   */
  iterator begin();

  /**
   * @brief Get an iterator to the end of the final state values' vector
   * @return an iterator to the end of the final state values' vector
   */
  iterator end();

 private:
  std::vector<std::shared_ptr<FinalStateValue> > finalStateValues_;   ///< Vector of the final state values object
  std::string id_;                                                    ///< Final state values collections id
};

}  // namespace finalStateValues

#endif  // API_FSV_FSVFINALSTATEVALUESCOLLECTION_H_
