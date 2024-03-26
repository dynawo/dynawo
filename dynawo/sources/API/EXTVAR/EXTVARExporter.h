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
 * @file EXTVARExporter.h
 * @brief Dynawo external variables collection exporter : interface file
 *
 */

#ifndef API_EXTVAR_EXTVAREXPORTER_H_
#define API_EXTVAR_EXTVAREXPORTER_H_

#include <string>

#include "EXTVARVariablesCollection.h"
namespace externalVariables {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Exporter
 * @brief Exporter interface class
 *
 * Exporter class for dynamic models collections.
 */
class Exporter {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Exporter() = default;

  /**
   * @brief Export method for this exporter
   *
   * @param collection variables collection to export
   * @param filePath File to export to
   */
  virtual void exportToFile(const VariablesCollection& collection, const std::string& filePath) const = 0;

   /**
   * @brief Export method for this exporter
   *
   * @param collection variables collection to export
   * @param stream stream to export to
   */
  virtual void exportToStream(const VariablesCollection& collection, std::ostream& stream) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVAREXPORTER_H_
