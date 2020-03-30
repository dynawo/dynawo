//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  CRTImporter.h
 *
 * @brief Criteria collection importer : interface file
 *
 */

#ifndef API_CRT_CRTIMPORTER_H_
#define API_CRT_CRTIMPORTER_H_

#include <boost/shared_ptr.hpp>

namespace criteria {
class CriteriaCollection;

/**
 * @class Importer
 * @brief Importer interface class
 *
 * Import class for criteria.
 */
class Importer {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Importer() {}
  /**
   * @brief Import criteria from file
   *
   * @param fileName file name
   *
   * @return criteria imported
   */
  virtual boost::shared_ptr<CriteriaCollection> importFromFile(const std::string& fileName) const = 0;

  /**
   * @brief Import criteria from stream
   *
   * @param stream stream from where the criteria must be imported
   *
   * @return criteria collection imported
   */
  virtual boost::shared_ptr<CriteriaCollection> importFromStream(std::istream& stream) const = 0;
};

}  // namespace criteria

#endif  // API_CRT_CRTIMPORTER_H_
