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
 * @file DYDImporter.h
 * @brief Dynawo dynamic models collection importer : interface file
 *
 */

#ifndef API_DYD_DYDIMPORTER_H_
#define API_DYD_DYDIMPORTER_H_

#include "DYDDynamicModelsCollection.h"
#include "DYDXmlHandler.h"

#include <string>
#include <xml/sax/parser/ParserFactory.h>

namespace dynamicdata {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Importer
 * @brief Importer interface class
 *
 * Import class for dynamic models collections.
 */
class Importer {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Importer() = default;

  /**
   * @brief Import dynamic models collection from files
   *
   * @param fileNames list of files to read
   * @returns Collection imported
   */
  virtual boost::shared_ptr<DynamicModelsCollection> importFromDydFiles(const std::vector<std::string>& fileNames) const = 0;

  /**
   * @brief Import dynamic models collection from stream
   *
   * @param stream stream to import
   * @param dydHandler dynamic models file handler
   * @param parser Smart pointer to SAX parser interface class
   * @param xsdValidation To use or not XSD validation
   */
  virtual void importFromStream(std::istream& stream, XmlHandler& dydHandler, xml::sax::parser::ParserPtr& parser, bool xsdValidation) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace dynamicdata

#endif  // API_DYD_DYDIMPORTER_H_
