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
 * @file  CSTRXmlExporter.h
 *
 * @brief Dynawo constraints xml exporter : header file
 *
 */

#ifndef API_CSTR_CSTRXMLEXPORTER_H_
#define API_CSTR_CSTRXMLEXPORTER_H_

#include "CSTRExporter.h"

namespace constraints {

/**
 * @class XmlExporter
 * @brief XML exporter interface class
 *
 * XML export class for constraints
 */
class XmlExporter : public Exporter {
 public:
  /**
   * @brief Export method in XML format
   *
   * @param constraints Constraints to export
   * @param filePath File to export XML formatted constraints to
   */
  void exportToFile(const std::shared_ptr<ConstraintsCollection>& constraints, const std::string& filePath) const override;

  /**
   * @brief Export method in XML format
   *
   * @param constraints Constraints to export
   * @param stream Stream to export XML formatted constraints to
   */
  void exportToStream(const std::shared_ptr<ConstraintsCollection>& constraints, std::ostream& stream) const override;
};

}  // namespace constraints

#endif  // API_CSTR_CSTRXMLEXPORTER_H_
