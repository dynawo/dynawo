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
#include "DYDIterators.h"
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
  dynamicdata::XmlImporter importer;

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
  for (std::map<string, std::shared_ptr<ModelDescription> >::const_iterator itMde = modelTemplateExpansions_.begin();
        itMde != modelTemplateExpansions_.end(); ++itMde) {
    std::shared_ptr<ModelTemplateExpansion> mte = std::dynamic_pointer_cast<ModelTemplateExpansion>(itMde->second->getModel());
    string templateId = mte->getTemplateId();
    if (modelTemplates_.find(templateId) != modelTemplates_.end()) {
      usefulModelTemplates_[templateId] = modelTemplates_[templateId];
    }
  }

#ifdef _DEBUG_
  Trace::info(Trace::compile()) << "Model Templates : " << Trace::endline;
  for (std::map<string, std::shared_ptr<ModelDescription> >::const_iterator itMd = modelTemplates_.begin(); itMd != modelTemplates_.end(); ++itMd) {
    string modelUsed = usefulModelTemplates_.find(itMd->first) != usefulModelTemplates_.end() ? "useful and compiled" : "useless";
    Trace::info(Trace::compile()) << " - " << itMd->first << " -> " << modelUsed << Trace::endline;
  }
#endif
}

void
DynamicData::mappingModelicaModels() {
  mappedModelDescriptions_.clear();
  referenceModelicaModels_.clear();
  modelicaModelReferenceMap_.clear();
  unitDynamicModelsMap_.clear();

  for (std::map<string, std::shared_ptr<ModelDescription> >::const_iterator itModelica = modelicaModels_.begin();
        itModelica != modelicaModels_.end(); ++itModelica) {
    // for each modelica model, either mark it as a reference model, or refer it to a reference model

    const string id = "Mapping Modelica Model " + itModelica->first;
    int l = static_cast<int>(id.size() / 2);
    Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;
    Trace::info(Trace::compile()) << "|                                                                                                  |" << Trace::endline;
    Trace::info(Trace::compile()) << "|" << setw(50 + l) << id << setw(50 - l - 1) << "|" << Trace::endline;
    Trace::info(Trace::compile()) << "|                                                                                                  |" << Trace::endline;
    Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;

    // search in mapped model library, if already mapped, return.
    vector<std::shared_ptr<ModelDescription> >::const_iterator it;
    it = find(mappedModelDescriptions_.begin(), mappedModelDescriptions_.end(), itModelica->second);
    if (it != mappedModelDescriptions_.end()) {
      Trace::info(Trace::compile()) << DYNLog(AlreadyMappedModel, itModelica->first) << Trace::endline;
      continue;
    }

    itModelica->second->hasCompiledModel(true);

    bool alreadyMapped = false;

    std::shared_ptr<ModelicaModel> modelicaModel = std::dynamic_pointer_cast<ModelicaModel>(itModelica->second->getModel());

    // Searching if a compiled model with the same structure exists in the reference models
    vector<std::shared_ptr<ModelDescription> >::const_iterator itrefModelDescriptions;
    for (itrefModelDescriptions = referenceModelicaModels_.begin(); itrefModelDescriptions != referenceModelicaModels_.end(); ++itrefModelDescriptions) {
      std::shared_ptr<ModelDescription> tmpModelicaModelDescription = *itrefModelDescriptions;
      std::shared_ptr<ModelicaModel> tmpModelicaModel = std::dynamic_pointer_cast<ModelicaModel>(tmpModelicaModelDescription->getModel());
      // Local unit dynamic models reference map completed in hasSameStructureAs() method
      std::map<shared_ptr<UnitDynamicModel>, shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;

      if (modelicaModel->hasSameStructureAs(tmpModelicaModel, unitDynamicModelsMap_)) {  // modelica model finds a reference model, map them.
        Trace::info(Trace::compile()) << DYNLog(AddingModelToMap, modelicaModel->getId(), tmpModelicaModel->getId()) << Trace::endline;

        modelicaModelReferenceMap_[itModelica->second] = tmpModelicaModelDescription;

        Trace::info(Trace::compile()) << DYNLog(CompiledModelID, tmpModelicaModelDescription->getCompiledModelId()) << Trace::endline;
        alreadyMapped = true;
        break;
      }
    }


    if (!alreadyMapped) {
      // not find a reference model. add the modelica model to the reference model lib and refer it to it self
      modelicaModelReferenceMap_[itModelica->second] = itModelica->second;
      referenceModelicaModels_.push_back(itModelica->second);  // mark the modelica model as a reference model, add it to the reference model lib
      const std::map<string, std::shared_ptr<UnitDynamicModel> >& unitDynamicModels = modelicaModel->getUnitDynamicModels();

      std::map<string, std::shared_ptr<UnitDynamicModel> >::const_iterator itUdm;
      for (itUdm = unitDynamicModels.begin(); itUdm != unitDynamicModels.end(); ++itUdm) {
        unitDynamicModelsMap_[itUdm->second] = itUdm->second;
      }
      Trace::info(Trace::compile()) << DYNLog(ReferenceModelDesc, itModelica->first) << Trace::endline;
      Trace::info(Trace::compile()) << DYNLog(CompiledModelID, itModelica->first) << Trace::endline;
      (itModelica->second)->setCompiledModelId(itModelica->first);
    }

    mappedModelDescriptions_.push_back(itModelica->second);  // mark the modelica model as mapped
  }
}

