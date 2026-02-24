//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file  LEQLostEquipmentsCollection.h
 *
 * @brief Dynawo lost equipments collection : interface file
 *
 */

#ifndef API_LEQ_LEQLOSTEQUIPMENTSCOLLECTION_H_
#define API_LEQ_LEQLOSTEQUIPMENTSCOLLECTION_H_

#include "LEQLostEquipment.h"

#include <boost/shared_ptr.hpp>
#include <string>
#include <set>

namespace lostEquipments {

/**
 * @brief structure used to sort lostEquipment instances in a set
 */
struct LostEquipmentComparator {
  /**
   * @brief compare two LostEquipment instance IDs lexicographically for sorting
   * @param lostEquipment1 first lost equipment to compare
   * @param lostEquipment2 second lost equipment to compare
   * @return @b true if the ID of lostEquipment1 is less than the ID of lostEquipment2, @b false otherwise
   */
  bool operator()(const boost::shared_ptr<LostEquipment>& lostEquipment1,
                  const boost::shared_ptr<LostEquipment>& lostEquipment2) const {
    return lostEquipment1->getId() < lostEquipment2->getId();
  }
};

using LostEquipmentsSet = std::set<boost::shared_ptr<LostEquipment>, LostEquipmentComparator>;  ///< Alias for lost equipments set

/**
 * @class LostEquipmentsCollection
 * @brief LostEquipmentsCollection interface class
 *
 * Interface class for LostEquipmentsCollection object. This a container for lost equipments
 */
class LostEquipmentsCollection {
 public:
  /**
   * @brief Add a lost equipment to the collection
   *
   * @param id Lost equipment's id
   * @param type Lost equipment's type
   */
  void addLostEquipment(const std::string& id, const std::string& type);

 public:
  /**
   * @class LostEquipmentsCollectionConstIterator
   * @brief Const iterator over lost equipments
   *
   * Const iterator over lost equipments stored in the collection
   */
  class LostEquipmentsCollectionConstIterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on lost equipments. Can create an iterator to the
     * beginning of the lost equipments' container or to the end.
     * Lost equipments cannot be modified.
     *
     * @param iterated Pointer to the lost equipments' vector iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the lost equipments' container.
     */
    LostEquipmentsCollectionConstIterator(const LostEquipmentsCollection* iterated, bool begin);

    /**
     * @brief Prefix-increment operator
     *
     * @returns Reference to this LostEquipmentsCollectionConstIterator
     */
    LostEquipmentsCollectionConstIterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this LostEquipmentsCollectionConstIterator
     */
    LostEquipmentsCollectionConstIterator operator++(int);

    /**
     * @brief Prefix-decrement operator
     *
     * @returns Reference to this LostEquipmentsCollectionConstIterator
     */
    LostEquipmentsCollectionConstIterator& operator--();

    /**
     * @brief Postfix-decrement operator
     *
     * @returns Copy of this LostEquipmentsCollectionConstIterator
     */
    LostEquipmentsCollectionConstIterator operator--(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are equals, else false
     */
    bool operator==(const LostEquipmentsCollectionConstIterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are different, else false
     */
    bool operator!=(const LostEquipmentsCollectionConstIterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns Lost equipment pointed to by this
     */
    const boost::shared_ptr<LostEquipment>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the lost equipment pointed to by this
     */
    const boost::shared_ptr<LostEquipment>* operator->() const;

   private:
    LostEquipmentsSet::const_iterator current_;  ///< current vector const iterator
  };

  /**
   * @brief Get a const_iterator to the beginning of the lost equipments' vector
   * @return beginning
   */
  LostEquipmentsCollectionConstIterator cbegin() const;

  /**
   * @brief Get a const_iterator to the end of the lost equipments' vector
   * @return end
   */
  LostEquipmentsCollectionConstIterator cend() const;

 private:
  LostEquipmentsSet lostEquipments_;  ///< set of the lost equipment objects
};

}  // end of namespace lostEquipments

#endif  // API_LEQ_LEQLOSTEQUIPMENTSCOLLECTION_H_
