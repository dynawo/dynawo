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
 * @file  JOBImporter.h
 *
 * @brief job collection importer : interface file
 *
 */

#ifndef API_JOB_JOBIMPORTER_H_
#define API_JOB_JOBIMPORTER_H_

#include "JOBJobsCollection.h"

#include <memory>

namespace job {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Importer
 * @brief Importer interface class
 *
 * Import class for job collection.
 */
class Importer {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Importer() = default;

  /**
   * @brief Import job's collection from file
   *
   * @param fileName file name
   *
   * @return jobs description imported
   */
  virtual std::shared_ptr<JobsCollection> importFromFile(const std::string& fileName) const = 0;

  /**
   * @brief Import job's collection from stream
   *
   * @param stream stream to import
   *
   * @return jobs description imported
   */
  virtual std::shared_ptr<JobsCollection> importFromStream(std::istream& stream) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace job

#endif  // API_JOB_JOBIMPORTER_H_
