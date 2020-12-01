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
#include <sstream>

#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

#include "DYNMacrosMessage.h"

#include "DYDConnector.h"
#include "DYDStaticRef.h"
#include "DYDMacroStaticRef.h"
#include "DYDMacroStaticReference.h"
#include "DYDDynamicModelsCollection.h"
#include "DYDIterators.h"
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
using std::vector;

using boost::dynamic_pointer_cast;
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
  for (macroConnector_iterator itMC = collection->beginMacroConnector();
          itMC != collection->endMacroConnector();
          ++itMC) {
    writeMacroConnector(*itMC, *formatter);
  }

  for (macroStaticReference_const_iterator itMSR = collection->cbeginMacroStaticReference();
          itMSR != collection->cendMacroStaticReference();
          ++itMSR) {
    writeMacroStaticReference(*itMSR, *formatter);
  }

  for (dynamicModel_iterator itModel = collection->beginModel();
          itModel != collection->endModel();
          ++itModel) {
    writeModel(*itModel, *formatter);
  }

  for (macroConnect_iterator itMacroConnect = collection->beginMacroConnect();
          itMacroConnect != collection->endMacroConnect();
          ++itMacroConnect) {
    writeMacroConnect(*itMacroConnect, *formatter);
  }

  for (connector_iterator itConnect = collection->beginConnector();
          itConnect != collection->endConnector();
          ++itConnect) {
    writeConnector(*itConnect, *formatter);
  }
  formatter->endElement();  // dynamicModelsArchitecture
  formatter->endDocument();
}

void
XmlExporter::writeModel(const shared_ptr<Model>& model, Formatter& formatter) const {
  switch (model->getType()) {
    case Model::BLACK_BOX_MODEL:
      writeBlackBoxModel(dynamic_pointer_cast<BlackBoxModel>(model), formatter);
      break;
    case Model::MODELICA_MODEL:
      writeModelicaModel(dynamic_pointer_cast<ModelicaModel>(model), formatter);
      break;
    case Model::MODEL_TEMPLATE:
      writeModelTemplate(dynamic_pointer_cast<ModelTemplate>(model), formatter);
      break;
    case Model::MODEL_TEMPLATE_EXPANSION:
      writeModelTemplateExpansion(dynamic_pointer_cast<ModelTemplateExpansion>(model), formatter);
      break;
  }
}

void
XmlExporter::writeBlackBoxModel(const shared_ptr<BlackBoxModel>& bbm, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", bbm->getId());

  if (bbm->getStaticId() != "")
    attrs.add("staticId", bbm->getStaticId());
  attrs.add("lib", bbm->getLib());
  if (bbm->getParFile() != "")
    attrs.add("parFile", bbm->getParFile());
  if (bbm->getParId() != "")
    attrs.add("parId", bbm->getParId());

  formatter.startElement("dyn", "blackBoxModel", attrs);

  for (staticRef_const_iterator itSR = bbm->cbeginStaticRef();
          itSR != bbm->cendStaticRef();
          ++itSR) {
    writeStaticRef(*itSR, formatter);
  }

  for (macroStaticRef_const_iterator itMSR = bbm->cbeginMacroStaticRef();
          itMSR != bbm->cendMacroStaticRef();
          ++itMSR) {
    writeMacroStaticRef(*itMSR, formatter);
  }

  formatter.endElement();  // blackBoxModel
}

void
XmlExporter::writeModelTemplateExpansion(const shared_ptr<ModelTemplateExpansion>& mte, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", mte->getId());
  attrs.add("templateId", mte->getTemplateId());

  if (mte->getStaticId() != "")
    attrs.add("staticId", mte->getStaticId());
  if (mte->getParFile() != "")
    attrs.add("parFile", mte->getParFile());
  if (mte->getParId() != "")
    attrs.add("parId", mte->getParId());

  formatter.startElement("dyn", "modelTemplateExpansion", attrs);

  for (staticRef_const_iterator itSR = mte->cbeginStaticRef();
          itSR != mte->cendStaticRef();
          ++itSR) {
    writeStaticRef(*itSR, formatter);
  }

  for (macroStaticRef_const_iterator itMSR = mte->cbeginMacroStaticRef();
          itMSR != mte->cendMacroStaticRef();
          ++itMSR) {
    writeMacroStaticRef(*itMSR, formatter);
  }

  formatter.endElement();  // modelTemplateExpansion
}

