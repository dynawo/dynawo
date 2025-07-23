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
 * @file  TLExporter.h
 *
 * @brief Dynawo timeline exporter : interface file
 *
 */
#ifndef API_TL_TLEXPORTER_H_
#define API_TL_TLEXPORTER_H_

#include "TLTimeline.h"

#include <boost/shared_ptr.hpp>
#include <iostream>
#include <string>

namespace timeline {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Exporter
 * @brief Exporter interface class
 *
 * Exporter class for timeline
 */
class Exporter {
 public:
  /**
   * @brief Default constructor
   */
  Exporter() : exportWithTime_(true), maxPriority_(boost::none) {}

  /**
   * @brief Destructor
   */
  virtual ~Exporter() = default;

  /**
   * @brief Export method for this exporter
   *
   * @param timeline Timeline to export
   * @param filePath File to export to
   */
  virtual void exportToFile(const boost::shared_ptr<Timeline>& timeline, const std::string& filePath) const = 0;

  /**
   * @brief Export method for this exporter
   *
   * @param timeline Timeline to export
   * @param stream stream to export to
   */
  virtual void exportToStream(const boost::shared_ptr<Timeline>& timeline, std::ostream& stream) const = 0;

  /**
   * @brief whether to export time setter
   * @param exportWithTime whether to export time
   */
  void setExportWithTime(const bool exportWithTime) {
    exportWithTime_ = exportWithTime;
  }

  /**
   * @brief maximum priority setter
   * @param maxPriority maximum priority allowed
   */
  void setMaxPriority(const boost::optional<int> maxPriority) {
    maxPriority_ = maxPriority;
  }

 protected:
  bool exportWithTime_;  ///< boolean indicating whether to export time when exporting timeline
  boost::optional<int> maxPriority_;  ///< maximum priority allowed when exporting timeline
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace timeline

#endif  // API_TL_TLEXPORTER_H_
