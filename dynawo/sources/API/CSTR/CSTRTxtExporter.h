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
 * @file  CSTRTxtExporter.h
 *
 * @brief Dynawo constraints txt exporter : header file
 *
 */

#ifndef API_CSTR_CSTRTXTEXPORTER_H_
#define API_CSTR_CSTRTXTEXPORTER_H_

#include "CSTRExporter.h"

namespace constraints {

/**
 * @class TxtExporter
 * @brief TXT exporter interface class
 *
 * Txt export class for constraints collection
 */
class TxtExporter : public Exporter {
 public:
  /**
   * @brief Export method in txt format
   *
   * @param constraints Constraints to export
   * @param filePath File to export txt formatted timeline to
   */
  void exportToFile(const std::shared_ptr<ConstraintsCollection>& constraints, const std::string& filePath) const override;

   /**
   * @brief Export method in txt format
   *
   * @param constraints Constraints to export
   * @param stream Stream to export txt formatted timeline to
   * @param afterTime export only events occuring after this 'afterTime' time
   */
  void exportToStream(const std::shared_ptr<ConstraintsCollection>& constraints, std::ostream& stream, double afterTime = -1.) const override;
};

}  // namespace constraints

#endif  // API_CSTR_CSTRTXTEXPORTER_H_
