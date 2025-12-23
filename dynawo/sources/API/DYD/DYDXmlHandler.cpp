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
 * @file DYDXmlHandler.cpp
 * @brief Handler for dynamic models collection
 * file : implementation file
 *
 * FormatXmlHandler is the implementation of Dynawo handler for parsing
 * dynamic models collection files.
 *
 */

#include <xml/sax/parser/Attributes.h>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

#include "DYNMacrosMessage.h"
#include "DYDUnitDynamicModelFactory.h"
#include "DYDModelTemplateExpansionFactory.h"
#include "DYDModelTemplateFactory.h"
#include "DYDBlackBoxModelFactory.h"
#include "DYDModelicaModelFactory.h"
#include "DYDDynamicModelsCollectionFactory.h"
#include "DYDMacroConnectFactory.h"
#include "DYDMacroConnectorFactory.h"
#include "DYDMacroStaticRefFactory.h"
#include "DYDMacroStaticReferenceFactory.h"
#include "DYDXmlHandler.h"
#include "DYDUnitDynamicModel.h"
#include "DYDMacroConnector.h"
#include "DYDMacroConnect.h"
#include "DYDMacroStaticRef.h"
#include "DYDMacroStaticReference.h"
#include "DYDModelTemplateExpansion.h"
#include "DYDBlackBoxModel.h"
#include "DYDModelTemplate.h"
#include "DYDModelicaModel.h"
#include "DYDDynamicModelsCollection.h"


namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;
namespace parser = xml::sax::parser;

