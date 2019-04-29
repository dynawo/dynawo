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
 * @file DYNCompiler.cpp
 * @brief Dynawo models compile implementation file
 *
 */

#include <iomanip>
#include <fstream>
#include <list>
#include <set>
#include <memory>
#include <boost/algorithm/string/replace.hpp>

#include <boost/algorithm/string/predicate.hpp>
#include <boost/lexical_cast.hpp>

#include "DYNStaticRefInterface.h"
#include "DYNConnectInterface.h"
#include "DYNModelDescription.h"
#include "DYNDynamicData.h"
#include "DYNCompiler.h"

#include "DYDDynamicModelsCollection.h"
#include "DYDModel.h"
#include "DYDModelicaModel.h"
#include "DYDModelTemplate.h"
#include "DYDModelTemplateExpansion.h"
#include "DYDBlackBoxModel.h"
#include "DYDUnitDynamicModel.h"
#include "DYDConnectorImpl.h"
#include "DYDMacroConnect.h"
#include "DYDMacroConnection.h"
#include "DYDMacroConnector.h"
#include "DYDStaticRef.h"
#include "DYDMacroStaticRef.h"
#include "DYDMacroStaticReference.h"
#include "DYDIterators.h"

#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNTimer.h"
#include "DYNExecUtils.h"
#include "DYNFileSystemUtils.h"

#include "EXTVARIterators.h"
#include "EXTVARXmlImporter.h"
#include "EXTVARXmlExporter.h"
#include "EXTVARVariablesCollectionFactory.h"
#include "EXTVARVariable.h"

using std::list;
using std::map;
using std::string;
using std::stringstream;
using std::set;
using std::vector;

using boost::dynamic_pointer_cast;
using boost::lexical_cast;
using boost::shared_ptr;

