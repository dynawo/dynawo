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
#include <list>
#include <set>
#include <iomanip>

#include <xml/sax/parser/ParserException.h>

// files in API parameter
#include "PARParametersSet.h"
#include "PARParameter.h"
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
#include "DYNConnectInterface.h"

// files in API_DYD
#include "DYDDynamicModelsCollection.h"
#include "DYDXmlImporter.h"
#include "DYDXmlExporter.h"
#include "DYDModel.h"


#include "DYDModel.h"
#include "DYDUnitDynamicModel.h"
#include "DYDModelicaModel.h"
#include "DYDBlackBoxModel.h"
#include "DYDModelTemplate.h"
#include "DYDModelTemplateExpansion.h"
#include "DYDConnectorImpl.h"
#include "DYDMacroConnection.h"
#include "DYDIterators.h"
#include "DYDMacroConnect.h"
#include "DYDMacroConnector.h"

using std::map;
using std::vector;
using std::list;
using std::pair;
using std::set;
using std::string;
using std::stringstream;
using std::setw;
using boost::shared_ptr;
using boost::dynamic_pointer_cast;

using parameters::ParametersSet;
using parameters::Parameter;
using parameters::ParametersSetFactory;
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
DynamicData::initFromDydFiles(const std::vector <string> & fileNames) {
  dynamicdata::XmlImporter importer;

  dynamicModelsCollection_ = importer.importFromDydFiles(fileNames);

  createModelDescriptions();

  analyzeDynamicData();

  associateParameters();
}

void
DynamicData::analyzeDynamicData() {
  classifyModelDescriptions();  // classify Model Descriptions according to type
  markModelTemplatesCalledByExpansions();  // get model template list to be compiled, by analyzing templateId in model template expansions
  mappingModelicaModels();  // map modelica models with their reference models
}

void
DynamicData::classifyModelDescriptions() {
  modelicaModels_.clear();
  blackBoxModels_.clear();
  modelTemplateExpansions_.clear();
  modelTemplates_.clear();

  map< string, shared_ptr<ModelDescription> >::const_iterator itMd = modelDescriptions_.begin();
  for (; itMd != modelDescriptions_.end(); ++itMd) {
    switch (itMd->second->getModel()->getType()) {
      case Model::MODELICA_MODEL:
        modelicaModels_[itMd->first] = itMd->second;
        break;
      case Model::BLACK_BOX_MODEL:
        blackBoxModels_[itMd->first] = itMd->second;
        break;
      case Model::MODEL_TEMPLATE:
        modelTemplates_[itMd->first] = itMd->second;
        break;
      case Model::MODEL_TEMPLATE_EXPANSION:
        modelTemplateExpansions_[itMd->first] = itMd->second;
        break;
    }
  }
}

void
DynamicData::markModelTemplatesCalledByExpansions() {
  usefulModelTemplates_.clear();
  // get model template list to be compiled, by analyzing templateId in model template expansions
  // update usefulModelTemplates_
  map<string, shared_ptr<ModelDescription> >::const_iterator itMde = modelTemplateExpansions_.begin();
  for (; itMde != modelTemplateExpansions_.end(); ++itMde) {
    shared_ptr<ModelTemplateExpansion> mte = dynamic_pointer_cast<ModelTemplateExpansion> (itMde->second->getModel());
    string templateId = mte->getTemplateId();
    if (modelTemplates_.find(templateId) != modelTemplates_.end()) {
      usefulModelTemplates_[templateId] = modelTemplates_[templateId];
    }
  }

#ifdef _DEBUG_
  Trace::info("COMPILE") << "Model Templates : " << Trace::endline;
  map< string, shared_ptr<ModelDescription> >::const_iterator itMd = modelTemplates_.begin();
  for (; itMd != modelTemplates_.end(); ++itMd) {
    string modelUsed = usefulModelTemplates_.find(itMd->first) != usefulModelTemplates_.end() ? "useful and compiled" : "useless";
    Trace::info("COMPILE") << " - " << itMd->first << " -> " << modelUsed << Trace::endline;
  }
#endif
}

