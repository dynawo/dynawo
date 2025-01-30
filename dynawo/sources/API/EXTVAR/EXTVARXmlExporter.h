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
 * @file EXTVARXmlExporter.h
 * @brief Dynawo external variables collection XML exporter : header file
 *
 */

#ifndef API_EXTVAR_EXTVARXMLEXPORTER_H_
#define API_EXTVAR_EXTVARXMLEXPORTER_H_

#include "EXTVARExporter.h"
#include "EXTVARVariable.h"

// forward declaration to avoid transitive link to XML library, as XMl formatter is used only in private
namespace xml {
namespace sax {
namespace formatter {
class Formatter;
}  // namespace formatter
}  // namespace sax
}  // namespace xml

namespace externalVariables {

/**
 * @class XmlExporter
 * @brief XML exporter interface class
 *
 * XML export class for external variables collections.
 */
class XmlExporter : public Exporter {
 public:
  /**
   * @brief Export method in XML format
   *
   * @param collection Collection to export
   * @param filePath destination XML path
   */
  void exportToFile(const VariablesCollection& collection, const std::string& filePath) const;

  /**
   * @brief Export method in XML format
   *
   * @param collection Collection to export
   * @param stream stream where the collection should be exported
   */
  void exportToStream(const VariablesCollection& collection, std::ostream& stream) const;

 private:
  /**
   * @brief Write one external variable in XML format
   *
   * @param variable the Variable object
   * @param formatter the destination XML location
   */
  void writeVariable(const std::shared_ptr<Variable>& variable, xml::sax::formatter::Formatter& formatter) const;
};

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARXMLEXPORTER_H_