namespace dynamicdata {

// namespace used to read xml file
static parser::namespace_uri& namespace_uri() {
  static parser::namespace_uri namespace_uri("http://www.rte-france.com/dynawo");
  return namespace_uri;
}

XmlHandler::XmlHandler() :
dynamicModelsCollection_(DynamicModelsCollectionFactory::newCollection()),
modelicaModelHandler_(parser::ElementName(namespace_uri(), "modelicaModel")),
modelTemplateHandler_(parser::ElementName(namespace_uri(), "modelTemplate")),
blackBoxModelHandler_(parser::ElementName(namespace_uri(), "blackBoxModel")),
modelTemplateExpansionHandler_(parser::ElementName(namespace_uri(), "modelTemplateExpansion")),
connectHandler_(parser::ElementName(namespace_uri(), "connect")),
macroConnectHandler_(parser::ElementName(namespace_uri(), "macroConnect")),
macroConnectorHandler_(parser::ElementName(namespace_uri(), "macroConnector")),
macroStaticReferenceHandler_(parser::ElementName(namespace_uri(), "macroStaticReference")) {
  onElement(namespace_uri()("dynamicModelsArchitecture/modelicaModel"), modelicaModelHandler_);
  onElement(namespace_uri()("dynamicModelsArchitecture/modelTemplate"), modelTemplateHandler_);
  onElement(namespace_uri()("dynamicModelsArchitecture/blackBoxModel"), blackBoxModelHandler_);
  onElement(namespace_uri()("dynamicModelsArchitecture/modelTemplateExpansion"), modelTemplateExpansionHandler_);
  onElement(namespace_uri()("dynamicModelsArchitecture/connect"), connectHandler_);
  onElement(namespace_uri()("dynamicModelsArchitecture/macroConnect"), macroConnectHandler_);
  onElement(namespace_uri()("dynamicModelsArchitecture/macroConnector"), macroConnectorHandler_);
  onElement(namespace_uri()("dynamicModelsArchitecture/macroStaticReference"), macroStaticReferenceHandler_);

  modelicaModelHandler_.onEnd(lambda::bind(&XmlHandler::addModelicaModel, lambda::ref(*this)));
  modelTemplateHandler_.onEnd(lambda::bind(&XmlHandler::addModelTemplate, lambda::ref(*this)));
  blackBoxModelHandler_.onEnd(lambda::bind(&XmlHandler::addBlackBoxModel, lambda::ref(*this)));
  modelTemplateExpansionHandler_.onEnd(lambda::bind(&XmlHandler::addModelTemplateExpansion, lambda::ref(*this)));
  connectHandler_.onEnd(lambda::bind(&XmlHandler::addConnect, lambda::ref(*this)));
  macroConnectHandler_.onEnd(lambda::bind(&XmlHandler::addMacroConnect, lambda::ref(*this)));
  macroConnectorHandler_.onEnd(lambda::bind(&XmlHandler::addMacroConnector, lambda::ref(*this)));
  macroStaticReferenceHandler_.onEnd(lambda::bind(&XmlHandler::addMacroStaticReference, lambda::ref(*this)));
}

XmlHandler::~XmlHandler() {}

boost::shared_ptr<DynamicModelsCollection>
XmlHandler::getDynamicModelsCollection() {
  return dynamicModelsCollection_;
}

void
XmlHandler::addModelicaModel() {
  std::shared_ptr<ModelicaModel> model = modelicaModelHandler_.get();
  dynamicModelsCollection_->addModel(model);
}

void
XmlHandler::addModelTemplate() {
  std::shared_ptr<ModelTemplate> model = modelTemplateHandler_.get();
  dynamicModelsCollection_->addModel(model);
}

void
XmlHandler::addBlackBoxModel() {
  dynamicModelsCollection_->addModel(blackBoxModelHandler_.get());
}

void
XmlHandler::addModelTemplateExpansion() {
  dynamicModelsCollection_->addModel(modelTemplateExpansionHandler_.get());
}

void
XmlHandler::addConnect() {
  ConnectorRead c = connectHandler_.get();
  dynamicModelsCollection_->addConnect(c.id1, c.var1, c.id2, c.var2);
}

void
XmlHandler::addMacroConnector() {
  dynamicModelsCollection_->addMacroConnector(macroConnectorHandler_.get());
}

void
XmlHandler::addMacroConnect() {
  dynamicModelsCollection_->addMacroConnect(macroConnectHandler_.get());
}

void
XmlHandler::addMacroStaticReference() {
  dynamicModelsCollection_->addMacroStaticReference(macroStaticReferenceHandler_.get());
}

ModelicaModelHandler::ModelicaModelHandler(elementName_type const& root_element) :
connectHandler_(parser::ElementName(namespace_uri(), "connect")),
initConnectHandler_(parser::ElementName(namespace_uri(), "initConnect")),
macroConnectHandler_(parser::ElementName(namespace_uri(), "macroConnect")),
staticRefHandler_(parser::ElementName(namespace_uri(), "staticRef")),
macroStaticRefHandler_(parser::ElementName(namespace_uri(), "macroStaticRef")),
unitDynamicModelHandler_(parser::ElementName(namespace_uri(), "unitDynamicModel")) {
  onStartElement(root_element, lambda::bind(&ModelicaModelHandler::create, lambda::ref(*this), lambda_args::arg2));

  onElement(root_element + namespace_uri()("connect"), connectHandler_);
  onElement(root_element + namespace_uri()("initConnect"), initConnectHandler_);
  onElement(root_element + namespace_uri()("macroConnect"), macroConnectHandler_);
  onElement(root_element + namespace_uri()("staticRef"), staticRefHandler_);
  onElement(root_element + namespace_uri()("macroStaticRef"), macroStaticRefHandler_);
  onElement(root_element + namespace_uri()("unitDynamicModel"), unitDynamicModelHandler_);

  connectHandler_.onEnd(lambda::bind(&ModelicaModelHandler::addConnect, lambda::ref(*this)));
  initConnectHandler_.onEnd(lambda::bind(&ModelicaModelHandler::addInitConnect, lambda::ref(*this)));
  macroConnectHandler_.onEnd(lambda::bind(&ModelicaModelHandler::addMacroConnect, lambda::ref(*this)));
  staticRefHandler_.onEnd(lambda::bind(&ModelicaModelHandler::addStaticRef, lambda::ref(*this)));
  macroStaticRefHandler_.onEnd(lambda::bind(&ModelicaModelHandler::addMacroStaticRef, lambda::ref(*this)));
  unitDynamicModelHandler_.onEnd(lambda::bind(&ModelicaModelHandler::addUnitDynamicModel, lambda::ref(*this)));
}

ModelicaModelHandler::~ModelicaModelHandler() {}

void
ModelicaModelHandler::create(attributes_type const& attributes) {
  modelicaModel_ = ModelicaModelFactory::newModel(attributes["id"]);
  if (attributes.has("staticId"))
    modelicaModel_->setStaticId(attributes["staticId"]);
  bool useAliasing = true;
  bool genCalcVars = true;
  if (attributes.has("useAliasing"))
    useAliasing = attributes["useAliasing"];
  if (attributes.has("generateCalculatedVariables"))
    genCalcVars = attributes["generateCalculatedVariables"];
  modelicaModel_->setCompilationOptions(useAliasing, genCalcVars);
}

std::shared_ptr<ModelicaModel>
ModelicaModelHandler::get() const {
  return modelicaModel_;
}

void
ModelicaModelHandler::addMacroConnect() {
  modelicaModel_->addMacroConnect(macroConnectHandler_.get());
}

void
ModelicaModelHandler::addConnect() {
  ConnectorRead c = connectHandler_.get();
  modelicaModel_->addConnect(c.id1, c.var1, c.id2, c.var2);
}

void
ModelicaModelHandler::addInitConnect() {
  ConnectorRead c = initConnectHandler_.get();
  modelicaModel_->addInitConnect(c.id1, c.var1, c.id2, c.var2);
}

void
ModelicaModelHandler::addStaticRef() {
  StaticRefRead s = staticRefHandler_.get();
  modelicaModel_->addStaticRef(s.var, s.staticVar, s.componentID);
}

void
ModelicaModelHandler::addMacroStaticRef() {
  modelicaModel_->addMacroStaticRef(macroStaticRefHandler_.get());
}

void
ModelicaModelHandler::addUnitDynamicModel() {
  modelicaModel_->addUnitDynamicModel(unitDynamicModelHandler_.get());
}

ModelTemplateHandler::ModelTemplateHandler(elementName_type const& root_element) :
connectHandler_(parser::ElementName(namespace_uri(), "connect")),
initConnectHandler_(parser::ElementName(namespace_uri(), "initConnect")),
macroConnectHandler_(parser::ElementName(namespace_uri(), "macroConnect")),
staticRefHandler_(parser::ElementName(namespace_uri(), "staticRef")),
macroStaticRefHandler_(parser::ElementName(namespace_uri(), "macroStaticRef")),
unitDynamicModelHandler_(parser::ElementName(namespace_uri(), "unitDynamicModel")) {
  onStartElement(root_element, lambda::bind(&ModelTemplateHandler::create, lambda::ref(*this), lambda_args::arg2));


  onElement(root_element + namespace_uri()("connect"), connectHandler_);
  onElement(root_element + namespace_uri()("initConnect"), initConnectHandler_);
  onElement(root_element + namespace_uri()("macroConnect"), macroConnectHandler_);
  onElement(root_element + namespace_uri()("staticRef"), staticRefHandler_);
  onElement(root_element + namespace_uri()("macroStaticRef"), macroStaticRefHandler_);
  onElement(root_element + namespace_uri()("unitDynamicModel"), unitDynamicModelHandler_);

  connectHandler_.onEnd(lambda::bind(&ModelTemplateHandler::addConnect, lambda::ref(*this)));
  initConnectHandler_.onEnd(lambda::bind(&ModelTemplateHandler::addInitConnect, lambda::ref(*this)));
  macroConnectHandler_.onEnd(lambda::bind(&ModelTemplateHandler::addMacroConnect, lambda::ref(*this)));
  staticRefHandler_.onEnd(lambda::bind(&ModelTemplateHandler::addStaticRef, lambda::ref(*this)));
  macroStaticRefHandler_.onEnd(lambda::bind(&ModelTemplateHandler::addMacroStaticRef, lambda::ref(*this)));
  unitDynamicModelHandler_.onEnd(lambda::bind(&ModelTemplateHandler::addUnitDynamicModel, lambda::ref(*this)));
}

ModelTemplateHandler::~ModelTemplateHandler() {}

void
ModelTemplateHandler::create(attributes_type const& attributes) {
  modelTemplate_ = ModelTemplateFactory::newModel(attributes["id"]);
  bool useAliasing = true;
  bool genCalcVars = true;
  if (attributes.has("useAliasing"))
    useAliasing = attributes["useAliasing"];
  if (attributes.has("generateCalculatedVariables"))
    genCalcVars = attributes["generateCalculatedVariables"];
  modelTemplate_->setCompilationOptions(useAliasing, genCalcVars);
}

std::shared_ptr<ModelTemplate>
ModelTemplateHandler::get() const {
  return modelTemplate_;
}

void
ModelTemplateHandler::addMacroConnect() {
  modelTemplate_->addMacroConnect(macroConnectHandler_.get());
}

void
ModelTemplateHandler::addConnect() {
  ConnectorRead c = connectHandler_.get();
  modelTemplate_->addConnect(c.id1, c.var1, c.id2, c.var2);
}

void
ModelTemplateHandler::addInitConnect() {
  ConnectorRead c = initConnectHandler_.get();
  modelTemplate_->addInitConnect(c.id1, c.var1, c.id2, c.var2);
}

void
ModelTemplateHandler::addStaticRef() {
  StaticRefRead s = staticRefHandler_.get();
  modelTemplate_->addStaticRef(s.var, s.staticVar, s.componentID);
}

void
ModelTemplateHandler::addMacroStaticRef() {
  modelTemplate_->addMacroStaticRef(macroStaticRefHandler_.get());
}

void
ModelTemplateHandler::addUnitDynamicModel() {
  modelTemplate_->addUnitDynamicModel(unitDynamicModelHandler_.get());
}

BlackBoxModelHandler::BlackBoxModelHandler(elementName_type const& root_element) :
staticRefHandler_(parser::ElementName(namespace_uri(), "staticRef")),
macroStaticRefHandler_(parser::ElementName(namespace_uri(), "macroStaticRef")) {
  onStartElement(root_element, lambda::bind(&BlackBoxModelHandler::create, lambda::ref(*this), lambda_args::arg2));

  onElement(root_element + namespace_uri()("staticRef"), staticRefHandler_);
  onElement(root_element + namespace_uri()("macroStaticRef"), macroStaticRefHandler_);

  staticRefHandler_.onEnd(lambda::bind(&BlackBoxModelHandler::addStaticRef, lambda::ref(*this)));
  macroStaticRefHandler_.onEnd(lambda::bind(&BlackBoxModelHandler::addMacroStaticRef, lambda::ref(*this)));
}

BlackBoxModelHandler::~BlackBoxModelHandler() {}

void
BlackBoxModelHandler::create(attributes_type const& attributes) {
  blackBoxModel_ = BlackBoxModelFactory::newModel(attributes["id"]);
  blackBoxModel_->setLib(attributes["lib"]);

  if (attributes.has("staticId"))
    blackBoxModel_->setStaticId(attributes["staticId"]);

  if (attributes.has("parFile"))
    blackBoxModel_->setParFile(attributes["parFile"]);

  if (attributes.has("parId"))
    blackBoxModel_->setParId(attributes["parId"]);
}

void
BlackBoxModelHandler::addStaticRef() {
  StaticRefRead s = staticRefHandler_.get();
  blackBoxModel_->addStaticRef(s.var, s.staticVar, s.componentID);
}

void
BlackBoxModelHandler::addMacroStaticRef() {
  blackBoxModel_->addMacroStaticRef(macroStaticRefHandler_.get());
}

std::shared_ptr<BlackBoxModel>
BlackBoxModelHandler::get() const {
  return blackBoxModel_;
}

ModelTemplateExpansionHandler::ModelTemplateExpansionHandler(elementName_type const& root_element) :
staticRefHandler_(parser::ElementName(namespace_uri(), "staticRef")),
macroStaticRefHandler_(parser::ElementName(namespace_uri(), "macroStaticRef")) {
  onStartElement(root_element, lambda::bind(&ModelTemplateExpansionHandler::create, lambda::ref(*this), lambda_args::arg2));

  onElement(root_element + namespace_uri()("staticRef"), staticRefHandler_);
  onElement(root_element + namespace_uri()("macroStaticRef"), macroStaticRefHandler_);

  staticRefHandler_.onEnd(lambda::bind(&ModelTemplateExpansionHandler::addStaticRef, lambda::ref(*this)));
  macroStaticRefHandler_.onEnd(lambda::bind(&ModelTemplateExpansionHandler::addMacroStaticRef, lambda::ref(*this)));
}

ModelTemplateExpansionHandler::~ModelTemplateExpansionHandler() {}

void
ModelTemplateExpansionHandler::create(attributes_type const& attributes) {
  modelTemplateExpansion_ = ModelTemplateExpansionFactory::newModel(attributes["id"]);
  modelTemplateExpansion_->setTemplateId(attributes["templateId"]);

  if (attributes.has("staticId"))
    modelTemplateExpansion_->setStaticId(attributes["staticId"]);

  if (attributes.has("parFile"))
    modelTemplateExpansion_->setParFile(attributes["parFile"]);

  if (attributes.has("parId"))
    modelTemplateExpansion_->setParId(attributes["parId"]);
}

void
ModelTemplateExpansionHandler::addStaticRef() {
  StaticRefRead s = staticRefHandler_.get();
  modelTemplateExpansion_->addStaticRef(s.var, s.staticVar, s.componentID);
}

void
ModelTemplateExpansionHandler::addMacroStaticRef() {
  modelTemplateExpansion_->addMacroStaticRef(macroStaticRefHandler_.get());
}

std::shared_ptr<ModelTemplateExpansion>
ModelTemplateExpansionHandler::get() const {
  return modelTemplateExpansion_;
}

ConnectHandler::ConnectHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&ConnectHandler::create, lambda::ref(*this), lambda_args::arg2));
}

