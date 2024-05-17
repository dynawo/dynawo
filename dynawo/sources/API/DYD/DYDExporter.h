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
 * @file DYDExporter.h
 * @brief Dynawo dynamic models collection exporter : interface file
 *
 */

#ifndef API_DYD_DYDEXPORTER_H_
#define API_DYD_DYDEXPORTER_H_

#include "DYDDynamicModelsCollection.h"

#include <string>

namespace dynamicdata {

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
   * @param collection Collection to export
   * @param filePath File to export to
   * @param encoding the encoding for xml (parameter is ignored if empty)
   */
  virtual void exportToFile(const boost::shared_ptr<DynamicModelsCollection>& collection, const std::string& filePath, const std::string& encoding) const = 0;

  /**
   * @brief Export method in XML format
   *
   * @param collection Collection to export
   * @param stream Stream to export XML formatted parameters to
   * @param encoding the encoding for xml (parameter is ignored if empty)
   */
  virtual void exportToStream(const boost::shared_ptr<DynamicModelsCollection>& collection, std::ostream& stream, const std::string& encoding) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace dynamicdata

#endif  // API_DYD_DYDEXPORTER_H_
