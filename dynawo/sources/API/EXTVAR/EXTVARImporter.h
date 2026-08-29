//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file EXTVARImporter.h
 * @brief Dynawo external variables importer : interface file
 *
 */

#ifndef API_EXTVAR_EXTVARIMPORTER_H_
#define API_EXTVAR_EXTVARIMPORTER_H_

#include <string>

#include "EXTVARVariablesCollection.h"
namespace externalVariables {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Importer
 * @brief Importer interface class
 *
 * Import class for dynamic models collections.
 */
class Importer {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Importer() = default;

  /**
   * @brief Import external (i.e. C++-connected) variables
   *
   * @param fileName File name
   * @returns Collection imported
   */
  virtual std::shared_ptr<VariablesCollection> importFromFile(const std::string& fileName) const = 0;

  /**
   * @brief Import external (i.e. C++-connected) variables
   *
   * @param stream Stream to import
   * @returns Collection imported
   */
  virtual std::shared_ptr<VariablesCollection> importFromStream(std::istream& stream) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARIMPORTER_H_
