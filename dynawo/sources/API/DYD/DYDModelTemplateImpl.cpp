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
 * @file DYDModelTemplateImpl.cpp
 * @brief model template description : implementation file
 *
 */

#include <algorithm>  // for std::find
#include <boost/lexical_cast.hpp>
#include <sstream>
#include <list>
#include <set>

#include <iomanip>
#include <fstream>
#include <memory>

#include "DYNMacrosMessage.h"

#include "DYDModelTemplateImpl.h"
#include "DYDConnectorFactory.h"
#include "DYDConnector.h"
#include "DYDStaticRef.h"
#include "DYDMacroConnect.h"
#include "DYDUnitDynamicModel.h"
#include "DYDWhiteBoxModelCommon.h"


using std::map;
using std::vector;
using std::list;
using std::pair;
using std::set;
using std::string;
using std::stringstream;
using boost::shared_ptr;
using boost::weak_ptr;
using boost::dynamic_pointer_cast;


using std::map;
using std::string;
using std::vector;

using boost::shared_ptr;

namespace dynamicdata {

ModelTemplate::Impl::Impl(const string& id) :
Model::Impl(id, Model::MODEL_TEMPLATE),
useAliasing_(true),
generateCalculatedVariables_(true) {
}

ModelTemplate::Impl::~Impl() {
}

void
ModelTemplate::Impl::setCompilationOptions(bool useAlias, bool generateCalculatedVariables) {
  useAliasing_ = useAlias;
  generateCalculatedVariables_ = generateCalculatedVariables;
}

bool
ModelTemplate::Impl::getUseAlias() const {
  return useAliasing_;
}

bool
ModelTemplate::Impl::getGenerateCalculatedVariables() const {
  return generateCalculatedVariables_;
}

const map<string, shared_ptr<UnitDynamicModel> >&
ModelTemplate::Impl::getUnitDynamicModels() const {
  return unitDynamicModelsMap_;
}

const map<string, shared_ptr<Connector> >&
ModelTemplate::Impl::getConnectors() const {
  return connectorsMap_;
}

const map<std::string, shared_ptr<Connector> >&
ModelTemplate::Impl::getInitConnectors() const {
  return initConnectorsMap_;
}

const map<std::string, shared_ptr<MacroConnect> >&
ModelTemplate::Impl::getMacroConnects() const {
  return macroConnectsMap_;
}

ModelTemplate&
ModelTemplate::Impl::addUnitDynamicModel(const shared_ptr<UnitDynamicModel>& model) {
  if (unitDynamicModelsMap_.find(model->getId()) != unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, ModelIDNotUnique, model->getId());
  unitDynamicModelsMap_[model->getId()] = model;
  return *this;
}

ModelTemplate&
ModelTemplate::Impl::addConnect(const string& model1, const string& var1,
        const string& model2, const string& var2) {
  string connectionId = getConnectionId(model1, var1, model2, var2, getId(), unitDynamicModelsMap_);
  // Used instead of map_[connectionId] = Connector::Impl(model1, var1, model2, var2)
  // to avoid necessity to create Connector::Impl default constructor
  std::pair<std::map<std::string, boost::shared_ptr<Connector> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = connectorsMap_.emplace(connectionId, shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2)));
#else
  ret = connectorsMap_.insert(std::make_pair(connectionId, shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2))));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, ConnectorIDNotUnique, id_, model1 + '_' + var1, model2 + '_' + var2);
  return *this;
}

ModelTemplate&
ModelTemplate::Impl::addInitConnect(const string& model1, const string& var1,
        const string& model2, const string& var2) {
  string ic_Id = getConnectionId(model1, var1, model2, var2, getId(), unitDynamicModelsMap_);
  // Used instead of initConnectorsMap_[ic_Id] = Connector::Impl(model1, var1, model2, var2)
  // to avoid necessity to create Connector::Impl default constructor
  std::pair<std::map<std::string, boost::shared_ptr<Connector> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = initConnectorsMap_.emplace(ic_Id, shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2)));
#else
  ret = initConnectorsMap_.insert(std::make_pair(ic_Id, shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2))));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, ConnectorIDNotUnique, id_, model1 + '_' + var1, model2 + '_' + var2);
  return *this;
}

ModelTemplate&
ModelTemplate::Impl::addMacroConnect(const boost::shared_ptr<MacroConnect>& macroConnect) {
  string id = getMacroConnectionId(macroConnect->getFirstModelId(), macroConnect->getSecondModelId(), getId(), unitDynamicModelsMap_);
  std::pair<std::map<std::string, boost::shared_ptr<MacroConnect> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = macroConnectsMap_.emplace(id, macroConnect);
#else
  ret = macroConnectsMap_.insert(std::make_pair(id, macroConnect));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroConnectIDNotUnique, id);
  return *this;
}

string
ModelTemplate::Impl::getId() const {
  return Model::Impl::getId();
}

Model::ModelType
ModelTemplate::Impl::getType() const {
  return Model::Impl::getType();
}

Model&
ModelTemplate::Impl::addStaticRef(const std::string& var, const std::string& staticVar) {
  return Model::Impl::addStaticRef(var, staticVar);
}

void
ModelTemplate::Impl::addMacroStaticRef(const boost::shared_ptr<MacroStaticRef>& macroStaticRef) {
  Model::Impl::addMacroStaticRef(macroStaticRef);
}

macroStaticRef_const_iterator
ModelTemplate::Impl::cbeginMacroStaticRef() const {
  return Model::Impl::cbeginMacroStaticRef();
}

macroStaticRef_const_iterator
ModelTemplate::Impl::cendMacroStaticRef() const {
  return Model::Impl::cendMacroStaticRef();
}

staticRef_iterator
ModelTemplate::Impl::beginStaticRef() {
  return Model::Impl::beginStaticRef();
}

staticRef_iterator
ModelTemplate::Impl::endStaticRef() {
  return Model::Impl::endStaticRef();
}

staticRef_const_iterator
ModelTemplate::Impl::cbeginStaticRef() const {
  return Model::Impl::cbeginStaticRef();
}

staticRef_const_iterator
ModelTemplate::Impl::cendStaticRef() const {
  return Model::Impl::cendStaticRef();
}

macroStaticRef_iterator
ModelTemplate::Impl::beginMacroStaticRef() {
  return Model::Impl::beginMacroStaticRef();
}

macroStaticRef_iterator
ModelTemplate::Impl::endMacroStaticRef() {
  return Model::Impl::endMacroStaticRef();
}

const boost::shared_ptr<StaticRef>&
ModelTemplate::Impl::findStaticRef(const std::string& key) {
  return Model::Impl::findStaticRef(key);
}

const boost::shared_ptr<MacroStaticRef>&
ModelTemplate::Impl::findMacroStaticRef(const std::string& id) {
  return Model::Impl::findMacroStaticRef(id);
}

}  // namespace dynamicdata
