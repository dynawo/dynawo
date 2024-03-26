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

#include "CRTCriteriaParams.h"

#include <boost/shared_ptr.hpp>
#include <unordered_set>
#include <string>
#include <vector>

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
   * @brief Setter for criteria parameters
   * @param params criteria parameters
   */
  void setParams(const boost::shared_ptr<CriteriaParams>& params);

  /**
   * @brief Getter for criteria parameters
   * @return criteria parameters
   */
  const boost::shared_ptr<CriteriaParams>& getParams() const;

  /**
   * @brief Add a component to the component list
   * @param id id of the component to add
   * @param voltageLevelId optional voltageLevelId of the component to add in case of bus criteria
   */
  void addComponentId(const std::string& id, const std::string& voltageLevelId = "");

  /**
   * @brief Add a country to the country list
   * @param id country id to add
   */
  void addCountry(const std::string& id);

 private:
  /**
   * @class ComponentId
   * @brief Container for component id
   *
   * Container for a component id and voltageLevelId.
   */
  class ComponentId {
   public:
    /**
     * @brief Constructor
     *
     * @param id The component id
     * @param voltageLevelId The component voltageLevelId
     */
    ComponentId(const std::string& id, const std::string& voltageLevelId);

    /**
     * @brief Getter for component id
     * @return component id
     */
    const std::string& getId() const;

    /**
     * @brief Getter for voltageLevelId
     * @return voltageLevelId
     */
    const std::string& getVoltageLevelId() const;

   private:
    std::string id_;              ///< id of the component
    std::string voltageLevelId_;  ///< voltageLevelId of the component
  };

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
    component_id_const_iterator(const Criteria* iterated, bool begin);

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
     * @returns component id pointed to by this
     */
    const ComponentId& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the component id pointed to by this
     */
    const ComponentId* operator->() const;

   private:
    std::vector<boost::shared_ptr<ComponentId> >::const_iterator current_;  ///< current vector const iterator
  };

  /**
   * @brief Get a component_id_const_iterator to the beginning of components ids container
   * @return a component_id_const_iterator to the beginning of components ids container
   */
  component_id_const_iterator begin() const;

  /**
   * @brief Get a component_id_const_iterator to the end of components ids container
   * @return a component_id_const_iterator to the end of components ids container
   */
  component_id_const_iterator end() const;

  /**
   * @brief Test if this criterion has at least one country filter
   * @return @b true if this criterion has at least one country filter
   */
  bool hasCountryFilter() const;

  /**
   * @brief Test if this criterion is limited to a specific country
   * @param country to test
   * @return @b true if this criterion should be limited to this country
   */
  bool containsCountry(const std::string& country) const;

 private:
  boost::shared_ptr<CriteriaParams> params_;              ///< parameters of this criteria
  std::vector<boost::shared_ptr<ComponentId> > compIds_;  ///< ids of the components
  std::unordered_set<std::string> countryIds_;          ///< ids of the countries
};

}  // namespace criteria

#endif  // API_CRT_CRTCRITERIA_H_
