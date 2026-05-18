//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
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
 * @file MANDATORYPARAMXmlExporter.h
 * @brief Mandatory parameters XML exporter : interface file
 */

#ifndef API_MANDATORYPARAM_MANDATORYPARAMXMLEXPORTER_H_
#define API_MANDATORYPARAM_MANDATORYPARAMXMLEXPORTER_H_

#include <string>

#include "MANDATORYPARAMCollection.h"

namespace mandatoryParameters {

/**
 * @class XmlExporter
 * @brief XML exporter for .mandatoryParam files
 */
class XmlExporter {
 public:
  /**
   * @brief Export a mandatory parameters collection to a file
   * @param collection collection to export
   * @param filePath path of the output file
   */
  void exportToFile(const Collection& collection, const std::string& filePath) const;
};

}  // namespace mandatoryParameters

#endif  // API_MANDATORYPARAM_MANDATORYPARAMXMLEXPORTER_H_
