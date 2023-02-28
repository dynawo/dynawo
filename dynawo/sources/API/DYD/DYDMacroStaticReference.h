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

#include "DYDIterators.h"
#include "DYDStaticRef.h"

#include <boost/shared_ptr.hpp>
#include <map>
#include <string>
#include <vector>

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

  void addStaticRef(boost::shared_ptr<StaticRef> staticRef);

  /**
   * @brief staticRef adder
   *
   * @param[in] var dynamic variable
   * @param[in] staticVar static variable
   * @throws Error::API exception if the staticRef already exists
   */
  void addStaticRef(const std::string& var, const std::string& staticVar);

  /**
   * @brief staticRef iterator : beginning of staticRefs
   * @return beginning of staticRefs
   */
  staticRef_const_iterator cbeginStaticRef() const;

  /**
   * @brief staticRef iterator : end of staticRefs
   * @return end of staticRefs
   */
  staticRef_const_iterator cendStaticRef() const;

  /**
   * @brief staticRef iterator : beginning of staticRefs
   * @return beginning of staticRefs
   */
  staticRef_iterator beginStaticRef();

  /**
   * @brief staticRef iterator : end of staticRefs
   * @return end of staticRefs
   */
  staticRef_iterator endStaticRef();

  /**
   * @brief find a staticRef thanks to its key (var_staticVar)
   * @param key key of the staticRef to be found
   * @throws Error::API exception if staticRef doesn't exist
   * @return the staticRef associated to the key
   */
  const boost::shared_ptr<StaticRef>& findStaticRef(const std::string& key);

  friend class staticRef_const_iterator;
  friend class staticRef_iterator;

 private:
  std::string id_;                                                   ///< id of the macroStaticReference
  std::map<std::string, boost::shared_ptr<StaticRef> > staticRefs_;  ///<  map of staticRefs
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROSTATICREFERENCE_H_
