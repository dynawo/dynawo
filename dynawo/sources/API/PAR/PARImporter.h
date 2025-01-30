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
 * @file PARImporter.h
 * @brief Dynawo parameters collection importer : interface file
 *
 */

#ifndef API_PAR_PARIMPORTER_H_
#define API_PAR_PARIMPORTER_H_

#include "PARParametersSetCollection.h"

#include <string>
#include <memory>


namespace parameters {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Importer
 * @brief Importer interface class
 *
 * Import class for parameters collections.
 */
class Importer {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Importer() = default;

  /**
   * @brief Import parameters' set collection from file
   *
   * @param fileName File name
   * @returns Collection imported
   */
  virtual std::shared_ptr<ParametersSetCollection> importFromFile(const std::string& fileName) const = 0;

  /**
   * @brief Import parameters' set collection from stream
   *
   * @param stream stream to import
   * @returns Collection imported
   */
  virtual std::shared_ptr<ParametersSetCollection> importFromStream(std::istream& stream) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace parameters

#endif  // API_PAR_PARIMPORTER_H_
