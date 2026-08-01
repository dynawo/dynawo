//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
 * @file  TLTxtExporter.h
 *
 * @brief Dynawo timeline txt exporter : header file
 *
 */
#ifndef API_TL_TLTXTEXPORTER_H_
#define API_TL_TLTXTEXPORTER_H_

#include "TLExporter.h"

namespace timeline {

/**
 * @class TxtExporter
 * @brief TXT exporter interface class
 *
 * Txt export class for timeline
 */
class TxtExporter : public Exporter {
 public:
  /**
   * @brief Export method in txt format
   *
   * @param timeline Timeline to export
   * @param filePath File to export txt formatted timeline to
   */
  void exportToFile(const boost::shared_ptr<Timeline>& timeline, const std::string& filePath) const override;

  /**
   * @brief Export method in txt format
   *
   * @param timeline Timeline to export
   * @param stream stream to export txt formatted timeline to
   */
  void exportToStream(const boost::shared_ptr<Timeline>& timeline, std::ostream& stream) const override;
};
}  // namespace timeline

#endif  // API_TL_TLTXTEXPORTER_H_
