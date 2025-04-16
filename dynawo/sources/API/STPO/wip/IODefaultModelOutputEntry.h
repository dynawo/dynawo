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
 * @file  IODefaultModelOutputEntry.h
 *
 * @brief Dynawo default model output : interface file
 *
 */
#ifndef API_IO_IODEFAULTMODELOUTPUTENTRY_H_
#define API_IO_IODEFAULTMODELOUTPUTENTRY_H_


#include <string>
#include <vector>
#include <memory>

#include "IOOutputEntry.h"
#include "make_unique.hpp"

namespace dynio {

/**
 * @class DefaultModelOutputEntry
 * @brief DefaultModelOutputEntry interface class
 *
 * class for output object.
 */
class DefaultModelOutputEntry {
 public:
  /**
   * @brief Constructor
   */
  DefaultModelOutputEntry();

  /**
   * @brief Setter for model library name
   * @param modelLib model library
   */
  void setModelLib(const std::string& modelLib);

  /**
   * @brief Getter for model library name
   * @return model library name
   */
  const std::string& getModelLib() const;

  /**
   * @brief Add output to model outputs list
   * @param output name
   */
  void addOutputEntry();

 private:
  // attributes read in input file
  std::string modelLib_;                            ///< Model's name for which we want have a curve
  std::vector< std::unique_ptr<OutputEntry> > outputs_;  ///< Vector of the output objects
};

/**
* @class DefaultModelOutputEntryFactory
* @brief DefaultModelOutputEntry factory class
*
* DefaultModelOutputEntryFactory encapsulates methods for creating new
* @p DefaultModelOutputEntry objects.
*/
class DefaultModelOutputEntryFactory {
 public:
  /**
  * @brief Create new DefaultModelOutputEntry instance
  *
  * @returns a unique pointer to a new @p DefaultModelOutputEntry
  */
  static std::unique_ptr<DefaultModelOutputEntry> newDefaultModelOutputEntry();
};

}  // namespace dynio

#endif  // API_IO_IODEFAULTMODELOUTPUTENTRY_H_
