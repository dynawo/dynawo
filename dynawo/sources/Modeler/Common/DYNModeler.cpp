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
 * @file  DYNModeler.cpp
 *
 * @brief Assembly all models declared in inputs files
 *
 */

#include <string>
#include <vector>
#include <cmath>
#include <map>

#include <boost/algorithm/string.hpp>
#include <boost/unordered_map.hpp>

#include "PARParametersSet.h"
#include "PARReference.h"
#include "DYDConnector.h"
#include "DYDMacroConnector.h"
#include "DYDMacroConnect.h"
#include "DYDMacroConnection.h"
#include "DYDDynamicModelsCollection.h"
#include "DYDModel.h"
#include "DYDModelicaModel.h"
#include "DYDModelTemplate.h"

#include "DYNModeler.h"
#include "DYNCommon.h"
#include "DYNCommonModeler.h"
#include "DYNVariable.h"
#include "DYNMacrosMessage.h"
#include "DYNSubModel.h"
#include "DYNConnectInterface.h"
#include "DYNStaticRefInterface.h"
#include "DYNModelDescription.h"
#include "DYNDynamicData.h"
#include "DYNModelMulti.h"
#include "DYNSubModelFactory.h"
#include "DYNTrace.h"
#include "DYNElement.h"
#include "DYNDataInterface.h"
#include "DYNExecUtils.h"

using std::string;
using std::map;
using std::vector;

using boost::shared_ptr;
using boost::dynamic_pointer_cast;

using parameters::ParametersSet;
using parameters::Reference;

