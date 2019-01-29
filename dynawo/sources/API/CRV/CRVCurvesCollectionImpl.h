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
 * @file  CRVCurvesCollectionImpl.h
 *
 * @brief Curve collection : header file
 *
 */

#ifndef API_CRV_CRVCURVESCOLLECTIONIMPL_H_
#define API_CRV_CRVCURVESCOLLECTIONIMPL_H_

#include <vector>
#include <string>
#include <boost/shared_ptr.hpp>

#include "CRVCurvesCollection.h"

namespace curves {
class Curve;

/**
 * @class CurvesCollection::Impl
 * @brief CurvesCollection implemented class
 *
 * Implementation of Curves collection interface class
 */
class CurvesCollection::Impl : public CurvesCollection {
 public:
  /**
   * @brief constructor
   *
   * @param id curvesCollection's id
   */
  explicit Impl(const std::string& id);

  /**
   * @brief Destructor
   */
  virtual ~Impl();

  /**
   * @copydoc CurvesCollection::add(const boost::shared_ptr<Curve>& curve)
   */
  void add(const boost::shared_ptr<Curve>& curve);

  /**
   * @copydoc CurvesCollection::updateCurves(const double& time)
   */
  void updateCurves(const double& time);

  /**
   * @brief get a const_iterator to the beginning of the curves' vector
   * @return a const_iterator to the beginning of the curves' vector
   */
  virtual const_iterator cbegin() const;

  /**
   * @brief get a const_iterator to the end of the curves' vector
   * @return a const_iterator to the end of the curves' vector
   */
  virtual const_iterator cend() const;

  /**
   * @brief get an iterator to the beginning of the curves' vector
   * @return an iterator to the beginning of the curves' vector
   */
  virtual iterator begin();

  /**
   * @brief get an iterator to the end of the curves' vector
   * @return an iterator to the end of the curves' vector
   */
  virtual iterator end();

  friend class CurvesCollection::BaseConstIteratorImpl;
  friend class CurvesCollection::BaseIteratorImpl;

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  std::vector<boost::shared_ptr<Curve> > curves_;  ///< Vector of the curves object
  std::string id_;  ///< Curves collections id
};

/**
 * @class CurvesCollection::BaseIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class CurvesCollection::BaseIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on curvesCollection. Can create an implementation for
   * an iterator to the beginning of the curves' container or to the end.
   *
   * @param iterated Pointer to the curves' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the curves' container.
   * @returns Created implementation object
   */
  BaseIteratorImpl(CurvesCollection::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~BaseIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  BaseIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  BaseIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  BaseIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  BaseIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const BaseIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const BaseIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Curve pointed to by this
   */
  boost::shared_ptr<Curve>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Curve pointed to by this
   */
  boost::shared_ptr<Curve>* operator->() const;

  /**
   * @brief Get the current iterator
   *
   * @returns Current iterator
   */
  std::vector<boost::shared_ptr<Curve> >::iterator current() const;

 private:
  std::vector<boost::shared_ptr<Curve> >::iterator current_;  ///< current vector iterator
};

/**
 * @class CurvesCollection::BaseConstIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class CurvesCollection::BaseConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on curvesCollection. Can create an implementation for
   * a constant iterator to the beginning of the curves' container or to the end.
   *
   * @param iterated Pointer to the curves' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the events' container.
   * @returns Created implementation object
   */
  BaseConstIteratorImpl(const CurvesCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the vector
   * @returns Created constant iterator
   */
  explicit BaseConstIteratorImpl(const BaseIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~BaseConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  BaseConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  BaseConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  BaseConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  BaseConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const BaseConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const BaseConstIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Curve pointed to by this
   */
  const boost::shared_ptr<Curve>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Curve pointed to by this
   */
  const boost::shared_ptr<Curve>* operator->() const;

 private:
  std::vector<boost::shared_ptr<Curve> >::const_iterator current_;  ///< current vector const iterator
};

}  // namespace curves

#endif  // API_CRV_CRVCURVESCOLLECTIONIMPL_H_
