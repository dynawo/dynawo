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
 * @file  STPImporter.h
 *
 * @brief Step output collection importer : interface file
 *
 */

#ifndef API_IO_IOIMPORTER_H_
#define API_IO_IOIMPORTER_H_

#include "IOOutputsCollection.h"

namespace io {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Importer
 * @brief Importer interface class
 *
 * Import class for outputs collection.
 */
class OutputsImporter {
 public:
  /**
   * @brief Destructor
   */
  virtual ~OutputsImporter() = default;

  /**
   * @brief Import outputs collection from file
   *
   * @param fileName file name
   *
   * @return Outputs collection imported
   */
  virtual std::shared_ptr<OutputsCollection> importFromFile(const std::string& fileName) const = 0;

  /**
   * @brief Import output's collection from stream
   *
   * @param stream stream from where the outputs must be imported
   *
   * @return Outputs collection imported
   */
  virtual std::shared_ptr<OutputsCollection> importFromStream(std::istream& stream) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace io

#endif  // API_IO_IOIMPORTER_H_
