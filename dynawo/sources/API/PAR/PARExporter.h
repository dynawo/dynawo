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
 * @file PARExporter.h
 * @brief Dynawo parameters collection exporter : interface file
 */

#ifndef API_PAR_PAREXPORTER_H_
#define API_PAR_PAREXPORTER_H_

#include "PARParametersSetCollection.h"

#include <string>
#include <memory>


namespace parameters {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Exporter
 * @brief Exporter interface class
 *
 * Exporter class for parameters collections.
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
   * @param collection Collection to export
   * @param filePath File to export to
   * @param encoding the encoding for xml (parameter is ignored if empty)
   */
  virtual void exportToFile(const std::shared_ptr<ParametersSetCollection>& collection, const std::string& filePath, const std::string& encoding) const = 0;

  /**
   * @brief Export method for this exporter
   *
   * @param collection Collection to export
   * @param stream stream to export to
   * @param encoding the encoding for xml (parameter is ignored if empty)
   */
  virtual void exportToStream(const std::shared_ptr<ParametersSetCollection>& collection, std::ostream& stream, const std::string& encoding) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace parameters

#endif  // API_PAR_PAREXPORTER_H_