void
XmlExporter::writeUnitDynamicModel(const shared_ptr<UnitDynamicModel>& mm, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", mm->getId());
  attrs.add("name", mm->getDynamicModelName());

  if (!mm->getDynamicFileName().empty())
    attrs.add("moFile", mm->getDynamicFileName());
  if (mm->getInitModelName() != "")
    attrs.add("initName", mm->getInitModelName());
  if (mm->getInitFileName() != "")
    attrs.add("initFile", mm->getInitFileName());
  if (mm->getParFile() != "")
    attrs.add("parFile", mm->getParFile());
  if (mm->getParId() != "")
    attrs.add("parId", mm->getParId());

  formatter.startElement("dyn", "unitDynamicModel", attrs);
  formatter.endElement();  // unitDynamicModel
}

void
XmlExporter::writeModelicaModel(const shared_ptr<ModelicaModel>& cm, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", cm->getId());
  if (cm->getStaticId() != "")
    attrs.add("staticId", cm->getStaticId());
  if (!cm->getUseAliasing())
    attrs.add("useAliasing", cm->getUseAliasing());
  if (!cm->getGenerateCalculatedVariables())
    attrs.add("generateCalculatedVariables", cm->getGenerateCalculatedVariables());

  formatter.startElement("dyn", "modelicaModel", attrs);
  for (map<std::string, shared_ptr<UnitDynamicModel> >::const_iterator itModel = cm->getUnitDynamicModels().begin();
          itModel != cm->getUnitDynamicModels().end();
          ++itModel) {
    writeUnitDynamicModel(itModel->second, formatter);
  }

  for (map<std::string, shared_ptr<MacroConnect> >::const_iterator itConnect = cm->getMacroConnects().begin();
          itConnect != cm->getMacroConnects().end();
          ++itConnect) {
    writeMacroConnect(itConnect->second, formatter);
  }

  for (map<std::string, shared_ptr<Connector> >::const_iterator itConnector = cm->getConnectors().begin();
          itConnector != cm->getConnectors().end();
          ++itConnector) {
    writeConnector(itConnector->second, formatter);
  }

  for (map<std::string, shared_ptr<Connector> >::const_iterator itConnector = cm->getInitConnectors().begin();
          itConnector != cm->getInitConnectors().end();
          ++itConnector) {
    writeInitConnector(itConnector->second, formatter);
  }

  for (staticRef_const_iterator itSR = cm->cbeginStaticRef();
          itSR != cm->cendStaticRef();
          ++itSR) {
    writeStaticRef(*itSR, formatter);
  }

  for (macroStaticRef_const_iterator itMSR = cm->cbeginMacroStaticRef();
          itMSR != cm->cendMacroStaticRef();
          ++itMSR) {
    writeMacroStaticRef(*itMSR, formatter);
  }

  formatter.endElement();  // modelicaModel
}

void
XmlExporter::writeModelTemplate(const shared_ptr<ModelTemplate>& mt, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", mt->getId());
  if (!mt->getUseAliasing())
    attrs.add("useAliasing", mt->getUseAliasing());
  if (!mt->getGenerateCalculatedVariables())
    attrs.add("generateCalculatedVariables", mt->getGenerateCalculatedVariables());

  formatter.startElement("dyn", "modelTemplate", attrs);
  for (map<std::string, shared_ptr<UnitDynamicModel> >::const_iterator itModel = mt->getUnitDynamicModels().begin();
          itModel != mt->getUnitDynamicModels().end();
          ++itModel) {
    writeUnitDynamicModel(itModel->second, formatter);
  }

  for (map<std::string, shared_ptr<MacroConnect> >::const_iterator itConnect = mt->getMacroConnects().begin();
          itConnect != mt->getMacroConnects().end();
          ++itConnect) {
    writeMacroConnect(itConnect->second, formatter);
  }

  for (map<std::string, shared_ptr<Connector> >::const_iterator itConnector = mt->getConnectors().begin();
          itConnector != mt->getConnectors().end();
          ++itConnector) {
    writeConnector(itConnector->second, formatter);
  }

  for (map<std::string, shared_ptr<Connector> >::const_iterator itConnector = mt->getInitConnectors().begin();
          itConnector != mt->getInitConnectors().end();
          ++itConnector) {
    writeInitConnector(itConnector->second, formatter);
  }

  for (staticRef_const_iterator itSR = mt->cbeginStaticRef();
          itSR != mt->cendStaticRef();
          ++itSR) {
    writeStaticRef(*itSR, formatter);
  }

  for (macroStaticRef_const_iterator itMSR = mt->cbeginMacroStaticRef();
          itMSR != mt->cendMacroStaticRef();
          ++itMSR) {
    writeMacroStaticRef(*itMSR, formatter);
  }

  formatter.endElement();  // modelTemplate
}