namespace DYN {

void
Compiler::compile() {
  getDDB();

  unitDynamicModelsMap_ = dyd_->getUnitDynamicModelsMap();
  map<string, shared_ptr<ModelDescription> > blackboxes = dyd_->getBlackBoxModelDescriptions();
  map<string, shared_ptr<ModelDescription> >::const_iterator itbbm;
  for (itbbm = blackboxes.begin(); itbbm != blackboxes.end(); ++itbbm) {
    compileBlackBoxModelDescription(itbbm->second);
  }

  map<string, shared_ptr<ModelDescription> > modeltemplates = dyd_->getModelTemplateDescriptionsToBeCompiled();
  map<string, shared_ptr<ModelDescription> >::const_iterator itmt;
  for (itmt = modeltemplates.begin(); itmt != modeltemplates.end(); ++itmt) {
    compileModelicaModelDescription(itmt->second);
  }

  // compile model template expansion. compile model template expansion after all the model templates are compiled
  map<string, shared_ptr<ModelDescription> > modeltemplateExpansions = dyd_->getModelTemplateExpansionDescriptions();
  map<string, shared_ptr<ModelDescription> >::const_iterator itmte;
  for (itmte = modeltemplateExpansions.begin(); itmte != modeltemplateExpansions.end(); ++itmte) {
    compileModelTemplateExpansionDescription(itmte->second);
  }

  vector< shared_ptr<ModelDescription> > refmodelicas = dyd_->getReferenceModelicaModels();
  vector< shared_ptr<ModelDescription> >::const_iterator itref;
  // compile all the reference models from refLib
  for (itref = refmodelicas.begin(); itref != refmodelicas.end(); ++itref) {
    compileModelicaModelDescription(*itref);
  }

  map<shared_ptr<ModelDescription>, shared_ptr<ModelDescription> > modelRefMap = dyd_->getModelicaModelReferenceMap();
  // in map refMap, the key is the modelicamodel, the value is the reference model
  map<shared_ptr<ModelDescription>, shared_ptr<ModelDescription> >::const_iterator itrefMap;
  // for other modelica models, set their libs as their reference models lib; concat parameters; add to compiled lib
  for (itrefMap = modelRefMap.begin(); itrefMap != modelRefMap.end(); ++itrefMap) {
    if (compiledModelDescriptions_.find(itrefMap->first->getID()) == compiledModelDescriptions_.end()) {
      itrefMap->first->setLib(itrefMap->second->getLib());  // set the lib of modelica model as its reference model
      itrefMap->first->setCompiledModelId(itrefMap->second->getCompiledModelId());  // set the compiled model ID as its reference model

      compiledModelDescriptions_[itrefMap->first->getID()] = itrefMap->first;  // add the modelica model to already compiled lib

      Trace::info("COMPILE") << itrefMap->first->getID() << " " << DYNLog(CompiledModelID, itrefMap->first->getCompiledModelId()) << Trace::endline;
    }
  }

  Trace::info("COMPILE") << DYNLog(CompilationDone) << Trace::endline;
}

void
Compiler::getDDB() {
  // Go through DDB and models directories to get available files
  // check that the DDB environment variable was set when it is used
  string DDBDir = "";
  if (useStandardPrecompiledModels_ || useStandardModelicaModels_) {
    if (!hasEnvVar("DYNAWO_DDB_DIR")) {
      throw DYNError(Error::MODELER, MissingDDBDir);
    }
    DDBDir = getEnvVar("DYNAWO_DDB_DIR");
  }

  // look for precompiled libs
  vector <string> libraryFiles;
  const bool searchInSubDirsStandardModels = true;
  const bool searchInSubDirsCustomModels = false;
  const bool packageNeedsRecursive = true;
  const bool stopWhenSeePackage = true;
  const string packageName = "package";
  vector <string> fileExtensionsForbiddenXML;
  fileExtensionsForbiddenXML.push_back(".desc.xml");
  fileExtensionsForbiddenXML.push_back(".cvg.xml");
  vector <string> noFileExtensionsForbidden;

  // look for standard precompiled models
  if (useStandardPrecompiledModels_) {
    Trace::info("COMPILE") << DYNLog(DDBDir, DDBDir) << Trace::endline;
    searchFilesAccordingToExtension(DDBDir, ".so", noFileExtensionsForbidden, searchInSubDirsStandardModels, libraryFiles);
  }

  for (vector<UserDefinedDirectory>::const_iterator itDir = precompiledModelsDirsPaths_.begin(); itDir != precompiledModelsDirsPaths_.end(); ++itDir) {
    Trace::info("COMPILE") << DYNLog(CustomDir, itDir->path, precompiledModelsExtension_) << Trace::endline;
    searchFilesAccordingToExtension(itDir->path, precompiledModelsExtension_, noFileExtensionsForbidden, searchInSubDirsCustomModels, libraryFiles);
  }

  // check for duplicate libs
  for (vector<string>::const_iterator itFile = libraryFiles.begin(); itFile != libraryFiles.end(); ++itFile) {
    if (libFiles_.find(file_name(*itFile)) != libFiles_.end()) {
      throw DYNError(Error::MODELER, DuplicateLibFile, file_name(*itFile));
    }
    libFiles_[file_name(*itFile)] = *itFile;
    Trace::debug("COMPILE") << *itFile << Trace::endline;
  }
  Trace::debug("COMPILE") << "" << Trace::endline;

  // look for Modelica models and external variable files
  if (useStandardModelicaModels_) {
    // scan for files required by OMC (i.e. only keep parent package.mo for packages)
    searchModelsFiles(DDBDir, ".mo", noFileExtensionsForbidden, searchInSubDirsStandardModels, !packageNeedsRecursive, stopWhenSeePackage, moFilesCompilation_);

    // scan for all .mo files (for sanity checks purposes)
    searchModelsFiles(DDBDir, ".mo", noFileExtensionsForbidden, searchInSubDirsStandardModels, packageNeedsRecursive, !stopWhenSeePackage, moFilesAll_);

    // scan for all .extvar (external variables files)
    searchModelsFiles(DDBDir, ".extvar", fileExtensionsForbiddenXML, searchInSubDirsStandardModels, packageNeedsRecursive, !stopWhenSeePackage, extVarFiles_);
  }

  for (vector<UserDefinedDirectory>::const_iterator itDir = modelicaModelsDirsPaths_.begin(); itDir != modelicaModelsDirsPaths_.end(); ++itDir) {
    searchModelsFiles(itDir->path, modelicaModelsExtension_, noFileExtensionsForbidden, itDir->isRecursive, !packageNeedsRecursive, stopWhenSeePackage,
            moFilesCompilation_);

    searchModelsFiles(itDir->path, modelicaModelsExtension_, noFileExtensionsForbidden, itDir->isRecursive, packageNeedsRecursive, !stopWhenSeePackage,
            moFilesAll_);
    searchModelsFiles(itDir->path, ".extvar", fileExtensionsForbiddenXML, itDir->isRecursive, packageNeedsRecursive, !stopWhenSeePackage, extVarFiles_);
  }
  Trace::info("COMPILE") << DYNLog(CompileFiles) << Trace::endline;
  for (std::map<string, string>::const_iterator itFile = moFilesCompilation_.begin(); itFile != moFilesCompilation_.end(); ++itFile) {
    Trace::debug("COMPILE") << (itFile->second) << Trace::endline;
  }
  Trace::debug("COMPILE") << "" << Trace::endline;

  Trace::debug("COMPILE") << "External variable files" << Trace::endline;
  for (std::map<string, string>::const_iterator itFile = extVarFiles_.begin(); itFile != extVarFiles_.end(); ++itFile) {
    Trace::debug("COMPILE") << itFile->second << Trace::endline;
  }
  Trace::debug("COMPILE") << "" << Trace::endline;
}

void
Compiler::compileModelTemplateExpansionDescription(const shared_ptr<ModelDescription>& modelTemplateExpansionDescription) {
  if (modelTemplateExpansionDescription->getType() != dynamicdata::Model::MODEL_TEMPLATE_EXPANSION) {
    throw DYNError(Error::MODELER, NotModelTemplateExpansion, modelTemplateExpansionDescription->getID());
  }

  string id = DYNLog(CompilingModel, modelTemplateExpansionDescription->getID()).str();
  int l = id.size() / 2;
  Trace::info("COMPILE") << "====================================================================================================" << Trace::endline;
  Trace::info("COMPILE") << "|                                                                                                  |" << Trace::endline;
  Trace::info("COMPILE") << "|" << std::setw(50 + l) << id << std::setw(50 - l - 1) << "|" << Trace::endline;
  Trace::info("COMPILE") << "|                                                                                                  |" << Trace::endline;
  Trace::info("COMPILE") << "====================================================================================================" << Trace::endline;
  string modelID(modelTemplateExpansionDescription->getID());
  if (compiledModelDescriptions_.find(modelID) != compiledModelDescriptions_.end()) {
    Trace::info("COMPILE") << DYNLog(AlreadyCompiledModel, modelID) << Trace::endline;
    return;
  }

  modelTemplateExpansionDescription->setCompiledModelId(modelID);

  shared_ptr<dynamicdata::ModelTemplateExpansion> modelTemplateExpansion;
  modelTemplateExpansion = dynamic_pointer_cast<dynamicdata::ModelTemplateExpansion> (modelTemplateExpansionDescription->getModel());


  if (modelTemplateDescriptions_.find(modelTemplateExpansion->getTemplateId()) != modelTemplateDescriptions_.end()) {
    string libtmp = modelTemplateDescriptions_[ modelTemplateExpansion->getTemplateId() ]->getLib();
    Trace::info("COMPILE") << "Set Lib: " << libtmp << Trace::endline;
    modelTemplateExpansionDescription->setLib(libtmp);
  } else {
    throw DYNError(Error::MODELER, UnableToFindLib, modelTemplateExpansion->getTemplateId());
  }

  // Everything is ok -> model added in already compiled models
  compiledModelDescriptions_[modelID] = modelTemplateExpansionDescription;
  modelTemplateExpansionDescription->hasCompiledModel(true);
  Trace::info("COMPILE") << DYNLog(ModelTemplateExpansionCompiled, modelID) << Trace::endline;
  Trace::info("COMPILE") << DYNLog(CompiledModelID, modelID) << Trace::endline;
}

void
Compiler::compileBlackBoxModelDescription(const shared_ptr<ModelDescription>& blackBoxModelDescription) {
  if (blackBoxModelDescription->getType() != dynamicdata::Model::BLACK_BOX_MODEL) {
    throw DYNError(Error::MODELER, NotBlackBoxModel, blackBoxModelDescription->getID());
  }

  string id = DYNLog(CompilingModel, blackBoxModelDescription->getID()).str();
  int l = id.size() / 2;
  Trace::info("COMPILE") << "====================================================================================================" << Trace::endline;
  Trace::info("COMPILE") << "|                                                                                                  |" << Trace::endline;
  Trace::info("COMPILE") << "|" << std::setw(50 + l) << id << std::setw(50 - l - 1) << "|" << Trace::endline;
  Trace::info("COMPILE") << "|                                                                                                  |" << Trace::endline;
  Trace::info("COMPILE") << "====================================================================================================" << Trace::endline;
  string modelID(blackBoxModelDescription->getID());
  if (compiledModelDescriptions_.find(modelID) != compiledModelDescriptions_.end()) {
    Trace::info("COMPILE") << DYNLog(AlreadyCompiledModel, modelID) << Trace::endline;
    return;
  }

  blackBoxModelDescription->setCompiledModelId(modelID);

  shared_ptr<dynamicdata::BlackBoxModel> blackBoxModel = dynamic_pointer_cast<dynamicdata::BlackBoxModel> (blackBoxModelDescription->getModel());

  if (libFiles_.find(blackBoxModel->getLib()) != libFiles_.end()) {
    blackBoxModelDescription->setLib(libFiles_[blackBoxModel->getLib()]);
    Trace::info("COMPILE") << DYNLog(SetLib, blackBoxModel->getLib(), libFiles_[blackBoxModel->getLib()]) << Trace::endline;
  } else {
    throw DYNError(Error::MODELER, UnableToFindLib, blackBoxModel->getLib());
  }

  // Everything is ok -> model added in already compiled models
  compiledModelDescriptions_[modelID] = blackBoxModelDescription;
  blackBoxModelDescription->hasCompiledModel(true);
  Trace::info("COMPILE") << DYNLog(BlackBoxModelCompiled, modelID) << Trace::endline;
  Trace::info("COMPILE") << DYNLog(CompiledModelID, modelID) << Trace::endline;
}

void
Compiler::compileModelicaModelDescription(const shared_ptr<ModelDescription>& modelDescription) {
  if (modelDescription->getType() != dynamicdata::Model::MODELICA_MODEL
          && modelDescription->getType() != dynamicdata::Model::MODEL_TEMPLATE) {
    throw DYNError(Error::MODELER, NotModelicaModel, modelDescription->getID());
  }

  bool isModelTemplate = modelDescription->getType() == dynamicdata::Model::MODEL_TEMPLATE;
  string libName;
  string modelID;
  map<string, shared_ptr<dynamicdata::UnitDynamicModel> > unitDynamicModels;
  if (isModelTemplate) {
    // create compiled model for model template
    modelDescription->hasCompiledModel(true);
    modelDescription->setCompiledModelId(modelDescription->getID());
    shared_ptr<dynamicdata::ModelTemplate> modelicaModel = dynamic_pointer_cast<dynamicdata::ModelTemplate> (modelDescription->getModel());
    libName = modelicaModel->getId() + ".so";
    unitDynamicModels = modelicaModel->getUnitDynamicModels();
    modelID = modelicaModel->getId();
  } else {
    // compile(modelicaModel) compile the modelica model already mapped;
    shared_ptr<dynamicdata::ModelicaModel> modelicaModel = dynamic_pointer_cast<dynamicdata::ModelicaModel> (modelDescription->getModel());
    libName = modelicaModel->getId() + ".so";
    unitDynamicModels = modelicaModel->getUnitDynamicModels();
    modelID = modelicaModel->getId();
  }

  string thisCompiledId = modelDescription->getCompiledModelId();

  string id = DYNLog(CompilingModel, modelDescription->getID()).str();
  int l = id.size() / 2;
  Trace::info("COMPILE") << "====================================================================================================" << Trace::endline;
  Trace::info("COMPILE") << "|                                                                                                  |" << Trace::endline;
  Trace::info("COMPILE") << "|" << std::setw(50 + l) << id << std::setw(50 - l - 1) << "|" << Trace::endline;
  Trace::info("COMPILE") << "|                                                                                                  |" << Trace::endline;
  Trace::info("COMPILE") << "====================================================================================================" << Trace::endline;
  string installDir = prettyPath(getEnvVar("DYNAWO_INSTALL_DIR"));

  // remove old files
  string cleanCommand = installDir + "/sbin/cleanCompileModelicaModel --model=" + thisCompiledId + " --directory=" + compileDirPath_;
  if (rmModels_)
    cleanCommand += " --remove-model-files";
#ifdef _DEBUG_
  cleanCommand += " --debug";
#endif
  stringstream ssClean;
  executeCommand(cleanCommand, ssClean);
  Trace::debug("COMPILE") << ssClean.str() << Trace::endline;

  // concat models
  concatModel(modelDescription);  // for .mo, .extvar, -init.mo

  // erase old version of the lib before compiling it.
  remove(createAbsolutePath(libName, compileDirPath_));

  // Get needed Modelica Model Files list and needed Init ModelFiles list

  map<string, shared_ptr<dynamicdata::UnitDynamicModel> >::const_iterator itUdm;
  vector <string> requiredModelicaFiles;
  for (itUdm = unitDynamicModels.begin(); itUdm != unitDynamicModels.end(); ++itUdm) {
    string moFileName = itUdm->second->getDynamicFileName();
    if ((!moFileName.empty()) && (std::find(requiredModelicaFiles.begin(), requiredModelicaFiles.end(), moFileName) == requiredModelicaFiles.end())) {
      requiredModelicaFiles.push_back(moFileName);
    }

    if (itUdm->second->getInitFileName() != "") {
      moFileName = itUdm->second->getInitFileName();
      if ((!moFileName.empty()) && (std::find(requiredModelicaFiles.begin(), requiredModelicaFiles.end(), moFileName) == requiredModelicaFiles.end())) {
        requiredModelicaFiles.push_back(moFileName);
      }
    }
  }

  vector <string> availableModelicaFiles;
  for (std::map<string, string>::const_iterator itFile = moFilesAll_.begin(); itFile != moFilesAll_.end(); ++itFile) {
    string moFileName = file_name(itFile->second);
    if (std::find(availableModelicaFiles.begin(), availableModelicaFiles.end(), moFileName) == availableModelicaFiles.end()) {
      availableModelicaFiles.push_back(moFileName);
    }
  }

  std::sort(requiredModelicaFiles.begin(), requiredModelicaFiles.end());
  std::sort(availableModelicaFiles.begin(), availableModelicaFiles.end());

  // compute the vector of missing models as the difference between required models and available models
  vector <string> missingModelicaModels;
  std::set_difference(requiredModelicaFiles.begin(), requiredModelicaFiles.end(),
          availableModelicaFiles.begin(), availableModelicaFiles.end(),
          std::inserter(missingModelicaModels, missingModelicaModels.begin()));

  if (missingModelicaModels.size() > 0) {
    string missingFiles = "";
    bool firstItem = true;
    for (vector<string>::const_iterator itFile = missingModelicaModels.begin(); itFile != missingModelicaModels.end(); ++itFile) {
      if (!firstItem) {
        missingFiles += ",";
      } else {
        firstItem = false;
      }
      missingFiles += " " + (*itFile);
    }
    throw DYNError(Error::MODELER, UnknownModelFile, missingFiles);
  }

  // Compilation and post-treatment on concatenated files
  string compileCommand = installDir + "/sbin/compileModelicaModel --model " + thisCompiledId + " --output-dir " + compileDirPath_ + " --lib " + libName;

  if (moFilesCompilation_.size() > 0) {
    string moFilesList = "";
    for (std::map<string, string>::const_iterator itFile = moFilesCompilation_.begin(); itFile != moFilesCompilation_.end(); ++itFile) {
      moFilesList += " " + (itFile->second);
    }

    compileCommand += " --moFiles" + moFilesList + " --initFiles" + moFilesList;
  }

  if (!additionalHeaderFiles_.empty()) {
    string additionalHeaderList = "";
    for (unsigned i = 0, iEnd = additionalHeaderFiles_.size(); i < iEnd; ++i) {
      additionalHeaderList += " " + additionalHeaderFiles_[i];
    }

    compileCommand += " --additionalHeaderList" + additionalHeaderList;
  }
  if (rmModels_)
    compileCommand += " --remove-model-files true";

  Trace::info("COMPILE") << DYNLog(CompileCommmand, compileCommand) << Trace::endline;

  stringstream ss;
  executeCommand(compileCommand, ss);
  Trace::debug("COMPILE") << ss.str() << Trace::endline;
  string echoString = ss.str();
  boost::replace_all(echoString, "'", "\"");
  // In case of static compilation it is expected that symbols about Timer are missing.
  string commandUndefined = "echo '" + echoString + "' | sed '1,/ldd -r/d' | c++filt | grep 'undefined' | grep -v 'DYN::Timer::~Timer()'"
          " | grep -v \"DYN::Timer::Timer([^)]*)\"";
  int returnCode = system(commandUndefined.c_str());
  bool hasUndefinedSymbol = (returnCode == 0);

  // testing if the lib was successfully compiled (test if it exists, and if no undefined symbol was noticed)
  if ((!exists(compileDirPath_ + "/" + libName)) || (hasUndefinedSymbol))
    throw DYNError(Error::MODELER, CompilationFailed, libName);

  string lib = compileDirPath_ + "/" + libName;
  Trace::info("COMPILE") << DYNLog(SetLib, modelID, lib) << Trace::endline;
  modelDescription->setLib(lib);

  if (isModelTemplate)
    modelTemplateDescriptions_[modelID] = modelDescription;

  // Everything is ok -> model added in already compiled models
  compiledModelDescriptions_[modelDescription->getID()] = modelDescription;
  compiledLib_.push_back(lib);
  Trace::info("COMPILE") << DYNLog(CompiledModelID, modelDescription->getCompiledModelId()) << Trace::endline;
}

void
Compiler::concatModel(const shared_ptr<ModelDescription> & modelicaModelDescription) {
  if (modelicaModelDescription->getType() != dynamicdata::Model::MODELICA_MODEL &&
          modelicaModelDescription->getType() != dynamicdata::Model::MODEL_TEMPLATE) {
    throw DYNError(Error::MODELER, ConcatModelNotModelica, modelicaModelDescription->getID());
  }

  map<string, shared_ptr<dynamicdata::UnitDynamicModel> > unitDynamicModels;
  map<string, shared_ptr<dynamicdata::Connector> > pinConnects;
  map<string, shared_ptr<dynamicdata::MacroConnect> > macroConnects;
  string modelID;
  if (modelicaModelDescription->getType() == dynamicdata::Model::MODELICA_MODEL) {
    shared_ptr<dynamicdata::ModelicaModel> model = dynamic_pointer_cast<dynamicdata::ModelicaModel> (modelicaModelDescription->getModel());
    unitDynamicModels = model->getUnitDynamicModels();
    pinConnects = model->getConnectors();
    modelID = model->getId();
    macroConnects = model->getMacroConnects();
  } else {
    shared_ptr<dynamicdata::ModelTemplate> model = dynamic_pointer_cast<dynamicdata::ModelTemplate> (modelicaModelDescription->getModel());
    unitDynamicModels = model->getUnitDynamicModels();
    pinConnects = model->getConnectors();
    modelID = model->getId();
    macroConnects = model->getMacroConnects();
  }

  vector<shared_ptr<dynamicdata::Connector> > internalConnects;
  ///< all external variables (including ones which may have been internally connected)
  map<string, shared_ptr<externalVariables::VariablesCollection> > allExternalVariables;
  bool hasInit = false;
  set<string> initModels;

  // Go through unit dynamic models to get init models and external variables files
  map<string, shared_ptr<dynamicdata::UnitDynamicModel> >::const_iterator itUnitDynamicModel;
  for (itUnitDynamicModel = unitDynamicModels.begin(); itUnitDynamicModel != unitDynamicModels.end(); ++itUnitDynamicModel) {
    shared_ptr<dynamicdata::UnitDynamicModel> unitDynamicModel = itUnitDynamicModel->second;
    string modelName = unitDynamicModel->getDynamicModelName();
    if (extVarFiles_.find(modelName) != extVarFiles_.end()) {
      Trace::info("COMPILE") << DYNLog(ParsingExtVarFile, extVarFiles_[modelName]) << Trace::endline;
      externalVariables::XmlImporter extVarImporter;
      shared_ptr<externalVariables::VariablesCollection> unitModelExternalVariables = extVarImporter.importFromFile(extVarFiles_[modelName]);

      allExternalVariables[unitDynamicModel->getId()] = unitModelExternalVariables;
    } else {
      Trace::info("COMPILE") << DYNLog(ExtVarFileNotFound, modelName) << Trace::endline;
    }

    // Test if there is an initialization model for current unit dynamic model
    string initName = unitDynamicModel->getInitModelName();
    if (initName != "")
      hasInit = true;
  }

  // Go through connects to keep only "internal" ones made at compile time
  map<string, shared_ptr<dynamicdata::Connector> >::const_iterator itPinConnect;
  for (itPinConnect = pinConnects.begin(); itPinConnect != pinConnects.end(); ++itPinConnect) {
    shared_ptr<dynamicdata::Connector> pinConnect = itPinConnect->second;

    set<string> internalModelsIDs;
    for (itUnitDynamicModel = unitDynamicModels.begin(); itUnitDynamicModel != unitDynamicModels.end(); ++itUnitDynamicModel) {
      internalModelsIDs.insert(itUnitDynamicModel->first);
    }

    if (internalModelsIDs.find(pinConnect->getFirstModelId()) != internalModelsIDs.end() &&
            internalModelsIDs.find(pinConnect->getSecondModelId()) != internalModelsIDs.end()) {
      internalConnects.push_back(pinConnect);
    }
  }

  // .mo file generation
  string modelConcatName = modelicaModelDescription->getCompiledModelId();

  string modelConcatFile = absolute(modelConcatName + ".mo", compileDirPath_);
  Trace::info("COMPILE") << DYNLog(GenerateModelicaConcatFile, modelConcatFile, modelID, modelicaModelDescription->getID()) << Trace::endline;
  std::ofstream fOut;

  fOut.open(modelConcatFile.c_str(), std::fstream::out);
  fOut << "model " << modelConcatName << std::endl;

  for (itUnitDynamicModel = unitDynamicModels.begin(); itUnitDynamicModel != unitDynamicModels.end(); ++itUnitDynamicModel) {
    fOut << "  " << itUnitDynamicModel->second->getDynamicModelName() << " " << itUnitDynamicModel->first << "() ;" << std::endl;
    Trace::info("COMPILE") << itUnitDynamicModel->second->getDynamicModelName() << " " << itUnitDynamicModel->first << "() ;" << Trace::endline;
  }
  fOut << "equation" << std::endl;

  vector<shared_ptr<dynamicdata::Connector> >::const_iterator itInternConnect;
  for (itInternConnect = internalConnects.begin(); itInternConnect != internalConnects.end(); ++itInternConnect) {
    fOut << "  connect(" << (*itInternConnect)->getFirstModelId() << "." << (*itInternConnect)->getFirstVariableId()
            << "," << (*itInternConnect)->getSecondModelId() << "." << (*itInternConnect)->getSecondVariableId() << ") ;" << std::endl;
  }

  static const string indexLabel = "@INDEX@";
  static const string nameLabel = "@NAME@";
  // expand macro connect
  vector<shared_ptr<dynamicdata::Connector> > macroConnection;
  for (map<string, shared_ptr<dynamicdata::MacroConnect> >::const_iterator itMC = macroConnects.begin();
      itMC != macroConnects.end(); ++itMC) {
    string connector = itMC->second->getConnector();
    string model1 = itMC->second->getFirstModelId();
    string model2 = itMC->second->getSecondModelId();

    shared_ptr<dynamicdata::MacroConnector> macroConnector = dyd_->getDynamicModelsCollection()->findMacroConnector(connector);

    // for each connect, create a system connect
    map<string, shared_ptr<dynamicdata::MacroConnection> > connectors = macroConnector->getConnectors();
    map<string, shared_ptr<dynamicdata::MacroConnection> >::const_iterator iter = connectors.begin();
    for (; iter != connectors.end(); ++iter) {
      string var1 = iter->second->getFirstVariableId();
      string var2 = iter->second->getSecondVariableId();
      // Greplace @INDEX@ in var1
      if (var1.find(indexLabel) != string::npos) {
        if (itMC->second->getIndex1() == "")
          throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "index1");
        var1.replace(var1.find(indexLabel), indexLabel.size(), itMC->second->getIndex1());
      }

      // replace @INDEX@ in var2
      if (var2.find(indexLabel) != string::npos) {
        if (itMC->second->getIndex2() == "")
          throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "index2");
        var2.replace(var2.find(indexLabel), indexLabel.size(), itMC->second->getIndex2());
      }

      // replace @NAME@ in var1
      if (var1.find(nameLabel) != string::npos) {
        if (itMC->second->getName1() == "")
          throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "name1");
        var1.replace(var1.find(nameLabel), nameLabel.size(), itMC->second->getName1());
      }

