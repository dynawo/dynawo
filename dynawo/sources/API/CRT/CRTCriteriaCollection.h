//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#include "CRTCriteria.h"

#include <string>


namespace criteria {
/**
 * @class CriteriaCollection
 * @brief Criteria collection interface class
 *
 * Interface class for criteria collection object. This a container for criteria
 */
class CriteriaCollection {
 public:
  /**
  * define type of components
  */
  typedef enum { BUS, LOAD, GENERATOR } CriteriaCollectionType_t;  ///< components type

  /**
   * @class CriteriaCollectionConstIterator
   * @brief Const iterator over criteria
   *
   * Const iterator over criteria stored in collection
   */
  class CriteriaCollectionConstIterator {
   public:
    /**
     * @brief Constructor
     * @param iterated Pointer to the criteria' vector iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the events' container.
     * @param type type of the component
     */
    CriteriaCollectionConstIterator(const CriteriaCollection* iterated, bool begin, CriteriaCollectionType_t type);

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
     * @returns Criteria pointed to by this
     */
    const std::shared_ptr<Criteria>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Criteria pointed to by this
     */
    const std::shared_ptr<Criteria>* operator->() const;

   private:
    std::vector<std::shared_ptr<Criteria> >::const_iterator current_;  ///< current vector const iterator
  };

 public:
  /**
   * @brief add a criteria to the collection
   *
   * @param type type of component this criteria applies to
   * @param criteria criteria to add to the collection
   */
  void add(CriteriaCollectionType_t type, const std::shared_ptr<Criteria>& criteria);

  /**
   * @brief merge this collection with the other one
   *
   * @param other another criteria collection
   */
  void merge(const std::shared_ptr<CriteriaCollection>& other);

  /**
   * @brief Get a CriteriaCollectionConstIterator to the beginning of the criteria' vector
   * @param type type of component
   * @return a CriteriaCollectionConstIterator to the beginning of the criteria' vector
   */
  CriteriaCollectionConstIterator begin(CriteriaCollectionType_t type) const;

  /**
   * @brief Get a CriteriaCollectionConstIterator to the end of the criteria' vector
   * @param type type of component
   * @return a CriteriaCollectionConstIterator to the end of the criteria' vector
   */
  CriteriaCollectionConstIterator end(CriteriaCollectionType_t type) const;

 private:
  std::vector<std::shared_ptr<Criteria> > busCriteria_;        ///< Vector of the bus criteria object
  std::vector<std::shared_ptr<Criteria> > loadCriteria_;       ///< Vector of the load criteria object
  std::vector<std::shared_ptr<Criteria> > generatorCriteria_;  ///< Vector of the generator criteria object
};

}  // namespace criteria

#endif  // API_CRT_CRTCRITERIACOLLECTION_H_
