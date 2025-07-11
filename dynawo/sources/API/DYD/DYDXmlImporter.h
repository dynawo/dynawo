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
 * @file DYDXmlImporter.h
 * @brief Dynawo dynamic models collection XML importer : header file
 *
 */

#ifndef API_DYD_DYDXMLIMPORTER_H_
#define API_DYD_DYDXMLIMPORTER_H_

#include "DYDImporter.h"

#include <boost/shared_ptr.hpp>

namespace dynamicdata {

/**
 * @class XmlImporter
 * @brief XML importer interface class
 *
 * XML import class for dynamic models collections.
 */
class XmlImporter : public Importer {
 public:
  /**
   * @copydoc Importer::importFromDydFiles()
   */
  boost::shared_ptr<DynamicModelsCollection> importFromDydFiles(const std::vector<std::string>& fileNames) const  override;

  /**
   * @copydoc Importer::importFromStream()
   */
  void importFromStream(std::istream& stream, XmlHandler& dydHandler, xml::sax::parser::ParserPtr& parser, bool xsdValidation) const  override;
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDXMLIMPORTER_H_