      // replace @NAME@ in var2
      if (var2.find(nameLabel) != string::npos) {
        if (itMC->second->getName2() == "")
          throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "index2");
        var2.replace(var2.find(nameLabel), nameLabel.size(), itMC->second->getName2());
      }

      fOut << "  connect(" << model1 << "." << var1 << "," << model2 << "." << var2 << ");" << std::endl;
      macroConnection.push_back(shared_ptr<dynamicdata::Connector>(new dynamicdata::Connector::Impl(model1, var1, model2, var2)));
    }
  }
  fOut << "end " << modelConcatName << ";" << std::endl;
  fOut.close();

  // .extvar file generation
  // only keep external variables for which no internal connect has already been conducted
  shared_ptr<externalVariables::VariablesCollection> modelExternalvariables = externalVariables::VariablesCollectionFactory::newCollection();
  bool atLeastOneExternalVariable = false;
  for (itUnitDynamicModel = unitDynamicModels.begin(); itUnitDynamicModel != unitDynamicModels.end(); ++itUnitDynamicModel) {
    std::string itUnitDynamicModelName = itUnitDynamicModel->first;
    set<string> extVarConnected;
    for (itInternConnect = internalConnects.begin(); itInternConnect != internalConnects.end(); ++itInternConnect) {
      if ((*itInternConnect)->getFirstModelId() == itUnitDynamicModelName)
        extVarConnected.insert((*itInternConnect)->getFirstVariableId());
      if ((*itInternConnect)->getSecondModelId() == itUnitDynamicModelName)
        extVarConnected.insert((*itInternConnect)->getSecondVariableId());
    }

    for (itInternConnect = macroConnection.begin(); itInternConnect != macroConnection.end(); ++itInternConnect) {
      if ((*itInternConnect)->getFirstModelId() ==  itUnitDynamicModelName)
        extVarConnected.insert((*itInternConnect)->getFirstVariableId());
      if ((*itInternConnect)->getSecondModelId() == itUnitDynamicModelName)
        extVarConnected.insert((*itInternConnect)->getSecondVariableId());
    }


    if (allExternalVariables.find(itUnitDynamicModelName) != allExternalVariables.end()) {
      boost::shared_ptr<externalVariables::VariablesCollection> unitModelExternalVariables = allExternalVariables.find(itUnitDynamicModelName)->second;
      for (externalVariables::variable_iterator itExternalVariable = unitModelExternalVariables->beginVariable();
              itExternalVariable != unitModelExternalVariables->endVariable(); ++itExternalVariable) {
        const string& variableName = (*itExternalVariable)->getId();

        // remove all sub-structures from the external variable identifier,
        // in order to retrieve the native Modelica (macro) object name
        string modelicaObjectName = variableName;
        std::size_t found = variableName.find(".");
        if (found != string::npos) {
          modelicaObjectName = variableName.substr(0, found);
        }

        if (extVarConnected.find(modelicaObjectName) == extVarConnected.end()) {
          shared_ptr<externalVariables::Variable> variable = *itExternalVariable;
          variable->setId(itUnitDynamicModelName + "." + variableName);
          modelExternalvariables->addVariable(variable);
          atLeastOneExternalVariable = true;
        }
      }
    }
  }

  if (atLeastOneExternalVariable) {
    const string extVarFlatPath = absolute(modelConcatName + ".extvar", compileDirPath_);
    externalVariables::XmlExporter extVarExporter;
    extVarExporter.exportToFile(*modelExternalvariables, extVarFlatPath);
  }

  // _init.mo file generation
  if (hasInit) {
    string initConcatName = modelConcatName + "_INIT";
    string initConcatFile = absolute(initConcatName + ".mo", compileDirPath_);
    fOut.open(initConcatFile.c_str(), std::fstream::out);
    fOut << "model " << initConcatName << std::endl;
    for (itUnitDynamicModel = unitDynamicModels.begin(); itUnitDynamicModel != unitDynamicModels.end(); ++itUnitDynamicModel) {
      if (itUnitDynamicModel->second->getInitModelName() != "")
        fOut << "  " << itUnitDynamicModel->second->getInitModelName() << " " << itUnitDynamicModel->first << "() ;" << std::endl;
    }
    fOut << "equation" << std::endl;
    map<string, shared_ptr<dynamicdata::Connector> > initConnects;
    if (modelicaModelDescription->getType() == dynamicdata::Model::MODELICA_MODEL) {
      shared_ptr<dynamicdata::ModelicaModel> modelicaModel = dynamic_pointer_cast<dynamicdata::ModelicaModel> (modelicaModelDescription->getModel());
      initConnects = modelicaModel->getInitConnectors();
    } else {
      shared_ptr<dynamicdata::ModelTemplate> modelicaModel = dynamic_pointer_cast<dynamicdata::ModelTemplate> (modelicaModelDescription->getModel());
      initConnects = modelicaModel->getInitConnectors();
    }
    map<string, shared_ptr<dynamicdata::Connector> >::const_iterator itInitConnect;
    for (itInitConnect = initConnects.begin(); itInitConnect != initConnects.end(); ++itInitConnect) {
      fOut << "  connect(" << itInitConnect->second->getFirstModelId() << "." << itInitConnect->second->getFirstVariableId()
              << "," << itInitConnect->second->getSecondModelId() << "." << itInitConnect->second->getSecondVariableId() << ") ;" << std::endl;
    }

    // expand init macro connect
    // expand macro connect
    for (map<string, shared_ptr<dynamicdata::MacroConnect> >::const_iterator itMC = macroConnects.begin();
        itMC != macroConnects.end(); ++itMC) {
      string connector = itMC->second->getConnector();
      string model1 = itMC->second->getFirstModelId();
      string model2 = itMC->second->getSecondModelId();

      shared_ptr<dynamicdata::MacroConnector> macroConnector = dyd_->getDynamicModelsCollection()->findMacroConnector(connector);

      // for each connect, create a system connect
      map<string, shared_ptr<dynamicdata::MacroConnection> > connectors = macroConnector->getInitConnectors();
      map<string, shared_ptr<dynamicdata::MacroConnection> >::const_iterator iter = connectors.begin();
      for (; iter != connectors.end(); ++iter) {
        string var1 = iter->second->getFirstVariableId();
        string var2 = iter->second->getSecondVariableId();
        // replace @INDEX@ in var1
        if (var1.find(indexLabel) != string::npos) {
          if (itMC->second->getIndex1() == "")
            throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "index1");
          var1.replace(var1.find(indexLabel), indexLabel.size(), itMC->second->getIndex1());
        }

        // replace @INDEX@ in var2
        if (var2.find(indexLabel) != string::npos) {
          if (itMC->second->getIndex2() == "")
            throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "index2");
          var2.replace(var2.find(indexLabel), indexLabel.size(), itMC->second->getIndex2());
        }

        // replace @NAME@ in var1
        if (var1.find(nameLabel) != string::npos) {
          if (itMC->second->getName1() == "")
            throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "name1");
          var1.replace(var1.find(nameLabel), nameLabel.size(), itMC->second->getName1());
        }

        // replace @NAME@ in var2
        if (var2.find(nameLabel) != string::npos) {
          if (itMC->second->getName2() == "")
            throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "name2");
          var2.replace(var2.find(nameLabel), nameLabel.size(), itMC->second->getName2());
        }

        fOut << "  connect(" << model1 << "." << var1 << "," << model2 << "." << var2 << ");" << std::endl;
      }
    }
    fOut << "end " << initConcatName << ";" << std::endl;
    fOut.close();
  }
}

