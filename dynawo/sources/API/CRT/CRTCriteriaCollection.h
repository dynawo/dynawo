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

#ifndef API_CRT_CRTCRITERIACOLLECTION_H_
#define API_CRT_CRTCRITERIACOLLECTION_H_

#include <string>
#include <boost/shared_ptr.hpp>

namespace criteria {
class Criteria;

/**
 * @class CriteriaCollection
 * @brief Criteria collection interface class
 *
 * Interface class for criteria collection object. This a container for criterias
 */
class CriteriaCollection {
 public:
  /**
  * define type of components
  */
  typedef enum {
    BUS,
    LOAD,
    GENERATORS
  } CriteriaCollectionType_t;  ///< components type

  /**
   * @brief Destructor
   */
  virtual ~CriteriaCollection() { }

  /**
   * @brief add a criteria to the collection
   *
   * @param type type of component this criteria applies to
   * @param criteria criteria to add to the collection
   */
  virtual void add(CriteriaCollectionType_t type, const boost::shared_ptr<Criteria> & criteria) = 0;

  /**
   * @brief merge this collection with the other one
   *
   * @param other another criteria collection
   */
  virtual void merge(const boost::shared_ptr<CriteriaCollection> & other) = 0;

  class Impl;  // Implementation class

 protected:
  class BaseConstCriteriaCollectionIteratorImpl;  // Abstract class for the interface

 public:
  /**
   * @class CriteriaCollectionConstIterator
   * @brief Const iterator over curves
   *
   * Const iterator over curves stored in collection
   */
  class CriteriaCollectionConstIterator {
   public:
    /**
     * @brief Constructor
     * @param iterated Pointer to the curves' vector iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the events' container.
     * @param type type of the component
     */
    CriteriaCollectionConstIterator(const CriteriaCollection::Impl* iterated, bool begin, CriteriaCollectionType_t type);

    /**
     * @brief Copy constructor
     * @param original : const iterator to copy
     */
    CriteriaCollectionConstIterator(const CriteriaCollectionConstIterator& original);

    /**
     * @brief Destructor
     */
    ~CriteriaCollectionConstIterator();

    /**
     * @brief assignment
     * @param other : CriteriaCollectionConstIterator to assign
     *
     * @returns Reference to this CriteriaCollectionConstIterator
     */
    CriteriaCollectionConstIterator& operator=(const CriteriaCollectionConstIterator& other);

    /**
     * @brief Prefix-increment operator
     *
     * @returns Reference to this CriteriaCollectionConstIterator
     */
    CriteriaCollectionConstIterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this CriteriaCollectionConstIterator
     */
    CriteriaCollectionConstIterator operator++(int);

    /**
     * @brief Prefix-decrement operator
     *
     * @returns Reference to this CriteriaCollectionConstIterator
     */
    CriteriaCollectionConstIterator& operator--();

    /**
     * @brief Postfix-decrement operator
     *
     * @returns Copy of this CriteriaCollectionConstIterator
     */
    CriteriaCollectionConstIterator operator--(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if CriteriaCollectionConstIterators are equals, else false
     */
    bool operator==(const CriteriaCollectionConstIterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if CriteriaCollectionConstIterators are different, else false
     */
    bool operator!=(const CriteriaCollectionConstIterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns Curve pointed to by this
     */
    const boost::shared_ptr<Criteria>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Curve pointed to by this
     */
    const boost::shared_ptr<Criteria>* operator->() const;

   private:
    BaseConstCriteriaCollectionIteratorImpl* impl_;  ///< Pointer to the implementation of the const iterator
  };

  /**
   * @brief Get a CriteriaCollectionConstIterator to the beginning of the curves' vector
   * @param type type of component
   * @return a CriteriaCollectionConstIterator to the beginning of the curves' vector
   */
  virtual CriteriaCollectionConstIterator begin(CriteriaCollectionType_t type) const = 0;

  /**
   * @brief Get a CriteriaCollectionConstIterator to the end of the curves' vector
   * @param type type of component
   * @return a CriteriaCollectionConstIterator to the end of the curves' vector
   */
  virtual CriteriaCollectionConstIterator end(CriteriaCollectionType_t type) const = 0;
};

}  // namespace criteria

#endif  // API_CRT_CRTCRITERIACOLLECTION_H_
