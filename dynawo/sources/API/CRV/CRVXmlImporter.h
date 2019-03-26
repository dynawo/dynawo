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
 * @file  CRVXmlImporter.h
 *
 * @brief Curves collection XML importer : header file
 *
 */

#ifndef API_CRV_CRVXMLIMPORTER_H_
#define API_CRV_CRVXMLIMPORTER_H_

#include "CRVImporter.h"

namespace curves {

/**
 * @class XmlImporter
 * @brief Xml Importer interface class
 *
 * Xml Import class for curves collection.
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
  boost::shared_ptr<CurvesCollection> importFromFile(const std::string& fileName) const;

   /**
   * @copydoc Importer::importFromStream()
   */
  boost::shared_ptr<CurvesCollection> importFromStream(std::istream& stream) const;
};

}  // namespace curves

#endif  // API_CRV_CRVXMLIMPORTER_H_
