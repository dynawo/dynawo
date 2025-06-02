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
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, bool value);

  /**
   * @brief Adds an int parameter in the parameters set
   *
   * Adds a new int parameter in the parameters set with given name and value.
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @returns Shared pointer to current ParametersSet instance
   */
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, int value);

  /**
   * @brief Adds a double parameter in the parameters set
   *
   * Adds a new double parameter in the parameters set with given name and value.
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @returns Shared pointer to current ParametersSet instance
   */
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, double value);

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
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, bool value, const std::string& row, const std::string& column);

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
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, int value, const std::string& row, const std::string& column);

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
  std::shared_ptr<ParametersSet> createParameter(const std::string& name, double value, const std::string& row, const std::string& column);

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
  const std::shared_ptr<Parameter>& getParameter(const std::string& name) const;

  /**
   * @brief Get a reference from the parameters set
   *
   * Get the reference with given name in the parameter set
   *
   * @param name : Name of the reference
   * @returns Shared pointer to the reference
   * @throws API exception if the reference is not found
   */
  const std::shared_ptr<Reference>& getReference(const std::string& name) const;

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
  void extend(const std::shared_ptr<ParametersSet>& parametersSet);

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
  const std::map<std::string, std::shared_ptr<Parameter> >& getParameters();

  /**
   * @brief Get a reference to the map of references
   *
   * @returns Reference to the map of references
   */
  const std::unordered_map<std::string, std::shared_ptr<Reference> >& getReferences();

  /**
  * @brief Get a reference to the map of macroParSets
  *
  * @returns Reference to the map of macroParSets
  */
  const std::map<std::string, std::shared_ptr<MacroParSet> >& getMacroParSets();

 private:
  /**
   * @copydoc ParametersSet::createParameter(const std::string& name, const std::string& value, const std::string& row, const std::string& column)
   */
  template<typename T>
  std::shared_ptr<ParametersSet> addParameter(const std::string& name, T value, const std::string& row, const std::string& column) {
    const std::vector<std::string>& parNames = tableParameterNames(name, row, column);
    std::string firstParName;
    bool isFirstParName = true;
    for (const auto& parName : parNames) {
      if (isFirstParName) {
        createParameter(parName, value);
        firstParName = parName;
        isFirstParName = false;
      } else {
        createAlias(parName, firstParName);
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
  static std::vector<std::string> tableParameterNames(const std::string& name, const std::string& row, const std::string& column);

 private:
  std::string id_;                                                           /**< Parameters' set id */
  std::string filepath_;                                                     /**< Parameters' set filepath */
  std::map<std::string, std::shared_ptr<Parameter> > parameters_;            /**< Map of the parameters */
  std::unordered_map<std::string, std::shared_ptr<Reference> > references_;  /**< Map of the references */
  std::map<std::string, std::shared_ptr<MacroParSet> > macroParSets_;        ///< Map of the macroParSet
};

}  // namespace parameters

#endif  // API_PAR_PARPARAMETERSSET_H_
