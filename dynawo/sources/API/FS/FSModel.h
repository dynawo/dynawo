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

#include "FSIterators.h"
#include "FSVariable.h"

#include <boost/shared_ptr.hpp>
#include <string>

namespace finalState {
/**
 * @class FinalStateModel
 * @brief final state model interface class
 *
 * Interface class for model object. Model is a container of variable or submodels
 */
class FinalStateModel {
 public:
   /**
   * @brief Constructor
   *
   * @param id model's id
   */
  explicit FinalStateModel(const std::string& id);

  /**
   * @brief Setter for model's id
   * @param id model's id
   */
  void setId(const std::string& id);

  /**
   * @brief Add a new submodel to the model
   * @param model model to add as a submodel to this model
   */
  void addSubModel(const boost::shared_ptr<FinalStateModel>& model);

  /**
   * @brief Add a new variable to the model
   * @param variable variable to add to this model
   */
  void addVariable(const boost::shared_ptr<Variable>& variable);

  /**
   * @brief Getter for model's id
   * @return id of this model
   */
  std::string getId() const;

  /**
   * @brief Get a variable_const_iterator to the beginning of variables' container
   * @return begin of variable
   */
  finalStateVariable_const_iterator cbeginVariable() const;

  /**
   * @brief Get a variable_const_iterator to the end of variables' container
   * @return end of variable
   */
  finalStateVariable_const_iterator cendVariable() const;

  /**
   * @brief Get a model_const_iterator to the beginning of models' container
   * @return begin of model
   */
  finalStateModel_const_iterator cbeginFinalStateModel() const;

  /**
   * @brief Get a model_const_iterator to the end of models' container
   * @return end of model
   */
  finalStateModel_const_iterator cendFinalStateModel() const;

  /**
   * @brief Get an iterator to the beginning of the variables' vector
   * @return begin of variable
   */
  finalStateVariable_iterator beginVariable();

  /**
   * @brief Get an iterator to the end of the variables' vector
   * @return end of variable
   */
  finalStateVariable_iterator endVariable();

  /**
   * @brief Get an iterator to the beginning of the models' vector
   * @return begin of model
   */
  finalStateModel_iterator beginFinalStateModel();

  /**
   * @brief Get an iterator to the end of the models' vector
   * @return end of model
   */
  finalStateModel_iterator endFinalStateModel();

  friend class finalStateModel_const_iterator;
  friend class finalStateVariable_const_iterator;
  friend class finalStateModel_iterator;
  friend class finalStateVariable_iterator;

 private:
  std::string id_;                                              ///< model's id
  std::vector<boost::shared_ptr<FinalStateModel> > subModels_;  ///< vector of each subModels contained in this model
  std::vector<boost::shared_ptr<Variable> > variables_;         ///< vector of each variables of this model
};

}  // namespace finalState

#endif  // API_FS_FSMODEL_H_
