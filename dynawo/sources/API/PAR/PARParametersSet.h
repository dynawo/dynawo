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
 * @file PARParametersSet.h
 * @brief Dynawo parameters set : interface file
 *
 */

#ifndef API_PAR_PARPARAMETERSSET_H_
#define API_PAR_PARPARAMETERSSET_H_

#include "PARParameter.h"
#include "PARReference.h"
#include "PARMacroParSet.h"

#include <unordered_map>
#include <map>
#include <string>
#include <vector>
#include <memory>

namespace parameters {

/**
 * @class ParametersSet
 * @brief Parameters set interface class
 *
 * ParametersSet objects describe a set of parameters.
 * Available types are those availables in @p Parameter class
 */
class ParametersSet : public std::enable_shared_from_this<ParametersSet> {
 public:
  /**
   * @brief constructor
   *
   * @param id id of the set of parameters
   */
  explicit ParametersSet(const std::string& id);

  /**
   * @brief Getter for parameters' set id
   *
   * @returns Parameters' set id
   */
  const std::string& getId() const;

  /**
   * @brief Getter for parameters' set file path
   *
   * @returns Parameters' set file path
   */
  const std::string& getFilePath() const;

  /**
   * @brief Setter for parameters' set file path
   *
   * @param filepath Parameters' set file path
   */
  void setFilePath(const std::string& filepath);

  /**
   * @brief Add a parameter alias in the parameters set
   *
   * The alias will be a reference to another parameter
   *
   * @param aliasName : Name of the parameter alias
   * @param origName : name of the origin parameter to rely on
   * @returns Shared pointer to current ParametersSet instance
   * @throws if the origin parameter does not exist, or the destination parameter already exists
   */
  std::shared_ptr<ParametersSet> createAlias(const std::string& aliasName, const std::string& origName);

  /**
   * @brief Adds a bool parameter in the parameters set
   *
   * Adds a new bool parameter in the parameters set with given name and value.
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @returns Shared pointer to current ParametersSet instance
   */
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, const bool value);

