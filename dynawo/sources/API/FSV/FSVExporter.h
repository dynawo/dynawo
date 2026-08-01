//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
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
 * @file  FSVExporter.h
 *
 * @brief Dynawo final state values exporter: interface file
 *
 */

#ifndef API_FSV_FSVEXPORTER_H_
#define API_FSV_FSVEXPORTER_H_

#include <string>
#include <boost/shared_ptr.hpp>

#include "FSVFinalStateValuesCollection.h"

namespace finalStateValues {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Exporter
 * @brief Exporter interface class
 *
 * Exporter class for final state values
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
   * @param finalStateValues finalStateValues to export
   * @param filePath file to export to
   */
  virtual void exportToFile(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues, const std::string& filePath) const = 0;

   /**
   * @brief Export method for this exporter
   *
   * @param finalStateValues finalStateValues to export
   * @param stream stream to export to
   */
  virtual void exportToStream(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues, std::ostream& stream) const = 0;
};

}  // namespace finalStateValues

#endif  // API_FSV_FSVEXPORTER_H_