void
Compiler::concatRefs() {
  // translate unitDynamic Model name to new unitDynamic Model name
  // reset old static ref and add new static ref
  map<string, shared_ptr<ModelDescription> >::iterator iMd;
  for (iMd = compiledModelDescriptions_.begin(); iMd != compiledModelDescriptions_.end(); ++iMd) {
    shared_ptr<ModelDescription> model = (iMd)->second;

    // --------------------------------
    // retrieve StaticRef elements
    // --------------------------------
    for (dynamicdata::staticRef_const_iterator itSR = model->getModel()->cbeginStaticRef();
          itSR != model->getModel()->cendStaticRef();
          ++itSR) {
      string modelId = model->getID();
      string modelVar = (*itSR)->getModelVar();
      string staticVar = (*itSR)->getStaticVar();

      shared_ptr<StaticRefInterface> newStaticRefInterface(new StaticRefInterface());
      newStaticRefInterface->setModelID(modelId);
      newStaticRefInterface->setModelVar(modelVar);
      newStaticRefInterface->setStaticVar(staticVar);

      model->addStaticRefInterface(newStaticRefInterface);
    }

    // --------------------------------
    // retrieve StaticRef elements from MacroStaticReference
    //---------------------------------
    for (dynamicdata::macroStaticRef_const_iterator itMSR = model->getModel()->cbeginMacroStaticRef();
          itMSR != model->getModel()->cendMacroStaticRef();
          ++itMSR) {
      // use the MacroStaticRef id to find the correspondant MacroStaticReference
      string macroStaticRefId = (*itMSR)->getId();
      shared_ptr<dynamicdata::MacroStaticReference> macroStaticReference = dyd_->getDynamicModelsCollection()->findMacroStaticReference(macroStaticRefId);
      // retrieve the StaticRef elements contained in the MacroStaticRefenence
      for (dynamicdata::staticRef_const_iterator itSR = macroStaticReference->cbeginStaticRef();
          itSR != macroStaticReference->cendStaticRef();
          ++itSR) {
        string modelId = model->getID();
        string modelVar = (*itSR)->getModelVar();
        string staticVar = (*itSR)->getStaticVar();

        shared_ptr<StaticRefInterface> newStaticRefInterface(new StaticRefInterface());
        newStaticRefInterface->setModelID(modelId);
        newStaticRefInterface->setModelVar(modelVar);
        newStaticRefInterface->setStaticVar(staticVar);

        model->addStaticRefInterface(newStaticRefInterface);
      }
    }
  }
}

