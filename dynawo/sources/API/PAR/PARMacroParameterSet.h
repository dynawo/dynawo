//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
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
  * @brief get the macro parameters sets
  *
  * @return macro parameters sets
  */
  const std::map<std::string, std::shared_ptr<Reference> >& getReferences() const {
    return references_;
  }

  /**
  * @brief get the macro parameters sets
  *
  * @return macro parameters sets
  */
  const std::map<std::string, std::shared_ptr<Parameter> >& getParameters() const {
    return parameters_;
  }

 private:
  std::string id_;                                                 ///< id of the macroParameterSet
  std::map<std::string, std::shared_ptr<Reference> > references_;  ///< map of references (key->name, value->reference)
  std::map<std::string, std::shared_ptr<Parameter> > parameters_;  ///< map of parameters (key->name, value->parameter)
};
}  // namespace parameters

#endif  // API_PAR_PARMACROPARAMETERSET_H_
