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
 * @file  FSFinalStateCollectionImpl.h
 *
 * @brief Final state collection description : header file
 *
 */
#ifndef API_FS_FSFINALSTATECOLLECTIONIMPL_H_
#define API_FS_FSFINALSTATECOLLECTIONIMPL_H_

#include <string>
#include <vector>

#include "FSFinalStateCollection.h"

namespace finalState {

/**
 * @class FinalStateCollection::Impl
 * @brief final state collection implemented class
 *
 * Implemented class for final state collection object. This a container for final state requested
 */
class FinalStateCollection::Impl : public FinalStateCollection {
 public:
  /**
   * @brief Constructor
   *
   * @param id final state collection's id
   */
  explicit Impl(const std::string& id);

  /**
   * @brief Destructor
   */
  virtual ~Impl();

  /**
   * @copydoc FinalStateCollection::addModel(const boost::shared_ptr<Model>& model)
   */
  void addModel(const boost::shared_ptr<Model>& model);

  /**
   * @copydoc FinalStateCollection::addVariable(const boost::shared_ptr<Variable>& variable)
   */
  void addVariable(const boost::shared_ptr<Variable>& variable);

  /**
   * @brief  Get a const_iterator to the beginning of the models' vector
   * @return a const_iterator to the beginning of the models' vector
   */
  virtual finalStateModel_const_iterator cbeginModel() const;

  /**
   * @brief Get a const_iterator to the end of the models' vector
   * @return a const_iterator to the end of the models' vector
   */
  virtual finalStateModel_const_iterator cendModel() const;

  /**
   * @brief Get a const_iterator to the beginning of the variables' vector
   * @return a const_iterator to the beginning of the variables' vector
   */
  virtual finalStateVariable_const_iterator cbeginVariable() const;

  /**
   * @brief Get a const_iterator to the end of the variables' vector
   * @return a const_iterator to the end of the variables' vector
   */
  virtual finalStateVariable_const_iterator cendVariable() const;

  /**
   * @brief Get an iterator to the beginning of the models' vector
   * @return an iterator to the beginning of the models' vector
   */
  virtual finalStateModel_iterator beginModel();

  /**
   * @brief Get an iterator to the end of the models' vector
   * @return an iterator to the end of the models' vector
   */
  virtual finalStateModel_iterator endModel();

  /**
   * @brief Get an iterator to the beginning of the variables' vector
   * @return an iterator to the beginning of the variables' vector
   */
  virtual finalStateVariable_iterator beginVariable();

  /**
   * @brief Get an iterator to the end of the variables' vector
   * @return an iterator to the end of the variables' vector
   */
  virtual finalStateVariable_iterator endVariable();


  friend class ModelConstIteratorImpl;
  friend class ModelIteratorImpl;
  friend class VariableConstIteratorImpl;
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

  std::string id_;  ///< Collection id
  std::vector<boost::shared_ptr<Model> > models_;  ///< model structure of researched final state
  std::vector<boost::shared_ptr<Variable> > variables_;  ///< top variable requested for final state
};

}  // namespace finalState

#endif  // API_FS_FSFINALSTATECOLLECTIONIMPL_H_
