//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file PARMacroParameterSet.h
 * @brief PARMacroParameterSet : interface file
 *
 */

#ifndef API_PAR_PARMACROPARAMETERSET_H_
#define API_PAR_PARMACROPARAMETERSET_H_

#include <map>
#include <string>
#include <memory>

#include "PARReference.h"
#include "PARParameter.h"

namespace parameters {
/**
 * @class MacroParameterSet
 * @brief MacroParameterSet interface class
 */
class MacroParameterSet {
 public:
  /**
   * @brief MacroParameterSet constructor
   * @param[in] id id of the macroParameterSet
   */
  explicit MacroParameterSet(const std::string& id);

  /**
   * @brief macroParameterSet id getter
   * @returns the id of the macroParameterSet
   */
  const std::string& getId() const;

  /**
   * @brief reference adder
   * @param[in] reference to be added
   */
  void addReference(const std::shared_ptr<Reference>& reference);

  /**
   * @brief parameter adder
   * @param[in] parameter to be added
   */
  void addParameter(const std::shared_ptr<Parameter>& parameter);

  /**
   * @class parameter_const_iterator
   * @brief Const iterator over parameters
   *
   * Const iterator over parameters described in a set of macroparameters.
   */
  class parameter_const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on macroparameter's set. Can create an iterator to the
     * beginning of the parameters' container or to the end. Parameters
     * cannot be modified.
     *
     * @param iterated Pointer to the parameters' set iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the parameters' container.
     */
    parameter_const_iterator(const MacroParameterSet* iterated, bool begin);

    /**
     * @brief Prefix-increment operator
     *
     * @returns Reference to this parameter_const_iterator
     */
    parameter_const_iterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this parameter_const_iterator
     */
    parameter_const_iterator operator++(int);

    /**
     * @brief Prefix-decrement operator
     *
     * @returns Reference to this parameter_const_iterator
     */
    parameter_const_iterator& operator--();

    /**
     * @brief Postfix-decrement operator
     *
     * @returns Copy of this parameter_const_iterator
     */
    parameter_const_iterator operator--(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are equals, else false
     */
    bool operator==(const parameter_const_iterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are different, else false
     */
    bool operator!=(const parameter_const_iterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns Parameter pointed to by this
     */
    const std::shared_ptr<Parameter>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the Parameter pointed to by this
     */
    const std::shared_ptr<Parameter>* operator->() const;

   private:
    std::map<std::string, std::shared_ptr<Parameter> >::const_iterator current_; /**< Hidden map iterator */
  };

  /**
   * @brief Get a parameter_const_iterator to the beginning of the parameters' set
   * @return beginning of constant iterator
   */
  parameter_const_iterator cbeginParameter() const;

  /**
   * @brief Get a parameter_const_iterator to the end of the parameters' set
   * @return end of constant iterator
   */
  parameter_const_iterator cendParameter() const;

  /**
   * @class reference_const_iterator
   * @brief Const iterator over references
   *
   * Const iterator over references described in a set of macroparameters.
   */
  class reference_const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on macroparameter's set. Can create an iterator to the
     * beginning of the references' container or to the end. References
     * cannot be modified.
     *
     * @param iterated Pointer to the references' set iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the references' container.
     */
    reference_const_iterator(const MacroParameterSet* iterated, bool begin);

    /**
     * @brief Prefix-increment operator
     *
     * @returns Reference to this reference_const_iterator
     */
    reference_const_iterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this reference_const_iterator
     */
    reference_const_iterator operator++(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are equals, else false
     */
    bool operator==(const reference_const_iterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are different, else false
     */
    bool operator!=(const reference_const_iterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns Reference pointed to by this
     */
    const std::shared_ptr<Reference>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the Reference pointed to by this
     */
    const std::shared_ptr<Reference>* operator->() const;

   private:
    std::map<std::string, std::shared_ptr<Reference> >::const_iterator current_; /**< Hidden map iterator */
  };

  /**
   * @brief Get a reference_const_iterator to the beginning of the references' set
   * @return beginning of constant iterator_ref
   */
  reference_const_iterator cbeginReference() const;

  /**
   * @brief Get a reference_const_iterator to the end of the references' set
   * @return end of constant iterator_ref
   */
  reference_const_iterator cendReference() const;

 private:
  std::string id_;                                                 ///< id of the macroParameterSet
  std::map<std::string, std::shared_ptr<Reference> > references_;  ///< map of references (key->name, value->reference)
  std::map<std::string, std::shared_ptr<Parameter> > parameters_;  ///< map of parameters (key->name, value->parameter)
};
}  // namespace parameters

#endif  // API_PAR_PARMACROPARAMETERSET_H_
