//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
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
  void addParametersSet(const std::shared_ptr<ParametersSet>& paramSet, bool force = false);

  /**
   * @brief Get parameters set with current id if available in the collection
   *
   * @param[in] id ID of wanted parameter set
   * @returns Reference to wanted ParametersSet instance
   * @throws Error::API exception if set with given ID do not exists
   */
  std::shared_ptr<ParametersSet> getParametersSet(const std::string& id);

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
  bool hasParametersSet(const std::string& id) const;

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
  void propagateOriginData(const std::string& filepath) const;

  /**
   * @brief Add a macroParamSet in the collection
   *
   * @param[in] macroParamSet set to add
   * in case an id already exists by creating a unique id for it
   * @throws Error::API exception if a macroParameterSet with given
   * ID already exists.
   */
  void addMacroParameterSet(const std::shared_ptr<MacroParameterSet>& macroParamSet);

  /**
  * @brief get the parameters sets
  *
  * @return parameters sets
  */
  const std::map<std::string, std::shared_ptr<ParametersSet> >& getParametersSets() const {
    return parametersSets_;
  }

  /**
  * @brief get the macro parameters sets
  *
  * @return macro parameters sets
  */
  const std::map<std::string, std::shared_ptr<MacroParameterSet> >& getMacroParametersSets() const {
    return macroParametersSets_;
  }

 private:
  std::map<std::string, std::shared_ptr<ParametersSet> > parametersSets_; /**< Map of the parameters set */
  std::map<std::string, std::shared_ptr<MacroParameterSet> > macroParametersSets_;  ///< Map of macroParametersSet (key->id, value->MacroParameterSet)
};

}  // namespace parameters

#endif  // API_PAR_PARPARAMETERSSETCOLLECTION_H_
