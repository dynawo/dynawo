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
 * @file PARParametersSetCollection.h
 * @brief Dynawo parameters set collection : interface file
 *
 */

#ifndef API_PAR_PARPARAMETERSSETCOLLECTION_H_
#define API_PAR_PARPARAMETERSSETCOLLECTION_H_

#include <string>

#include <boost/shared_ptr.hpp>

#include "PARExport.h"

namespace parameters {

class ParametersSet;

/**
 * @class ParametersSetCollection
 * @brief Parameters set collection interface class
 *
 * ParametersSetCollection objects describe collection parameters' set.
 */
class __DYNAWO_PAR_EXPORT ParametersSetCollection {
 public:
  /**
   * @brief Add a parameters set in the collection
   *
   * Add a parameter set in the collection
   *
   * @param[in] paramSet Parameters' set to add
   * @param[in] force If true, forces the set adding in the collection
   * in case an id already exists by creating a unique id for it
   * @throws Error::API exception if force is false and a set with given
   * ID already exists.
   */
  virtual void addParametersSet(boost::shared_ptr<ParametersSet> paramSet, bool force = false) = 0;

  /**
   * @brief Get parameters set with current id if available in the collection
   *
   * @param[in] id ID of wanted parameter set
   * @returns Reference to wanted ParametersSet instance
   * @throws Error::API exception if set with given ID do not exists
   */
  virtual boost::shared_ptr<ParametersSet> getParametersSet(const std::string& id) = 0;

  /**
   * @brief Check if a parameter set is in the collection
   *
   * @param[in] id Name of the parameter set
   * @returns Existence of the parameter set in the collection
   */
  virtual bool hasParametersSet(const std::string& id) = 0;

  class Impl;

 protected:
  class BaseIteratorImpl;  // Abstract class, for the interface

 public:
  /**
   * @class parametersSet_const_iterator
   * @brief Const iterator over parameters' set
   *
   * Const iterator over parameters' set listed in a collection.
   */
  class parametersSet_const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on parameter's set collection. Can create an iterator to the
     * beginning of the parameters' set container or to the end. ParametersSet objects
     * cannot be modified.
     *
     * @param iterated Pointer to the parameters' set collection iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the parameters' sets container.
     * @returns Created parametersSet_const_iterator.
     */
    parametersSet_const_iterator(const ParametersSetCollection::Impl* iterated, bool begin);

    /**
     * @brief Copy constructor
     * @param original : const iterator to copy
     */
    parametersSet_const_iterator(const parametersSet_const_iterator& original);

    /**
     * @brief Destructor
     */
    ~parametersSet_const_iterator();

    /**
     * @brief Prefix-increment operator
     *
     * @returns Reference to this parametersSet_const_iterator
     */
    parametersSet_const_iterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this parametersSet_const_iterator
     */
    parametersSet_const_iterator operator++(int);

    /**
     * @brief Prefix-decrement operator
     *
     * @returns Reference to this parametersSet_const_iterator
     */
    parametersSet_const_iterator& operator--();

    /**
     * @brief Postfix-decrement operator
     *
     * @returns Copy of this parametersSet_const_iterator
     */
    parametersSet_const_iterator operator--(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are equals, else false
     */
    bool operator==(const parametersSet_const_iterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are different, else false
     */
    bool operator!=(const parametersSet_const_iterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns Parameters' set pointed to by this
     */
    const boost::shared_ptr<ParametersSet>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the ParametersSet pointed to by this
     */
    const boost::shared_ptr<ParametersSet>* operator->() const;

   private:
    BaseIteratorImpl* impl_; /**< Pointer to the implementation of iterator */
  };

  /**
   * @brief Get a parametersSet_const_iterator to the beginning of the parameters' set collection
   * @return beginning of constant iterator
   */
  virtual parametersSet_const_iterator cbeginParametersSet() const = 0;

  /**
   * @brief Get a parametersSet_const_iterator to the end of the parameters' set collection
   * @return end of constant iterator
   */
  virtual parametersSet_const_iterator cendParametersSet() const = 0;
};

}  // namespace parameters

#endif  // API_PAR_PARPARAMETERSSETCOLLECTION_H_
