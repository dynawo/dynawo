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

#include "PARParametersSet.h"
#include "PARMacroParameterSet.h"

#include <boost/shared_ptr.hpp>
#include <map>
#include <string>

namespace parameters {

/**
 * @class ParametersSetCollection
 * @brief Parameters set collection interface class
 *
 * ParametersSetCollection objects describe collection parameters' set.
 */
class ParametersSetCollection {
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
  void addParametersSet(boost::shared_ptr<ParametersSet> paramSet, bool force = false);

  /**
   * @brief Get parameters set with current id if available in the collection
   *
   * @param[in] id ID of wanted parameter set
   * @returns Reference to wanted ParametersSet instance
   * @throws Error::API exception if set with given ID do not exists
   */
  boost::shared_ptr<ParametersSet> getParametersSet(const std::string& id);

  /**
   * @brief add parameters and references coming from macroParameterSets
   */
  void getParametersFromMacroParameter();

  /**
   * @brief Check if a parameter set is in the collection
   *
   * @param[in] id Name of the parameter set
   * @returns Existence of the parameter set in the collection
   */
  bool hasParametersSet(const std::string& id);

  /**
   * @brief Check if a macroParameterSet set is in the collection
   *
   * @param[in] id Name of the macroParameterSet
   * @returns Existence of macroParameterSet in the collection
   */
  bool hasMacroParametersSet(const std::string& id) const;

  /**
   * @brief propatgates the origin of parameters (file path, parent param set id)
   *
   * @param filepath origin file path
   */
  void propagateOriginData(const std::string& filepath);

  /**
   * @brief Add a macroParamSet in the collection
   *
   * @param[in] macroParamSet set to add
   * in case an id already exists by creating a unique id for it
   * @throws Error::API exception if a macroParameterSet with given
   * ID already exists.
   */
  void addMacroParameterSet(boost::shared_ptr<MacroParameterSet> macroParamSet);

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
     */
    parametersSet_const_iterator(const ParametersSetCollection* iterated, bool begin);

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
    std::map<std::string, boost::shared_ptr<ParametersSet> >::const_iterator current_; /**< Hidden map iterator */
  };

  /**
   * @brief Get a parametersSet_const_iterator to the beginning of the parameters' set collection
   * @return beginning of constant iterator
   */
  parametersSet_const_iterator cbeginParametersSet() const;

  /**
   * @brief Get a parametersSet_const_iterator to the end of the parameters' set collection
   * @return end of constant iterator
   */
  parametersSet_const_iterator cendParametersSet() const;

  /**
   * @class macroparameterset_const_iterator
   * @brief Const iterator over macroparameters' set
   *
   * Const iterator over macroparameters' set listed in a collection.
   */
  class macroparameterset_const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on parameter's set collection. Can create an iterator to the
     * beginning of the macroparameters' set container or to the end. MacroParameter objects
     * cannot be modified.
     *
     * @param iterated Pointer to the parameters' set collection iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the macroparameters' sets container.
     */
    macroparameterset_const_iterator(const ParametersSetCollection* iterated, bool begin);

    /**
     * @brief Prefix-increment operator
     *
     * @returns Reference to this macroparameterset_const_iterator
     */
    macroparameterset_const_iterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this macroparameterset_const_iterator
     */
    macroparameterset_const_iterator operator++(int);

    /**
     * @brief Prefix-decrement operator
     *
     * @returns Reference to this macroparameterset_const_iterator
     */
    macroparameterset_const_iterator& operator--();

    /**
     * @brief Postfix-decrement operator
     *
     * @returns Copy of this macroparameterset_const_iterator
     */
    macroparameterset_const_iterator operator--(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are equals, else false
     */
    bool operator==(const macroparameterset_const_iterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are different, else false
     */
    bool operator!=(const macroparameterset_const_iterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns MacroParameters' set pointed to by this
     */
    const boost::shared_ptr<MacroParameterSet>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the MacroParameters pointed to by this
     */
    const boost::shared_ptr<MacroParameterSet>* operator->() const;

   private:
    std::map<std::string, boost::shared_ptr<MacroParameterSet> >::const_iterator current_; /**< Hidden map iterator */
  };

  /**
   * @brief Get a macroparameterset_const_iterator to the beginning of the macroParameterSet' set collection
   * @return beginning of constant iterator
   */
  macroparameterset_const_iterator cbeginMacroParameterSet() const;

  /**
   * @brief Get a macroparameterset_const_iterator to the end of the macroParameterSet' set collection
   * @return end of constant iterator
   */
  macroparameterset_const_iterator cendMacroParameterSet() const;

 private:
  std::map<std::string, boost::shared_ptr<ParametersSet> > parametersSets_; /**< Map of the parameters set */
  std::map<std::string, boost::shared_ptr<MacroParameterSet> > macroParametersSets_;  ///< Map of macroParametersSet (key->id, value->MacroParameterSet)
};

}  // namespace parameters

#endif  // API_PAR_PARPARAMETERSSETCOLLECTION_H_