void
XmlExporter::writeInitConnector(const shared_ptr<Connector>& ic, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id1", ic->getFirstModelId());
  attrs.add("var1", ic->getFirstVariableId());
  attrs.add("id2", ic->getSecondModelId());
  attrs.add("var2", ic->getSecondVariableId());
  formatter.startElement("dyn", "initConnect", attrs);
  formatter.endElement();  // initConnect
}

void
XmlExporter::writeMacroConnect(const shared_ptr<MacroConnect>& mc, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("connector", mc->getConnector());
  attrs.add("id1", mc->getFirstModelId());
  attrs.add("id2", mc->getSecondModelId());
  if (mc->getIndex1() != "")
    attrs.add("index1", mc->getIndex1());
  if (mc->getName1() != "")
    attrs.add("name1", mc->getName1());
  if (mc->getIndex2() != "")
    attrs.add("index2", mc->getIndex2());
  if (mc->getName2() != "")
    attrs.add("name2", mc->getName2());
  formatter.startElement("dyn", "macroConnect", attrs);
  formatter.endElement();
}

void
XmlExporter::writeConnector(const boost::shared_ptr<Connector>& dc, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id1", dc->getFirstModelId());
  attrs.add("var1", dc->getFirstVariableId());
  attrs.add("id2", dc->getSecondModelId());
  attrs.add("var2", dc->getSecondVariableId());
  formatter.startElement("dyn", "connect", attrs);
  formatter.endElement();  // connect
}

void
XmlExporter::writeStaticRef(const boost::shared_ptr<StaticRef>& sr, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("var", sr->getModelVar());
  attrs.add("staticVar", sr->getStaticVar());
  formatter.startElement("dyn", "staticRef", attrs);
  formatter.endElement();  // staticRef
}

void
XmlExporter::writeMacroStaticRef(const shared_ptr<MacroStaticRef>& macroStaticRef, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", macroStaticRef->getId());
  formatter.startElement("dyn", "macroStaticRef", attrs);
  formatter.endElement();
}

void
XmlExporter::writeMacroStaticReference(const boost::shared_ptr<MacroStaticReference>& macroStaticReference, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", macroStaticReference->getId());
  formatter.startElement("dyn", "macroStaticReference", attrs);
  for (staticRef_const_iterator itSR = macroStaticReference->cbeginStaticRef();
          itSR != macroStaticReference->cendStaticRef();
          ++itSR) {
    writeStaticRef(*itSR, formatter);
  }
  formatter.endElement();
}

void
XmlExporter::writeMacroConnector(const boost::shared_ptr<MacroConnector>& mc, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", mc->getId());
  formatter.startElement("dyn", "macroConnector", attrs);
  for (map<string, shared_ptr<MacroConnection> >::const_iterator itConnector = mc->getConnectors().begin();
          itConnector != mc->getConnectors().end();
          ++itConnector) {
    writeMacroConnection(itConnector->second, formatter);
  }
  for (map<string, shared_ptr<MacroConnection> >::const_iterator itConnector = mc->getInitConnectors().begin();
          itConnector != mc->getInitConnectors().end();
          ++itConnector) {
    writeInitMacroConnection(itConnector->second, formatter);
  }

  formatter.endElement();
}

void
XmlExporter::writeMacroConnection(const boost::shared_ptr<MacroConnection>& mc, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("var1", mc->getFirstVariableId());
  attrs.add("var2", mc->getSecondVariableId());
  formatter.startElement("dyn", "connect", attrs);
  formatter.endElement();
}

void
XmlExporter::writeInitMacroConnection(const boost::shared_ptr<MacroConnection>& mc, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("var1", mc->getFirstVariableId());
  attrs.add("var2", mc->getSecondVariableId());
  formatter.startElement("dyn", "initConnect", attrs);
  formatter.endElement();
}

}  // namespace dynamicdata
