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
 * @file  CRVCurvesCollection.h
 *
 * @brief Curves collection description : interface file
 *
 */

#ifndef API_CRV_CRVCURVESCOLLECTION_H_
#define API_CRV_CRVCURVESCOLLECTION_H_

#include "CRVCurve.h"

#include <boost/shared_ptr.hpp>
#include <string>

namespace curves {

/**
 * @class CurvesCollection
 * @brief Curves collection interface class
 *
 * Interface class for curves collection object. This a container for curves
 */
class CurvesCollection {
 public:
    /**
   * @brief constructor
   *
   * @param id curvesCollection's id
   */
  explicit CurvesCollection(const std::string& id);

  /**
   * @brief add a curve to the collection
   *
   * @param curve curve to add to the collection
   */
  void add(const boost::shared_ptr<Curve>& curve);

  /**
   * @brief add a new point for each curve
   *
   * @param time time of the new point
   */
  void updateCurves(const double& time);

 public:
  /**
   * @class iterator
   * @brief iterator over curves
   *
   * iterator over curves stored in curves collection
   */
  class iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on curves. Can create an iterator to the
     * beginning of the curves' container or to the end. Curves
     * can be modified.
     *
     * @param iterated Pointer to the curves' collection iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the curves' container.
     */
    iterator(CurvesCollection* iterated, bool begin);

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
     * @returns Curve pointed to by this
     */
    boost::shared_ptr<Curve>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Curve pointed to by this
     */
    boost::shared_ptr<Curve>* operator->() const;

   private:
    std::vector<boost::shared_ptr<Curve> >::iterator current_;  ///< current vector iterator
  };

  /**
   * @class const_iterator
   * @brief Const iterator over curves
   *
   * Const iterator over curves stored in collection
   */
  class const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on curves. Can create a const iterator to the
     * beginning of the curves' container or to the end. Curves
     * cannot be modified.
     *
     * @param iterated Pointer to the curves' collection iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the curves' container.
     */
    const_iterator(const CurvesCollection* iterated, bool begin);

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
     * @returns Curve pointed to by this
     */
    const boost::shared_ptr<Curve>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Curve pointed to by this
     */
    const boost::shared_ptr<Curve>* operator->() const;

   private:
    std::vector<boost::shared_ptr<Curve> >::const_iterator current_;  ///< current vector const iterator
  };

  /**
   * @brief Get a const_iterator to the beginning of the curves' vector
   * @return a const_iterator to the beginning of the curves' vector
   */
  const_iterator cbegin() const;

  /**
   * @brief Get a const_iterator to the end of the curves' vector
   * @return a const_iterator to the end of the curves' vector
   */
  const_iterator cend() const;

  /**
   * @brief Get an iterator to the beginning of the curves' vector
   * @return an iterator to the beginning of the curves' vector
   */
  iterator begin();

  /**
   * @brief Get an iterator to the end of the curves' vector
   * @return an iterator to the end of the curves' vector
   */
  iterator end();

 private:
  std::vector<boost::shared_ptr<Curve> > curves_;  ///< Vector of the curves object
  std::string id_;                                 ///< Curves collections id
};

}  // namespace curves

#endif  // API_CRV_CRVCURVESCOLLECTION_H_
