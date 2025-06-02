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
 * @file DYNVariableAliasFactory.h
 * @brief variable alias factory : header file
 *
 */

#ifndef MODELER_COMMON_DYNVARIABLEALIASFACTORY_H_
#define MODELER_COMMON_DYNVARIABLEALIASFACTORY_H_

#include <boost/shared_ptr.hpp>
#include "DYNEnumUtils.h"

namespace DYN {
class VariableAlias;
class VariableNative;

/**
 * @class VariableAliasFactory
 * @brief variable alias factory class
 *
 * VariableAliasFactory encapsulates methods for creating new
 * @p VariableAlias objects.
 */
class VariableAliasFactory {
 public:
  /**
   * @brief Create new VariableAlias instance
   *
   * @param[in] name name of the new VariableAlias instance
   * @param[in] refName name of the VariableNative towards which to point
   * @param[in] type Type of the variable
   * @param[in] negated @b whether the reference is negated
   * @returns Shared pointer to a new @p VariableAlias with given name, reference name, and negated attributes
   */
  static boost::shared_ptr<VariableAlias> create(const std::string& name, const std::string& refName,
      typeVar_t type = UNDEFINED_TYPE, bool negated = false);

  /**
   * @brief Create new VariableAlias instance
   *
   * @param[in] name name of the new VariableAlias instance
   * @param[in] refVar the VariableNative towards which to point
   * @param[in] type Type of the variable
   * @param[in] negated @b whether the reference is negated
   * @returns Shared pointer to a new @p VariableAlias with given name, reference variable, and negated attributes
   */
  static boost::shared_ptr<VariableAlias> create(const std::string& name, const boost::shared_ptr<VariableNative> refVar,
      const typeVar_t type = UNDEFINED_TYPE, bool negated = false);
};

}  // namespace DYN

#endif  // MODELER_COMMON_DYNVARIABLEALIASFACTORY_H_
