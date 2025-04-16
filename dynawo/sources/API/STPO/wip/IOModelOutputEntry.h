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
 * @file  IOModelOutputEntry.h
 *
 * @brief Dynawo model output : interface file
 *
 */
#ifndef API_IO_IOMODELOUTPUTENTRY_H_
#define API_IO_IOMODELOUTPUTENTRY_H_


#include <string>
#include <vector>
#include <memory>

#include "IOOutputEntry.h"

namespace dynio {

/**
 * @class ModelOutputEntry
 * @brief ModelOutputEntry interface class
 *
 * class for output object.
 */
class ModelOutputEntry {
 public:
  /**
   * @brief Constructor
   */
  ModelOutputEntry();

  /**
   * @brief Setter for model name
   * @param modelName model name
   */
  void setModelName(const std::string& modelName);

  /**
   * @brief Getter for model name
   * @return model name
   */
  const std::string& getModelName() const;

  /**
   * @brief Add output to model outputs list
   * @param output name
   */
  void addOutputEntry();

 private:
  // attributes read in input file
  std::string modelName_;                          ///< Model's name for which we want have a curve
  std::vector< std::unique_ptr<OutputEntry> > outputs_;  ///< Vector of the output objects
};

/**
* @class ModelOutputEntryFactory
* @brief ModelOutputEntry factory class
*
* ModelOutputEntryFactory encapsulates methods for creating new
* @p ModelOutputEntry objects.
*/
class ModelOutputEntryFactory {
 public:
  /**
  * @brief Create new ModelOutputEntry instance
  *
  * @returns a unique pointer to a new @p ModelOutputEntry
  */
  static std::unique_ptr<ModelOutputEntry> newModelOutputEntry();
};
}  // namespace dynio

#endif  // API_IO_IOMODELOUTPUTENTRY_H_
