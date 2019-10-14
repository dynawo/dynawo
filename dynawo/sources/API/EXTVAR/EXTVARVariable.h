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
 * @file EXTVARVariable.h
 * @brief Variable description : interface file
 *
 */

#ifndef API_EXTVAR_EXTVARVARIABLE_H_
#define API_EXTVAR_EXTVARVARIABLE_H_

#include <string>

namespace externalVariables {

/**
 * @class Variable
 * @brief Variable interface class
 *
 * Variable is a virtual base class for all model types
 */
class Variable {
 public:
  /**
   * @brief Available model types enum
   */
  enum Type {
    CONTINUOUS,  ///< For continuous variables
    DISCRETE,  ///< For discrete (discrete real) variables
    BOOLEAN,  ///< For boolean variables
    CONTINUOUS_ARRAY,  ///< For continuous array variables
    DISCRETE_ARRAY  ///< For discrete array variables
  };

  /**
   * @brief Destructor
   */
  virtual ~Variable() {}

  /**
   * @brief Variable id getter
   * @returns Variable id
   */
  virtual std::string getId() const = 0;

  /**
   * @brief Variable id setter
   * @param id : the id to set
   * @returns Variable
   */
  virtual Variable& setId(const std::string & id) = 0;

  /**
   * @brief Variable type getter
   * @returns Variable type
   */
  virtual Type getType() const = 0;


  /**
   * @brief whether the external variable has a user-defined default value
   * @returns whether it has a default value
   */
  virtual bool hasDefaultValue() const = 0;

  /**
   * @brief Variable default value setter
   * @param value : the default value to set
   * @returns Variable
   */
  virtual Variable& setDefaultValue(const std::string & value) = 0;

  /**
   * @brief Variable default value getter
   * @returns Variable default value
   */
  virtual std::string getDefaultValue() const = 0;

   /**
   * @brief whether the external variable has a size defined
   * @returns whether it has a size defined
   */
  virtual bool hasSize() const = 0;

  /**
   * @brief variable array size setter
   * @param size size of the array
   * @return Variable modified
   */
  virtual Variable& setSize(unsigned int size) = 0;

  /**
   * @brief variable array size getter
   * @return size of the array
   */
  virtual unsigned int getSize() const = 0;

  /**
   * @brief whether the external variable is optional
   * @returns whether it's an optional external variable
   */
  virtual bool hasOptional() const = 0;

  /**
   * @brief variable array optional setter
   * @param optional @b true if the variable array is optional
   * @return Variable modified
   */
  virtual Variable& setOptional(bool optional) = 0;

  /**
   * @brief variable array optional getter
   * @return @b true if the external variable is optional
   */
  virtual bool getOptional() const = 0;

  class Impl;  ///< Implemented class
};

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARVARIABLE_H_
