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
 * @file DYNDynamicData.cpp
 * @brief Dynawo dynamic data structure implementation file
 */

#include <sstream>
#include <iomanip>
#include <memory>

// files in API parameter
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"
#include "PARParametersSetCollection.h"
#include "PARReference.h"
#include "PARReferenceFactory.h"
#include "PARXmlImporter.h"

#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNErrorQueue.h"
#include "DYNFileSystemUtils.h"
#include "DYNModelDescription.h"
#include "DYNDynamicData.h"
#include "DYNDataInterface.h"
#include "DYNCommonModeler.h"

// files in API_DYD
#include "DYDDynamicModelsCollection.h"
#include "DYDXmlImporter.h"
#include "DYDXmlExporter.h"
#include "DYDModel.h"


#include "DYDModel.h"
#include "DYDUnitDynamicModel.h"
#include "DYDModelicaModel.h"
#include "DYDModelTemplate.h"
#include "DYDModelTemplateExpansion.h"
#include "DYDConnector.h"
#include "DYDMacroConnection.h"
#include "DYDMacroConnect.h"
#include "DYDMacroConnector.h"

using std::vector;
using std::string;
using std::setw;
using boost::shared_ptr;

using parameters::ParametersSet;
using parameters::ParametersSetFactory;
using parameters::Parameter;
using parameters::ParametersSetCollection;
using parameters::Reference;
using parameters::ReferenceFactory;
using parameters::XmlImporter;

using dynamicdata::Model;
using dynamicdata::UnitDynamicModel;
using dynamicdata::ModelicaModel;
using dynamicdata::BlackBoxModel;
using dynamicdata::ModelTemplate;
using dynamicdata::ModelTemplateExpansion;
using dynamicdata::Connector;

