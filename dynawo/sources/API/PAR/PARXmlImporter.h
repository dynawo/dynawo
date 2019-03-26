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
 * @file PARXmlImporter.h
 * @brief Dynawo parameters collection XML importer : header file
 *
 */

#ifndef API_PAR_PARXMLIMPORTER_H_
#define API_PAR_PARXMLIMPORTER_H_

#include "PARImporter.h"

namespace parameters {

/**
 * @class XmlImporter
 * @brief XML importer interface class
 *
 * XML import class for parameters collections.
 */
class XmlImporter : public Importer {
 public:
  /**
   * @brief Destructor
   */
  virtual ~XmlImporter() {}

  /**
   * @copydoc Importer::importFromFile()
   */
  boost::shared_ptr<ParametersSetCollection> importFromFile(const std::string& fileName) const;

  /**
   * @copydoc Importer::importFromStream()
   */
  boost::shared_ptr<ParametersSetCollection> importFromStream(std::istream& stream) const;
};

}  // namespace parameters

#endif  // API_PAR_PARXMLIMPORTER_H_