void
DynamicData::mappingModelicaModels() {
  mappedModelDescriptions_.clear();
  referenceModelicaModels_.clear();
  modelicaModelReferenceMap_.clear();
  unitDynamicModelsMap_.clear();

  map<string, shared_ptr<ModelDescription> >::const_iterator itModelica = modelicaModels_.begin();
  for (; itModelica != modelicaModels_.end(); ++itModelica) {
    // for each modelica model, either mark it as a reference model, or refer it to a reference model

    const string id = "Mapping Modelica Model " + itModelica->first;
    int l = id.size() / 2;
    Trace::info("COMPILE") << "====================================================================================================" << Trace::endline;
    Trace::info("COMPILE") << "|                                                                                                  |" << Trace::endline;
    Trace::info("COMPILE") << "|" << setw(50 + l) << id << setw(50 - l - 1) << "|" << Trace::endline;
    Trace::info("COMPILE") << "|                                                                                                  |" << Trace::endline;
    Trace::info("COMPILE") << "====================================================================================================" << Trace::endline;

    // search in mapped model library, if already mapped, return.
    vector<shared_ptr<ModelDescription> >::const_iterator it;
    it = find(mappedModelDescriptions_.begin(), mappedModelDescriptions_.end(), itModelica->second);
    if (it != mappedModelDescriptions_.end()) {
      Trace::info("COMPILE") << DYNLog(AlreadyMappedModel, itModelica->first) << Trace::endline;
      continue;
    }

    itModelica->second->hasCompiledModel(true);

    bool alreadyMapped = false;

    shared_ptr<ModelicaModel> modelicaModel = dynamic_pointer_cast<ModelicaModel> (itModelica->second->getModel());

    // Searching if a compiled model with the same structure exists in the reference models
    vector< shared_ptr<ModelDescription> >::const_iterator itrefModelDescriptions;
    for (itrefModelDescriptions = referenceModelicaModels_.begin(); itrefModelDescriptions != referenceModelicaModels_.end(); ++itrefModelDescriptions) {
      shared_ptr<ModelDescription> tmpModelicaModelDescription = *itrefModelDescriptions;
      shared_ptr<ModelicaModel> tmpModelicaModel = dynamic_pointer_cast<ModelicaModel> (tmpModelicaModelDescription->getModel());
      // Local unit dynamic models reference map completed in hasSameStructureAs() method
      map<shared_ptr<UnitDynamicModel>, shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;

      if (modelicaModel->hasSameStructureAs(tmpModelicaModel, unitDynamicModelsMap_)) {  // modelica model finds a reference model, map them.
        Trace::info("COMPILE") << DYNLog(AddingModelToMap, modelicaModel->getId(), tmpModelicaModel->getId()) << Trace::endline;

        modelicaModelReferenceMap_[itModelica->second] = tmpModelicaModelDescription;

        Trace::info("COMPILE") << DYNLog(CompiledModelID, tmpModelicaModelDescription->getCompiledModelId()) << Trace::endline;
        alreadyMapped = true;
        break;
      }
    }


    if (!alreadyMapped) {
      // not find a reference model. add the modelica model to the reference model lib and refer it to it self
      modelicaModelReferenceMap_[itModelica->second] = itModelica->second;
      referenceModelicaModels_.push_back(itModelica->second);  // mark the modelica model as a reference model, add it to the reference model lib
      map<string, shared_ptr<UnitDynamicModel> > unitDynamicModels = modelicaModel->getUnitDynamicModels();

      map<string, shared_ptr<UnitDynamicModel> >::const_iterator itUdm;
      for (itUdm = unitDynamicModels.begin(); itUdm != unitDynamicModels.end(); ++itUdm) {
        unitDynamicModelsMap_[itUdm->second] = itUdm->second;
      }
      Trace::info("COMPILE") << DYNLog(ReferenceModelDesc, itModelica->first) << Trace::endline;
      Trace::info("COMPILE") << DYNLog(CompiledModelID, itModelica->first) << Trace::endline;
      (itModelica->second)->setCompiledModelId(itModelica->first);
    }

    mappedModelDescriptions_.push_back(itModelica->second);  // mark the modelica model as mapped
  }
}

