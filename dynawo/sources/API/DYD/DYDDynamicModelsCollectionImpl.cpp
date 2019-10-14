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
 * @file DYDDynamicModelsCollectionImpl.cpp
 * @brief Dynamic models collection description : implementation file
 *
 */

#include "DYNMacrosMessage.h"

#include "DYDBlackBoxModelFactory.h"
#include "DYDModelicaModelFactory.h"
#include "DYDModelTemplateExpansionFactory.h"
#include "DYDModelTemplateFactory.h"
#include "DYDMacroConnect.h"
#include "DYDConnectorFactory.h"
#include "DYDConnector.h"
#include "DYDDynamicModelsCollectionImpl.h"
#include "DYDIterators.h"
#include "DYDUnitDynamicModelFactory.h"
#include "DYDIdentifiableFactory.h"
#include "DYDModel.h"
#include "DYDMacroConnector.h"
#include "DYDMacroStaticReference.h"

using std::map;
using std::string;

using boost::dynamic_pointer_cast;
using boost::shared_ptr;

using DYN::Error;

namespace dynamicdata {

DynamicModelsCollection::Impl::Impl() {
}

DynamicModelsCollection::Impl::~Impl() {
}

void
DynamicModelsCollection::Impl::addModel(const shared_ptr<Model>& model) {
  string id = model->getId();
  // Used instead of models_[name] = ModelFactory::newModel(id)
  // to avoid necessity to create Model::Impl default constructor
  std::pair<std::map<std::string, boost::shared_ptr<Model> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = models_.emplace(id, model);
#else
  ret = models_.insert(std::make_pair(id, model));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, ModelIDNotUnique, id);
}

void
DynamicModelsCollection::Impl::addConnect(const string& model1, const string& var1,
        const string& model2, const string& var2) {
  if (model1 == model2)
    throw DYNError(DYN::Error::API, InternalConnectDoneInSystem, model1, var1, model2, var2);

  connectors_.push_back(shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2)));
}

void
DynamicModelsCollection::Impl::addMacroConnect(const boost::shared_ptr<MacroConnect>& macroConnect) {
  macroConnects_.push_back(macroConnect);
}

void
DynamicModelsCollection::Impl::addMacroConnector(const boost::shared_ptr<MacroConnector>& macroConnector) {
  string id = macroConnector->getId();
  std::pair<std::map<std::string, boost::shared_ptr<MacroConnector> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = macroConnectors_.emplace(id, macroConnector);
#else
  ret = macroConnectors_.insert(std::make_pair(id, macroConnector));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroConnectorIDNotUnique, id);
}

void
DynamicModelsCollection::Impl::addMacroStaticReference(const boost::shared_ptr<MacroStaticReference>& macroStaticReference) {
  string id = macroStaticReference->getId();
  std::pair<std::map<std::string, boost::shared_ptr<MacroStaticReference> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = macroStaticReferences_.emplace(id, macroStaticReference);
#else
  ret = macroStaticReferences_.insert(std::make_pair(id, macroStaticReference));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroStaticReferenceNotUnique, id);
}

dynamicModel_const_iterator
DynamicModelsCollection::Impl::cbeginModel() const {
  return dynamicModel_const_iterator(this, true);
}

dynamicModel_const_iterator
DynamicModelsCollection::Impl::cendModel() const {
  return dynamicModel_const_iterator(this, false);
}

connector_const_iterator
DynamicModelsCollection::Impl::cbeginConnector() const {
  return connector_const_iterator(this, true);
}

connector_const_iterator
DynamicModelsCollection::Impl::cendConnector() const {
  return connector_const_iterator(this, false);
}

macroConnector_const_iterator
DynamicModelsCollection::Impl::cbeginMacroConnector() const {
  return macroConnector_const_iterator(this, true);
}

macroConnector_const_iterator
DynamicModelsCollection::Impl::cendMacroConnector() const {
  return macroConnector_const_iterator(this, false);
}

macroConnect_const_iterator
DynamicModelsCollection::Impl::cbeginMacroConnect() const {
  return macroConnect_const_iterator(this, true);
}

macroConnect_const_iterator
DynamicModelsCollection::Impl::cendMacroConnect() const {
  return macroConnect_const_iterator(this, false);
}

macroStaticReference_const_iterator
DynamicModelsCollection::Impl::cbeginMacroStaticReference() const {
  return macroStaticReference_const_iterator(this, true);
}

macroStaticReference_const_iterator
DynamicModelsCollection::Impl::cendMacroStaticReference() const {
  return macroStaticReference_const_iterator(this, false);
}

dynamicModel_iterator
DynamicModelsCollection::Impl::beginModel() {
  return dynamicModel_iterator(this, true);
}

dynamicModel_iterator
DynamicModelsCollection::Impl::endModel() {
  return dynamicModel_iterator(this, false);
}

connector_iterator
DynamicModelsCollection::Impl::beginConnector() {
  return connector_iterator(this, true);
}

connector_iterator
DynamicModelsCollection::Impl::endConnector() {
  return connector_iterator(this, false);
}

macroConnector_iterator
DynamicModelsCollection::Impl::beginMacroConnector() {
  return macroConnector_iterator(this, true);
}

macroConnector_iterator
DynamicModelsCollection::Impl::endMacroConnector() {
  return macroConnector_iterator(this, false);
}

macroConnect_iterator
DynamicModelsCollection::Impl::beginMacroConnect() {
  return macroConnect_iterator(this, true);
}

macroConnect_iterator
DynamicModelsCollection::Impl::endMacroConnect() {
  return macroConnect_iterator(this, false);
}

macroStaticReference_iterator
DynamicModelsCollection::Impl::beginMacroStaticReference() {
  return macroStaticReference_iterator(this, true);
}

macroStaticReference_iterator
DynamicModelsCollection::Impl::endMacroStaticReference() {
  return macroStaticReference_iterator(this, false);
}

const shared_ptr<MacroConnector>&
DynamicModelsCollection::Impl::findMacroConnector(const std::string& connector) {
  map<string, shared_ptr<MacroConnector> >::const_iterator iter = macroConnectors_.find(connector);
  if (iter == macroConnectors_.end())
    throw DYNError(DYN::Error::API, MacroConnectorUndefined, connector);

  return iter->second;
}

const shared_ptr<MacroStaticReference>&
DynamicModelsCollection::Impl::findMacroStaticReference(const std::string& id) {
  map<string, shared_ptr<MacroStaticReference> >::const_iterator iter = macroStaticReferences_.find(id);
  if (iter == macroStaticReferences_.end())
    throw DYNError(DYN::Error::API, MacroStaticReferenceUndefined, id);

  return iter->second;
}

}  // namespace dynamicdata
