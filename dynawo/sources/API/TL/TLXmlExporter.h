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
 * @file  TLXmlExporter.h
 * @brief Dynawo timeline xml exporter : header file
 *
 */
#ifndef API_TL_TLXMLEXPORTER_H_
#define API_TL_TLXMLEXPORTER_H_

#include "TLExporter.h"

namespace timeline {

/**
 * @class XmlExporter
 * @brief XML exporter interface class
 *
 * XML export class for timeline
 */
class XmlExporter : public Exporter {
 public:
  /**
   * @brief Export method in XML format
   *
   * @param timeline Timeline to export
   * @param filePath File to export XML formatted timeline to
   */
  void exportToFile(const boost::shared_ptr<Timeline>& timeline, const std::string& filePath) const override;

  /**
   * @brief Export method in XML format
   *
   * @param timeline Timeline to export
   * @param stream stream to export XML formatted timeline to
   */
  void exportToStream(const boost::shared_ptr<Timeline>& timeline, std::ostream& stream) const override;
};

}  // namespace timeline

#endif  // API_TL_TLXMLEXPORTER_H_
