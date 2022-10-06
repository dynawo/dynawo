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
 * @file  DYNParameterSolver.h
 *
 * @brief Dynawo Solver Parameter: header file
 *
 */
#ifndef SOLVERS_COMMON_DYNPARAMETERSOLVER_H_
#define SOLVERS_COMMON_DYNPARAMETERSOLVER_H_

#include <string>
#include <vector>

#include <boost/optional.hpp>
#include <boost/any.hpp>

#include "DYNCommon.h"
#include "DYNParameter.h"

namespace DYN {

/**
 * class ParameterSolver
 */
class ParameterSolver : public ParameterCommon {
 public:
  /**
   * @brief Constructor
   *
   * @param name name of the parameter
   * @param valueType type of the parameter (bool, int, string, double)
   * @param mandatory whether the parameter is mandatory or optional
   */
  ParameterSolver(const std::string& name, const typeVarC_t& valueType, bool mandatory);

  /**
   * @brief Default copy Constructor
   */
  ParameterSolver(const ParameterSolver&) = default;
  /**
   * @brief Default assignement operator
   * @returns *this
   */
  ParameterSolver& operator=(const ParameterSolver&) = delete;

  /**
    * @brief check whether the parameter's value is set
    * @return whether the parameter's value is set
    */
  inline bool hasValue() const {
    return value_ != boost::none;
  }

  /**
   * @brief parameter's value setter
   * @param value parameter's value
   */
  template<typename T> void setValue(const T& value);

  /**
   * @brief parameter's value intermediary getter
   * @return parameter's value
   */
  boost::any getAnyValue() const;

  /**
   * @brief parameter's value getter (converting the value to double)
   * @return parameter's value (converted to double)
   */
  double getDoubleValue() const;

  /**
   * @brief TypeError getter
   * @return TypeError getter
   */
  Error::TypeError_t getTypeError() const;

 private:
  ParameterSolver() = delete;  ///< default constructor

  boost::optional<boost::any> value_;  ///< value of the parameter
};
}  // namespace DYN

#include "DYNParameterSolver.hpp"

#endif  // SOLVERS_COMMON_DYNPARAMETERSOLVER_H_