ConnectHandler::~ConnectHandler() {}

void
ConnectHandler::create(attributes_type const& attributes) {
  connector_.id1 = attributes["id1"].as_string();
  connector_.id2 = attributes["id2"].as_string();
  connector_.var1 = attributes["var1"].as_string();
  connector_.var2 = attributes["var2"].as_string();
}

ConnectorRead
ConnectHandler::get() const {
  return connector_;
}

MacroConnectHandler::MacroConnectHandler(const elementName_type& root_element) {
  onStartElement(root_element, lambda::bind(&MacroConnectHandler::create, lambda::ref(*this), lambda_args::arg2));
}

MacroConnectHandler::~MacroConnectHandler() {}

void
MacroConnectHandler::create(attributes_type const& attributes) {
  macroConnect_ = MacroConnectFactory::newMacroConnect(attributes["connector"], attributes["id1"], attributes["id2"]);
  if (attributes.has("index1"))
    macroConnect_->setIndex1(attributes["index1"]);
  if (attributes.has("index2"))
    macroConnect_->setIndex2(attributes["index2"]);
  if (attributes.has("name1"))
    macroConnect_->setName1(attributes["name1"]);
  if (attributes.has("name2"))
    macroConnect_->setName2(attributes["name2"]);
  if (attributes.has("componentId"))
    macroConnect_->setComponentId(attributes["componentId"]);
}

