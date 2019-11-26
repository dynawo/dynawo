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

namespace finalState {
class FinalStateModel;
class Variable;
class finalStateVariable_const_iterator;
class finalStateModel_const_iterator;
class finalStateVariable_iterator;
class finalStateModel_iterator;

/**
 * @class FinalStateCollection
 * @brief final state collection interface class
 *
 * Interface class for final state collection object. This a container for final state requested
 */
class FinalStateCollection {
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
  virtual void addFinalStateModel(const boost::shared_ptr<FinalStateModel>& model) = 0;

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
  virtual finalStateVariable_const_iterator cbeginVariable() const = 0;

  /**
   * @brief Get a const_iterator to the end of the variables' vector
   * @return a const_iterator to the end of the variables' vector
   */
  virtual finalStateVariable_const_iterator cendVariable() const = 0;

  /**
   * @brief Get a const_iterator to the beginning of the models' vector
   * @return a const_iterator to the beginning of the models' vector
   */
  virtual finalStateModel_const_iterator cbeginFinalStateModel() const = 0;

  /**
   * @brief Get a const_iterator to the end of the models' vector
   * @return a const_iterator to the end of the models' vector
   */
  virtual finalStateModel_const_iterator cendFinalStateModel() const = 0;

  /**
   * @brief Get an iterator to the beginning of the variables' vector
   * @return an iterator to the beginning of the variables' vector
   */
  virtual finalStateVariable_iterator beginVariable() = 0;

  /**
   * @brief Get an iterator to the end of the variables' vector
   * @return an iterator to the end of the variables' vector
   */
  virtual finalStateVariable_iterator endVariable() = 0;

  /**
   * @brief Get an iterator to the beginning of the models' vector
   * @return an iterator to the beginning of the models' vector
   */
  virtual finalStateModel_iterator beginFinalStateModel() = 0;

  /**
   * @brief Get an iterator to the end of the models' vector
   * @return an iterator to the end of the models' vector
   */
  virtual finalStateModel_iterator endFinalStateModel() = 0;

  class Impl;  // Implementation class
};

}  // namespace finalState

#endif  // API_FS_FSFINALSTATECOLLECTION_H_
