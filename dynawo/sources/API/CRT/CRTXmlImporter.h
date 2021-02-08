//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  CRTXmlImporter.h
 *
 * @brief Criteria collection XML importer : header file
 *
 */

#ifndef API_CRT_CRTXMLIMPORTER_H_
#define API_CRT_CRTXMLIMPORTER_H_

#include "CRTImporter.h"

namespace criteria {

/**
 * @class XmlImporter
 * @brief Xml Importer interface class
 *
 * Xml Import class for criteria collection.
 */
class XmlImporter : public Importer {
 public:
  /**
   * @brief Constructor
   * @param multiThreadingMode true if this simulation is running in parallel with others simulation
   */
  explicit XmlImporter(bool multiThreadingMode): multiThreadingMode_(multiThreadingMode) {}
  /**
   * @brief Destructor
   */
  virtual ~XmlImporter() {}
  /**
   * @copydoc Importer::importFromFile()
   */
  boost::shared_ptr<CriteriaCollection> importFromFile(const std::string& fileName) const;

   /**
   * @copydoc Importer::importFromStream()
   */
  boost::shared_ptr<CriteriaCollection> importFromStream(std::istream& stream) const;

 private:
  bool multiThreadingMode_;  ///< true if this simulation is running in parallel with others simulation
};

}  // namespace criteria

#endif  // API_CRT_CRTXMLIMPORTER_H_