std::shared_ptr<MacroConnect>
MacroConnectHandler::get() const {
  return macroConnect_;
}

MacroConnectorHandler::MacroConnectorHandler(const elementName_type& root_element) :
macroConnectionHandler_(parser::ElementName(namespace_uri(), "connect")),
macroInitConnectionHandler_(parser::ElementName(namespace_uri(), "initConnect")) {
  onStartElement(root_element, lambda::bind(&MacroConnectorHandler::create, lambda::ref(*this), lambda_args::arg2));

  onElement(root_element + namespace_uri()("connect"), macroConnectionHandler_);
  onElement(root_element + namespace_uri()("initConnect"), macroInitConnectionHandler_);

  macroConnectionHandler_.onEnd(lambda::bind(&MacroConnectorHandler::addConnect, lambda::ref(*this)));
  macroInitConnectionHandler_.onEnd(lambda::bind(&MacroConnectorHandler::addInitConnect, lambda::ref(*this)));
}

MacroConnectorHandler::~MacroConnectorHandler() {}

void
MacroConnectorHandler::create(attributes_type const & attributes) {
  macroConnector_ = MacroConnectorFactory::newMacroConnector(attributes["id"]);
}

void
MacroConnectorHandler::addConnect() {
  MacroConnectionRead c = macroConnectionHandler_.get();
  macroConnector_->addConnect(c.var1, c.var2);
}

