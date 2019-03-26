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
 * @file  FSXmlExporter.h
 *
 * @brief Dynawo final state XML exporter : header file
 *
 */
#ifndef API_FS_FSXMLEXPORTER_H_
#define API_FS_FSXMLEXPORTER_H_


#include "FSExporter.h"

namespace finalState {

/**
 * @class XmlExporter
 * @brief XML exporter interface class
 *
 * XML export class for final state
 */
class XmlExporter : public Exporter {
 public:
  /**
   * @brief Destructor
   */
  virtual ~XmlExporter() {}

  /**
   * @brief Export method in XML format
   *
   * @param finalState final state to export
   * @param filePath file where the final state must be exported
   */
  void exportToFile(const boost::shared_ptr<FinalStateCollection>& finalState, const std::string& filePath) const;

  /**
   * @brief Export method in XML format
   *
   * @param finalState final state to export
   * @param stream stream where the final state must be exported
   */
  void exportToStream(const boost::shared_ptr<FinalStateCollection>& finalState, std::ostream& stream) const;
};

}  // namespace finalState

#endif  // API_FS_FSXMLEXPORTER_H_
