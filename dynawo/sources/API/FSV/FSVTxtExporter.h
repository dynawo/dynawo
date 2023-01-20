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
 * @file  FSVTxtExporter.h
 *
 * @brief Dynawo final state values collection TXT exporter : header file
 *
 */

#ifndef API_FSV_FSVTXTEXPORTER_H_
#define API_FSV_FSVTXTEXPORTER_H_

#include "FSVExporter.h"

namespace finalStateValues {

/**
 * @class TxtExporter
 * @brief TXT exporter interface class
 *
 * Txt export class for final state values
 */
class TxtExporter : public Exporter {
 public:
  /**
   * @brief Export method in TXT format
   *
   * @param finalStateValues final state values
   * @param filePath file where the final state values must be exported
   */
  void exportToFile(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues, const std::string& filePath) const;

  /**
   * @brief Export method in txt format
   *
   * @param finalStateValues finalStateValues to export
   * @param stream stream where the final state values must be exported
   */
  void exportToStream(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues, std::ostream& stream) const;
};

}  // namespace finalStateValues

#endif  // API_FSV_FSVTXTEXPORTER_H_