void
MacroConnectorHandler::addInitConnect() {
  MacroConnectionRead c = macroInitConnectionHandler_.get();
  macroConnector_->addInitConnect(c.var1, c.var2);
}

std::shared_ptr<MacroConnector>
MacroConnectorHandler::get() const {
  return macroConnector_;
}

MacroConnectionHandler::MacroConnectionHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&MacroConnectionHandler::create, lambda::ref(*this), lambda_args::arg2));
}

MacroConnectionHandler::~MacroConnectionHandler() {}

void
MacroConnectionHandler::create(attributes_type const& attributes) {
  macroConnection_.var1 = attributes["var1"].as_string();
  macroConnection_.var2 = attributes["var2"].as_string();
}

MacroConnectionRead
MacroConnectionHandler::get() const {
  return macroConnection_;
}

StaticRefHandler::StaticRefHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&StaticRefHandler::create, lambda::ref(*this), lambda_args::arg2));
}

StaticRefHandler::~StaticRefHandler() {}

void
StaticRefHandler::create(attributes_type const& attributes) {
  staticRef_.var = attributes["var"].as_string();
  staticRef_.staticVar = attributes["staticVar"].as_string();
  if (attributes.has("componentId"))
    staticRef_.componentID = attributes["componentId"].as_string();
}