  /**
   * @brief Adds an int parameter in the parameters set
   *
   * Adds a new int parameter in the parameters set with given name and value.
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @returns Shared pointer to current ParametersSet instance
   */
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, const int value);

  /**
   * @brief Adds a double parameter in the parameters set
   *
   * Adds a new double parameter in the parameters set with given name and value.
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @returns Shared pointer to current ParametersSet instance
   */
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, const double value);

  /**
   * @brief Adds a string parameter in the parameters set
   *
   * Adds a new string parameter in the parameters set with given name and value.
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @returns Shared pointer to current ParametersSet instance
   */
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, const std::string& value);

  /**
   * @brief Adds a bool parameter in the parameters set
   *
   * Adds a new bool parameter in the parameters set with given name and value.
   * For the case of a parameter inside an array
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @param row : row of the parameter inside its array (in case of array parameter)
   * @param column : column of the parameter inside its array
   * @returns Shared pointer to current ParametersSet instance
   */
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, const bool value, const std::string& row, const std::string& column);

  /**
   * @brief Adds an int parameter in the parameters set
   *
   * Adds a new int parameter in the parameters set with given name and value.
   * For the case of a parameter inside an array
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @param row : row of the parameter inside its array (in case of array parameter)
   * @param column : column of the parameter inside its array
   * @returns Shared pointer to current ParametersSet instance
   */
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, const int value, const std::string& row, const std::string& column);

  /**
   * @brief Adds a double parameter in the parameters set
   *
   * Adds a new double parameter in the parameters set with given name and value.
   * For the case of a parameter inside an array
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @param row : row of the parameter inside its array (in case of array parameter)
   * @param column : column of the parameter inside its array
   * @returns Shared pointer to current ParametersSet instance
   */
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, const double value, const std::string& row, const std::string& column);

  /**
   * @brief Adds a string parameter in the parameters set
   *
   * Adds a new string parameter in the parameters set with given name and value.
   * For the case of a parameter inside an array
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @param row : row of the parameter inside its array (in case of array parameter)
   * @param column : column of the parameter inside its array
   * @returns Shared pointer to current ParametersSet instance
   */
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, const std::string& value, const std::string& row, const std::string& column);

  /**
   * @brief Add a new parameter in the map
   *
   * Add a new parameter in the underlying map if it does not already exists
   *
   * @param[in] param Parameter to add to the set
   * @returns Reference to current ParametersSet instance
   */
  std::shared_ptr<ParametersSet> addParameter(const std::shared_ptr<Parameter>& param);

  /**
   * @brief Add a new macroParSet
   *
   * @param[in] macroParSet macroParSet to add
   * @returns Reference to current ParametersSet instance
   * @throws API exception if the macroParSet is already in the map
   */
  std::shared_ptr<ParametersSet> addMacroParSet(const std::shared_ptr<MacroParSet>& macroParSet);

  /**
   * @brief Add a new reference in the map
   *
   * Add a new reference in the underlying map if it does not already exists
   *
   * @param[in] ref Reference to add to the set
   * @returns Reference to current ParametersSet instance
   */
  std::shared_ptr<ParametersSet> addReference(const std::shared_ptr<Reference>& ref);

  /**
   * @brief Get a parameter from the parameters set
   *
   * Get the parameter with given name in the parameter set
   *
   * @param name : Name of the parameter
   * @returns Shared pointer to the parameter
   * @throws API exception if the parameter is not found
   */
  const std::shared_ptr<Parameter> getParameter(const std::string& name) const;

  /**
   * @brief Get a reference from the parameters set
   *
   * Get the reference with given name in the parameter set
   *
   * @param name : Name of the reference
   * @returns Shared pointer to the reference
   * @throws API exception if the reference is not found
   */
  const std::shared_ptr<Reference> getReference(const std::string& name) const;

  /**
   * @brief Check if a parameter is in the parameters set
   *
   * Check if a parameter with given name exists in the parameter set
   *
   * @param name : Name of the parameter
   * @returns Existence of the parameter in the set
   */
  bool hasParameter(const std::string& name) const;

  /**
   * @brief Check if a macroParSet is in the parameters set
   *
   * Check if a macroParSet with given id exists in the parameter set
   *
   * @param id : id of the macroParSet
   * @returns Existence of the parameter in the set
   */
  bool hasMacroParSet(const std::string& id) const;

  /**
   * @brief Check if there is a macroParSet the parameters set
   * @returns Existence of a macroParSet in the set
   */
  bool hasMacroParSet() const;

  /**
   * @brief Check if a reference is in the parameters set
   *
   * Check if a reference with given name exists in the parameter set
   *
   * @param name : Name of the reference
   * @returns Existence of the reference in the set
   */
  bool hasReference(const std::string& name) const;

  /**
   * @brief Extends parameters set with the content of given parameters set
   *
   * Extends parameters set with the parameters included in the parameters set
   * given as argument
   *
   * @param parametersSet : ParametersSet to use for extension
   */
  void extend(std::shared_ptr<ParametersSet> parametersSet);

  /**
   * @brief Get a vector of parameter names
   *
   * @returns Vector of parameters' name
   */
  std::vector<std::string> getParametersNames() const;

  /**
   * @brief Get a vector of unused parameters' names
   *
   * @returns Vector of unused parameters' names
   */
  std::vector<std::string> getParamsUnused() const;

  /**
   * @brief Get a vector of references names
   *
   * @returns Vector of references' name
   */
  std::vector<std::string> getReferencesNames() const;

  /**
   * @brief Get a reference to the map of parameters
   *
   * @returns Reference to the map of parameters
   */
  std::map<std::string, std::shared_ptr<Parameter> >& getParameters();

  /**
   * @brief Get a reference to the map of references
   *
   * @returns Reference to the map of references
   */
  std::unordered_map<std::string, std::shared_ptr<Reference> >& getReferences();

 public:
  /**
   * @class parameter_const_iterator
   * @brief Const iterator over parameters
   *
   * Const iterator over parameters described in a set of parameters.
   */
  class parameter_const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on parameter's set. Can create an iterator to the
     * beginning of the parameters' container or to the end. Parameters
     * cannot be modified.
     *
     * @param iterated Pointer to the parameters' set iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the parameters' container.
     */
    parameter_const_iterator(const ParametersSet* iterated, bool begin);

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
   * Const iterator over references described in a set of parameters.
   */
  class reference_const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on parameter's set. Can create an iterator to the
     * beginning of the references' container or to the end. References
     * cannot be modified.
     *
     * @param iterated Pointer to the references' set iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the references' container.
     */
    reference_const_iterator(const ParametersSet* iterated, bool begin);

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
    std::unordered_map<std::string, std::shared_ptr<Reference> >::const_iterator current_; /**< Hidden map iterator */
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

  /**
   * @class macroparset_const_iterator
   * @brief Const iterator over macroparsets
   *
   * Const iterator over macroparsets described in a set of parameters.
   */
  class macroparset_const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on parameter's set. Can create an iterator to the
     * beginning of the macroparsets' container or to the end. macroparsets
     * cannot be modified.
     *
     * @param iterated Pointer to the macroparsets' set iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the macroparsets' container.
     */
    macroparset_const_iterator(const ParametersSet* iterated, bool begin);

    /**
     * @brief Prefix-increment operator
     *
     * @returns reference to this macroparset_const_iterator
     */
    macroparset_const_iterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this macroparset_const_iterator
     */
    macroparset_const_iterator operator++(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are equals, else false
     */
    bool operator==(const macroparset_const_iterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are different, else false
     */
    bool operator!=(const macroparset_const_iterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns MacroParSet pointed to by this
     */
    const std::shared_ptr<MacroParSet>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the MacroParSet pointed to by this
     */
    const std::shared_ptr<MacroParSet>* operator->() const;

   private:
    std::map<std::string, std::shared_ptr<MacroParSet> >::const_iterator current_; /**< Hidden map iterator */
  };

  /**
   * @brief Get a macroparset_const_iterator to the beginning of the macroparsets' set
   * @return beginning of constant iterator_ref
   */
  macroparset_const_iterator cbeginMacroParSet() const;

  /**
   * @brief Get a macroparset_const_iterator to the end of the macroparsets' set
   * @return end of constant iterator_ref
   */
  macroparset_const_iterator cendMacroParSet() const;

 private:
  /**
   * @copydoc ParametersSet::createParameter(const std::string& name, const std::string& value, const std::string& row, const std::string& column)
   */
  template<typename T>
  std::shared_ptr<ParametersSet> addParameter(const std::string& name, T value, const std::string& row, const std::string& column) {
    const std::vector<std::string>& parNames = tableParameterNames(name, row, column);
    std::string firstParName;
    bool isFirstParName = true;
    for (std::vector<std::string>::const_iterator itName = parNames.begin(); itName != parNames.end(); ++itName) {
      const std::string itParName = *itName;
      if (isFirstParName) {
        createParameter(itParName, value);
        firstParName = itParName;
        isFirstParName = false;
      } else {
        createAlias(itParName, firstParName);
      }
    }

    return shared_from_this();
  }

  /**
   * @brief generate the table parameter names (used as identifier inside the list of all parameters) for parameters creation
   *
   * @param name the generic parameter table name
   * @param row the row index
   * @param column the column index
   * @returns the full local value parameter name
   */
  std::vector<std::string> tableParameterNames(const std::string& name, const std::string& row, const std::string& column) const;

 private:
  std::string id_;                                                           /**< Parameters' set id */
  std::string filepath_;                                                     /**< Parameters' set filepath */
  std::map<std::string, std::shared_ptr<Parameter> > parameters_;            /**< Map of the parameters */
  std::unordered_map<std::string, std::shared_ptr<Reference> > references_;  /**< Map of the references */
  std::map<std::string, std::shared_ptr<MacroParSet> > macroParSets_;        ///< Map of the macroParSet
};

}  // namespace parameters

#endif  // API_PAR_PARPARAMETERSSET_H_