void
DynamicData::associateParameters() {
  map<string, shared_ptr<ModelDescription> >::const_iterator iter = modelDescriptions_.begin();

  for (; iter != modelDescriptions_.end(); ++iter) {
    shared_ptr<dynamicdata::Model> model = iter->second->getModel();

    // add parameters to modelDescription
    switch (model->getType()) {
        // model templates do not require parameters (only expansions do)
      case Model::MODEL_TEMPLATE:
        break;

        // for Modelica models, add a unit dynamic model (the reference udm) prefix to parameter names
      case Model::MODELICA_MODEL: {
        shared_ptr<ParametersSet> modelSet(ParametersSetFactory::newInstance(model->getId()));
        shared_ptr<ModelicaModel> modelicaModel = dynamic_pointer_cast<ModelicaModel>(model);
        map<string, shared_ptr<UnitDynamicModel> > models = modelicaModel->getUnitDynamicModels();

        map<string, shared_ptr<UnitDynamicModel> >::const_iterator itUDM = models.begin();
        for (; itUDM != models.end(); ++itUDM) {
          shared_ptr<ParametersSet> udmSet = getParametersSet(model->getId(), itUDM->second->getParFile(), itUDM->second->getParId());
          if (unitDynamicModelsMap_.find(itUDM->second) == unitDynamicModelsMap_.end())
            throw DYNError(Error::MODELER, UDMUndefined, itUDM->first, model->getId());

          shared_ptr<UnitDynamicModel> udmRef = unitDynamicModelsMap_[itUDM->second];
          const string& udmId = udmRef->getId();

          if (udmSet)
            mergeParameters(modelSet, udmId, udmSet);  // create parameters with their new prefixed names in the ParametersSet ModelSet
        }
        (iter->second)->setParametersSet(modelSet);
        break;
      }
      case Model::BLACK_BOX_MODEL: {
        shared_ptr<BlackBoxModel> bbm = dynamic_pointer_cast<BlackBoxModel>(model);
        shared_ptr<ParametersSet> modelSet = getParametersSet(bbm->getId(), bbm->getParFile(), bbm->getParId());
        (iter->second)->setParametersSet(modelSet);
        break;
      }
      case Model::MODEL_TEMPLATE_EXPANSION: {
        shared_ptr<ModelTemplateExpansion> modelTemplateExp = dynamic_pointer_cast<ModelTemplateExpansion>(model);
        shared_ptr<ParametersSet> modelSet = getParametersSet(modelTemplateExp->getId(), modelTemplateExp->getParFile(), modelTemplateExp->getParId());
        (iter->second)->setParametersSet(modelSet);
        break;
      }
    }
  }
  DYNErrorQueue::get()->flush();
}

shared_ptr<ParametersSet>
DynamicData::getParametersSet(const string& modelId, const string& parFile, const string& parId) {
  if (parFile == "" && parId == "")
    return shared_ptr<ParametersSet>();
  if (parFile != "" && parId == "") {
    DYNErrorQueue::get()->push(DYNError(Error::API, MissingParameterId, modelId));
    return shared_ptr<ParametersSet>();
  }
  if (parFile == "" && parId != "") {
    DYNErrorQueue::get()->push(DYNError(Error::API, MissingParameterFile, modelId));
    return shared_ptr<ParametersSet>();
  }

  if (referenceParameters_.find(parFile) != referenceParameters_.end())
    return referenceParameters_[parFile]->getParametersSet(parId);

  // Parameters file not already loaded
  parameters::XmlImporter parametersImporter;

  try {
    shared_ptr<ParametersSetCollection> parametersSetCollection = parametersImporter.importFromFile(canonical(parFile, rootDirectory_));
    referenceParameters_[parFile] = parametersSetCollection;
    return parametersSetCollection->getParametersSet(parId);
  } catch (const xml::sax::parser::ParserException& exp) {
    throw DYNError(Error::MODELER, XmlParsingError, parFile, exp.what());
  }
}

