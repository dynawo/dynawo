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
using boost::make_shared;
using boost::dynamic_pointer_cast;

using parameters::ParametersSet;
using parameters::Reference;

namespace DYN {

void
Modeler::initSystem() {
  model_ = std::make_shared<ModelMulti>();

  if (data_ && data_->instantiateNetwork())
    initNetwork();

  initModelDescription();
  initConnects();
  sanityCheckFlowConnection();

  if (actionBuffer_)
    model_->setActionBuffer(actionBuffer_);
}

void
Modeler::initNetwork() {
  // network model from an IIDM situation
  // --------------------------------------------
  const string DDBDir = getMandatoryEnvVar("DYNAWO_DDB_DIR");

  modelNetwork_ = SubModelFactory::createSubModelFromLib(DDBDir + "/DYNModelNetwork" + sharedLibraryExtension());
  modelNetwork_->initFromData(data_);
  data_->setModelNetwork(modelNetwork_);
  modelNetwork_->name("NETWORK");
  const std::shared_ptr<ParametersSet>& networkParams = dyd_->getNetworkParameters();
  modelNetwork_->setPARParameters(networkParams);

  model_->addSubModel(modelNetwork_, "DYNModelNetwork" + string(sharedLibraryExtension()));
  subModels_["NETWORK"] = modelNetwork_;
}

void
Modeler::initModelDescription() {
  for (const auto& modelDescriptionPair : dyd_->getModelDescriptions()) {
    const auto& modelDescription = modelDescriptionPair.second;
    if (modelDescription->getModel()->getType() == dynamicdata::Model::MODEL_TEMPLATE) {
      continue;
    }

    if (modelDescription->hasCompiledModel()) {
      shared_ptr<SubModel> model;
      model = SubModelFactory::createSubModelFromLib(modelDescription->getLib());
      model->name(modelDescription->getID());
      model->staticId(modelDescription->getStaticId());
      std::shared_ptr<ParametersSet> params = modelDescription->getParametersSet();
      initParamDescription(modelDescription);

      model->setPARParameters(params);
      model->initFromData(data_);
      // add the submodel
      model_->addSubModel(model, modelDescription->getLib());
      subModels_[modelDescription->getID()] = model;
      modelDescription->setSubModel(model);
      // reference static
      if (!modelDescription->getStaticId().empty()) {
        data_->setDynamicModel(modelDescription->getStaticId(), model);
        initStaticRefs(model, modelDescription);
        if (modelNetwork_ != nullptr)
          modelNetwork_->mapToNetworkBridge(model);
      }
    } else {
      throw DYNError(Error::MODELER, CompileModel, modelDescription->getID());
    }
  }
}

void
Modeler::initParamDescription(const std::shared_ptr<ModelDescription>& modelDescription) const {
  const std::shared_ptr<ParametersSet>& params = modelDescription->getParametersSet();

  // params can be a nullptr if no parFile was given for the model
  if (params) {
    // if there are references in external parameters, retrieve the parameters' value from IIDM
    for (const auto& referenceName : params->getReferencesNames()) {
      string refType = params->getReference(referenceName)->getType();
      const Reference::OriginData refOrigData = params->getReference(referenceName)->getOrigData();
      const string& refOrigName = params->getReference(referenceName)->getOrigName();
      string staticID = modelDescription->getStaticId();
      const string& componentID = params->getReference(referenceName)->getComponentId();
      // if data_ origin is IIDM file, retrieve the value and add a parameter in the parameter set.
      if (!componentID.empty())
        staticID = componentID;  // when componentID exist, this id should be used to find the parameter value
      if (refOrigData == Reference::IIDM) {
        if (staticID.empty())
          throw DYNError(Error::MODELER, ParameterStaticIdNotFound, refOrigName, params->getReference(referenceName)->getName(), modelDescription->getID());
        if (refType == "DOUBLE") {
          const double value = data_->getStaticParameterDoubleValue(staticID, refOrigName);
          params->createParameter(referenceName, value);
        } else if (refType == "INT") {
          const int value = data_->getStaticParameterIntValue(staticID, refOrigName);
          params->createParameter(referenceName, value);
        } else if (refType == "BOOL") {
          const bool value = data_->getStaticParameterBoolValue(staticID, refOrigName);
          params->createParameter(referenceName, value);
        } else {
          throw DYNError(Error::MODELER, ParameterWrongTypeReference, referenceName);
        }
      } else if (refOrigData == Reference::PAR) {
        continue;  // PAR reference already resolved in DynamicData => nothing to do
      } else {
        throw DYNError(Error::MODELER, FunctionNotAvailable);
      }
    }
  }
}

void
Modeler::initStaticRefs(const boost::shared_ptr<SubModel>& model, const std::shared_ptr<ModelDescription>& modelDescription) const {
  for (const auto& staticRefInterface : modelDescription->getStaticRefInterfaces()) {
    const string& modelID = staticRefInterface->getModelID().empty() ? modelDescription->getID() : staticRefInterface->getModelID();
    const string& modelVar = staticRefInterface->getModelVar();
    const string& staticVar = staticRefInterface->getStaticVar();

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
  const string labelVoltageLevel = "@VOLTAGE_LEVEL@";

  // replace @STATIC_ID@ with the static id of the model where the connection should be made
  const bool foundStaticIdInVar1 = var1.find(labelStaticId) != string::npos;
  const bool foundStaticIdInVar2 = var2.find(labelStaticId) != string::npos;
  if (foundStaticIdInVar1)
    var1.replace(var1.find(labelStaticId), labelStaticId.size(), "@" + subModel2->staticId() + "@");
  if (foundStaticIdInVar2)
    var2.replace(var2.find(labelStaticId), labelStaticId.size(), "@" + subModel1->staticId() + "@");

  // replace @VOLTAGE_LEVEL@ with the voltage level id of the connected model
  const bool foundVLInVar1 = var1.find(labelVoltageLevel) != string::npos;
  const bool foundVLInVar2 = var2.find(labelVoltageLevel) != string::npos;
  if (foundVLInVar1) {
    const string vlId = data_->getVoltageLevelId(subModel2->staticId());
    if (vlId.empty())
      throw DYNError(Error::MODELER, MacroNotResolved, var1, "voltage level not found for model " + subModel2->name());
    var1.replace(var1.find(labelVoltageLevel), labelVoltageLevel.size(), "@" + vlId + "@");
  }
  if (foundVLInVar2) {
    const string vlId = data_->getVoltageLevelId(subModel1->staticId());
    if (vlId.empty())
      throw DYNError(Error::MODELER, MacroNotResolved, var2, "voltage level not found for model " + subModel1->name());
    var2.replace(var2.find(labelVoltageLevel), labelVoltageLevel.size(), "@" + vlId + "@");
  }

  // replace @NODE@, @NODE1@, @NODE2@ with the bus id.
  // When a numeric node index @<N>@ follows @NODE@, the new NODE_BREAKER resolution
  // @<vlId>@@@NODE@@<N>@ is used instead of the classic static-id-based lookup.
  replaceNodeWithBus(subModel1, var1, subModel2, var2, labelNode);
  replaceNodeWithBus(subModel1, var1, subModel2, var2, labelNode1);
  replaceNodeWithBus(subModel1, var1, subModel2, var2, labelNode2);
}

void
Modeler::replaceNodeWithBus(const shared_ptr<SubModel>& subModel1, string& var1,
    const shared_ptr<SubModel>& subModel2, string& var2, const string& labelNode) const {
  const bool foundNodeInVar1 = var1.find(labelNode) != string::npos;
  const bool foundNodeInVar2 = var2.find(labelNode) != string::npos;
  if (foundNodeInVar1)
    var1 = findNodeConnectorName(var1, labelNode);
  if (foundNodeInVar2)
    var2 = findNodeConnectorName(var2, labelNode);
  if (var1.find(labelNode) != string::npos || var2.find(labelNode) != string::npos)
    throw DYNError(Error::MODELER, WrongConnectTwoUnknownNodes, subModel1->name(), var1, subModel2->name(), var2);
}

void
Modeler::initConnects() {
  Trace::debug(Trace::modeler()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::modeler()) << DYNLog(DynamicConnectStart) << Trace::endline;
  Trace::debug(Trace::modeler()) << "------------------------------" << Trace::endline;
  for (const auto& connectInterfacePair : dyd_->getConnectInterfaces()) {
    const auto& connectInterface = connectInterfacePair.second;
    string id1 = connectInterface->getConnectedModel1();
    string id2 = connectInterface->getConnectedModel2();
    string var1 = connectInterface->getModel1Var();
    string var2 = connectInterface->getModel2Var();

    const auto& iter1 = subModels_.find(id1);
    const auto& iter2 = subModels_.find(id2);
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
  // Handles two patterns (both use two @ at each seam, following the DYD convention):
  //   @<staticId>@@NODE@_var          → existing: bus looked up from component static id
  //   @<vlId>@@NODE@@<N>@_var         → new NODE_BREAKER: bus looked up from voltage level + node index
  // The patterns are distinguished by checking whether a decimal @<N>@ immediately follows @NODE@.
  string tmpId = id;
  const size_t pos = id.find(labelNode);
  if (pos == string::npos)
    return tmpId;

  // id.substr(1, pos-2) extracts the identifier between the outer @ delimiters.
  // With two @ at the seam (@<id>@@NODE@), pos-2 gives exactly the id without surrounding @.
  const string idPart = id.substr(1, pos - 2);

  // Check for NODE_BREAKER macro: @<vlId>@@NODE@@<index>@ where index is a decimal integer
  const size_t afterNode = pos + labelNode.size();
  if (afterNode < id.size() && id[afterNode] == '@') {
    const size_t startContent = afterNode + 1;
    const size_t endContent = id.find('@', startContent);
    if (endContent != string::npos) {
      const string nodeContent = id.substr(startContent, endContent - startContent);
      int nodeIndex = 0;
      try {
        nodeIndex = std::stoi(nodeContent);
      } catch (const std::exception&) {
        throw DYNError(Error::MODELER, MacroNotResolved, id,
            "node index '" + nodeContent + "' is not a valid integer in " + labelNode);
      }
      const string labelNodeIndex = "@" + nodeContent + "@";
      const string busName = data_->getBusNameFromNode(idPart, nodeIndex);
      if (busName.empty()) {
        throw DYNError(Error::MODELER, MacroNotResolved, id,
            "bus not found for voltage level '" + idPart + "' at node " + nodeContent);
      }
      tmpId.replace(tmpId.find("@" + idPart + "@"), idPart.size() + 2, "");
      tmpId.replace(tmpId.find(labelNode + labelNodeIndex), labelNode.size() + labelNodeIndex.size(), busName);
      return tmpId;
    }
  }

  // @<staticId>@@NODE@
  const string busName = data_->getBusName(idPart, labelNode);
  if (busName.empty()) {
    throw DYNError(Error::MODELER, MacroNotResolved, id, "bus not found");
  }
  tmpId.replace(tmpId.find("@" + idPart + "@"), idPart.size() + 2, "");
  tmpId.replace(tmpId.find(labelNode), labelNode.size(), busName);
  return tmpId;
}

void
Modeler::collectAllInternalConnections(const std::shared_ptr<dynamicdata::ModelicaModel>& model,
    vector<std::pair<string, string> >& variablesConnectedInternally) const {

  const string& modelId = model->getId();
  map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> > unitDynamicModels = model->getUnitDynamicModels();

  const auto& subModelIter = subModels_.find(modelId);
  if (subModelIter == subModels_.end()) {
    return;
  }
  const shared_ptr<SubModel>& subModel = subModelIter->second;

  // Retrieve internal flow connection
  for (const auto& pinConnectPair : model->getConnectors()) {
    const std::shared_ptr<dynamicdata::Connector>& pinConnect = pinConnectPair.second;
    const auto& firstModelId = pinConnect->getFirstModelId();
    const auto& secondModelId = pinConnect->getSecondModelId();
    const auto& firstVariableId = pinConnect->getFirstVariableId();
    const auto& secondVariableId = pinConnect->getSecondVariableId();

    if (unitDynamicModels.find(firstModelId) != unitDynamicModels.end() && unitDynamicModels.find(secondModelId) != unitDynamicModels.end()) {
      string firstVarName = firstModelId + "_" + firstVariableId;
      std::replace(firstVarName.begin(), firstVarName.end(), '.', '_');
      string secondVarName = secondModelId + "_" + secondVariableId;
      std::replace(secondVarName.begin(), secondVarName.end(), '.', '_');
      model_->findVariablesConnectedBy(subModel, firstVarName, subModel, secondVarName, variablesConnectedInternally);
    }
  }

  for (const auto& macroConnectPair : model->getMacroConnects()) {
    const auto& macroConnect = macroConnectPair.second;
    const string& connector = macroConnect->getConnector();
    const string& model1 = macroConnect->getFirstModelId();
    const string& model2 = macroConnect->getSecondModelId();

    const std::shared_ptr<dynamicdata::MacroConnector>& macroConnector = dyd_->getDynamicModelsCollection()->findMacroConnector(connector);
    // for each connect, create a system connect
    for (const auto& macroConnectorPair : macroConnector->getConnectors()) {
      const auto& macroConnection = macroConnectorPair.second;
      string var1 = macroConnection->getFirstVariableId();
      string var2 = macroConnection->getSecondVariableId();
      replaceMacroInVariableId(macroConnect->getIndex1(), macroConnect->getName1(), model1, model2, connector, var1);
      replaceMacroInVariableId(macroConnect->getIndex2(), macroConnect->getName2(), model1, model2, connector, var2);

      string firstVarName = model1 + "_" + var1;
      std::replace(firstVarName.begin(), firstVarName.end(), '.', '_');
      string secondVarName = model2 + "_" + var2;
      std::replace(secondVarName.begin(), secondVarName.end(), '.', '_');
      model_->findVariablesConnectedBy(subModel, firstVarName, subModel, secondVarName, variablesConnectedInternally);
    }
  }
}
void
Modeler::sanityCheckFlowConnection() const {
  std::unordered_map<string, unsigned> flowVarId2ConnIndex;
  unsigned connIndex = 0;
  for (const auto& modelDescription : dyd_->getModelDescriptions()) {
    if (modelDescription.second->getModel()->getType() != dynamicdata::Model::MODELICA_MODEL) {
      continue;
    }
    const std::shared_ptr<ModelDescription>& modelDesc = modelDescription.second;
    const string& modelId = modelDesc->getID();
    std::shared_ptr<dynamicdata::ModelicaModel> model = std::dynamic_pointer_cast<dynamicdata::ModelicaModel>(modelDesc->getModel());

    const auto& subModelIter = subModels_.find(modelId);
    if (subModelIter == subModels_.end()) {
      continue;
    }
    const shared_ptr<SubModel>& subModel = subModelIter->second;

    // Find all flow variables connected internally to this model
    vector<std::pair<string, string> > variablesConnectedInternally;
    collectAllInternalConnections(model, variablesConnectedInternally);


    // Assign an unique id for all flow connections
    for (const auto& variableConnectedInternally : variablesConnectedInternally) {
      const boost::shared_ptr<Variable>& var = subModel->getVariable(variableConnectedInternally.first);
      if (var->getType() == FLOW) {
        string firstVar = modelId + "_" + variableConnectedInternally.first;
        string secondVar = modelId + "_" + variableConnectedInternally.second;
        bool found = false;
        if (flowVarId2ConnIndex.find(firstVar) != flowVarId2ConnIndex.end()) {
          const unsigned existingIndex = flowVarId2ConnIndex[firstVar];
          flowVarId2ConnIndex[secondVar] = existingIndex;
          found = true;
        } else if (flowVarId2ConnIndex.find(secondVar) != flowVarId2ConnIndex.end()) {
          const unsigned existingIndex = flowVarId2ConnIndex[secondVar];
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
  for (const auto& connectInterfacePair : dyd_->getConnectInterfaces()) {
    const auto& connectInterface = connectInterfacePair.second;
    const string& id1 = connectInterface->getConnectedModel1();
    const string& id2 = connectInterface->getConnectedModel2();
    string var1 = connectInterface->getModel1Var();
    string var2 = connectInterface->getModel2Var();

    const auto& iter1 = subModels_.find(id1);
    const auto& iter2 = subModels_.find(id2);
    if (iter1 == subModels_.end() || iter2 == subModels_.end()) {
      continue;
    }
    replaceStaticAndNodeMacroInVariableName(iter1->second, var1, iter2->second, var2);

    vector<std::pair<string, string> > connectedVars;
    model_->findVariablesConnectedBy(iter1->second, var1, iter2->second, var2, connectedVars);
    for (const auto& connectedVar : connectedVars) {
      string firstVar = iter1->first + "_" + connectedVar.first;
      string secondVar = iter2->first + "_" + connectedVar.second;
      if (flowVarId2ConnIndex.find(firstVar) != flowVarId2ConnIndex.end()) {
        throw DYNError(Error::MODELER, FlowConnectionMixedSystemAndInternal, id1, connectedVar.first,
            id2, connectedVar.second);
      }
      if (flowVarId2ConnIndex.find(secondVar) != flowVarId2ConnIndex.end()) {
        throw DYNError(Error::MODELER, FlowConnectionMixedSystemAndInternal, id1, connectedVar.first,
            id2, connectedVar.second);
      }
    }
  }
}

}  // namespace DYN
