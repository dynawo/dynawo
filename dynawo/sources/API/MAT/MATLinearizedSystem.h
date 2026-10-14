//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file  MATLinearizedSystem.h
 *
 * @brief Linearized system to export : interface file
 *
 */

#ifndef API_MAT_MATLINEARIZEDSYSTEM_H_
#define API_MAT_MATLINEARIZEDSYSTEM_H_

#include "MATMatrix.h"

#include <string>
#include <vector>

namespace matrix {

/**
 * @class LinearizedSystem
 * @brief Linearization of the system F(x, x') = 0 at a given time
 *
 * Contains the jacobians \f$ \partial F / \partial x \f$ and \f$ \partial F / \partial x' \f$ (one row per equation, one column per variable)
 * and the description of the variables and of the equations.
 */
class LinearizedSystem {
 public:
  /**
   * @brief description of a variable of the system
   */
  struct Variable {
    std::string name;  ///< name of the variable in its model
    std::string modelName;  ///< name of the model of the variable
    std::string type;  ///< type of the variable (differential, algebraic...)
  };

  /**
   * @brief description of an equation of the system
   */
  struct Equation {
    std::string type;  ///< type of the equation (differential, algebraic...)
  };

  /**
   * @brief constructor
   *
   * @param time time of the linearization
   */
  explicit LinearizedSystem(double time);

  /**
   * @brief time getter
   * @return the time of the linearization
   */
  double getTime() const {
    return time_;
  }

  /**
   * @brief jacobian setter
   * @param jacobian jacobian of the system with respect to the variables
   */
  void setJacobian(Matrix jacobian);

  /**
   * @brief jacobian getter
   * @return the jacobian of the system with respect to the variables
   */
  const Matrix& getJacobian() const {
    return jacobian_;
  }

  /**
   * @brief prim jacobian setter
   * @param jacobianPrim jacobian of the system with respect to the derivatives of the variables
   */
  void setJacobianPrim(Matrix jacobianPrim);

  /**
   * @brief prim jacobian getter
   * @return the jacobian of the system with respect to the derivatives of the variables
   */
  const Matrix& getJacobianPrim() const {
    return jacobianPrim_;
  }

  /**
   * @brief add a variable, its index in the jacobians is the number of variables added before it
   *
   * @param name name of the variable in its model
   * @param modelName name of the model of the variable
   * @param type type of the variable
   */
  void addVariable(const std::string& name, const std::string& modelName, const std::string& type);

  /**
   * @brief variables getter
   * @return the variables, ordered as the columns of the jacobians
   */
  const std::vector<Variable>& getVariables() const {
    return variables_;
  }

  /**
   * @brief add an equation, its index in the jacobians is the number of equations added before it
   *
   * @param type type of the equation
   */
  void addEquation(const std::string& type);

  /**
   * @brief equations getter
   * @return the equations, ordered as the rows of the jacobians
   */
  const std::vector<Equation>& getEquations() const {
    return equations_;
  }

 private:
  double time_;  ///< time of the linearization
  Matrix jacobian_;  ///< jacobian of the system with respect to the variables
  Matrix jacobianPrim_;  ///< jacobian of the system with respect to the derivatives of the variables
  std::vector<Variable> variables_;  ///< variables, ordered as the columns of the jacobians
  std::vector<Equation> equations_;  ///< equations, ordered as the rows of the jacobians
};

}  // namespace matrix

#endif  // API_MAT_MATLINEARIZEDSYSTEM_H_