void
DynamicData::createModelDescriptions() {
  for (dynamicdata::model_iterator itModel = dynamicModelsCollection_->beginModel();
          itModel != dynamicModelsCollection_->endModel();
          ++itModel) {
    shared_ptr<ModelDescription> model = shared_ptr<ModelDescription>(new ModelDescription(*itModel));
    string staticId = "";
    switch ((*itModel)->getType()) {
      case Model::MODELICA_MODEL: {
        shared_ptr<ModelicaModel> modelicaModel = dynamic_pointer_cast<ModelicaModel>(*itModel);
        staticId = modelicaModel->getStaticId();
        break;
      }
      case Model::MODEL_TEMPLATE:
        break;
      case Model::BLACK_BOX_MODEL: {
        shared_ptr<BlackBoxModel> bbm = dynamic_pointer_cast<BlackBoxModel>(*itModel);
        staticId = bbm->getStaticId();
        break;
      }
      case Model::MODEL_TEMPLATE_EXPANSION: {
        shared_ptr<ModelTemplateExpansion> modelTemplateExp = dynamic_pointer_cast<ModelTemplateExpansion>(*itModel);
        staticId = modelTemplateExp->getStaticId();
        break;
      }
    }
    model->setStaticId(staticId);
    if (staticId != "" && dataInterface_) {
      dataInterface_->hasDynamicModel(staticId);
    }
    modelDescriptions_[model->getID()] = model;
  }

  // @todo: instead of copying the full table one by one, directly copy the vector ?
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

    shared_ptr<dynamicdata::MacroConnector> macroConnector = dynamicModelsCollection_->findMacroConnector(connector);

    // check if macroConnector has no init connect
    map<string, shared_ptr<dynamicdata::MacroConnection> > initConnector = macroConnector->getInitConnectors();
    if (initConnector.size() != 0)
      throw DYNError(DYN::Error::MODELER, SystemInitConnectorForbidden, connector);

    // for each connect, create a system connect
    map<string, shared_ptr<dynamicdata::MacroConnection> > connectors = macroConnector->getConnectors();
    map<string, shared_ptr<dynamicdata::MacroConnection> >::const_iterator iter = connectors.begin();
    for (; iter != connectors.end(); ++iter) {
      string var1 = iter->second->getFirstVariableId();
      string var2 = iter->second->getSecondVariableId();

      // replace @INDEX@ in var1
      if (var1.find(indexLabel) != string::npos) {
        if ((*itMacroConnect)->getIndex1() == "")
          throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "index1");
        var1.replace(var1.find(indexLabel), indexLabel.size(), (*itMacroConnect)->getIndex1());
      }

      // replace @INDEX@ in var2
      if (var2.find(indexLabel) != string::npos) {
        if ((*itMacroConnect)->getIndex2() == "")
          throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "index2");
        var2.replace(var2.find(indexLabel), indexLabel.size(), (*itMacroConnect)->getIndex2());
      }

      // replace @NAME@ in var1
      if (var1.find(nameLabel) != string::npos) {
        if ((*itMacroConnect)->getName1() == "")
          throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "name1");
        var1.replace(var1.find(nameLabel), nameLabel.size(), (*itMacroConnect)->getName1());
      }

      // replace @NAME@ in var2
      if (var2.find(nameLabel) != string::npos) {
        if ((*itMacroConnect)->getName2() == "")
          throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "name2");
        var2.replace(var2.find(nameLabel), nameLabel.size(), (*itMacroConnect)->getName2());
      }

      systemConnects_.push_back(shared_ptr<dynamicdata::Connector>(new dynamicdata::Connector::Impl(model1, var1, model2, var2)));
    }
  }
}

void
DynamicData::mergeParameters(shared_ptr<ParametersSet>& concatParams, const string& udmName, const shared_ptr<ParametersSet>& udmSet) {
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
    shared_ptr<Reference> reference = ReferenceFactory::newReference(referenceName);
    reference->setType(ref->getType());
    reference->setOrigData(ref->getOrigData());
    reference->setOrigName(ref->getOrigName());
    reference->setComponentId(ref->getComponentId());
    concatParams->addReference(reference);
  }
}

void
DynamicData::getNetworkParameters(const string & parFile, const string& parSet) {
  const string filePath = searchFile(parFile, rootDirectory_, false);
  if (filePath == "")
    throw DYNError(Error::MODELER, UnknownParFile, parFile, rootDirectory_);

  shared_ptr<ParametersSet> parameters = getParametersSet("network", filePath, parSet);
  DYNErrorQueue::get()->flush();
  setNetworkParameters(parameters);
}

void
DynamicData::addConnectInterface(const shared_ptr<ConnectInterface>& connect) {
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

  connects_[connectId] = connect;
}

}  // namespace DYN
