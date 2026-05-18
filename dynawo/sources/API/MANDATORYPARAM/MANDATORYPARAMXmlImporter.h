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
 * @file MANDATORYPARAMXmlImporter.h
 * @brief Mandatory parameters XML importer : interface file
 */

#ifndef API_MANDATORYPARAM_MANDATORYPARAMXMLIMPORTER_H_
#define API_MANDATORYPARAM_MANDATORYPARAMXMLIMPORTER_H_

#include <memory>
#include <string>

#include "MANDATORYPARAMCollection.h"

namespace mandatoryParameters {

/**
 * @class XmlImporter
 * @brief XML importer for .mandatoryParam files
 */
class XmlImporter {
 public:
  /**
   * @brief Import a mandatory parameters collection from a file
   * @param filePath path to the .mandatoryParam file
   * @return parsed collection
   */
  std::shared_ptr<Collection> importFromFile(const std::string& filePath) const;

  /**
   * @brief Import a mandatory parameters collection from a stream
   * @param stream input stream containing .mandatoryParam XML
   * @return parsed collection
   */
  std::shared_ptr<Collection> importFromStream(std::istream& stream) const;
};

}  // namespace mandatoryParameters

#endif  // API_MANDATORYPARAM_MANDATORYPARAMXMLIMPORTER_H_