void
DynamicData::associateParameters() {
  for (std::map<string, std::shared_ptr<ModelDescription> >::const_iterator iter = modelDescriptions_.begin();
        iter != modelDescriptions_.end(); ++iter) {
    std::shared_ptr<dynamicdata::Model> model = iter->second->getModel();

    // add parameters to modelDescription
    switch (model->getType()) {
        // model templates do not require parameters (only expansions do)
      case Model::MODEL_TEMPLATE:
        break;

        // for Modelica models, add a unit dynamic model (the reference udm) prefix to parameter names
      case Model::MODELICA_MODEL: {
        std::shared_ptr<ParametersSet> modelSet = ParametersSetFactory::newParametersSet(model->getId());
        std::shared_ptr<ModelicaModel> modelicaModel = std::dynamic_pointer_cast<ModelicaModel>(model);
        const std::map<string, std::shared_ptr<UnitDynamicModel> >& models = modelicaModel->getUnitDynamicModels();

        std::map<string, std::shared_ptr<UnitDynamicModel> >::const_iterator itUDM = models.begin();
        for (; itUDM != models.end(); ++itUDM) {
          std::shared_ptr<ParametersSet> udmSet = getParametersSet(model->getId(), itUDM->second->getParFile(), itUDM->second->getParId());
          resolveParReferences(model, udmSet);
          if (unitDynamicModelsMap_.find(itUDM->second) == unitDynamicModelsMap_.end())
            throw DYNError(Error::MODELER, UDMUndefined, itUDM->first, model->getId());

          std::shared_ptr<UnitDynamicModel> udmRef = unitDynamicModelsMap_[itUDM->second];
          const string& udmId = udmRef->getId();

          if (udmSet)
            mergeParameters(modelSet, udmId, udmSet);  // create parameters with their new prefixed names in the ParametersSet ModelSet
        }
        (iter->second)->setParametersSet(modelSet);
        break;
      }
      case Model::BLACK_BOX_MODEL: {
        std::shared_ptr<BlackBoxModel> bbm = std::dynamic_pointer_cast<BlackBoxModel>(model);
        std::shared_ptr<ParametersSet> modelSet = getParametersSet(bbm->getId(), bbm->getParFile(), bbm->getParId());
        resolveParReferences(bbm, modelSet);
        (iter->second)->setParametersSet(modelSet);
        break;
      }
      case Model::MODEL_TEMPLATE_EXPANSION: {
        std::shared_ptr<ModelTemplateExpansion> modelTemplateExp = std::dynamic_pointer_cast<ModelTemplateExpansion>(model);
        std::shared_ptr<ParametersSet> modelSet = getParametersSet(modelTemplateExp->getId(), modelTemplateExp->getParFile(), modelTemplateExp->getParId());
        resolveParReferences(modelTemplateExp, modelSet);
        (iter->second)->setParametersSet(modelSet);
        break;
      }
    }
  }
  DYNErrorQueue::instance().flush();
}

