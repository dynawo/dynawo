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
 * @file  FSFinalStateCollection.h
 *
 * @brief Final State collection description : interface file
 *
 */

#ifndef API_FS_FSFINALSTATECOLLECTION_H_
#define API_FS_FSFINALSTATECOLLECTION_H_

#include <boost/shared_ptr.hpp>

#include "FSExport.h"

namespace finalState {
class Model;
class Variable;
class variable_const_iterator;
class model_const_iterator;
class variable_iterator;
class model_iterator;

/**
 * @class FinalStateCollection
 * @brief final state collection interface class
 *
 * Interface class for final state collection object. This a container for final state requested
 */
class __DYNAWO_FS_EXPORT FinalStateCollection {
 public:
  /**
   * @brief Destructor
   */
  virtual ~FinalStateCollection() { }

  /**
   * @brief add a model to the final state structure
   *
   * @param model model to add to the structure
   */
  virtual void addModel(const boost::shared_ptr<Model>& model) = 0;

  /**
   * @brief add a variable to the final state structure
   *
   * @param variable model to add to the structure
   */
  virtual void addVariable(const boost::shared_ptr<Variable>& variable) = 0;

  /**
   * @brief Get a const_iterator to the beginning of the variables' vector
   * @return a const_iterator to the beginning of the variables' vector
   */
  virtual variable_const_iterator cbeginVariable() const = 0;

  /**
   * @brief Get a const_iterator to the end of the variables' vector
   * @return a const_iterator to the end of the variables' vector
   */
  virtual variable_const_iterator cendVariable() const = 0;

  /**
   * @brief Get a const_iterator to the beginning of the models' vector
   * @return a const_iterator to the beginning of the models' vector
   */
  virtual model_const_iterator cbeginModel() const = 0;

  /**
   * @brief Get a const_iterator to the end of the models' vector
   * @return a const_iterator to the end of the models' vector
   */
  virtual model_const_iterator cendModel() const = 0;

  /**
   * @brief Get an iterator to the beginning of the variables' vector
   * @return an iterator to the beginning of the variables' vector
   */
  virtual variable_iterator beginVariable() = 0;

  /**
   * @brief Get an iterator to the end of the variables' vector
   * @return an iterator to the end of the variables' vector
   */
  virtual variable_iterator endVariable() = 0;

  /**
   * @brief Get an iterator to the beginning of the models' vector
   * @return an iterator to the beginning of the models' vector
   */
  virtual model_iterator beginModel() = 0;

  /**
   * @brief Get an iterator to the end of the models' vector
   * @return an iterator to the end of the models' vector
   */
  virtual model_iterator endModel() = 0;

  class Impl;  // Implementation class
};

}  // namespace finalState

#endif  // API_FS_FSFINALSTATECOLLECTION_H_
