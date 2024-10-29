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
 * @file  CRVXmlExporter.h
 *
 * @brief Dynawo curves collection XML exporter: header file
 *
 */
#ifndef API_CRV_CRVXMLEXPORTER_H_
#define API_CRV_CRVXMLEXPORTER_H_

#include "CRVExporter.h"

namespace curves {

/**
 * @class XmlExporter
 * @brief XML exporter interface class
 *
 * XML export class for curves collection
 */
class XmlExporter : public Exporter {
 public:
  /**
   * @brief Export method in XML format
   *
   * @param curves curves to export
   * @param filePath file where the curves must be exported
   */
  void exportToFile(const std::shared_ptr<CurvesCollection>& curves, const std::string& filePath) const;

  /**
   * @brief Export method in XML format
   *
   * @param curves curves to export
   * @param stream stream where the curves must be exported
   */
  void exportToStream(const std::shared_ptr<CurvesCollection>& curves, std::ostream& stream) const;
};

}  // namespace curves

#endif  // API_CRV_CRVXMLEXPORTER_H_
