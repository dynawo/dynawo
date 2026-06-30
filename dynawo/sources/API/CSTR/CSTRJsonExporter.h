//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  CSTRJsonExporter.h
 *
 * @brief Dynawo constraints JSON exporter : header file
 *
 */

#ifndef API_CSTR_CSTRJSONEXPORTER_H_
#define API_CSTR_CSTRJSONEXPORTER_H_

#include "CSTRExporter.h"

namespace constraints {

/**
 * @class JsonExporter
 * @brief JSON exporter interface class
 *
 * JSON export class for constraints
 */
class JsonExporter : public Exporter {
 public:
  /**
   * @brief Export method in JSON format
   *
   * @param constraints Constraints to export
   * @param filePath File to export JSON formatted constraints to
   * @param exportEventType Whether to export event type
   */
  void exportToFile(const std::shared_ptr<ConstraintsCollection>& constraints,
                    const std::string& filePath,
                    bool exportEventType = false) const override;

  /**
   * @brief Export method in JSON format
   *
   * @param constraints Constraints to export
   * @param stream Stream to export JSON formatted constraints to
   * @param minTime Minimum time threshold (constraints with time < minTime are excluded, negative value means no filtering)
   * @param exportEventType Whether to export event type
   */
  void exportToStream(const std::shared_ptr<ConstraintsCollection>& constraints,
                      std::ostream& stream,
                      double minTime = -1.0,
                      bool exportEventType = false) const override;
};

}  // namespace constraints

#endif  // API_CSTR_CSTRJSONEXPORTER_H_
