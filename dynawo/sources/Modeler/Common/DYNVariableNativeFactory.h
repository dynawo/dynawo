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
 * @file DYNVariableNativeFactory.h
 * @brief native variable factory : header file
 */

#ifndef MODELER_COMMON_DYNVARIABLENATIVEFACTORY_H_
#define MODELER_COMMON_DYNVARIABLENATIVEFACTORY_H_

#include <boost/shared_ptr.hpp>

#include "DYNEnumUtils.h"

namespace DYN {
class VariableNative;

/**
 * @class VariableNativeFactory
 * @brief native variable factory class
 *
 * VariableNativeFactory encapsulates methods for creating new
 * @p VariableNative objects.
 */
class VariableNativeFactory {
 public:
  /**
   * @brief Create new VariableNative instance
   *
   * @param[in] name name of the new VariableNative instance
   * @param[in] type the VariableNative type (INTEGER, BOOLEAN, ...)
   * @param[in] isState @b whether the variable is needed for local model simulation
   * @param[in] negated @b whether the variable is negated
   * @returns Shared pointer to a new @p VariableNative with given name, type, and negated attributes
   */
  static boost::shared_ptr<VariableNative> create(const std::string& name, typeVar_t type, bool isState, bool negated = false);

  /**
   * @brief Create new (state) VariableNative instance
   *
   * @param[in] name name of the new VariableNative instance
   * @param[in] type the VariableNative type (INTEGER, BOOLEAN, ...)
   * @param[in] negated @b whether the variable is negated
   * @returns Shared pointer to a new @p VariableNative with given name, type, and negated attributes
   */
  inline static boost::shared_ptr<VariableNative> createState(const std::string& name, const typeVar_t type, const bool negated = false) {
    return create(name, type, true, negated);
  }

  /**
   * @brief Create new (calculated, i.e. non-state) VariableNative instance
   *
   * @param[in] name name of the new VariableNative instance
   * @param[in] type the VariableNative type (INTEGER, BOOLEAN, ...)
   * @param[in] negated @b whether the variable is negated
   * @returns Shared pointer to a new @p VariableNative with given name, type, and negated attributes
   */
  inline static boost::shared_ptr<VariableNative> createCalculated(const std::string& name, const typeVar_t type, const bool negated = false) {
    return create(name, type, false, negated);
  }
};

}  // namespace DYN

#endif  // MODELER_COMMON_DYNVARIABLENATIVEFACTORY_H_
