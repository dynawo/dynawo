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
 * @file  FSModelImpl.h
 *
 * @brief final state model : header file
 *
 */
#ifndef API_FS_FSMODELIMPL_H_
#define API_FS_FSMODELIMPL_H_

#include <vector>

#include "FSModel.h"


namespace finalState {
class Variable;

/**
 * @class Model::Impl
 * @brief final state model implemented class
 *
 * Interface class for model object. Model is a container of variable or submodels
 */
class Model::Impl : public Model {
 public:
  /**
   * @brief Constructor
   *
   * @param id model's id
   */
  explicit Impl(const std::string& id);

  /**
   * @brief Destructor
   */
  ~Impl();

  /**
   * @copydoc Model::setId(const std::string& id)
   */
  void setId(const std::string& id);

  /**
   * @copydoc Model::addSubModel(const boost::shared_ptr<Model>& model)
   */
  void addSubModel(const boost::shared_ptr<Model>& model);

  /**
   * @copydoc Model::addVariable(const boost::shared_ptr<Variable>& variable)
   */
  void addVariable(const boost::shared_ptr<Variable>& variable);

  /**
   * @copydoc Model::getId()
   */
  std::string getId() const;

  /**
   * @copydoc Model::cbeginModel()
   */
  virtual model_const_iterator cbeginModel() const;

  /**
   * @copydoc Model::cendModel()
   */
  virtual model_const_iterator cendModel() const;

  /**
   * @copydoc Model::cbeginVariable()
   */
  virtual variable_const_iterator cbeginVariable() const;

  /**
   * @copydoc Model::cendVariable()
   */
  virtual variable_const_iterator cendVariable() const;

  /**
   * @brief Get an iterator to the beginning of the models' vector
   * @return an iterator to the beginning of the models' vector
   */
  virtual model_iterator beginModel();

  /**
   * @brief Get an iterator to the end of the models' vector
   * @return an iterator to the end of the models' vector
   */
  virtual model_iterator endModel();

  /**
   * @brief Get an iterator to the beginning of the variables' vector
   * @return an iterator to the beginning of the variables' vector
   */
  virtual variable_iterator beginVariable();

  /**
   * @brief Get an iterator to the end of the variables' vector
   * @return an iterator to the end of the variables' vector
   */
  virtual variable_iterator endVariable();

  friend class ModelConstIteratorImpl;
  friend class VariableConstIteratorImpl;
  friend class ModelIteratorImpl;
  friend class VariableIteratorImpl;

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  std::string id_;  ///< model's id
  std::vector<boost::shared_ptr<Model> > subModels_;  ///< vector of each subModels contained in this model
  std::vector<boost::shared_ptr<Variable> > variables_;  ///< vector of each variables of this model
};

}  // namespace finalState

#endif  // API_FS_FSMODELIMPL_H_