string
Compiler::connectVariableName(const shared_ptr<ModelDescription>& model, const string& rawVariableName) {
  if (model->getType() == dynamicdata::Model::MODELICA_MODEL) {
    const map<string, shared_ptr<dynamicdata::UnitDynamicModel> > & unitDynamicModels = (dynamic_pointer_cast<dynamicdata::ModelicaModel> (model->getModel()))->getUnitDynamicModels();  // NOLINT(whitespace/line_length)
    return modelicaModelVariableName(rawVariableName, model->getID(), unitDynamicModels);
  } else {
    return rawVariableName;
  }
}

string
Compiler::modelicaModelVariableName(const string& rawVariableName, const string& modelId,
        const map<string, shared_ptr<dynamicdata::UnitDynamicModel> > & unitDynamicModels) {
  map<string, shared_ptr<dynamicdata::UnitDynamicModel> >::const_iterator itUnitDynamicModel;
  for (itUnitDynamicModel = unitDynamicModels.begin(); itUnitDynamicModel != unitDynamicModels.end(); ++itUnitDynamicModel) {
    if (boost::starts_with(rawVariableName, itUnitDynamicModel->first + "_")) {
      string newVariableName = rawVariableName;
      newVariableName.replace(0, itUnitDynamicModel->first.length(), unitDynamicModelsMap_.find(itUnitDynamicModel->second)->second->getId());
      return newVariableName;
    }
  }
  throw DYNError(Error::MODELER, ConnectorVarNotFound, rawVariableName, modelId);
}

