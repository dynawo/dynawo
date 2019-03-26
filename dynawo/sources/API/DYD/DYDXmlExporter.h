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
 * @file DYDXmlExporter.h
 * @brief Dynawo dynamic models collection XML exporter : header file
 *
 */

#ifndef API_DYD_DYDXMLEXPORTER_H_
#define API_DYD_DYDXMLEXPORTER_H_

#include "DYDExporter.h"

namespace xml {
namespace sax {
namespace formatter {
class Formatter;
}
}
}

namespace dynamicdata {
class DynamicModelsCollection;
class Model;
class BlackBoxModel;
class ModelTemplateExpansion;
class UnitDynamicModel;
class ModelTemplate;
class ModelicaModel;
class Connector;
class StaticRef;
class MacroConnect;
class MacroConnector;
class MacroConnection;
class MacroStaticRef;
class MacroStaticReference;

/**
 * @class XmlExporter
 * @brief XML exporter interface class
 *
 * XML export class for dynamic models collections.
 */
class XmlExporter : public Exporter {
 public:
  /**
   * @brief Destructor
   */
  virtual ~XmlExporter() {}
  /**
   * @brief Export method in XML format
   *
   * @param collection Collection to export
   * @param filePath File to export XML formatted parameters to
   */
  void exportToFile(const boost::shared_ptr<DynamicModelsCollection>& collection, const std::string& filePath) const;

  /**
   * @brief Export method in XML format
   *
   * @param collection Collection to export
   * @param stream Stream to export XML formatted parameters to
   */
  void exportToStream(const boost::shared_ptr<DynamicModelsCollection>& collection, std::ostream& stream) const;

 private:
  /**
   * @brief Write given Model in given formatter
   *
   * @param[in] model Model to write
   * @param[out] formatter Output formatter
   */
  void writeModel(const boost::shared_ptr<Model>& model, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief Write given BlackBoxModel in given formatter
   *
   * @param[in] bbm BlackBoxModel to write
   * @param[out] formatter Output formatter
   */
  void writeBlackBoxModel(const boost::shared_ptr<BlackBoxModel>& bbm, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief Write given ModelTemplateExpansion in given formatter
   *
   * @param[in] mte ModelTemplateExpansion to write
   * @param[out] formatter Output formatter
   */
  void writeModelTemplateExpansion(const boost::shared_ptr<ModelTemplateExpansion>& mte, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief Write given UnitDynamicModel in given formatter
   *
   * @param[in] mm UnitDynamicModel to write
   * @param[out] formatter Output formatter
   */
  void writeUnitDynamicModel(const boost::shared_ptr<UnitDynamicModel>& mm, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief Write given ModelTemplate in given formatter
   *
   * @param[in] mt ModelTemplate to write
   * @param[out] formatter Output formatter
   */
  void writeModelTemplate(const boost::shared_ptr<ModelTemplate>& mt, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief Write given ModelicaModel in given formatter
   *
   * @param[in] cm ModelicaModel to write
   * @param[out] formatter Output formatter
   */
  void writeModelicaModel(const boost::shared_ptr<ModelicaModel>& cm, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief Write given InitConnector in given formatter
   *
   * @param[in] ic Initialization Connector to write
   * @param[out] formatter Output formatter
   */
  void writeInitConnector(const boost::shared_ptr<Connector>& ic, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief Write given static reference in given formatter
   *
   * @param[in] sr static reference to write
   * @param[out] formatter Output formatter
   */
  void writeStaticRef(const boost::shared_ptr<StaticRef>& sr, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief write given macroStaticRef in given formatter
   *
   * @param[in] macroStaticRef: MacroStaticRef object to write
   * @param[out] formatter Output formatter
   */
  void writeMacroStaticRef(const boost::shared_ptr<MacroStaticRef>& macroStaticRef, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief write given macroStaticReference in given formatter
   *
   * @param[in] macroStaticReference: MacroStaticReference object to write
   * @param[out] formatter Output formatter
   */
  void writeMacroStaticReference(const boost::shared_ptr<MacroStaticReference>& macroStaticReference, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief Write given Connector in given formatter
   *
   * @param[in] c Connector to write
   * @param[out] formatter Output formatter
   */
  void writeConnector(const boost::shared_ptr<Connector>& c, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief write given macro connect in given formatter
   *
   * @param[in] mc Macro connect to write
   * @param[out] formatter Output formatter
   */
  void writeMacroConnect(const boost::shared_ptr<MacroConnect>& mc, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief write given macro connector in given formatter
   *
   * @param[in] mc Macro connector to write
   * @param[out] formatter Output formatter
   */
  void writeMacroConnector(const boost::shared_ptr<MacroConnector>& mc, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief write given macro connection in given formatter
   *
   * @param[in] mc Macro connection to write
   * @param[out] formatter Output formatter
   */
  void writeMacroConnection(const boost::shared_ptr<MacroConnection>& mc, xml::sax::formatter::Formatter& formatter) const;

  /**
   * @brief write given init macro connection in given formatter
   *
   * @param[in] mc Init macro connection to write
   * @param[out] formatter Output formatter
   */
  void writeInitMacroConnection(const boost::shared_ptr<MacroConnection>& mc, xml::sax::formatter::Formatter& formatter) const;
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDXMLEXPORTER_H_
