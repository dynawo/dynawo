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
 * @file  CRVCurve.h
 *
 * @brief Dynawo output : interface file
 *
 */
#ifndef API_STPO_STPOOUTPUTENTRY_H_
#define API_STPO_STPOOUTPUTENTRY_H_


#include <string>
#include <memory>


namespace stepOutputs {
/**
 * @class OutputEntry
 * @brief OutputEntry interface class
 *
 * class for output object.
 */
class OutputEntry {
 public:
  /**
   * @brief Constructor
   */
  OutputEntry();

  /**
   * @brief Setter for output's variable
   * @param variable output's variable
   */
  void setVariable(const std::string& variable);

  /**
   * @brief Setter for output's alias
   * @param alias output's alias
   */
  void setAlias(const std::string& alias);

  /**
   * @brief Getter for output's variable
   * @return variable name associated to this output
   */
  const std::string& getVariable() const;

  /**
   * @brief Getter for output's alias
   * @return alias associated to this output
   */
  const std::string& getAlias() const;

 private:
  // attributes read in input file
  std::string variable_;   ///< Variable name
  std::string alias_;      ///< Alias
};

/**
 * @class OutputEntryFactory
 * @brief OutputEntry factory class
 *
 * OutputEntryFactory encapsulates methods for creating new
 * @p OutputEntry objects.
 */
class OutputEntryFactory {
 public:
  /**
  * @brief Create new OutputEntry instance
  *
  * @returns a unique pointer to a new @p OutputEntry
  */
  static std::unique_ptr<OutputEntry> newOutputEntry();
};
}  // namespace stepOutputs

#endif  // API_STPO_STPOOUTPUTENTRY_H_