void
Compiler::concatConnects() {
  vector <shared_ptr<dynamicdata::Connector> > systemConnects = dyd_->getSystemConnects();
  for (vector <shared_ptr<dynamicdata::Connector> >::const_iterator itConnector = systemConnects.begin();
          itConnector != systemConnects.end(); ++itConnector) {
    shared_ptr<dynamicdata::Connector> connector = *itConnector;
    shared_ptr<ConnectInterface> connect(new ConnectInterface());

    assert((*itConnector)->getFirstModelId() != (*itConnector)->getSecondModelId() && "fully internal connects should not be set with system dynamic connects");

    bool model1Ok = false;
    bool model2Ok = false;

    if (connector->getFirstModelId() == "NETWORK") {
      connect->setConnectedModel1("NETWORK");
      connect->setModel1Var(connector->getFirstVariableId());
      model1Ok = true;
    } else if (connector->getSecondModelId() == "NETWORK") {
      connect->setConnectedModel2("NETWORK");
      connect->setModel2Var(connector->getSecondVariableId());
      model2Ok = true;
    }

    if (compiledModelDescriptions_.find(connector->getFirstModelId()) != compiledModelDescriptions_.end()) {
      connect->setConnectedModel1(connector->getFirstModelId());
      connect->setModel1Var(connectVariableName(compiledModelDescriptions_[connector->getFirstModelId()], connector->getFirstVariableId()));
      model1Ok = true;
    }

    if (compiledModelDescriptions_.find(connector->getSecondModelId()) != compiledModelDescriptions_.end()) {
      connect->setConnectedModel2(connector->getSecondModelId());
      connect->setModel2Var(connectVariableName(compiledModelDescriptions_[connector->getSecondModelId()], connector->getSecondVariableId()));
      model2Ok = true;
    }

    if (!model1Ok || !model2Ok) {
      string unknownModel = (!model1Ok) ? connector->getFirstModelId() : connector->getSecondModelId();
      throw DYNError(Error::MODELER, InvalidDynamicConnect, connector->getFirstModelId(), connector->getFirstVariableId(),
              connector->getSecondModelId(), connector->getSecondVariableId(), unknownModel);
    }

    dyd_->addConnectInterface(connect);
  }
}

}  // namespace DYN
