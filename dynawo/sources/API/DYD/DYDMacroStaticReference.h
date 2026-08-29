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
 * @file DYDMacroStaticReference.h
 * @brief MacroStaticReference : interface file
 *
 */

#ifndef API_DYD_DYDMACROSTATICREFERENCE_H_
#define API_DYD_DYDMACROSTATICREFERENCE_H_

#include "DYDStaticRef.h"

#include <map>
#include <memory>
#include <string>

namespace dynamicdata {

/**
 * @class MacroStaticReference
 * @brief MacroStaticReference interface class
 */
class MacroStaticReference {
 public:
  /**
   * @brief MacroStaticReference constructor
   *
   * @param[in] id id of the macroStaticReference
   */
  explicit MacroStaticReference(const std::string& id);

  /**
   * @brief macroStaticReference id getter
   *
   * @returns the id of the macroStaticReference
   */
  const std::string& getId() const;

  /**
   * @brief staticRef adder
   *
   * @param[in] var dynamic variable
   * @param[in] staticVar static variable
   * @throws Error::API exception if the staticRef already exists
   */
  void addStaticRef(const std::string& var, const std::string& staticVar);

  /**
   * @brief find a staticRef thanks to its key (var_staticVar)
   * @param key key of the staticRef to be found
   * @throws Error::API exception if staticRef doesn't exist
   * @return the staticRef associated to the key
   */
  const std::unique_ptr<StaticRef>& findStaticRef(const std::string& key);

  /**
  * @brief get the static refs
  *
  * @return static refs
  */
  const std::map<std::string, std::unique_ptr<StaticRef> >& getStaticReferences() const {
    return staticRefs_;
  }

 private:
  std::string id_;                                                   ///< id of the macroStaticReference
  std::map<std::string, std::unique_ptr<StaticRef> > staticRefs_;    ///<  map of staticRefs
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROSTATICREFERENCE_H_
