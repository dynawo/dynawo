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
 * @file EXTVARVariable.h
 * @brief Variable description : interface file
 *
 */

#ifndef API_EXTVAR_EXTVARVARIABLE_H_
#define API_EXTVAR_EXTVARVARIABLE_H_

#include <boost/core/noncopyable.hpp>
#include <boost/optional.hpp>
#include <string>

namespace externalVariables {

/**
 * @class Variable
 * @brief Variable interface class
 *
 * Variable is a base class for all model types
 */
class Variable : public boost::noncopyable {
 public:
  /**
   * @brief Available model types enum
   */
  enum class Type {
    CONTINUOUS,        ///< For continuous variables
    DISCRETE,          ///< For discrete (discrete real) variables
    BOOLEAN,           ///< For boolean variables
    CONTINUOUS_ARRAY,  ///< For continuous array variables
    DISCRETE_ARRAY     ///< For discrete array variables
  };

  /**
   * @brief Create new Variable
   * @param[in] id the variable identifier
   * @param[in] type the variable type (discrete or continuous)
   */
  Variable(const std::string& id, Type type);

  /**
   * @brief Variable id getter
   * @returns Variable id
   */
  std::string getId() const;

  /**
   * @brief Variable id setter
   * @param id : the id to set
   * @returns Variable
   */
  Variable& setId(const std::string& id);

  /**
   * @brief Variable type getter
   * @returns Variable type
   */
  Type getType() const;

  /**
   * @brief whether the external variable has a user-defined default value
   * @returns whether it has a default value
   */
  bool hasDefaultValue() const;

  /**
   * @brief Variable default value setter
   * @param value : the default value to set
   * @returns Variable
   */
  Variable& setDefaultValue(const std::string& value);

  /**
   * @brief Variable default value getter
   * @returns Variable default value
   */
  std::string getDefaultValue() const;

  /**
   * @brief whether the external variable has a size defined
   * @returns whether it has a size defined
   */
  bool hasSize() const;

  /**
   * @brief variable array size setter
   * @param size size of the array
   * @return Variable modified
   */
  Variable& setSize(unsigned int size);

  /**
   * @brief variable array size getter
   * @return size of the array
   */
  unsigned int getSize() const;

  /**
   * @brief whether the external variable is optional
   * @returns whether it's an optional external variable
   */
  bool hasOptional() const;

  /**
   * @brief variable array optional setter
   * @param optional @b true if the variable array is optional
   * @return Variable modified
   */
  Variable& setOptional(bool optional);

  /**
   * @brief variable array optional getter
   * @return @b true if the external variable is optional
   */
  bool getOptional() const;

 private:
  std::string id_;                      ///< Variable ID
  Type type_;                           ///< Variable type (discrete or continuous)
  std::string defaultValue_;            ///< default value to use in fictitious equations
  boost::optional<unsigned int> size_;  ///< size of the array (if the variable is an array)
  boost::optional<bool> optional_;      ///< @b true if the variable is an optional external variable
};

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARVARIABLE_H_
