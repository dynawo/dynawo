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

#include "FSIterators.h"
#include "FSModel.h"
#include "FSVariable.h"

#include <boost/shared_ptr.hpp>
#include <string>

namespace finalState {

/**
 * @class FinalStateCollection
 * @brief final state collection interface class
 *
 * Interface class for final state collection object. This a container for final state requested
 */
class FinalStateCollection {
 public:
  /**
   * @brief Constructor
   *
   * @param id final state collection's id
   */
  explicit FinalStateCollection(const std::string& id);

  /**
   * @brief add a model to the final state structure
   *
   * @param model model to add to the structure
   */
  void addFinalStateModel(const boost::shared_ptr<FinalStateModel>& model);

  /**
   * @brief add a variable to the final state structure
   *
   * @param variable model to add to the structure
   */
  void addVariable(const boost::shared_ptr<Variable>& variable);

  /**
   * @brief Get a const_iterator to the beginning of the variables' vector
   * @return a const_iterator to the beginning of the variables' vector
   */
  finalStateVariable_const_iterator cbeginVariable() const;

  /**
   * @brief Get a const_iterator to the end of the variables' vector
   * @return a const_iterator to the end of the variables' vector
   */
  finalStateVariable_const_iterator cendVariable() const;

  /**
   * @brief Get a const_iterator to the beginning of the models' vector
   * @return a const_iterator to the beginning of the models' vector
   */
  finalStateModel_const_iterator cbeginFinalStateModel() const;

  /**
   * @brief Get a const_iterator to the end of the models' vector
   * @return a const_iterator to the end of the models' vector
   */
  finalStateModel_const_iterator cendFinalStateModel() const;

  /**
   * @brief Get an iterator to the beginning of the variables' vector
   * @return an iterator to the beginning of the variables' vector
   */
  finalStateVariable_iterator beginVariable();

  /**
   * @brief Get an iterator to the end of the variables' vector
   * @return an iterator to the end of the variables' vector
   */
  finalStateVariable_iterator endVariable();

  /**
   * @brief Get an iterator to the beginning of the models' vector
   * @return an iterator to the beginning of the models' vector
   */
  finalStateModel_iterator beginFinalStateModel();

  /**
   * @brief Get an iterator to the end of the models' vector
   * @return an iterator to the end of the models' vector
   */
  finalStateModel_iterator endFinalStateModel();

  friend class finalStateModel_const_iterator;
  friend class finalStateVariable_const_iterator;
  friend class finalStateModel_iterator;
  friend class finalStateVariable_iterator;

 private:
  std::string id_;                                           ///< Collection id
  std::vector<boost::shared_ptr<FinalStateModel> > models_;  ///< model structure of researched final state
  std::vector<boost::shared_ptr<Variable> > variables_;      ///< top variable requested for final state
};

}  // namespace finalState

#endif  // API_FS_FSFINALSTATECOLLECTION_H_
