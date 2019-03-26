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
 * @file DYDMacroStaticReference.h
 * @brief MacroStaticReference : interface file
 *
 */

#ifndef API_DYD_DYDMACROSTATICREFERENCE_H_
#define API_DYD_DYDMACROSTATICREFERENCE_H_

#include <string>
#include <map>
#include <vector>
#include <boost/shared_ptr.hpp>

#include "DYDExport.h"

namespace dynamicdata {
class staticRef_const_iterator;
class staticRef_iterator;
class StaticRef;

/**
 * @class MacroStaticReference
 * @brief MacroStaticReference interface class
 */
class __DYNAWO_DYD_EXPORT MacroStaticReference {
 public:
  /**
   * @brief Destructor
   */
  virtual ~MacroStaticReference() {}
  /**
   * @brief macroStaticReference id getter
   *
   * @returns the id of the macroStaticReference
   */
  virtual std::string getId() const = 0;

  /**
   * @brief staticRef adder
   *
   * @param[in] var: dynamic variable
   * @param[in] staticVar: static variable
   * @throws Error::API exception if the staticRef already exists
   */
  virtual void addStaticRef(const std::string& var, const std::string& staticVar) = 0;

    /**
   * @brief staticRef iterator : beginning of staticRefs
   * @return beginning of staticRefs
   */
  virtual staticRef_const_iterator cbeginStaticRef() const = 0;

  /**
   * @brief staticRef iterator : end of staticRefs
   * @return end of staticRefs
   */
  virtual staticRef_const_iterator cendStaticRef() const = 0;

  /**
   * @brief staticRef iterator : beginning of staticRefs
   * @return beginning of staticRefs
   */
  virtual staticRef_iterator beginStaticRef() = 0;

  /**
   * @brief staticRef iterator : end of staticRefs
   * @return end of staticRefs
   */
  virtual staticRef_iterator endStaticRef() = 0;

  /**
   * @brief find a staticRef thanks to its key (var_staticVar)
   * @param key: key of the staticRef to be found
   * @throws Error::API exception if staticRef doesn't exist
   * @return the staticRef associated to the key
   */
  virtual const boost::shared_ptr<StaticRef>& findStaticRef(const std::string& key) = 0;

  class Impl;  ///< Implementation class
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROSTATICREFERENCE_H_
