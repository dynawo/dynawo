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
 * @file  CRVOutputStreamCollection.h
 *
 * @brief Outputs collection description : interface file
 *
 */

#ifndef API_IO_IOOUTPUTSCOLLECTION_H_
#define API_IO_IOOUTPUTSCOLLECTION_H_

#include "IOOutput.h"

#include <string>

namespace io {

/**
 * @class OutputStreamCollection
 * @brief Outputs collection interface class
 *
 * Interface class for outputs collection object. This a container for outputs
 */
class OutputsCollection {
 public:
    /**
   * @brief constructor
   */
  explicit OutputsCollection() {};

  /**
   * @brief add an output stream to the collection
   *
   * @param output output to add to the collection
   */
  void add(const std::shared_ptr<Output>& output);

  // /**
  //  * @brief send values based of all recorded outputs
  //  *
  //  * @param time time of the new point
  //  */
  // void send(const double& time);

 public:
  /**
   * @class iterator
   * @brief iterator over outputs
   *
   * iterator over outputs stored in outputs collection
   */
  class iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on outputs. Can create an iterator to the
     * beginning of the outputs' container or to the end. outputs
     * can be modified.
     *
     * @param iterated Pointer to the outputs' collection iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the outputs' container.
     */
    iterator(OutputsCollection* iterated, bool begin);

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
     * @returns Output pointed to by this
     */
    std::shared_ptr<Output>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Output pointed to by this
     */
    std::shared_ptr<Output>* operator->() const;

   private:
    std::vector<std::shared_ptr<Output> >::iterator current_;  ///< current vector iterator
  };

  /**
   * @class const_iterator
   * @brief Const iterator over outputs
   *
   * Const iterator over outputs stored in collection
   */
  class const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on outputs. Can create a const iterator to the
     * beginning of the outputs' container or to the end. Outputs
     * cannot be modified.
     *
     * @param iterated Pointer to the outputs' collection iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the outputs' container.
     */
    const_iterator(const OutputsCollection* iterated, bool begin);

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
     * @returns Output pointed to by this
     */
    const std::shared_ptr<Output>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Output pointed to by this
     */
    const std::shared_ptr<Output>* operator->() const;

   private:
    std::vector<std::shared_ptr<Output> >::const_iterator current_;  ///< current vector const iterator
  };

  /**
   * @brief Get a const_iterator to the beginning of the outputs' vector
   * @return a const_iterator to the beginning of the outputs' vector
   */
  const_iterator cbegin() const;

  /**
   * @brief Get a const_iterator to the end of the outputs' vector
   * @return a const_iterator to the end of the outputs' vector
   */
  const_iterator cend() const;

  /**
   * @brief Get an iterator to the beginning of the outputs' vector
   * @return an iterator to the beginning of the outputs' vector
   */
  iterator begin();

  /**
   * @brief Get an iterator to the end of the outputs' vector
   * @return an iterator to the end of the outputs' vector
   */
  iterator end();

 private:
  std::vector<std::shared_ptr<Output> > outputs_;  ///< Vector of the output objects
  // std::shared_ptr<OutputConnectorInterface>;
};

}  // namespace outputs

#endif  // API_IO_IOOUTPUTSCOLLECTION_H_