std::shared_ptr<ParametersSet>
DynamicData::getParametersSet(const string& modelId, const string& parFile, const string& parId) {
  if (parFile == "" && parId == "") {
    return std::shared_ptr<ParametersSet>();
  }
  if (parFile != "" && parId == "") {
    DYNErrorQueue::instance().push(DYNError(Error::API, MissingParameterId, modelId));
    return std::shared_ptr<ParametersSet>();
  }
  if (parFile == "" && parId != "") {
    DYNErrorQueue::instance().push(DYNError(Error::API, MissingParameterFile, modelId));
    return std::shared_ptr<ParametersSet>();
  }

  std::string canonicalParFilePath = canonical(parFile, rootDirectory_);
  if (referenceParameters_.find(canonicalParFilePath) != referenceParameters_.end())
    return referenceParameters_[canonicalParFilePath]->getParametersSet(parId);

  // Parameters file not already loaded
  parameters::XmlImporter parametersImporter;
  shared_ptr<ParametersSetCollection> parametersSetCollection = parametersImporter.importFromFile(canonicalParFilePath);
  parametersSetCollection->propagateOriginData(canonicalParFilePath);
  referenceParameters_[canonicalParFilePath] = parametersSetCollection;
  parametersSetCollection->getParametersFromMacroParameter();
  return parametersSetCollection->getParametersSet(parId);
}