namespace DYN {

void
DynamicData::initFromDydFiles(const std::vector <string>& fileNames) {
  const dynamicdata::XmlImporter importer;

  setDynamicModelsCollection(importer.importFromDydFiles(fileNames));
}

void
DynamicData::setDynamicModelsCollection(const boost::shared_ptr<dynamicdata::DynamicModelsCollection>& dynamicModelsCollection) {
  dynamicModelsCollection_ = dynamicModelsCollection;

  createModelDescriptions();

  analyzeDynamicData();

  associateParameters();
}

void
DynamicData::analyzeDynamicData() {
  markModelTemplatesCalledByExpansions();  // get model template list to be compiled, by analyzing templateId in model template expansions
  mappingModelicaModels();  // map modelica models with their reference models
}

void
DynamicData::markModelTemplatesCalledByExpansions() {
  usefulModelTemplates_.clear();
  // get model template list to be compiled, by analyzing templateId in model template expansions
  // update usefulModelTemplates_
  for (const auto& modelTemplateExpansionPair : modelTemplateExpansions_) {
    const std::shared_ptr<ModelTemplateExpansion> mte = std::dynamic_pointer_cast<ModelTemplateExpansion> (modelTemplateExpansionPair.second->getModel());
    const string& templateId = mte->getTemplateId();
    if (modelTemplates_.find(templateId) != modelTemplates_.end()) {
      usefulModelTemplates_[templateId] = modelTemplates_[templateId];
    }
  }

#ifdef _DEBUG_
  Trace::info(Trace::compile()) << "Model Templates : " << Trace::endline;
  for (const auto& modelTemplatePair : modelTemplates_) {
    string modelUsed = usefulModelTemplates_.find(modelTemplatePair.first) != usefulModelTemplates_.end() ? "useful and compiled" : "useless";
    Trace::info(Trace::compile()) << " - " << modelTemplatePair.first << " -> " << modelUsed << Trace::endline;
  }
#endif
}

void
DynamicData::mappingModelicaModels() {
  mappedModelDescriptions_.clear();
  referenceModelicaModels_.clear();
  modelicaModelReferenceMap_.clear();
  unitDynamicModelsMap_.clear();

  for (const auto& modelicaModelPair : modelicaModels_) {
    // for each modelica model, either mark it as a reference model, or refer it to a reference model
    const auto& modelicaModelDescription = modelicaModelPair.second;

    const string id = "Mapping Modelica Model " + modelicaModelPair.first;
    const int l = static_cast<int>(id.size() / 2);
    Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;
    Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
    Trace::info(Trace::compile()) << "¦" << setw(50 + l) << id << setw(50 - l - 1) << "¦" << Trace::endline;
    Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
    Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;

    // search in mapped model library, if already mapped, return.
    const auto& it = find(mappedModelDescriptions_.begin(), mappedModelDescriptions_.end(), modelicaModelDescription);
    if (it != mappedModelDescriptions_.end()) {
      Trace::info(Trace::compile()) << DYNLog(AlreadyMappedModel, modelicaModelPair.first) << Trace::endline;
      continue;
    }

    modelicaModelDescription->hasCompiledModel(true);

    bool alreadyMapped = false;

    const std::shared_ptr<ModelicaModel>& modelicaModel = std::dynamic_pointer_cast<ModelicaModel> (modelicaModelDescription->getModel());

    // Searching if a compiled model with the same structure exists in the reference models
    for (const auto& referenceModelicaModel : referenceModelicaModels_) {
      std::shared_ptr<ModelicaModel> tmpModelicaModel = std::dynamic_pointer_cast<ModelicaModel> (referenceModelicaModel->getModel());
      // Local unit dynamic models reference map completed in hasSameStructureAs() method
      std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;

      if (modelicaModel->hasSameStructureAs(tmpModelicaModel, unitDynamicModelsMap_)) {  // modelica model finds a reference model, map them.
        Trace::info(Trace::compile()) << DYNLog(AddingModelToMap, modelicaModel->getId(), tmpModelicaModel->getId()) << Trace::endline;

        modelicaModelReferenceMap_[modelicaModelDescription] = referenceModelicaModel;

        Trace::info(Trace::compile()) << DYNLog(CompiledModelID, referenceModelicaModel->getCompiledModelId()) << Trace::endline;
        alreadyMapped = true;
        break;
      }
    }


    if (!alreadyMapped) {
      // not find a reference model. add the modelica model to the reference model lib and refer it to it self
      modelicaModelReferenceMap_[modelicaModelDescription] = modelicaModelDescription;
      referenceModelicaModels_.push_back(modelicaModelDescription);  // mark the modelica model as a reference model, add it to the reference model lib
      const std::map<string, std::shared_ptr<UnitDynamicModel> >& unitDynamicModels = modelicaModel->getUnitDynamicModels();

      std::map<string, std::shared_ptr<UnitDynamicModel> >::const_iterator itUdm;
      for (itUdm = unitDynamicModels.begin(); itUdm != unitDynamicModels.end(); ++itUdm) {
        unitDynamicModelsMap_[itUdm->second] = itUdm->second;
      }
      Trace::info(Trace::compile()) << DYNLog(ReferenceModelDesc, modelicaModelPair.first) << Trace::endline;
      Trace::info(Trace::compile()) << DYNLog(CompiledModelID, modelicaModelPair.first) << Trace::endline;
      modelicaModelDescription->setCompiledModelId(modelicaModelPair.first);
    }

    mappedModelDescriptions_.push_back(modelicaModelDescription);  // mark the modelica model as mapped
  }
}

void
DynamicData::associateParameters() {
  for (const auto& modelDescriptionPair : modelDescriptions_) {
    const auto& modelDescription = modelDescriptionPair.second;
    std::shared_ptr<dynamicdata::Model> model = modelDescription->getModel();

    // add parameters to modelDescription
    switch (model->getType()) {
        // model templates do not require parameters (only expansions do)
      case Model::MODEL_TEMPLATE:
        break;

        // for Modelica models, add a unit dynamic model (the reference udm) prefix to parameter names
      case Model::MODELICA_MODEL: {
        auto modelSet = std::make_shared<ParametersSet>(model->getId());
        const std::shared_ptr<ModelicaModel> modelicaModel = std::dynamic_pointer_cast<ModelicaModel>(model);
        const std::map<string, std::shared_ptr<UnitDynamicModel> >& models = modelicaModel->getUnitDynamicModels();

        for (const auto& unitDynamicModelPair : models) {
          const auto& unitDynamicModel = unitDynamicModelPair.second;
          std::shared_ptr<ParametersSet> udmSet = getParametersSet(model->getId(), unitDynamicModel->getParFile(), unitDynamicModel->getParId());
          resolveParReferences(model, udmSet);
          if (unitDynamicModelsMap_.find(unitDynamicModel) == unitDynamicModelsMap_.end())
            throw DYNError(Error::MODELER, UDMUndefined, unitDynamicModelPair.first, model->getId());

          const std::shared_ptr<UnitDynamicModel> udmRef = unitDynamicModelsMap_[unitDynamicModel];
          const string& udmId = udmRef->getId();

          if (udmSet)
            mergeParameters(modelSet, udmId, udmSet);  // create parameters with their new prefixed names in the ParametersSet ModelSet
        }
        modelDescription->setParametersSet(modelSet);
        break;
      }
      case Model::BLACK_BOX_MODEL: {
        std::shared_ptr<BlackBoxModel> bbm = std::dynamic_pointer_cast<BlackBoxModel>(model);
        std::shared_ptr<ParametersSet> modelSet = getParametersSet(bbm->getId(), bbm->getParFile(), bbm->getParId());
        resolveParReferences(bbm, modelSet);
        modelDescription->setParametersSet(modelSet);
        break;
      }
      case Model::MODEL_TEMPLATE_EXPANSION: {
        std::shared_ptr<ModelTemplateExpansion> modelTemplateExp = std::dynamic_pointer_cast<ModelTemplateExpansion>(model);
        std::shared_ptr<ParametersSet> modelSet = getParametersSet(modelTemplateExp->getId(), modelTemplateExp->getParFile(), modelTemplateExp->getParId());
        resolveParReferences(modelTemplateExp, modelSet);
        modelDescription->setParametersSet(modelSet);
        break;
      }
    }
  }
  DYNErrorQueue::instance().flush();
}

std::shared_ptr<ParametersSet>
DynamicData::getParametersSet(const string& modelId, const string& parFile, const string& parId) {
  if (parFile.empty() && parId.empty()) {
    return std::shared_ptr<ParametersSet>();
  }
  if (!parFile.empty() && parId.empty()) {
    DYNErrorQueue::instance().push(DYNError(Error::API, MissingParameterId, modelId));
    return std::shared_ptr<ParametersSet>();
  }
  if (parFile.empty() && !parId.empty()) {
    DYNErrorQueue::instance().push(DYNError(Error::API, MissingParameterFile, modelId));
    return std::shared_ptr<ParametersSet>();
  }

  const std::string canonicalParFilePath = canonical(parFile, rootDirectory_);
  if (referenceParameters_.find(canonicalParFilePath) != referenceParameters_.end())
    return referenceParameters_[canonicalParFilePath]->getParametersSet(parId);

  // Parameters file not already loaded
  const parameters::XmlImporter parametersImporter;
  const std::shared_ptr<ParametersSetCollection> parametersSetCollection = parametersImporter.importFromFile(canonicalParFilePath);
  parametersSetCollection->propagateOriginData(canonicalParFilePath);
  referenceParameters_[canonicalParFilePath] = parametersSetCollection;
  parametersSetCollection->getParametersFromMacroParameter();
  return parametersSetCollection->getParametersSet(parId);
}

void
DynamicData::resolveParReferences(const std::shared_ptr<Model>& model, const std::shared_ptr<ParametersSet>& modelSet) {
  if (modelSet == nullptr)
    return;
  const std::unordered_map<std::string, std::shared_ptr<Reference> >& references = modelSet->getReferences();
  for (const auto& ref : references) {
    const std::shared_ptr<Reference>& parRef = ref.second;
    if (parRef->getOrigData() == Reference::OriginData::PAR) {
      if (parRef->getParFile().empty()) {
        if (parRef->getParId().empty()) {
          parRef->setParId(modelSet->getId());
        }
        parRef->setParFile(modelSet->getFilePath());
      }
      const std::shared_ptr<ParametersSet> referencedParametersSet = getParametersSet(model->getId(), parRef->getParFile(), parRef->getParId());
      const auto& refParamSetReferences = referencedParametersSet->getReferences();
      const auto& itRef = refParamSetReferences.find(parRef->getOrigName());
      if (itRef != references.end())
        throw DYNError(DYN::Error::API, ReferenceToAnotherReference, parRef->getName(), parRef->getOrigName(), parRef->getParId(), parRef->getParFile());
      const std::shared_ptr<Parameter>& referencedParameter = referencedParametersSet->getParameter(parRef->getOrigName());
      if (parRef->getType() == "DOUBLE") {
        modelSet->createParameter(parRef->getName(), referencedParameter->getDouble());
      } else if (parRef->getType() == "INT") {
        modelSet->createParameter(parRef->getName(), referencedParameter->getInt());
      } else if (parRef->getType() == "BOOL") {
        modelSet->createParameter(parRef->getName(), referencedParameter->getBool());
      } else {
        throw DYNError(Error::MODELER, ParameterWrongTypeReference, parRef->getName());
      }
    }
  }
}

void
DynamicData::createModelDescriptions() {
  modelicaModels_.clear();
  blackBoxModels_.clear();
  modelTemplateExpansions_.clear();
  modelTemplates_.clear();

  for (const auto& dynamicModelPair : dynamicModelsCollection_->getModels()) {
    const auto& dynamicModel = dynamicModelPair.second;
    std::shared_ptr<ModelDescription> model = std::make_shared<ModelDescription>(dynamicModel);
    string staticId = "";

    // init value will be replaced after
    std::map<std::string, std::shared_ptr<DYN::ModelDescription> >* mappedModel = nullptr;

    switch (dynamicModel->getType()) {
      case Model::MODELICA_MODEL: {
        std::shared_ptr<ModelicaModel> modelicaModel = std::dynamic_pointer_cast<ModelicaModel>(dynamicModel);
        staticId = modelicaModel->getStaticId();
        mappedModel = &modelicaModels_;
        break;
      }
      case Model::MODEL_TEMPLATE:
        mappedModel = &modelTemplates_;
        break;
      case Model::BLACK_BOX_MODEL: {
        const std::shared_ptr<BlackBoxModel> bbm = std::dynamic_pointer_cast<BlackBoxModel>(dynamicModel);
        staticId = bbm->getStaticId();
        mappedModel = &blackBoxModels_;
        break;
      }
      case Model::MODEL_TEMPLATE_EXPANSION: {
        const std::shared_ptr<ModelTemplateExpansion> modelTemplateExp = std::dynamic_pointer_cast<ModelTemplateExpansion>(dynamicModel);
        staticId = modelTemplateExp->getStaticId();
        mappedModel = &modelTemplateExpansions_;
        break;
      }
    }
    model->setStaticId(staticId);
    if (!staticId.empty() && dataInterface_) {
      dataInterface_->hasDynamicModel(staticId);
    }
    std::pair<std::string, std::shared_ptr<DYN::ModelDescription> > item = std::make_pair(model->getID(), model);
    modelDescriptions_.insert(item);

    if (mappedModel != nullptr) {
      mappedModel->insert(item);
    }
  }

  // One by one copy due to the iterators design (no other possibility)
  for (const auto& connector : dynamicModelsCollection_->getConnectors()) {
    systemConnects_.push_back(connector);
  }

  static const string indexLabel = "@INDEX@";
  static const string nameLabel = "@NAME@";
  // expand macro connects as connector
  // for internal model macro connects, it's made before the compilation
  for (const auto& macroConnect : dynamicModelsCollection_->getMacroConnects()) {
    const string& connector = macroConnect->getConnector();
    const string& model1 = macroConnect->getFirstModelId();
    const string& model2 = macroConnect->getSecondModelId();

    const std::shared_ptr<dynamicdata::MacroConnector> macroConnector = dynamicModelsCollection_->findMacroConnector(connector);

    // check if macroConnector has no init connect
    const std::map<string, std::unique_ptr<dynamicdata::MacroConnection> >& initConnector = macroConnector->getInitConnectors();
    if (!initConnector.empty())
      throw DYNError(DYN::Error::MODELER, SystemInitConnectorForbidden, connector);

    // for each connect, create a system connect
    for (const auto& connectorPair : macroConnector->getConnectors()) {
      string var1 = connectorPair.second->getFirstVariableId();
      string var2 = connectorPair.second->getSecondVariableId();
      replaceMacroInVariableId(macroConnect->getIndex1(), macroConnect->getName1(), model1, model2, connector, var1);
      replaceMacroInVariableId(macroConnect->getIndex2(), macroConnect->getName2(), model1, model2, connector, var2);

      systemConnects_.push_back(std::make_shared<dynamicdata::Connector>(model1, var1, model2, var2));
    }
  }
}

void
DynamicData::mergeParameters(const std::shared_ptr<ParametersSet>& concatParams, const string& udmName, const std::shared_ptr<ParametersSet>& udmSet) {
  // for parameters in parameterSet
  for (const auto& name : udmSet->getParametersNames()) {
    const string parameterName = udmName + "_" + name;
    const std::shared_ptr<Parameter> par = udmSet->getParameter(name);

    switch (par->getType()) {
      case Parameter::BOOL: {
        concatParams->createParameter(parameterName, par->getBool());
        break;
      }
      case Parameter::INT: {
        concatParams->createParameter(parameterName, par->getInt());
        break;
      }
      case Parameter::DOUBLE: {
        concatParams->createParameter(parameterName, par->getDouble());
        break;
      }
      case Parameter::STRING: {
        concatParams->createParameter(parameterName, par->getString());
        break;
      }
      case Parameter::SIZE_OF_ENUM:
        throw DYNError(Error::MODELER, ParameterUnknownType, udmName, name);
    }
  }
  // for references in parameterSet
  for (const auto& refName : udmSet->getReferencesNames()) {
    const std::shared_ptr<Reference> ref = udmSet->getReference(refName);
    const string referenceName = udmName + "_" + refName;
    const std::shared_ptr<Reference> reference = ReferenceFactory::newReference(referenceName, ref->getOrigData());
    reference->setType(ref->getType());
    reference->setOrigName(ref->getOrigName());
    reference->setComponentId(ref->getComponentId());
    concatParams->addReference(std::move(reference));
  }
}

void
DynamicData::getNetworkParameters(const string& parFile, const string& parSet) {
  const std::shared_ptr<ParametersSet> parameters = getParametersSet("network", parFile, parSet);
  DYNErrorQueue::instance().flush();
  setNetworkParameters(parameters);
}

void
DynamicData::addConnectInterface(std::unique_ptr<ConnectInterface> connect) {
  const string id1 = connect->getConnectedModel1();
  const string id2 = connect->getConnectedModel2();
  const string var1 = connect->getModel1Var();
  const string var2 = connect->getModel2Var();

  // connector sorted thanks to the id of each models/variables, whatever is the order of declaration in inputs file
  const string first_pin = id1 + "_" + var1;
  const string second_pin = id2 + "_" + var2;
  string connectId = first_pin + "_" + second_pin;
  if (first_pin > second_pin)
    connectId = second_pin + "_" + first_pin;

  connects_[connectId] = std::move(connect);
}

}  // namespace DYN