namespace DYN {

void
Modeler::initSystem() {
  model_ = shared_ptr<ModelMulti>(new ModelMulti());

  if (data_ && data_->instantiateNetwork())
    initNetwork();

  initModelDescription();
  initConnects();
  SanityCheckFlowConnection();
}

void
Modeler::initNetwork() {
  // network model from an IIDM situation
  // --------------------------------------------
  shared_ptr<SubModel> modelNetwork;
  string DDBDir = getMandatoryEnvVar("DYNAWO_DDB_DIR");

  modelNetwork = SubModelFactory::createSubModelFromLib(DDBDir + "/DYNModelNetwork" + sharedLibraryExtension());
  modelNetwork->initFromData(data_);
  data_->setModelNetwork(modelNetwork);
  modelNetwork->name("NETWORK");
  shared_ptr<ParametersSet> networkParams = dyd_->getNetworkParameters();
  modelNetwork->setPARParameters(networkParams);

  model_->addSubModel(modelNetwork, "DYNModelNetwork" + string(sharedLibraryExtension()));
  subModels_["NETWORK"] = modelNetwork;
}

void
Modeler::initModelDescription() {
  const std::map<string, shared_ptr<ModelDescription> >& modelDescriptions = dyd_->getModelDescriptions();
  for (std::map<string, shared_ptr<ModelDescription> >::const_iterator itModelDescription = modelDescriptions.begin();
        itModelDescription != modelDescriptions.end(); ++itModelDescription) {
    if (itModelDescription->second->getModel()->getType() == dynamicdata::Model::MODEL_TEMPLATE) {
      continue;
    }

    if ((itModelDescription->second)->hasCompiledModel()) {
      shared_ptr<SubModel> model;
      model = SubModelFactory::createSubModelFromLib(itModelDescription->second->getLib());
      model->name((itModelDescription->second)->getID());
      model->staticId((itModelDescription->second)->getStaticId());
      shared_ptr<ParametersSet> params = (itModelDescription->second)->getParametersSet();
      initParamDescription(itModelDescription->second);

      model->setPARParameters(params);
      model->initFromData(data_);
      // add the submodel
      model_->addSubModel(model, itModelDescription->second->getLib());
      subModels_[(itModelDescription->second)->getID()] = model;
      (itModelDescription->second)->setSubModel(model);
      // reference static
      if ((itModelDescription->second)->getStaticId() != "") {
        data_->setDynamicModel((itModelDescription->second)->getStaticId(), model);
        initStaticRefs(model, (itModelDescription->second));
      }
    } else {
      throw DYNError(Error::MODELER, CompileModel, (itModelDescription->second)->getID());
    }
  }
}

void
Modeler::initParamDescription(const shared_ptr<ModelDescription>& modelDescription) {
  shared_ptr<ParametersSet> params = modelDescription->getParametersSet();

  // params can be a nullptr if no parFile was given for the model
  if (params) {
    // if there are references in external parameters, retrieve the parameters' value from IIDM
    vector<string> referencesNames = params->getReferencesNames();

    for (vector<string>::const_iterator itRef = referencesNames.begin(); itRef != referencesNames.end(); ++itRef) {
      string refType = params->getReference(*itRef)->getType();
      Reference::OriginData refOrigData_ = params->getReference(*itRef)->getOrigData();  // IIDM
      string refOrigName = params->getReference(*itRef)->getOrigName();
      string staticID = modelDescription->getStaticId();
      string componentID = params->getReference(*itRef)->getComponentId();
      // if data_ origin is IIDM file, retrieve the value and add a parameter in the parameter set.
      if (componentID != "")
        staticID = componentID;  // when componentID exist, this id should be used to find the parameter value
      if (refOrigData_ == Reference::IIDM) {
        if (staticID.empty())
          throw DYNError(Error::MODELER, ParameterStaticIdNotFound, refOrigName, params->getReference(*itRef)->getName(), modelDescription->getID());
        if (refType == "DOUBLE") {
          double value = data_->getStaticParameterDoubleValue(staticID, refOrigName);
          params->createParameter(*itRef, value);
        } else if (refType == "INT") {
          int value = data_->getStaticParameterIntValue(staticID, refOrigName);
          params->createParameter(*itRef, value);
        } else if (refType == "BOOL") {
          bool value = data_->getStaticParameterBoolValue(staticID, refOrigName);
          params->createParameter(*itRef, value);
        } else {
          throw DYNError(Error::MODELER, ParameterWrongTypeReference, *itRef);
        }
      } else {
        throw DYNError(Error::MODELER, FunctionNotAvailable);
      }
    }
  }
}

void
Modeler::initStaticRefs(const shared_ptr<SubModel>& model, const shared_ptr<ModelDescription>& modelDescription) {
  vector<shared_ptr<StaticRefInterface> > references = modelDescription->getStaticRefInterfaces();

  vector<shared_ptr<StaticRefInterface> >::const_iterator itReference;
  for (itReference = references.begin(); itReference != references.end(); ++itReference) {
    string modelID = ((*itReference)->getModelID().empty()) ? modelDescription->getID() : (*itReference)->getModelID();
    string modelVar = (*itReference)->getModelVar();
    string staticVar = (*itReference)->getStaticVar();

    data_->setReference(staticVar, model->staticId(), modelID, modelVar);
  }
}


void
Modeler::replaceStaticAndNodeMacroInVariableName(const shared_ptr<SubModel>& subModel1, string& var1,
    const shared_ptr<SubModel>& subModel2, string& var2) const {

  // convention : if node inside a connector, the staticId of the component is placed before
  // so the name of the var is as follow : @STATIC_ID@@@NODE@_var or @STATIC_ID@@@NODE1@_var or @STATIC_ID@@@NODE2@_var
  const string labelNode = "@NODE@";
  const string labelNode1 = "@NODE1@";
  const string labelNode2 = "@NODE2@";
  const string labelStaticId = "@STATIC_ID@";

  // replace @STATIC_ID@ with the static id of the model where the connection should be made
  bool foundStaticIdInVar1 = (var1.find(labelStaticId) != string::npos);
  bool foundStaticIdInVar2 = (var2.find(labelStaticId) != string::npos);
  if (foundStaticIdInVar1)
    var1.replace(var1.find(labelStaticId), labelStaticId.size(), "@" + subModel2->staticId() + "@");
  if (foundStaticIdInVar2)
    var2.replace(var2.find(labelStaticId), labelStaticId.size(), "@" + subModel1->staticId() + "@");

  // replace @NODE@, @NODE1@, @NODE2@ with the static id of the bus
  replaceNodeWithBus(subModel1, var1, subModel2, var2, labelNode);
  replaceNodeWithBus(subModel1, var1, subModel2, var2, labelNode1);
  replaceNodeWithBus(subModel1, var1, subModel2, var2, labelNode2);
}

void
Modeler::replaceNodeWithBus(const shared_ptr<SubModel>& subModel1, string& var1,
    const shared_ptr<SubModel>& subModel2, string& var2, const string& labelNode) const {
  bool foundNodeInVar1 = (var1.find(labelNode) != string::npos);
  bool foundNodeInVar2 = (var2.find(labelNode) != string::npos);
  if (foundNodeInVar1 && foundNodeInVar2) {
    throw DYNError(Error::MODELER, WrongConnectTwoUnknownNodes, subModel1->name(), var1, subModel2->name(), var2);
  } else if (foundNodeInVar1) {
    var1 = findNodeConnectorName(var1, labelNode);
  } else if (foundNodeInVar2) {
    var2 = findNodeConnectorName(var2, labelNode);
  }
}

void
Modeler::initConnects() {
  Trace::debug(Trace::modeler()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::modeler()) << DYNLog(DynamicConnectStart) << Trace::endline;
  Trace::debug(Trace::modeler()) << "------------------------------" << Trace::endline;
  const std::map<string, shared_ptr<ConnectInterface> >& connects = dyd_->getConnectInterfaces();
  for (std::map<string, shared_ptr<ConnectInterface> >::const_iterator itConnector = connects.begin();
          itConnector != connects.end(); ++itConnector) {
    string id1 = (itConnector->second)->getConnectedModel1();
    string id2 = (itConnector->second)->getConnectedModel2();
    string var1 = (itConnector->second)->getModel1Var();
    string var2 = (itConnector->second)->getModel2Var();

    map<string, shared_ptr<SubModel> >::iterator iter1;
    map<string, shared_ptr<SubModel> >::iterator iter2;
    iter1 = subModels_.find(id1);
    iter2 = subModels_.find(id2);
    if (iter1 == subModels_.end() || iter2 == subModels_.end()) {
      Trace::warn() << DYNLog(CreateDynamicConnectFailed, id1, var1, id2, var2) << Trace::endline;
      Trace::warn() << DYNLog(NotInstancedModel) << Trace::endline;
      continue;
    }

    replaceStaticAndNodeMacroInVariableName(iter1->second, var1, iter2->second, var2);

    Trace::debug(Trace::modeler()) << DYNLog(DynamicConnect, id1, var1, id2, var2) << Trace::endline;

    model_->connectElements(iter1->second, var1, iter2->second, var2);
  }
  Trace::debug(Trace::modeler()) << "------------------------------" << Trace::endline;
}

string
Modeler::findNodeConnectorName(const string& id, const string& labelNode) const {
  // remove labelNode: @NODE@ or @NODE1@ or @NODE2@
  string tmpId = id;
  tmpId.replace(tmpId.find(labelNode), labelNode.size(), "");
  // retrieve the staticId of the component
  vector<string> strs;
  boost::split(strs, tmpId, boost::is_any_of("@"));

  if (strs.size() == 3) {
    string busName = data_->getBusName(strs[1], labelNode);
    if (busName.empty()) {
      throw DYNError(Error::MODELER, MacroNotResolved, id, "bus not found");
    }
    string staticIdLabel = "@" + strs[1] + "@";
    // replace @staticId@ by the node name
    tmpId.replace(tmpId.find(staticIdLabel), staticIdLabel.size(), busName);
  }
  return tmpId;
}

void
Modeler::collectAllInternalConnections(shared_ptr<dynamicdata::ModelicaModel> model,
    vector<std::pair<string, string> >& variablesConnectedInternally) const {

  string modelId = model->getId();
  map<string, shared_ptr<dynamicdata::Connector> > pinConnects = model->getConnectors();
  map<string, shared_ptr<dynamicdata::UnitDynamicModel> > unitDynamicModels = model->getUnitDynamicModels();
  map<string, shared_ptr<dynamicdata::MacroConnect> > macroConnects = model->getMacroConnects();

  map<string, shared_ptr<SubModel> >::const_iterator subModelIter = subModels_.find(modelId);
  if (subModelIter == subModels_.end()) {
    return;
  }
  shared_ptr<SubModel> subModel = subModelIter->second;

  // Retrieve internal flow connection
  for (map<string, shared_ptr<dynamicdata::Connector> >::const_iterator itPinConnect = pinConnects.begin();
      itPinConnect != pinConnects.end(); ++itPinConnect) {
    shared_ptr<dynamicdata::Connector> pinConnect = itPinConnect->second;

    if (unitDynamicModels.find(pinConnect->getFirstModelId()) != unitDynamicModels.end() &&
        unitDynamicModels.find(pinConnect->getSecondModelId()) != unitDynamicModels.end()) {
      string firstVarName = pinConnect->getFirstModelId()+"_"+pinConnect->getFirstVariableId();
      std::replace(firstVarName.begin(), firstVarName.end(), '.', '_');
      string secondVarName = pinConnect->getSecondModelId()+"_"+pinConnect->getSecondVariableId();
      std::replace(secondVarName.begin(), secondVarName.end(), '.', '_');
      model_->findVariablesConnectedBy(subModel, firstVarName, subModel, secondVarName, variablesConnectedInternally);
    }
  }


  for (map<string, shared_ptr<dynamicdata::MacroConnect> >::const_iterator itMC = macroConnects.begin();
      itMC != macroConnects.end(); ++itMC) {
    string connector = itMC->second->getConnector();
    string model1 = itMC->second->getFirstModelId();
    string model2 = itMC->second->getSecondModelId();

    shared_ptr<dynamicdata::MacroConnector> macroConnector = dyd_->getDynamicModelsCollection()->findMacroConnector(connector);
    // for each connect, create a system connect
    map<string, shared_ptr<dynamicdata::MacroConnection> > connectors = macroConnector->getConnectors();
    for (map<string, shared_ptr<dynamicdata::MacroConnection> >::const_iterator iter = connectors.begin();
        iter != connectors.end(); ++iter) {
      string var1 = iter->second->getFirstVariableId();
      string var2 = iter->second->getSecondVariableId();
      replaceMacroInVariableId(itMC->second->getIndex1(), itMC->second->getName1(), model1, model2, connector, var1);
      replaceMacroInVariableId(itMC->second->getIndex2(), itMC->second->getName2(), model1, model2, connector, var2);

      string firstVarName = model1+"_"+var1;
      std::replace(firstVarName.begin(), firstVarName.end(), '.', '_');
      string secondVarName = model2+"_"+var2;
      std::replace(secondVarName.begin(), secondVarName.end(), '.', '_');
      model_->findVariablesConnectedBy(subModel, firstVarName, subModel, secondVarName, variablesConnectedInternally);
    }
  }
}
void
Modeler::SanityCheckFlowConnection() const {
  boost::unordered_map<string, unsigned> flowVarId2ConnIndex;
  unsigned connIndex = 0;
  const std::map<string, shared_ptr<ModelDescription> >& modelDescriptions = dyd_->getModelDescriptions();
  for (std::map<string, shared_ptr<ModelDescription> >::const_iterator itModelDescription = modelDescriptions.begin(),
      itModelDescriptionEnd = modelDescriptions.end();
      itModelDescription != itModelDescriptionEnd; ++itModelDescription) {
    if (itModelDescription->second->getModel()->getType() != dynamicdata::Model::MODELICA_MODEL) {
      continue;
    }
    shared_ptr<ModelDescription> modelDesc = itModelDescription->second;
    string modelId = modelDesc->getID();
    shared_ptr<dynamicdata::ModelicaModel> model = dynamic_pointer_cast<dynamicdata::ModelicaModel> (modelDesc->getModel());

    map<string, shared_ptr<SubModel> >::const_iterator subModelIter = subModels_.find(modelId);
    if (subModelIter == subModels_.end()) {
      continue;
    }
    shared_ptr<SubModel> subModel = subModelIter->second;

    // Find all flow variables connected internally to this model
    vector<std::pair<string, string> > variablesConnectedInternally;
    collectAllInternalConnections(model, variablesConnectedInternally);


    // Assign an unique id for all flow connections
    for (size_t i = 0, iEnd = variablesConnectedInternally.size(); i < iEnd; ++i) {
      boost::shared_ptr <Variable> var = subModel->getVariable(variablesConnectedInternally[i].first);
      if (var->getType() == FLOW) {
        string firstVar = modelId+"_"+variablesConnectedInternally[i].first;
        string secondVar = modelId+"_"+variablesConnectedInternally[i].second;
        bool found = false;
        if (flowVarId2ConnIndex.find(firstVar) != flowVarId2ConnIndex.end()) {
          unsigned existingIndex = flowVarId2ConnIndex[firstVar];
          flowVarId2ConnIndex[secondVar] = existingIndex;
          found = true;
        } else if (flowVarId2ConnIndex.find(secondVar) != flowVarId2ConnIndex.end()) {
          unsigned existingIndex = flowVarId2ConnIndex[secondVar];
          flowVarId2ConnIndex[firstVar] = existingIndex;
          found = true;
        }
        if (!found) {
          flowVarId2ConnIndex[firstVar] = connIndex;
          flowVarId2ConnIndex[secondVar] = connIndex;
          ++connIndex;
        }
      }
    }
  }

  // Now compare to external flow connections
  const std::map<string, shared_ptr<ConnectInterface> >& connects = dyd_->getConnectInterfaces();
  for (std::map<string, shared_ptr<ConnectInterface> >::const_iterator itConnector = connects.begin();
      itConnector != connects.end(); ++itConnector) {
    string id1 = (itConnector->second)->getConnectedModel1();
    string id2 = (itConnector->second)->getConnectedModel2();
    string var1 = (itConnector->second)->getModel1Var();
    string var2 = (itConnector->second)->getModel2Var();

    map<string, shared_ptr<SubModel> >::const_iterator iter1;
    map<string, shared_ptr<SubModel> >::const_iterator iter2;
    iter1 = subModels_.find(id1);
    iter2 = subModels_.find(id2);
    if (iter1 == subModels_.end() || iter2 == subModels_.end()) {
      continue;
    }
    replaceStaticAndNodeMacroInVariableName(iter1->second, var1, iter2->second, var2);

    vector<std::pair<string, string> > connectedVars;
    model_->findVariablesConnectedBy(iter1->second, var1, iter2->second, var2, connectedVars);
    for (size_t i = 0, iEnd = connectedVars.size(); i < iEnd; ++i) {
      string firstVar = iter1->first+"_"+connectedVars[i].first;
      string secondVar = iter2->first+"_"+connectedVars[i].second;
      if (flowVarId2ConnIndex.find(firstVar) != flowVarId2ConnIndex.end()) {
        throw DYNError(Error::MODELER, FlowConnectionMixedSystemAndInternal, id1, connectedVars[i].first,
            id2, connectedVars[i].second);
      }
      if (flowVarId2ConnIndex.find(secondVar) != flowVarId2ConnIndex.end()) {
        throw DYNError(Error::MODELER, FlowConnectionMixedSystemAndInternal, id1, connectedVars[i].first,
            id2, connectedVars[i].second);
      }
    }
  }
}

}  // namespace DYN
