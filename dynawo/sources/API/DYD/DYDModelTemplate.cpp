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
 * @file DYDModelTemplate.cpp
 * @brief model template description : implementation file
 *
 */

#include "DYDModelTemplate.h"

#include "DYDConnector.h"
#include "DYDConnectorFactory.h"
#include "DYDMacroConnect.h"
#include "DYDStaticRef.h"
#include "DYDUnitDynamicModel.h"
#include "DYDWhiteBoxModelCommon.h"
#include "DYNMacrosMessage.h"

#include <memory>

using std::map;
using std::string;


namespace dynamicdata {

ModelTemplate::ModelTemplate(const string& id) : Model(id, Model::MODEL_TEMPLATE), useAliasing_(true), generateCalculatedVariables_(true) {}

ModelTemplate::~ModelTemplate() {}

void
ModelTemplate::setCompilationOptions(const bool useAliasing, bool const generateCalculatedVariables) {
  useAliasing_ = useAliasing;
  generateCalculatedVariables_ = generateCalculatedVariables;
}

bool
ModelTemplate::getUseAliasing() const {
  return useAliasing_;
}

bool
ModelTemplate::getGenerateCalculatedVariables() const {
  return generateCalculatedVariables_;
}

const map<string, std::shared_ptr<UnitDynamicModel> >&
ModelTemplate::getUnitDynamicModels() const {
  return unitDynamicModelsMap_;
}

const map<string, std::shared_ptr<Connector> >&
ModelTemplate::getConnectors() const {
  return connectorsMap_;
}

const map<std::string, std::shared_ptr<Connector> >&
ModelTemplate::getInitConnectors() const {
  return initConnectorsMap_;
}

const map<std::string, std::shared_ptr<MacroConnect> >&
ModelTemplate::getMacroConnects() const {
  return macroConnectsMap_;
}

ModelTemplate&
ModelTemplate::addUnitDynamicModel(const std::shared_ptr<UnitDynamicModel>& model) {
  if (unitDynamicModelsMap_.find(model->getId()) != unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, ModelIDNotUnique, model->getId());
  unitDynamicModelsMap_[model->getId()] = model;
  return *this;
}

ModelTemplate&
ModelTemplate::addConnect(const string& model1, const string& var1, const string& model2, const string& var2) {
  string connectionId = getConnectionId(model1, var1, model2, var2, getId(), unitDynamicModelsMap_);
  // Used instead of map_[connectionId] = Connector::Impl(model1, var1, model2, var2)
  // to avoid necessity to create Connector::Impl default constructor
  std::pair<std::map<std::string, std::shared_ptr<Connector> >::iterator, bool> ret;
  ret = connectorsMap_.emplace(connectionId, ConnectorFactory::newConnector(model1, var1, model2, var2));
  if (!ret.second)
    throw DYNError(DYN::Error::API, ConnectorIDNotUnique, id_.get(), model1 + '_' + var1, model2 + '_' + var2);
  return *this;
}

ModelTemplate&
ModelTemplate::addInitConnect(const string& model1, const string& var1, const string& model2, const string& var2) {
  string ic_Id = getConnectionId(model1, var1, model2, var2, getId(), unitDynamicModelsMap_);
  // Used instead of initConnectorsMap_[ic_Id] = Connector::Impl(model1, var1, model2, var2)
  // to avoid necessity to create Connector::Impl default constructor
  std::pair<std::map<std::string, std::shared_ptr<Connector> >::iterator, bool> ret;
  ret = initConnectorsMap_.emplace(ic_Id, ConnectorFactory::newConnector(model1, var1, model2, var2));
  if (!ret.second)
    throw DYNError(DYN::Error::API, ConnectorIDNotUnique, id_.get(), model1 + '_' + var1, model2 + '_' + var2);
  return *this;
}

ModelTemplate&
ModelTemplate::addMacroConnect(const std::shared_ptr<MacroConnect>& macroConnect) {
  string id = getMacroConnectionId(macroConnect->getFirstModelId(), macroConnect->getSecondModelId(), getId(), unitDynamicModelsMap_);
  std::pair<std::map<std::string, std::shared_ptr<MacroConnect> >::iterator, bool> ret;
  ret = macroConnectsMap_.emplace(id, macroConnect);
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroConnectIDNotUnique, id);
  return *this;
}

}  // namespace dynamicdata
