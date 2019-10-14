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

#include <string>
#include <iostream>
#include <boost/shared_ptr.hpp>

namespace timeline {
class Timeline;

/**
 * @class Exporter
 * @brief Exporter interface class
 *
 * Exporter class for timeline
 */
class Exporter {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Exporter() {}

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
};

}  // namespace timeline

#endif  // API_TL_TLEXPORTER_H_
