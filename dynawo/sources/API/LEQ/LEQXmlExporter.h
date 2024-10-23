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
 * @file  LEQXmlExporter.h
 *
 * @brief Dynawo lost equipments xml exporter : header file
 *
 */

#ifndef API_LEQ_LEQXMLEXPORTER_H_
#define API_LEQ_LEQXMLEXPORTER_H_

#include "LEQExporter.h"

namespace lostEquipments {

/**
 * @class XmlExporter
 * @brief XML exporter interface class
 *
 * XML export class for lost equipments
 */
class XmlExporter : public Exporter {
 public:
  /**
   * @brief Export method in XML format
   *
   * @param lostEquipments Lost equipments to export
   * @param filePath File to export XML formatted lost equipments to
   */
  void exportToFile(const std::shared_ptr<LostEquipmentsCollection>& lostEquipments, const std::string& filePath) const;

  /**
   * @brief Export method in XML format
   *
   * @param lostEquipments Lost equipments to export
   * @param stream Stream to export XML formatted lost equipments to
   */
  void exportToStream(const std::shared_ptr<LostEquipmentsCollection>& lostEquipments, std::ostream& stream) const;
};

}  // namespace lostEquipments

#endif  // API_LEQ_LEQXMLEXPORTER_H_
