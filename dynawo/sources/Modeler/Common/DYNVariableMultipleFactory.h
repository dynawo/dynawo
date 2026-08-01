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
 * @file DYNVariableMultipleFactory.h
 * @brief multiple variable factory : header file
 */

#ifndef MODELER_COMMON_DYNVARIABLEMULTIPLEFACTORY_H_
#define MODELER_COMMON_DYNVARIABLEMULTIPLEFACTORY_H_

#include <boost/shared_ptr.hpp>

#include "DYNEnumUtils.h"

namespace DYN {
class VariableMultiple;

/**
 * @class VariableMultipleFactory
 * @brief multiple variable factory class
 *
 * VariableMultipleFactory encapsulates methods for creating new
 * @p VariableMultiple objects.
 */
class VariableMultipleFactory {
 public:
  /**
   * @brief Create new VariableMultiple instance
   *
   * @param[in] name name of the new VariableMultiple instance
   * @param[in] cardinalityName name of the parameter to use to derive the number of variables
   * @param[in] type the VariableMultiple type (INTEGER, BOOLEAN, ...)
   * @param[in] isState @b whether the variable is needed for local model simulation
   * @param[in] negated @b whether the variable is negated
   * @returns Shared pointer to a new @p VariableMultiple with given name, type, and negated attributes
   */
  static boost::shared_ptr<VariableMultiple> create(const std::string& name, const std::string& cardinalityName, typeVar_t type,
                                                    bool isState, bool negated = false);

  /**
   * @brief Create new (state) VariableMultiple instance
   *
   * @param[in] name name of the new VariableMultiple instance
   * @param[in] cardinalityName name of the parameter to use to derive the number of variables
   * @param[in] type the VariableMultiple type (INTEGER, BOOLEAN, ...)
   * @param[in] negated @b whether the variable is negated
   * @returns Shared pointer to a new @p VariableMultiple with given name, type, and negated attributes
   */
  inline static boost::shared_ptr<VariableMultiple> createState(const std::string& name, const std::string& cardinalityName,
                                                                const typeVar_t type, const bool negated = false) {
    return create(name, cardinalityName, type, true, negated);
  }

  /**
   * @brief Create new (calculated, i.e. non-state) VariableMultiple instance
   *
   * @param[in] name name of the new VariableMultiple instance
   * @param[in] cardinalityName name of the parameter to use to derive the number of variables
   * @param[in] type the VariableMultiple type (INTEGER, BOOLEAN, ...)
   * @param[in] negated @b whether the variable is negated
   * @returns Shared pointer to a new @p VariableMultiple with given name, type, and negated attributes
   */
  inline static boost::shared_ptr<VariableMultiple> createCalculated(const std::string& name, const std::string& cardinalityName, const typeVar_t type,
                                                                     const bool negated = false) {
    return create(name, cardinalityName, type, false, negated);
  }
};

}  // namespace DYN

#endif  // MODELER_COMMON_DYNVARIABLEMULTIPLEFACTORY_H_
