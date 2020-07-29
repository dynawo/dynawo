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

#ifndef API_CRT_CRTCRITERIA_H_
#define API_CRT_CRTCRITERIA_H_

#include <string>
#include <boost/shared_ptr.hpp>

#include "CRTCriteriaParams.h"

namespace criteria {

/**
 * @class Criteria
 * @brief Criteria interface class
 *
 * Interface class for criteria object.
 */
class Criteria {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Criteria() { }

  /**
   * @brief Setter for criteria parameters
   * @param params criteria parameters
   */
  virtual void setParams(const boost::shared_ptr<CriteriaParams>& params) = 0;

  /**
   * @brief Getter for criteria parameters
   * @return criteria parameters
   */
  virtual const boost::shared_ptr<CriteriaParams>& getParams() const = 0;

  /**
   * @brief Add an id to the component list
   * @param id id to add
   */
  virtual void addComponentId(const std::string& id) = 0;

  /**
   * @brief Add a country to the country list
   * @param id country id to add
   */
  virtual void addCountry(const std::string& id) = 0;


  class Impl;
 protected:
  class BaseCompIdConstIteratorImpl;  // Abstract class for the interface

 public:
   /**
    * @class component_id_const_iterator
    * @brief Const iterator over components id
    *
    * Const iterator over components id stored in criteria
    */
  class component_id_const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Can create a constant iterator to the
     * beginning of the component ids container or to the end.
     *
     * @param iterated Pointer to the component ids iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the container.
     */
    component_id_const_iterator(const Criteria::Impl* iterated, bool begin);

    /**
     * @brief Copy constructor
     * @param original : component_id_const_iterator to copy
     */
    component_id_const_iterator(const component_id_const_iterator& original);

    /**
     * @brief Destructor
     */
    ~component_id_const_iterator();

    /**
     * @brief assignment
     * @param other : component_id_const_iterator to assign
     *
     * @returns Reference to this component_id_const_iterator
     */
    component_id_const_iterator& operator=(const component_id_const_iterator& other);

    /**
     * @brief Prefix-increment operator
     *
     * @returns Reference to this component_id_const_iterator
     */
    component_id_const_iterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this component_id_const_iterator
     */
    component_id_const_iterator operator++(int);

    /**
     * @brief Prefix-decrement operator
     *
     * @returns Reference to this component_id_const_iterator
     */
    component_id_const_iterator& operator--();

    /**
     * @brief Postfix-decrement operator
     *
     * @returns Copy of this component_id_const_iterator
     */
    component_id_const_iterator operator--(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are equals, else false
     */
    bool operator==(const component_id_const_iterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are different, else false
     */
    bool operator!=(const component_id_const_iterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns id pointed to by this
     */
    const std::string& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the id pointed to by this
     */
    const std::string* operator->() const;

   private:
    BaseCompIdConstIteratorImpl* impl_;  ///<  Pointer to the implementation of the const iterator
  };

  /**
   * @brief Get a component_id_const_iterator to the beginning of components ids container
   * @return a component_id_const_iterator to the beginning of components ids container
   */
  virtual component_id_const_iterator begin() const = 0;

  /**
   * @brief Get a component_id_const_iterator to the end of components ids container
   * @return a component_id_const_iterator to the end of components ids container
   */
  virtual component_id_const_iterator end() const = 0;

  /**
   * @brief Test if this criteria is limited to a specific country
   * @return @b true if this criteria has at least one country filter
   */
  virtual bool hasCountryFilter() const = 0;

  /**
   * @brief Test if this criteria is limited to a specific country
   * @param country to test
   * @return @b true if this criteria should be limited to this country
   */
  virtual bool containsCountry(const std::string& country) const = 0;
};

}  // namespace criteria

#endif  // API_CRT_CRTCRITERIA_H_
