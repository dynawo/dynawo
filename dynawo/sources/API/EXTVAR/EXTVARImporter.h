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
 * @file EXTVARImporter.h
 * @brief Dynawo external variables importer : interface file
 *
 */

#ifndef API_EXTVAR_EXTVARIMPORTER_H_
#define API_EXTVAR_EXTVARIMPORTER_H_

#include <string>

#include "EXTVARExport.h"

namespace externalVariables {
class VariablesCollection;

/**
 * @class Importer
 * @brief Importer interface class
 *
 * Import class for dynamic models collections.
 */
class __DYNAWO_EXTVAR_EXPORT Importer {
 public:
  /**
   * @brief Import external (i.e. C++-connected) variables
   *
   * @param fileName File name
   * @returns Collection imported
   */
  virtual boost::shared_ptr<VariablesCollection> importFromFile(const std::string& fileName) const = 0;

  /**
   * @brief Import external (i.e. C++-connected) variables
   *
   * @param stream Stream to import
   * @returns Collection imported
   */
  virtual boost::shared_ptr<VariablesCollection> importFromStream(std::istream& stream) const = 0;
};

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARIMPORTER_H_
