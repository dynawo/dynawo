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

#include <string>

#include "DYDExport.h"

namespace dynamicdata {
class DynamicModelsCollection;

/**
 * @class Exporter
 * @brief Exporter interface class
 *
 * Exporter class for dynamic models collections.
 */
class __DYNAWO_DYD_EXPORT Exporter {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Exporter() {}
  /**
   * @brief Export method for this exporter
   *
   * @param collection Collection to export
   * @param filePath File to export to
   */
  virtual void exportToFile(const boost::shared_ptr<DynamicModelsCollection>& collection, const std::string& filePath) const = 0;

  /**
   * @brief Export method in XML format
   *
   * @param collection Collection to export
   * @param stream Stream to export XML formatted parameters to
   */
  virtual void exportToStream(const boost::shared_ptr<DynamicModelsCollection>& collection, std::ostream& stream) const = 0;
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDEXPORTER_H_
