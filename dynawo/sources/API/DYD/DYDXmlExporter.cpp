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
 * @file DYDXmlExporter.cpp
 * @brief Dynawo dynamic models collection XML exporter : implementation file
 *
 */
#include <fstream>

#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

#include "DYNMacrosMessage.h"

#include "DYDConnector.h"
#include "DYDStaticRef.h"
#include "DYDMacroStaticRef.h"
#include "DYDMacroStaticReference.h"
#include "DYDDynamicModelsCollection.h"
#include "DYDXmlExporter.h"
#include "DYDMacroConnection.h"
#include "DYDMacroConnector.h"
#include "DYDMacroConnect.h"
#include "DYDUnitDynamicModel.h"
#include "DYDBlackBoxModel.h"
#include "DYDModelTemplateExpansion.h"
#include "DYDModelTemplate.h"
#include "DYDModelicaModel.h"

using std::fstream;
using std::map;
using std::string;

using boost::shared_ptr;

using xml::sax::formatter::AttributeList;
using xml::sax::formatter::Formatter;
using xml::sax::formatter::FormatterPtr;

namespace dynamicdata {

void
XmlExporter::exportToFile(const shared_ptr<DynamicModelsCollection>& collection, const string& filePath, const std::string& encoding) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }

  exportToStream(collection, file, encoding);
  file.close();
}

void XmlExporter::exportToStream(const boost::shared_ptr<DynamicModelsCollection>& collection, std::ostream& stream, const std::string& encoding) const {
  FormatterPtr formatter = Formatter::createFormatter(stream);
  formatter->addNamespace("dyn", "http://www.rte-france.com/dynawo");
  if (!encoding.empty()) {
    formatter->setEncoding(encoding);
  }

  formatter->startDocument();
  AttributeList attrs;
  formatter->startElement("dyn", "dynamicModelsArchitecture", attrs);
  for (const auto&  macroConnectorPair : collection->getMacroConnectors())
    writeMacroConnector(macroConnectorPair.second, *formatter);

  for (const auto&  macroStaticReferencePair : collection->getMacroStaticReferences())
    writeMacroStaticReference(macroStaticReferencePair.second, *formatter);

  for (const auto&  modelPair : collection->getModels())
    writeModel(modelPair.second, *formatter);

  for (const auto&  macroConnectPair : collection->getMacroConnects())
    writeMacroConnect(macroConnectPair, *formatter);

  for (const auto& connectPair : collection->getConnectors())
    writeConnector(connectPair, *formatter);

  formatter->endElement();  // dynamicModelsArchitecture
  formatter->endDocument();
}

void
XmlExporter::writeModel(const std::shared_ptr<Model>& model, Formatter& formatter) const {
  switch (model->getType()) {
    case Model::BLACK_BOX_MODEL:
      writeBlackBoxModel(std::dynamic_pointer_cast<BlackBoxModel>(model), formatter);
      break;
    case Model::MODELICA_MODEL:
      writeModelicaModel(std::dynamic_pointer_cast<ModelicaModel>(model), formatter);
      break;
    case Model::MODEL_TEMPLATE:
      writeModelTemplate(std::dynamic_pointer_cast<ModelTemplate>(model), formatter);
      break;
    case Model::MODEL_TEMPLATE_EXPANSION:
      writeModelTemplateExpansion(std::dynamic_pointer_cast<ModelTemplateExpansion>(model), formatter);
      break;
  }
}

void
XmlExporter::writeBlackBoxModel(const std::shared_ptr<BlackBoxModel>& bbm, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", bbm->getId());

  if (!bbm->getStaticId().empty())
    attrs.add("staticId", bbm->getStaticId());
  attrs.add("lib", bbm->getLib());
  if (!bbm->getParFile().empty())
    attrs.add("parFile", bbm->getParFile());
  if (!bbm->getParId().empty())
    attrs.add("parId", bbm->getParId());

  formatter.startElement("dyn", "blackBoxModel", attrs);

  for (const auto& staticRefPair : bbm->getStaticRefs())
    writeStaticRef(staticRefPair.second, formatter);

  for (const auto& macroStaticRefPair : bbm->getMacroStaticRefs())
    writeMacroStaticRef(macroStaticRefPair.second, formatter);

  formatter.endElement();  // blackBoxModel
}

