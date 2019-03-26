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
 * @file EXTVARXmlImporter.h
 * @brief Dynawo external variables XML importer : header file
 */

#ifndef API_EXTVAR_EXTVARXMLIMPORTER_H_
#define API_EXTVAR_EXTVARXMLIMPORTER_H_

#include <boost/shared_ptr.hpp>

#include "EXTVARImporter.h"

namespace externalVariables {
class VariablesCollection;

/**
 * @class XmlImporter
 * @brief XML importer interface class
 *
 * XML import class for external variables collections.
 */
class XmlImporter : public Importer {
 public:
  /**
   * @brief Destructor
   */
  virtual ~XmlImporter() {}
  /**
   * @copydoc Importer::importFromFile()
   */
  boost::shared_ptr<VariablesCollection> importFromFile(const std::string& fileName) const;

  /**
   * @copydoc Importer::importFromStream()
   */
  boost::shared_ptr<VariablesCollection> importFromStream(std::istream& stream) const;
};

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARXMLIMPORTER_H_
