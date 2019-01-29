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
 * @file DYDModelImpl.h
 * @brief Variable description : header file
 *
 */

#ifndef API_EXTVAR_EXTVARVARIABLEIMPL_H_
#define API_EXTVAR_EXTVARVARIABLEIMPL_H_

#include <boost/optional.hpp>

#include "EXTVARVariable.h"

namespace externalVariables {

/**
 * @class Variable::Impl
 * @brief Variable implemented class
 *
 * Variable is a base class for all variable types
 */
class Variable::Impl : public Variable {
 public:
  /**
   * @brief Create new Variable
   * @param[in] id the variable identifier
   * @param[in] type the variable type (discrete or continuous)
   * @return Shared pointer to a new @p Variable
   */
  Impl(const std::string& id, Type type);

  /**
   * @brief Destructor
   */
  ~Impl();

  /**
   * @copydoc Variable::getId()
   */
  std::string getId() const;

  /*
   * @copydoc Variable::setId()
   */
  Variable& setId(const std::string & id);

  /**
   * @copydoc Variable::getType()
   */
  Type getType() const;


  /**
   * @copydoc Variable::hasDefaultValue()
   */
  bool hasDefaultValue() const;

  /**
   * @copydoc Variable::setDefaultValue(const std::string & value)
   */
  Variable& setDefaultValue(const std::string & value);

  /**
   * @copydoc Variable::getDefaultValue()
   */
  std::string getDefaultValue() const;

  /**
   * @copydoc Variable::hasSize()
   */
  bool hasSize() const;

  /**
   * @copydoc Variable::setSize()
   */
  Variable& setSize(unsigned int size);

  /**
   * @copydoc Variable::getSize()
   */
  unsigned int getSize() const;

   /**
   * @copydoc Variable::hasOptional()
   */
  bool hasOptional() const;

  /**
   * @copydoc Variable::setOptional()
   */
  Variable& setOptional(bool optional);

  /**
   * @copydoc Variable::getOptional()
   */
  bool getOptional() const;

 protected:
  std::string id_;  ///< Variable ID
  Type type_;  ///< Variable type (discrete or continuous)
  std::string defaultValue_;  ///< default value to use in fictitious equations
  boost::optional<unsigned int> size_;  ///< size of the array (if the variable is an array)
  boost::optional<bool> optional_;  ///< @b true if the variable is an optional external variable

 private:
  /**
   * @brief Copy constructor
   *
   * @param[in] original Variable to be copied
   * @returns Copy of Variable::Impl instance
   */
  Impl(const Impl& original);

  /**
   * @brief default constructor
   */
  Impl();
};

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARVARIABLEIMPL_H_
