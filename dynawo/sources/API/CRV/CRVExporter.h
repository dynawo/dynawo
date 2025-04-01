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
 * @file  CRVExporter.h
 *
 * @brief Dynawo curves exporter: interface file
 *
 */
#ifndef API_CRV_CRVEXPORTER_H_
#define API_CRV_CRVEXPORTER_H_

#include <string>
#include <boost/shared_ptr.hpp>

#include "CRVCurvesCollection.h"

namespace curves {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Exporter
 * @brief Exporter interface class
 *
 * Exporter class for curves
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
   * @param curves curvers to export
   * @param filePath file to export to
   */
  virtual void exportToFile(const boost::shared_ptr<CurvesCollection>& curves, const std::string& filePath) const = 0;

   /**
   * @brief Export method for this exporter
   *
   * @param curves curves to export
   * @param stream stream to export to
   */
  virtual void exportToStream(const boost::shared_ptr<CurvesCollection>& curves, std::ostream& stream) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace curves

#endif  // API_CRV_CRVEXPORTER_H_
