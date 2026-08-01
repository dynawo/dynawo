//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
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

namespace dynamicdata {

void
DynamicModelsCollection::addModel(const std::shared_ptr<Model>& model) {
  const string& id = model->getId();
  // Used instead of models_[name] = ModelFactory::newModel(id)
  // to avoid necessity to create Model default constructor
  const auto& ret = models_.emplace(id, model);
  if (!ret.second)
    throw DYNError(DYN::Error::API, ModelIDNotUnique, id);
}

void
DynamicModelsCollection::addConnect(const string& model1, const string& var1, const string& model2, const string& var2) {
  if (model1 == model2)
    throw DYNError(DYN::Error::API, InternalConnectDoneInSystem, model1, var1, model2, var2);

  connectors_.push_back(ConnectorFactory::newConnector(model1, var1, model2, var2));
}

void
DynamicModelsCollection::addMacroConnect(const std::shared_ptr<MacroConnect>& macroConnect) {
  macroConnects_.push_back(macroConnect);
}

void
DynamicModelsCollection::addMacroConnector(const std::shared_ptr<MacroConnector>& macroConnector) {
  const string& id = macroConnector->getId();
  const std::pair<std::map<std::string, std::shared_ptr<MacroConnector> >::iterator, bool> ret = macroConnectors_.emplace(id, macroConnector);
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroConnectorIDNotUnique, id);
}

void
DynamicModelsCollection::addMacroStaticReference(const std::shared_ptr<MacroStaticReference>& macroStaticReference) {
  const string& id = macroStaticReference->getId();
  std::pair<std::map<std::string, std::shared_ptr<MacroStaticReference> >::iterator, bool> ret;
  ret = macroStaticReferences_.emplace(id, macroStaticReference);
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroStaticReferenceNotUnique, id);
}

const std::shared_ptr<MacroConnector>&
DynamicModelsCollection::findMacroConnector(const std::string& connector) {
  const auto& iter = macroConnectors_.find(connector);
  if (iter == macroConnectors_.end())
    throw DYNError(DYN::Error::API, MacroConnectorUndefined, connector);

  return iter->second;
}

const std::shared_ptr<MacroStaticReference>&
DynamicModelsCollection::findMacroStaticReference(const std::string& id) {
  const auto& iter = macroStaticReferences_.find(id);
  if (iter == macroStaticReferences_.end())
    throw DYNError(DYN::Error::API, MacroStaticReferenceUndefined, id);

  return iter->second;
}

}  // namespace dynamicdata
