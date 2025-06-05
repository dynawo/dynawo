//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
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
 * @file  FSVCsvExporter.h
 *
 * @brief Dynawo final state values collection CSV exporter : header file
 *
 */

#ifndef API_FSV_FSVCSVEXPORTER_H_
#define API_FSV_FSVCSVEXPORTER_H_

#include "FSVExporter.h"

namespace finalStateValues {

/**
 * @class CsvExporter
 * @brief CSV exporter interface class
 *
 * Csv export class for final state values
 */
class CsvExporter : public Exporter {
 public:
  /**
   * @brief Export method in CSV format
   *
   * @param finalStateValues final state values
   * @param filePath file where the final state values must be exported
   */
  void exportToFile(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues, const std::string& filePath) const override;

  /**
   * @brief Export method in csv format
   *
   * @param finalStateValues finalStateValues to export
   * @param stream stream where the final state values must be exported
   */
  void exportToStream(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues, std::ostream& stream) const override;
};

}  // namespace finalStateValues

#endif  // API_FSV_FSVCSVEXPORTER_H_
