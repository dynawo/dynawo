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
 * @file  STPOXmlImporter.h
 *
 * @brief Outputs collection XML importer : header file
 *
 */

#ifndef API_STPO_STPOXMLIMPORTER_H_
#define API_STPO_STPOXMLIMPORTER_H_

#include "STPOImporter.h"

namespace stepOutputs {

/**
 * @class XmlImporter
 * @brief Xml Importer interface class
 *
 * Xml Import class for outputs collection.
 */
class XmlImporter : public Importer {
 public:
  /**
   * @copydoc Importer::importFromFile()
   */
  std::shared_ptr<OutputsCollection> importFromFile(const std::string& fileName) const;

   /**
   * @copydoc Importer::importFromStream()
   */
  std::shared_ptr<OutputsCollection> importFromStream(std::istream& stream) const;
};

}  // namespace stepOutputs

#endif  // API_STPO_STPOXMLIMPORTER_H_
