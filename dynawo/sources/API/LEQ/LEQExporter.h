//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file  LEQExporter.h
 *
 * @brief Dynawo lost equipments exporter : interface class
 *
 */

#ifndef API_LEQ_LEQEXPORTER_H_
#define API_LEQ_LEQEXPORTER_H_

#include "LEQLostEquipmentsCollection.h"

#include <boost/shared_ptr.hpp>
#include <string>
#include <iostream>

namespace lostEquipments {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Exporter
 * @brief Exporter interface class
 *
 * Exporter class for LostEquipmentsCollection
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
   * @param lostEquipments Lost equipments to export
   * @param filePath File to export to
   */
  virtual void exportToFile(const boost::shared_ptr<LostEquipmentsCollection>& lostEquipments, const std::string& filePath) const = 0;

  /**
   * @brief Export method for this exporter
   *
   * @param lostEquipments Lost equipments to export
   * @param stream Stream to export to
   */
  virtual void exportToStream(const boost::shared_ptr<LostEquipmentsCollection>& lostEquipments, std::ostream& stream) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace lostEquipments

#endif  // API_LEQ_LEQEXPORTER_H_
