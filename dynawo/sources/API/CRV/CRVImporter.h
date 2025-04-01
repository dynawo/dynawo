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
 * @file  CRVImporter.h
 *
 * @brief Curves collection importer : interface file
 *
 */

#ifndef API_CRV_CRVIMPORTER_H_
#define API_CRV_CRVIMPORTER_H_

#include <boost/shared_ptr.hpp>

#include "CRVCurvesCollection.h"

namespace curves {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Importer
 * @brief Importer interface class
 *
 * Import class for curves collection.
 */
class Importer {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Importer() = default;

  /**
   * @brief Import curves's collection from file
   *
   * @param fileName file name
   *
   * @return Curves collection imported
   */
  virtual boost::shared_ptr<CurvesCollection> importFromFile(const std::string& fileName) const = 0;

  /**
   * @brief Import curves's collection from stream
   *
   * @param stream stream from where the curves must be imported
   *
   * @return Curves collection imported
   */
  virtual boost::shared_ptr<CurvesCollection> importFromStream(std::istream& stream) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace curves

#endif  // API_CRV_CRVIMPORTER_H_
