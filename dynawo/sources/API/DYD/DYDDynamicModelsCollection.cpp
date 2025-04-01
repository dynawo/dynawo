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
 * @file DYDDynamicModelsCollection.cpp
 * @brief Dynamic models collection description : implementation file
 *
 */

#include "DYDDynamicModelsCollection.h"

#include "DYDBlackBoxModelFactory.h"
#include "DYDConnector.h"
#include "DYDConnectorFactory.h"
#include "DYDIdentifiableFactory.h"
#include "DYDIterators.h"
#include "DYDMacroConnect.h"
#include "DYDMacroConnector.h"
#include "DYDMacroStaticReference.h"
#include "DYDModel.h"
#include "DYDModelTemplateExpansionFactory.h"
#include "DYDModelTemplateFactory.h"
#include "DYDModelicaModelFactory.h"
#include "DYDUnitDynamicModelFactory.h"
#include "DYNMacrosMessage.h"

using std::map;
using std::string;

using boost::dynamic_pointer_cast;
using boost::shared_ptr;

using DYN::Error;

namespace dynamicdata {

void
DynamicModelsCollection::addModel(const shared_ptr<Model>& model) {
  const string& id = model->getId();
  // Used instead of models_[name] = ModelFactory::newModel(id)
  // to avoid necessity to create Model default constructor
  std::pair<std::map<std::string, boost::shared_ptr<Model> >::iterator, bool> ret;
  ret = models_.emplace(id, model);
  if (!ret.second)
    throw DYNError(DYN::Error::API, ModelIDNotUnique, id);
}

void
DynamicModelsCollection::addConnect(const string& model1, const string& var1, const string& model2, const string& var2) {
  if (model1 == model2)
    throw DYNError(DYN::Error::API, InternalConnectDoneInSystem, model1, var1, model2, var2);

  connectors_.push_back(shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2)));
}

void
DynamicModelsCollection::addMacroConnect(const boost::shared_ptr<MacroConnect>& macroConnect) {
  macroConnects_.push_back(macroConnect);
}

void
DynamicModelsCollection::addMacroConnector(const boost::shared_ptr<MacroConnector>& macroConnector) {
  const string& id = macroConnector->getId();
  std::pair<std::map<std::string, boost::shared_ptr<MacroConnector> >::iterator, bool> ret;
  ret = macroConnectors_.emplace(id, macroConnector);
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroConnectorIDNotUnique, id);
}

void
DynamicModelsCollection::addMacroStaticReference(const boost::shared_ptr<MacroStaticReference>& macroStaticReference) {
  const string& id = macroStaticReference->getId();
  std::pair<std::map<std::string, boost::shared_ptr<MacroStaticReference> >::iterator, bool> ret;
  ret = macroStaticReferences_.emplace(id, macroStaticReference);
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroStaticReferenceNotUnique, id);
}

dynamicModel_const_iterator
DynamicModelsCollection::cbeginModel() const {
  return dynamicModel_const_iterator(this, true);
}

dynamicModel_const_iterator
DynamicModelsCollection::cendModel() const {
  return dynamicModel_const_iterator(this, false);
}

connector_const_iterator
DynamicModelsCollection::cbeginConnector() const {
  return connector_const_iterator(this, true);
}

connector_const_iterator
DynamicModelsCollection::cendConnector() const {
  return connector_const_iterator(this, false);
}

macroConnector_const_iterator
DynamicModelsCollection::cbeginMacroConnector() const {
  return macroConnector_const_iterator(this, true);
}

macroConnector_const_iterator
DynamicModelsCollection::cendMacroConnector() const {
  return macroConnector_const_iterator(this, false);
}

macroConnect_const_iterator
DynamicModelsCollection::cbeginMacroConnect() const {
  return macroConnect_const_iterator(this, true);
}

macroConnect_const_iterator
DynamicModelsCollection::cendMacroConnect() const {
  return macroConnect_const_iterator(this, false);
}

macroStaticReference_const_iterator
DynamicModelsCollection::cbeginMacroStaticReference() const {
  return macroStaticReference_const_iterator(this, true);
}

macroStaticReference_const_iterator
DynamicModelsCollection::cendMacroStaticReference() const {
  return macroStaticReference_const_iterator(this, false);
}

dynamicModel_iterator
DynamicModelsCollection::beginModel() {
  return dynamicModel_iterator(this, true);
}

dynamicModel_iterator
DynamicModelsCollection::endModel() {
  return dynamicModel_iterator(this, false);
}

connector_iterator
DynamicModelsCollection::beginConnector() {
  return connector_iterator(this, true);
}

connector_iterator
DynamicModelsCollection::endConnector() {
  return connector_iterator(this, false);
}

macroConnector_iterator
DynamicModelsCollection::beginMacroConnector() {
  return macroConnector_iterator(this, true);
}

macroConnector_iterator
DynamicModelsCollection::endMacroConnector() {
  return macroConnector_iterator(this, false);
}

macroConnect_iterator
DynamicModelsCollection::beginMacroConnect() {
  return macroConnect_iterator(this, true);
}

macroConnect_iterator
DynamicModelsCollection::endMacroConnect() {
  return macroConnect_iterator(this, false);
}

macroStaticReference_iterator
DynamicModelsCollection::beginMacroStaticReference() {
  return macroStaticReference_iterator(this, true);
}

macroStaticReference_iterator
DynamicModelsCollection::endMacroStaticReference() {
  return macroStaticReference_iterator(this, false);
}

const shared_ptr<MacroConnector>&
DynamicModelsCollection::findMacroConnector(const std::string& connector) {
  map<string, shared_ptr<MacroConnector> >::const_iterator iter = macroConnectors_.find(connector);
  if (iter == macroConnectors_.end())
    throw DYNError(DYN::Error::API, MacroConnectorUndefined, connector);

  return iter->second;
}

const shared_ptr<MacroStaticReference>&
DynamicModelsCollection::findMacroStaticReference(const std::string& id) {
  map<string, shared_ptr<MacroStaticReference> >::const_iterator iter = macroStaticReferences_.find(id);
  if (iter == macroStaticReferences_.end())
    throw DYNError(DYN::Error::API, MacroStaticReferenceUndefined, id);

  return iter->second;
}

}  // namespace dynamicdata