void
DynamicData::resolveParReferences(std::shared_ptr<Model> model, std::shared_ptr<ParametersSet> modelSet) {
  if (modelSet == nullptr)
    return;
  std::unordered_map<std::string, boost::shared_ptr<Reference> >& references = modelSet->getReferences();
  for (const std::pair<const std::string, boost::shared_ptr<Reference> >& ref : references) {
    const shared_ptr<Reference>& parRef = ref.second;
    if (parRef->getOrigData() == Reference::OriginData::PAR) {
      if (parRef->getParFile().empty()) {
        if (parRef->getParId().empty()) {
          parRef->setParId(modelSet->getId());
        }
        parRef->setParFile(modelSet->getFilePath());
      }
      const std::shared_ptr<ParametersSet> referencedParametersSet = getParametersSet(model->getId(), parRef->getParFile(), parRef->getParId());
      const std::unordered_map<std::string, shared_ptr<parameters::Reference> > refParamSetReferences = referencedParametersSet->getReferences();
      const std::unordered_map<std::string, shared_ptr<Reference> >::const_iterator itRef = refParamSetReferences.find(parRef->getOrigName());
      if (itRef != references.end())
        throw DYNError(DYN::Error::API, ReferenceToAnotherReference, parRef->getName(), parRef->getOrigName(), parRef->getParId(), parRef->getParFile());
      shared_ptr<Parameter> referencedParameter = referencedParametersSet->getParameter(parRef->getOrigName());
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

  for (dynamicdata::dynamicModel_iterator itModel = dynamicModelsCollection_->beginModel();
          itModel != dynamicModelsCollection_->endModel();
          ++itModel) {
    std::shared_ptr<ModelDescription> model = std::make_shared<ModelDescription>(*itModel);
    string staticId = "";

    // init value will be replaced after
    std::map<std::string, std::shared_ptr<DYN::ModelDescription> >* mappedModel = NULL;

    switch ((*itModel)->getType()) {
      case Model::MODELICA_MODEL: {
        std::shared_ptr<ModelicaModel> modelicaModel = std::dynamic_pointer_cast<ModelicaModel>(*itModel);
        staticId = modelicaModel->getStaticId();
        mappedModel = &modelicaModels_;
        break;
      }
      case Model::MODEL_TEMPLATE:
        mappedModel = &modelTemplates_;
        break;
      case Model::BLACK_BOX_MODEL: {
        std::shared_ptr<BlackBoxModel> bbm = std::dynamic_pointer_cast<BlackBoxModel>(*itModel);
        staticId = bbm->getStaticId();
        mappedModel = &blackBoxModels_;
        break;
      }
      case Model::MODEL_TEMPLATE_EXPANSION: {
        std::shared_ptr<ModelTemplateExpansion> modelTemplateExp = std::dynamic_pointer_cast<ModelTemplateExpansion>(*itModel);
        staticId = modelTemplateExp->getStaticId();
        mappedModel = &modelTemplateExpansions_;
        break;
      }
    }
    model->setStaticId(staticId);
    if (staticId != "" && dataInterface_) {
      dataInterface_->hasDynamicModel(staticId);
    }
    std::pair<std::string, std::shared_ptr<DYN::ModelDescription> > item = std::make_pair(model->getID(), model);
    modelDescriptions_.insert(item);

    if (mappedModel != NULL) {
      mappedModel->insert(item);
    }
  }


  // One by one copy due to the iterators design (no other possibility)
  for (dynamicdata::connector_iterator itConnector = dynamicModelsCollection_->beginConnector();
          itConnector != dynamicModelsCollection_->endConnector();
          ++itConnector) {
    systemConnects_.push_back(*itConnector);
  }

  static const string indexLabel = "@INDEX@";
  static const string nameLabel = "@NAME@";
  // expand macro connects as connector
  // for internal model macro connects, it's made before the compilation
  for (dynamicdata::macroConnect_iterator itMacroConnect = dynamicModelsCollection_->beginMacroConnect();
          itMacroConnect != dynamicModelsCollection_->endMacroConnect();
          ++itMacroConnect) {
    string connector = (*itMacroConnect)->getConnector();
    string model1 = (*itMacroConnect)->getFirstModelId();
    string model2 = (*itMacroConnect)->getSecondModelId();

    std::shared_ptr<dynamicdata::MacroConnector> macroConnector = dynamicModelsCollection_->findMacroConnector(connector);

    // check if macroConnector has no init connect
    const std::map<string, std::unique_ptr<dynamicdata::MacroConnection> >& initConnector = macroConnector->getInitConnectors();
    if (initConnector.size() != 0)
      throw DYNError(DYN::Error::MODELER, SystemInitConnectorForbidden, connector);

    // for each connect, create a system connect
    const std::map<string, std::unique_ptr<dynamicdata::MacroConnection> >& connectors = macroConnector->getConnectors();
    std::map<string, std::unique_ptr<dynamicdata::MacroConnection> >::const_iterator iter = connectors.begin();
    for (; iter != connectors.end(); ++iter) {
      string var1 = iter->second->getFirstVariableId();
      string var2 = iter->second->getSecondVariableId();
      replaceMacroInVariableId((*itMacroConnect)->getIndex1(), (*itMacroConnect)->getName1(), model1, model2, connector, var1);
      replaceMacroInVariableId((*itMacroConnect)->getIndex2(), (*itMacroConnect)->getName2(), model1, model2, connector, var2);

      systemConnects_.push_back(std::make_shared<dynamicdata::Connector>(model1, var1, model2, var2));
    }
  }
}

void
DynamicData::mergeParameters(std::shared_ptr<ParametersSet>& concatParams, const string& udmName, const std::shared_ptr<ParametersSet>& udmSet) {
  // for parameters in parameterSet
  vector<string> parametersName = udmSet->getParametersNames();
  for (vector<string>::const_iterator itName = parametersName.begin(); itName != parametersName.end(); ++itName) {
    const string parameterName = udmName + "_" + *itName;
    const shared_ptr<Parameter> par = udmSet->getParameter(*itName);

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
        throw DYNError(Error::MODELER, ParameterUnknownType, udmName, *itName);
    }
  }
  // for references in parameterSet
  const vector<string>& referencesName = udmSet->getReferencesNames();
  for (vector<string>::const_iterator itRefName = referencesName.begin(); itRefName != referencesName.end(); ++itRefName) {
    const shared_ptr<Reference> ref = udmSet->getReference(*itRefName);
    const string referenceName = udmName + "_" + *itRefName;
    shared_ptr<Reference> reference = ReferenceFactory::newReference(referenceName, ref->getOrigData());
    reference->setType(ref->getType());
    reference->setOrigName(ref->getOrigName());
    reference->setComponentId(ref->getComponentId());
    concatParams->addReference(reference);
  }
}

void
DynamicData::getNetworkParameters(const string& parFile, const string& parSet) {
  std::shared_ptr<ParametersSet> parameters = getParametersSet("network", parFile, parSet);
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
