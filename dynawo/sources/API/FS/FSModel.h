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
 * @file  FSModel.h
 *
 * @brief final state model : interface file
 *
 */
#ifndef API_FS_FSMODEL_H_
#define API_FS_FSMODEL_H_

#include <string>
#include <boost/shared_ptr.hpp>

namespace finalState {
class Variable;
class finalStateVariable_const_iterator;
class finalStateModel_const_iterator;
class finalStateVariable_iterator;
class finalStateModel_iterator;

/**
 * @class FinalStateModel
 * @brief final state model interface class
 *
 * Interface class for model object. Model is a container of variable or submodels
 */
class FinalStateModel {
 public:
  /**
   * @brief Destructor
   */
  virtual ~FinalStateModel() { }

  /**
   * @brief Setter for model's id
   * @param id model's id
   */
  virtual void setId(const std::string& id) = 0;

  /**
   * @brief Add a new submodel to the model
   * @param model model to add as a submodel to this model
   */
  virtual void addSubModel(const boost::shared_ptr<FinalStateModel>& model) = 0;

  /**
   * @brief Add a new variable to the model
   * @param variable variable to add to this model
   */
  virtual void addVariable(const boost::shared_ptr<Variable>& variable) = 0;

  /**
   * @brief Getter for model's id
   * @return id of this model
   */
  virtual std::string getId() const = 0;

  class Impl;

  /**
   * @brief Get a variable_const_iterator to the beginning of variables' container
   * @return begin of variable
   */
  virtual finalStateVariable_const_iterator cbeginVariable() const = 0;

  /**
   * @brief Get a variable_const_iterator to the end of variables' container
   * @return end of variable
   */
  virtual finalStateVariable_const_iterator cendVariable() const = 0;

  /**
   * @brief Get a model_const_iterator to the beginning of models' container
   * @return begin of model
   */
  virtual finalStateModel_const_iterator cbeginFinalStateModel() const = 0;

  /**
   * @brief Get a model_const_iterator to the end of models' container
   * @return end of model
   */
  virtual finalStateModel_const_iterator cendFinalStateModel() const = 0;

  /**
   * @brief Get an iterator to the beginning of the variables' vector
   * @return begin of variable
   */
  virtual finalStateVariable_iterator beginVariable() = 0;

  /**
   * @brief Get an iterator to the end of the variables' vector
   * @return end of variable
   */
  virtual finalStateVariable_iterator endVariable() = 0;

  /**
   * @brief Get an iterator to the beginning of the models' vector
   * @return begin of model
   */
  virtual finalStateModel_iterator beginFinalStateModel() = 0;

  /**
   * @brief Get an iterator to the end of the models' vector
   * @return end of model
   */
  virtual finalStateModel_iterator endFinalStateModel() = 0;
};

}  // namespace finalState

#endif  // API_FS_FSMODEL_H_
