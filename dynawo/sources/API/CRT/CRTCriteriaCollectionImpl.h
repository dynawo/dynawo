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

#ifndef API_CRT_CRTCRITERIACOLLECTIONIMPL_H_
#define API_CRT_CRTCRITERIACOLLECTIONIMPL_H_

#include <vector>
#include <string>
#include <boost/shared_ptr.hpp>

#include "CRTCriteriaCollection.h"

namespace criteria {

/**
 * @class CriteriaCollection::Impl
 * @brief CriteriaCollection implemented class
 *
 * Implementation of Criteria collection interface class
 */
class CriteriaCollection::Impl : public CriteriaCollection {
 public:
  /**
   * @brief Constructor
   */
  Impl() {}

  /**
   * @brief Destructor
   */
  ~Impl() {}

  /**
   * @copydoc CriteriaCollection::add(CriteriaCollectionType_t type, const boost::shared_ptr<Criteria> & criteria)
   */
  void add(CriteriaCollectionType_t type, const boost::shared_ptr<Criteria> & criteria);

  /**
   * @copydoc CriteriaCollection::merge(const boost::shared_ptr<CriteriaCollection> & other)
   */
  void merge(const boost::shared_ptr<CriteriaCollection> & other);

  /**
   * @copydoc CriteriaCollection::begin(CriteriaCollectionType_t type) const
   */
  CriteriaCollectionConstIterator begin(CriteriaCollectionType_t type) const;

  /**
   * @copydoc CriteriaCollection::end(CriteriaCollectionType_t type) const
   */
  CriteriaCollectionConstIterator end(CriteriaCollectionType_t type) const;

  friend class CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl;

 protected:
  std::vector<boost::shared_ptr<Criteria> > busCriterias_;  ///< Vector of the bus criteria object
  std::vector<boost::shared_ptr<Criteria> > loadCriterias_;  ///< Vector of the load criteria object
  std::vector<boost::shared_ptr<Criteria> > generatorCriterias_;  ///< Vector of the generator criteria object
};

/**
 * @class CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl {
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
   * @param type type of the component
   * @returns Created implementation object
   */
  BaseConstCriteriaCollectionIteratorImpl(const CriteriaCollection::Impl* iterated, bool begin, CriteriaCollectionType_t type);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the vector
   * @returns Created constant iterator
   */
  BaseConstCriteriaCollectionIteratorImpl(const BaseConstCriteriaCollectionIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~BaseConstCriteriaCollectionIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  BaseConstCriteriaCollectionIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  BaseConstCriteriaCollectionIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  BaseConstCriteriaCollectionIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  BaseConstCriteriaCollectionIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const BaseConstCriteriaCollectionIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const BaseConstCriteriaCollectionIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Curve pointed to by this
   */
  const boost::shared_ptr<Criteria>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Curve pointed to by this
   */
  const boost::shared_ptr<Criteria>* operator->() const;

  /**
   * @brief Get the current iterator
   *
   * @returns Current iterator
   */
  std::vector<boost::shared_ptr<Criteria> >::const_iterator current() const;

 private:
  std::vector<boost::shared_ptr<Criteria> >::const_iterator current_;  ///< current vector const iterator
};
}  // namespace criteria

#endif  // API_CRT_CRTCRITERIACOLLECTIONIMPL_H_
