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

#include "DYNCommon.h"

namespace DYN {

/**
 * @brief type definition for continuous variable's property
 */
typedef enum {
  UNDEFINED_PROPERTY = 0,  ///< Undefined type
  DIFFERENTIAL = 1,  ///< The continuous variable is a differential variable
  ALGEBRAIC = -1,  ///< The continuous variable is an algebraic variable
  EXTERNAL = -2,  ///< The continuous variable is an external variable
  OPTIONAL_EXTERNAL = -3  ///< The continuous variable is an optional external variable
} propertyContinuousVar_t;

/**
 * @brief type definition for function's property
 */
typedef enum {
  UNDEFINED_EQ = 0,  ///< Undefined type
  DIFFERENTIAL_EQ = 1,  ///< The residual function is a differential equation
  ALGEBRAIC_EQ = -1  ///< The residual function is an algebraic equation
} propertyF_t;

/**
 * @brief type definition for variable
 */
typedef enum {
  DISCRETE,  ///< The variable is a discrete real variable
  CONTINUOUS,  ///< The variable is a continuous variable
  FLOW,  ///< The variable is a flow variable
  INTEGER,  ///< The variable is an integer variable
  BOOLEAN,  ///< The variable is a boolean variable
  UNDEFINED_TYPE  ///< Undefined type
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
 * @brief mode change type for function
 * A mode change type can be a differential mode change, an algebraic mode change requiring a Jacobian update or not.
 * The enum is ordered and the order is used to detect what is the most critical change at a certain time step. Order modification
 * will change the simulation tool behavior.
 */
typedef enum {
  NO_MODE = 0,  ///< No function change
  DIFFERENTIAL_MODE,  ///< Mode change on a differential function
  ALGEBRAIC_MODE,  ///< Mode change on an algebraic function not requiring a Jacobian update
  ALGEBRAIC_J_UPDATE_MODE  ///< Mode change on an algebraic function requiring a Jacobian update
} modeChangeType_t;

/**
 * @brief Flags for the different types of silent Z
 */
typedef enum {
  NotSilent = 0x01,
  NotUsedInDiscreteEquations = 0x02,
  NotUsedInContinuousEquations = 0x04
} SilentZFlags;

/**
 * @brief discrete variable change type
 */
typedef enum {
  NO_Z_CHANGE = 0,  ///< no discrete variable has changed
  NOT_SILENT_Z_CHANGE,  ///< at least one z that modify both continuous and discrete equation has changed
  NOT_USED_IN_CONTINUOUS_EQ_Z_CHANGE,  ///< at least on z that is used only in discrete equation has changed
  NOT_USED_IN_DISCRETE_EQ_Z_CHANGE  ///< only z that are used only in continuous equations were modified
} zChangeType_t;


/**
* define value type of the constraints
*/
typedef enum {
  NO_CONSTRAINTS_FILTER = 0,
  CONSTRAINTS_KEEP_FIRST,     ///< value registered in the constraint should be the first value seen by the simulation
  CONSTRAINTS_KEEP_LAST,          ///< value registered in the constraint should be the last value seen by the simulation
  SIZE_OF_ENUM  ///< value to use ONLY to assess the enumeration size
} ConstraintValueType_t;  ///< constraint value type


static const char* ConstraintValueTypeNames[ConstraintValueType_t::SIZE_OF_ENUM] = {"DISABLED", "FIRST", "LAST"};  ///< string conversion of enum values
// statically check that the size of ConstraintValueTypeNames fits the number of ConstraintValueType
/**
 * @brief Test is the size of ConstraintValueTypeNames is relevant with the enumeration size
 */
static_assert(sizeof(ConstraintValueTypeNames) / sizeof(char*) == ConstraintValueType_t::SIZE_OF_ENUM,
    "Constraints value type string size does not match ConstraintValueType enumeration");

/**
 * @brief return the string associated to the mode change type
 * @param modeChangeType mode change type as an enum
 * @return the string associated to the mode change type
 */
std::string modeChangeType2Str(modeChangeType_t modeChangeType);

/**
 * @brief type definition for state of G (zero crossing? )
 */
typedef int state_g;
static const state_g ROOT_UP = 1;  ///< ROOT is activated
static const state_g ROOT_DOWN = -1;  ///< ROOT is unactivated
static const state_g NO_ROOT = 0;  ///< State of the root is undefined

/**
 * @brief return the property of variable(differential, algebraic, or external)
 * @param property : property of a variable as an enum type
 * @return property of a variable as a string
 */
std::string propertyVar2Str(propertyContinuousVar_t property);

/**
 * @brief return the type of a variable as a string
 * @param type : type of a variable as an enum type
 * @return type of a variable as a string
 */
std::string typeVar2Str(typeVar_t type);

/**
 * @brief convert the variable type from Modelica type to C type
 * @param type : type of a variable as an enum type
 * @return type of a variable as C type (enum)
 */
typeVarC_t toCTypeVar(typeVar_t type);

/**
 * @brief convert a parameter scope to string
 * @param scope : the parameter origin as an enum
 * @return the converted scope as a string
 */
std::string paramScope2Str(parameterScope_t scope);
}  // namespace DYN
#endif  // COMMON_DYNENUMUTILS_H_