void
XmlExporter::writeModelTemplateExpansion(const std::shared_ptr<ModelTemplateExpansion>& mte, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", mte->getId());
  attrs.add("templateId", mte->getTemplateId());

  if (!mte->getStaticId().empty())
    attrs.add("staticId", mte->getStaticId());
  if (!mte->getParFile().empty())
    attrs.add("parFile", mte->getParFile());
  if (!mte->getParId().empty())
    attrs.add("parId", mte->getParId());

  formatter.startElement("dyn", "modelTemplateExpansion", attrs);

  for (const auto& staticRefPair : mte->getStaticRefs()) {
    writeStaticRef(staticRefPair.second, formatter);
  }

  for (const auto& macroStaticRefPair : mte->getMacroStaticRefs()) {
    writeMacroStaticRef(macroStaticRefPair.second, formatter);
  }

  formatter.endElement();  // modelTemplateExpansion
}

void
XmlExporter::writeUnitDynamicModel(const std::shared_ptr<UnitDynamicModel>& mm, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", mm->getId());
  attrs.add("name", mm->getDynamicModelName());

  if (!mm->getDynamicFileName().empty())
    attrs.add("moFile", mm->getDynamicFileName());
  if (!mm->getInitModelName().empty())
    attrs.add("initName", mm->getInitModelName());
  if (!mm->getInitFileName().empty())
    attrs.add("initFile", mm->getInitFileName());
  if (!mm->getParFile().empty())
    attrs.add("parFile", mm->getParFile());
  if (!mm->getParId().empty())
    attrs.add("parId", mm->getParId());

  formatter.startElement("dyn", "unitDynamicModel", attrs);
  formatter.endElement();  // unitDynamicModel
}

void
XmlExporter::writeModelicaModel(const std::shared_ptr<ModelicaModel>& cm, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", cm->getId());
  if (!cm->getStaticId().empty())
    attrs.add("staticId", cm->getStaticId());
  if (!cm->getUseAliasing())
    attrs.add("useAliasing", cm->getUseAliasing());
  if (!cm->getGenerateCalculatedVariables())
    attrs.add("generateCalculatedVariables", cm->getGenerateCalculatedVariables());

  formatter.startElement("dyn", "modelicaModel", attrs);
  for (const auto& unitDynamicModelPair : cm->getUnitDynamicModels())
    writeUnitDynamicModel(unitDynamicModelPair.second, formatter);

  for (const auto& macroConnectPair : cm->getMacroConnects())
    writeMacroConnect(macroConnectPair.second, formatter);

  for (const auto& connectorPair : cm->getConnectors())
    writeConnector(connectorPair.second, formatter);

  for (const auto& initConnectorPair : cm->getInitConnectors())
    writeInitConnector(initConnectorPair.second, formatter);

  for (const auto& staticRefPair : cm->getStaticRefs())
    writeStaticRef(staticRefPair.second, formatter);

  for (const auto& macroStaticRefPair : cm->getMacroStaticRefs())
    writeMacroStaticRef(macroStaticRefPair.second, formatter);

  formatter.endElement();  // modelicaModel
}

void
XmlExporter::writeModelTemplate(const std::shared_ptr<ModelTemplate>& mt, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", mt->getId());
  if (!mt->getUseAliasing())
    attrs.add("useAliasing", mt->getUseAliasing());
  if (!mt->getGenerateCalculatedVariables())
    attrs.add("generateCalculatedVariables", mt->getGenerateCalculatedVariables());

  formatter.startElement("dyn", "modelTemplate", attrs);
  for (const auto& unitDynamicModelPair : mt->getUnitDynamicModels())
    writeUnitDynamicModel(unitDynamicModelPair.second, formatter);

  for (const auto& macroConnectPair : mt->getMacroConnects())
    writeMacroConnect(macroConnectPair.second, formatter);

  for (const auto& connectorPair : mt->getConnectors())
    writeConnector(connectorPair.second, formatter);

  for (const auto& initConnectorPair : mt->getInitConnectors())
    writeInitConnector(initConnectorPair.second, formatter);

  for (const auto& staticRefPair : mt->getStaticRefs())
    writeStaticRef(staticRefPair.second, formatter);

  for (const auto& macroStaticRefPair : mt->getMacroStaticRefs())
    writeMacroStaticRef(macroStaticRefPair.second, formatter);

  formatter.endElement();  // modelTemplate
}

