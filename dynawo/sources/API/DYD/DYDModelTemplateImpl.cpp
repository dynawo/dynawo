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
Model::Impl(id, Model::MODEL_TEMPLATE) {
}

ModelTemplate::Impl::~Impl() {
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
  if (unitDynamicModelsMap_.find(model1) == unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, ConnectorNotPartofModel, model1, model2, getId());
  if (unitDynamicModelsMap_.find(model2) == unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, ConnectorNotPartofModel, model2, model1, getId());

  string pc_first = model1 + '_' + var1;
  string pc_second = model2 + '_' + var2;
  // To build the connector Id, sort the string so as 1st_Model_ID is smaller than 2nd_Model_ID. EX: ID_1 < ID_2
  string pc_Id;
  if (pc_first < pc_second)
    pc_Id = pc_first + '_' + pc_second;
  else
    pc_Id = pc_second + '_' + pc_first;

  // Used instead of map_[pc_Id] = Connector::Impl(model1, var1, model2, var2)
  // to avoid necessity to create Connector::Impl default constructor
  std::pair<std::map<std::string, boost::shared_ptr<Connector> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = connectorsMap_.emplace(pc_Id, shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2)));
#else
  ret = connectorsMap_.insert(std::make_pair(pc_Id, shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2))));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, ConnectorIDNotUnique, id_, pc_first, pc_second);
  return *this;
}

ModelTemplate&
ModelTemplate::Impl::addInitConnect(const string& model1, const string& var1,
        const string& model2, const string& var2) {
  if (unitDynamicModelsMap_.find(model1) == unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, ConnectorNotPartofModel, model1, model2, getId());
  if (unitDynamicModelsMap_.find(model2) == unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, ConnectorNotPartofModel, model2, model1, getId());

  string ic_first;
  string ic_second;
  string ic_Id;
  ic_first = model1 + '_' + var1;
  ic_second = model2 + '_' + var2;
  // To build the connector Id, sort the string so as 1st_Model_ID is smaller than 2nd_Model_ID. EX: ID_1 < ID_2
  if (ic_first < ic_second)
    ic_Id = ic_first + '_' + ic_second;
  else
    ic_Id = ic_second + '_' + ic_first;
  // Used instead of initConnectorsMap_[ic_Id] = Connector::Impl(model1, var1, model2, var2)
  // to avoid necessity to create Connector::Impl default constructor
  std::pair<std::map<std::string, boost::shared_ptr<Connector> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = initConnectorsMap_.emplace(ic_Id, shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2)));
#else
  ret = initConnectorsMap_.insert(std::make_pair(ic_Id, shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2))));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, ConnectorIDNotUnique, id_, ic_first, ic_second);
  return *this;
}

ModelTemplate&
ModelTemplate::Impl::addMacroConnect(const boost::shared_ptr<MacroConnect>& macroConnect) {
  string model1 = macroConnect->getFirstModelId();
  string model2 = macroConnect->getSecondModelId();
  if (unitDynamicModelsMap_.find(model1) == unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, MacroConnectNotPartofModel, model1, model2, getId());
  if (unitDynamicModelsMap_.find(model2) == unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, MacroConnectNotPartofModel, model2, model1, getId());

  string id;
  if (model1 < model2)
    id = model1 + '_' + model2;
  else
    id = model2 + '_' + model1;
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

staticRef_const_iterator
ModelTemplate::Impl::cbeginStaticRef() const {
  return Model::Impl::cbeginStaticRef();
}

staticRef_const_iterator
ModelTemplate::Impl::cendStaticRef() const {
  return Model::Impl::cendStaticRef();
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
