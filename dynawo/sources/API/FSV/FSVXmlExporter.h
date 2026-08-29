//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  FSVXmlExporter.h
 *
 * @brief Dynawo final state values collection XML exporter as final state values: header file
 *
 */

#ifndef API_FSV_FSVXMLEXPORTER_H_
#define API_FSV_FSVXMLEXPORTER_H_

#include "FSVExporter.h"

namespace finalStateValues {

/**
 * @class XmlExporter
 * @brief XML exporter interface class
 *
 * XML export class for final state values collection
 */
class XmlExporter : public Exporter {
 public:
  /**
   * @brief Export method in XML format
   *
   * @param finalStateValues final state values
   * @param filePath file where the final state values must be exported
   */
  void exportToFile(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues, const std::string& filePath) const override;

  /**
   * @brief Export method in XML format. Note: Only those marked as final state
   * values will be exported.
   *
   * @param finalStateValues final state values to export as final state values.
   * @param stream stream where the final state values must be exported
   */
  void exportToStream(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues, std::ostream& stream) const override;
};

}  // namespace finalStateValues

#endif  // API_FSV_FSVXMLEXPORTER_H_