StaticRefRead
StaticRefHandler::get() const {
  return staticRef_;
}

MacroStaticRefHandler::MacroStaticRefHandler(const elementName_type& root_element) {
  onStartElement(root_element, lambda::bind(&MacroStaticRefHandler::create, lambda::ref(*this), lambda_args::arg2));
}

MacroStaticRefHandler::~MacroStaticRefHandler() {}

void
MacroStaticRefHandler::create(attributes_type const& attributes) {
  const std::string & componentId = attributes.has("componentId") ? attributes["componentId"].as_string() : "";
  macroStaticRef_ = MacroStaticRefFactory::newMacroStaticRef(attributes["id"], componentId);
}

std::shared_ptr<MacroStaticRef>
MacroStaticRefHandler::get() const {
  return macroStaticRef_;
}

MacroStaticReferenceHandler::MacroStaticReferenceHandler(const elementName_type& root_element) :
staticRefHandler_(parser::ElementName(namespace_uri(), "staticRef")) {
  onStartElement(root_element, lambda::bind(&MacroStaticReferenceHandler::create, lambda::ref(*this), lambda_args::arg2));

  onElement(root_element + namespace_uri()("staticRef"), staticRefHandler_);

  staticRefHandler_.onEnd(lambda::bind(&MacroStaticReferenceHandler::addStaticRef, lambda::ref(*this)));
}

MacroStaticReferenceHandler::~MacroStaticReferenceHandler() {}

void
MacroStaticReferenceHandler::create(attributes_type const & attributes) {
  macroStaticReference_ = MacroStaticReferenceFactory::newMacroStaticReference(attributes["id"]);
}

void
MacroStaticReferenceHandler::addStaticRef() {
  StaticRefRead c = staticRefHandler_.get();
  macroStaticReference_->addStaticRef(c.var, c.staticVar);
}

std::shared_ptr<MacroStaticReference>
MacroStaticReferenceHandler::get() const {
  return macroStaticReference_;
}

UnitDynamicModelHandler::UnitDynamicModelHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&UnitDynamicModelHandler::create, lambda::ref(*this), lambda_args::arg2));
}

UnitDynamicModelHandler::~UnitDynamicModelHandler() {}

void
UnitDynamicModelHandler::create(attributes_type const& attributes) {
  const std::string& name = attributes["name"];
  unitDynamicModel_ = UnitDynamicModelFactory::newModel(attributes["id"], name);

  if (attributes.has("moFile"))
    unitDynamicModel_->setDynamicFileName(attributes["moFile"]);

  if (attributes.has("initName"))
    unitDynamicModel_->setInitModelName(attributes["initName"]);

  if (attributes.has("initFile")) {
    if (!attributes.has("initName"))
      throw DYNError(DYN::Error::API, MissingDYDInitName, name);
    unitDynamicModel_->setInitFileName(attributes["initFile"]);
  }

  if (attributes.has("parFile"))
    unitDynamicModel_->setParFile(attributes["parFile"]);

  if (attributes.has("parId"))
    unitDynamicModel_->setParId(attributes["parId"]);
}

std::shared_ptr<UnitDynamicModel>
UnitDynamicModelHandler::get() const {
  return unitDynamicModel_;
}

}  // namespace dynamicdata