void
XmlExporter::writeInitConnector(const std::shared_ptr<Connector>& ic, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id1", ic->getFirstModelId());
  attrs.add("var1", ic->getFirstVariableId());
  attrs.add("id2", ic->getSecondModelId());
  attrs.add("var2", ic->getSecondVariableId());
  formatter.startElement("dyn", "initConnect", attrs);
  formatter.endElement();  // initConnect
}

void
XmlExporter::writeMacroConnect(const std::shared_ptr<MacroConnect>& mc, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("connector", mc->getConnector());
  attrs.add("id1", mc->getFirstModelId());
  attrs.add("id2", mc->getSecondModelId());
  if (!mc->getIndex1().empty())
    attrs.add("index1", mc->getIndex1());
  if (!mc->getName1().empty())
    attrs.add("name1", mc->getName1());
  if (!mc->getIndex2().empty())
    attrs.add("index2", mc->getIndex2());
  if (!mc->getName2().empty())
    attrs.add("name2", mc->getName2());
  formatter.startElement("dyn", "macroConnect", attrs);
  formatter.endElement();
}

void
XmlExporter::writeConnector(const std::shared_ptr<Connector>& dc, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id1", dc->getFirstModelId());
  attrs.add("var1", dc->getFirstVariableId());
  attrs.add("id2", dc->getSecondModelId());
  attrs.add("var2", dc->getSecondVariableId());
  formatter.startElement("dyn", "connect", attrs);
  formatter.endElement();  // connect
}

void
XmlExporter::writeStaticRef(const std::unique_ptr<StaticRef>& sr, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("var", sr->getModelVar());
  attrs.add("staticVar", sr->getStaticVar());
  formatter.startElement("dyn", "staticRef", attrs);
  formatter.endElement();  // staticRef
}

void
XmlExporter::writeMacroStaticRef(const std::shared_ptr<MacroStaticRef>& macroStaticRef, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", macroStaticRef->getId());
  formatter.startElement("dyn", "macroStaticRef", attrs);
  formatter.endElement();
}

void
XmlExporter::writeMacroStaticReference(const std::shared_ptr<MacroStaticReference>& macroStaticReference, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", macroStaticReference->getId());
  formatter.startElement("dyn", "macroStaticReference", attrs);
  for (const auto& staticRefPair : macroStaticReference->getStaticReferences())
    writeStaticRef(staticRefPair.second, formatter);

  formatter.endElement();
}

void
XmlExporter::writeMacroConnector(const std::shared_ptr<MacroConnector>& mc, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", mc->getId());
  formatter.startElement("dyn", "macroConnector", attrs);
  for (const auto& connectorPair : mc->getConnectors())
    writeMacroConnection(connectorPair.second, formatter);

  for (const auto& initConnectorPair : mc->getInitConnectors())
    writeInitMacroConnection(initConnectorPair.second, formatter);

  formatter.endElement();
}

void
XmlExporter::writeMacroConnection(const std::unique_ptr<MacroConnection>& mc, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("var1", mc->getFirstVariableId());
  attrs.add("var2", mc->getSecondVariableId());
  formatter.startElement("dyn", "connect", attrs);
  formatter.endElement();
}

void
XmlExporter::writeInitMacroConnection(const std::unique_ptr<MacroConnection>& mc, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("var1", mc->getFirstVariableId());
  attrs.add("var2", mc->getSecondVariableId());
  formatter.startElement("dyn", "initConnect", attrs);
  formatter.endElement();
}

}  // namespace dynamicdata
