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
 * @file  DYNEnumUtils.h
 *
 * @brief Define some common enum and functions for the modeler
 *
 */
#ifndef COMMON_DYNENUMUTILS_H_
#define COMMON_DYNENUMUTILS_H_

#include <string>

#include "DYNCommun.h"

namespace DYN {

/**
 * @brief type definition for continuous variable's property
 */
typedef enum {
  UNDEFINED_PROPERTY = 0,  ///< Undefined type
  DIFFERENTIAL = 1,  ///< The continuous variable is a differential variable
  ALGEBRIC = -1,  ///< The continuous variable is an algebric variable
  EXTERNAL = -2,  ///< The continuous variable is an external variable
  OPTIONAL_EXTERNAL = -3  ///< The continuous variable is an optional external variable
} propertyContinuousVar_t;

/**
 * @brief type definition for function's property
 */
typedef enum {
  UNDEFINED_EQ = 0,  ///< Undefined type
  DIFFERENTIAL_EQ = 1,  ///< The residual function is a differential equation
  ALGEBRIC_EQ = -1  ///< The residual function is an algebric equation
} propertyF_t;

/**
 * @brief type definition for variable
 */
typedef enum {
  DISCRETE,  ///< The variable is a discrete real variable
  CONTINUOUS,  ///< The variable is a continuous variable
  FLOW,  ///< The variable is a flow variable
  INTEGER,  ///< The variable is an integer variable
  BOOLEAN  ///< The variable is a boolean variable
} typeVar_t;

/**
 * @brief scope definition for parameter
 * C++ parameters are only external parameters (internal parameters are not declared)
 * Modelica parameters may rely on various scopes
 */
typedef enum {
  EXTERNAL_PARAMETER,  ///< The parameter only relies on external values
  SHARED_PARAMETER,  ///< The parameter has a default internal value, which may be externally updated
  INTERNAL_PARAMETER  ///< The parameter only computes its own value internally
} parameterScope_t;
/**
 * @brief type definition for state of G (zero crossing? )
 */
typedef int state_g;
static const state_g ROOT_UP = 1;  ///< ROOT is activated
static const state_g ROOT_DOWN = -1;  ///< ROOT is unactivated
static const state_g NO_ROOT = 0;  ///< State of the root is undefined

/**
 * @brief return the property of variable(differential, algebric, or external)
 * @param property : property of a variable as an enum type
 * @return property of a variable as a string
 */
std::string propertyVar2Str(const propertyContinuousVar_t& property);

/**
 * @brief return the type of a variable as a string
 * @param type : type of a variable as an enum type
 * @return type of a variable as a string
 */
std::string typeVar2Str(const typeVar_t& type);

/**
 * @brief convert the variable type from Modelica type to C type
 * @param type : type of a variable as an enum type
 * @return type of a variable as C type (enum)
 */
typeVarC_t toCTypeVar(const typeVar_t& type);

/**
 * @brief convert a parameter scope to string
 * @param scope : the parameter origin as an enum
 * @return the converted scope as a string
 */
std::string paramScope2Str(const parameterScope_t& scope);
}  // namespace DYN
#endif  // COMMON_DYNENUMUTILS_H_
