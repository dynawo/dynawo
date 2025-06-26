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
 * @file  CSTRExporter.h
 *
 * @brief Dynawo constraints exporter : interface class
 *
 */

#ifndef API_CSTR_CSTREXPORTER_H_
#define API_CSTR_CSTREXPORTER_H_

#include "CSTRConstraintsCollection.h"

#include <string>

namespace constraints {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Exporter
 * @brief Exporter interface class
 *
 * Exporter class for ConstraintsCollection
 */
class Exporter {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Exporter() = default;

  /**
   * @brief Export method for this exporter
   *
   * @param constraints ConstraintsCollection to export
   * @param filePath File to export to
   */
  virtual void exportToFile(const std::shared_ptr<ConstraintsCollection>& constraints, const std::string& filePath) const = 0;

  /**
   * @brief Export method for this exporter
   *
   * @param constraints ConstraintsCollection to export
   * @param stream stream to export to
   * @param afterTime export only events occuring after this 'afterTime' time
   */
  virtual void exportToStream(const std::shared_ptr<ConstraintsCollection>& constraints, std::ostream& stream, double afterTime) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace constraints

#endif  // API_CSTR_CSTREXPORTER_H_
