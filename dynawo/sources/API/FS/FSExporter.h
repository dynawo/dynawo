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
 * @file  FSExporter.h
 *
 * @brief Dynawo final state exporter: interface file
 *
 */
#ifndef API_FS_FSEXPORTER_H_
#define API_FS_FSEXPORTER_H_

#include <string>

#include <boost/shared_ptr.hpp>

#include "FSExport.h"

namespace finalState {
class FinalStateCollection;

/**
 * @class Exporter
 * @brief Exporter interface class
 *
 * Exporter class for finalState
 */
class __DYNAWO_FS_EXPORT Exporter {
 public:
  /**
   * @brief Export method for this exporter
   *
   * @param finalState final state to export
   * @param filePath file to export to
   */
  virtual void exportToFile(const boost::shared_ptr<FinalStateCollection>& finalState, const std::string& filePath) const = 0;

   /**
   * @brief Export method for this exporter
   *
   * @param finalState final state to export
   * @param stream stream to export to
   */
  virtual void exportToStream(const boost::shared_ptr<FinalStateCollection>& finalState, std::ostream& stream) const = 0;
};

}  // namespace finalState

#endif  // API_FS_FSEXPORTER_H_
