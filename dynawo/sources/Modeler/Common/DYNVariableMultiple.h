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
 * @file  DYNVariableMultiple.h
 *
 * @brief Dynawo multiple variable : header file
 * @todo use this class for multiple variables once parameters reading has been updated
 *
 */
#ifndef MODELER_COMMON_DYNVARIABLEMULTIPLE_H_
#define MODELER_COMMON_DYNVARIABLEMULTIPLE_H_

#include <string>

#include <boost/optional.hpp>

#include "DYNVariableNative.h"

namespace DYN {

/**
 * @class VariableMultiple
 * @brief VariableMultiple implemented class
 *
 * Implementation of VariableMultiple class : store each information needed by dynawo to deal with a multiple variable
 */

class VariableMultiple : public VariableNative {
 public:
  /**
   * @brief Constructor
   *
   * @param name name of the variable
   * @param cardinalityName name of the parameter used to set the variable cardinality
   * @param type Type of the variable
   * @param isState @b whether the variable is a state variable
   * @param negated @b if the variable is negated
   */
  VariableMultiple(const std::string& name, const std::string& cardinalityName, const typeVar_t& type, bool isState, bool negated);

  /**
   * @brief Destructor
   */
  virtual ~VariableMultiple() = default;

  /**
   * @brief Getter for variable's cardinality parameter name
   *
   * @return variable's cardinality
   */
  inline std::string getCardinalityName() const {
    return cardinalityName_;
  }

  /**
   * @brief Check whether the variable cardinality value has been set
   *
   * @return @b whether it is already set
   */
  bool cardinalitySet() const;

  /**
   * @brief Getter for variable's cardinality value : the number of unit variables to create
   *
   * @return variable's cardinality value
   */
  unsigned int getCardinality() const;

  /**
   * @copydoc VariableNative::getIndex()
   */
  int getIndex() const;

  /**
   * @brief Setter for variable's cardinality value : the number of unit variables to create
   *
   * @param cardinality the new cardinality value
   */
  void setCardinality(const unsigned int& cardinality);

 private:
  VariableMultiple();  ///< Private default constructor

  const std::string cardinalityName_;  ///< name of the parameter used for cardinality computation
  boost::optional<unsigned int> cardinality_;  ///< the cardinality numeric value (use of boost::optional to easily check whether it has been set)
};
}  // namespace DYN

#endif  // MODELER_COMMON_DYNVARIABLEMULTIPLE_H_
