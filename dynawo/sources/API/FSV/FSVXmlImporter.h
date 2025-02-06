//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  FSVXmlImporter.h
 *
 * @brief Final State Values collection XML importer : header file
 *
 */

#ifndef API_FSV_FSVXMLIMPORTER_H_
#define API_FSV_FSVXMLIMPORTER_H_

#include "FSVFinalStateValuesCollection.h"

namespace finalStateValues {

/**
 * @class XmlImporter
 * @brief Xml Importer interface class
 *
 * Xml Import class for final state values collection.
 */
class XmlImporter {
 public:
  /**
   * @brief Import final state values collection from file
   *
   * @param fileName file name
   *
   * @return Final state values collection imported
   */
  std::shared_ptr<FinalStateValuesCollection> importFromFile(const std::string &fileName) const;

  /**
   * @brief Import final state values collection from stream
   *
   * @param stream stream from where the final state values must be imported
   *
   * @return Final state values collection imported
   */
  std::shared_ptr<FinalStateValuesCollection> importFromStream(std::istream &stream) const;
};

}  // namespace finalStateValues

#endif  // API_FSV_FSVXMLIMPORTER_H_
