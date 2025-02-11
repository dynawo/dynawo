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
 * @file  CRVCsvExporter.h
 *
 * @brief Dynawo curves collection CSV exporter : header file
 *
 */
#ifndef API_CRV_CRVCSVEXPORTER_H_
#define API_CRV_CRVCSVEXPORTER_H_

#include "CRVExporter.h"

namespace curves {

/**
 * @class CsvExporter
 * @brief CSV exporter interface class
 *
 * Csv export class for curves
 */
class CsvExporter : public Exporter {
 public:
  /**
   * @brief Export method in csv format
   *
   * @param curves curves to export
   * @param filePath File to export csv formatted curves to
   */
  void exportToFile(const std::shared_ptr<CurvesCollection>& curves, const std::string& filePath) const;

  /**
   * @brief Export method in csv format
   *
   * @param curves curves to export
   * @param stream stream to export csv formatted curves to
   */
  void exportToStream(const std::shared_ptr<CurvesCollection>& curves, std::ostream& stream) const;
};

}  // namespace curves

#endif  // API_CRV_CRVCSVEXPORTER_H_
