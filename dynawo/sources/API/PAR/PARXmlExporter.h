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
 * @file PARXmlExporter.h
 * @brief Dynawo parameters collection XML exporter : header file
 *
 */

#ifndef API_PAR_PARXMLEXPORTER_H_
#define API_PAR_PARXMLEXPORTER_H_

#include "PARExporter.h"

namespace parameters {

/**
 * @class XmlExporter
 * @brief XML exporter interface class
 *
 * XML export class for parameters collections.
 */
class XmlExporter : public Exporter {
 public:
  /**
   * @brief Export method in XML format
   *
   * @param collection Collection to export
   * @param filePath File to export XML formatted parameters to
   * @param encoding the encoding for xml (parameter is ignored if empty)
   */
  void exportToFile(const std::shared_ptr<ParametersSetCollection>& collection, const std::string& filePath, const std::string& encoding = "") const override;

  /**
   * @brief Export method in XML format
   *
   * @param collection Collection to export
   * @param stream stream to export XML formatted parameters to
   * @param encoding the encoding for xml (parameter is ignored if empty)
   */
  void exportToStream(const std::shared_ptr<ParametersSetCollection>& collection, std::ostream& stream, const std::string& encoding = "") const override;
};

}  // namespace parameters

#endif  // API_PAR_PARXMLEXPORTER_H_
