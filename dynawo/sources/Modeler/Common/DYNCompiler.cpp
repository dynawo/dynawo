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
#include <set>
#include <memory>
#include <unordered_set>
#include <boost/algorithm/string/replace.hpp>

#include <boost/algorithm/string/predicate.hpp>

#include "DYNStaticRefInterface.h"
#include "DYNConnectInterface.h"
#include "DYNModelDescription.h"
#include "DYNDynamicData.h"
#include "DYNCompiler.h"
#include "DYNCommonModeler.h"

#include "DYDDynamicModelsCollection.h"
#include "DYDModel.h"
#include "DYDModelicaModel.h"
#include "DYDModelTemplate.h"
#include "DYDModelTemplateExpansion.h"
#include "DYDBlackBoxModel.h"
#include "DYDUnitDynamicModel.h"
#include "DYDConnector.h"
#include "DYDMacroConnection.h"
#include "DYDMacroConnector.h"
#include "DYDStaticRef.h"
#include "DYDMacroStaticRef.h"
#include "DYDMacroStaticReference.h"
#include "DYDIterators.h"

#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNExecUtils.h"
#include "DYNFileSystemUtils.h"

#include "EXTVARIterators.h"
#include "EXTVARXmlImporter.h"
#include "EXTVARXmlExporter.h"
#include "EXTVARVariablesCollectionFactory.h"
#include "EXTVARVariable.h"

#include "DYNCommon.h"

using std::map;
using std::string;
using std::stringstream;
using std::set;
using std::vector;

using boost::shared_ptr;
using std::unordered_map;
using std::unordered_set;

namespace DYN {

void
Compiler::compile() {
  getDDB();

  unitDynamicModelsMap_ = dyd_->getUnitDynamicModelsMap();
  const std::map<string, std::shared_ptr<ModelDescription> >& blackboxes = dyd_->getBlackBoxModelDescriptions();
  for (std::map<string, std::shared_ptr<ModelDescription> >::const_iterator itbbm = blackboxes.begin(); itbbm != blackboxes.end(); ++itbbm) {
    compileBlackBoxModelDescription(itbbm->second);
  }

  const std::map<string, std::shared_ptr<ModelDescription> >& modeltemplates = dyd_->getModelTemplateDescriptionsToBeCompiled();
  for (std::map<string, std::shared_ptr<ModelDescription> >::const_iterator itmt = modeltemplates.begin(); itmt != modeltemplates.end(); ++itmt) {
    compileModelicaModelDescription(itmt->second);
  }

  // compile model template expansion. compile model template expansion after all the model templates are compiled
  const std::map<string, std::shared_ptr<ModelDescription> >& modeltemplateExpansions = dyd_->getModelTemplateExpansionDescriptions();
  for (std::map<string, std::shared_ptr<ModelDescription> >::const_iterator itmte = modeltemplateExpansions.begin();
        itmte != modeltemplateExpansions.end(); ++itmte) {
    compileModelTemplateExpansionDescription(itmte->second);
  }

  vector<std::shared_ptr<ModelDescription> > refmodelicas = dyd_->getReferenceModelicaModels();
  // compile all the reference models from refLib
  for (vector<std::shared_ptr<ModelDescription> >::const_iterator itref = refmodelicas.begin(); itref != refmodelicas.end(); ++itref) {
    compileModelicaModelDescription(*itref);
  }

  const std::map<std::shared_ptr<ModelDescription>, std::shared_ptr<ModelDescription> >& modelRefMap = dyd_->getModelicaModelReferenceMap();
  // in map refMap, the key is the modelicamodel, the value is the reference model
  // for other modelica models, set their libs as their reference models lib; concat parameters; add to compiled lib
  for (std::map<std::shared_ptr<ModelDescription>, std::shared_ptr<ModelDescription> >::const_iterator itrefMap = modelRefMap.begin();
        itrefMap != modelRefMap.end(); ++itrefMap) {
    if (compiledModelDescriptions_.find(itrefMap->first->getID()) == compiledModelDescriptions_.end()) {
      itrefMap->first->setLib(itrefMap->second->getLib());  // set the lib of modelica model as its reference model
      itrefMap->first->setCompiledModelId(itrefMap->second->getCompiledModelId());  // set the compiled model ID as its reference model

      compiledModelDescriptions_[itrefMap->first->getID()] = itrefMap->first;  // add the modelica model to already compiled lib

      Trace::info(Trace::compile()) << itrefMap->first->getID() << " " << DYNLog(CompiledModelID, itrefMap->first->getCompiledModelId()) << Trace::endline;
    }
  }

  Trace::info(Trace::compile()) << DYNLog(CompilationDone) << Trace::endline;
}

void
Compiler::getDDB() {
  // Go through DDB and models directories to get available files
  // check that the DDB environment variable was set when it is used
  string DDBDir = "";
  if (useStandardPrecompiledModels_ || useStandardModelicaModels_) {
    DDBDir = getMandatoryEnvVar("DYNAWO_DDB_DIR");
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
    Trace::info(Trace::compile()) << DYNLog(DDBDir, DDBDir) << Trace::endline;
    searchFilesAccordingToExtension(DDBDir, sharedLibraryExtension(), noFileExtensionsForbidden, searchInSubDirsStandardModels, libraryFiles);
  }

  for (vector<UserDefinedDirectory>::const_iterator itDir = precompiledModelsDirsPaths_.begin(); itDir != precompiledModelsDirsPaths_.end(); ++itDir) {
    Trace::info(Trace::compile()) << DYNLog(CustomDir, itDir->path, precompiledModelsExtension_) << Trace::endline;
    searchFilesAccordingToExtension(itDir->path, precompiledModelsExtension_, noFileExtensionsForbidden, searchInSubDirsCustomModels, libraryFiles);
  }

  // check for duplicate libs
  for (vector<string>::const_iterator itFile = libraryFiles.begin(); itFile != libraryFiles.end(); ++itFile) {
    if (libFiles_.find(file_name(*itFile)) != libFiles_.end()) {
      throw DYNError(Error::MODELER, DuplicateLibFile, file_name(*itFile));
    }
    libFiles_[file_name(*itFile)] = *itFile;
    Trace::debug(Trace::compile()) << *itFile << Trace::endline;
  }
  Trace::debug(Trace::compile()) << "" << Trace::endline;

  // look for Modelica models and external variable files
  if (useStandardModelicaModels_) {
    // scan for files required by OMC (i.e. only keep parent package.mo for packages)
    searchModelsFiles(DDBDir, ".mo", noFileExtensionsForbidden, pathsToIgnore_,
        searchInSubDirsStandardModels, !packageNeedsRecursive, stopWhenSeePackage, moFilesCompilation_);

    // scan for all .mo files (for sanity checks purposes)
    searchModelsFiles(DDBDir, ".mo", noFileExtensionsForbidden, pathsToIgnore_,
        searchInSubDirsStandardModels, packageNeedsRecursive, !stopWhenSeePackage, moFilesAll_);

    // scan for all .extvar (external variables files)
    searchModelsFiles(DDBDir, ".extvar", fileExtensionsForbiddenXML, pathsToIgnore_,
        searchInSubDirsStandardModels, packageNeedsRecursive, !stopWhenSeePackage, extVarFiles_);
  }

  for (vector<UserDefinedDirectory>::const_iterator itDir = modelicaModelsDirsPaths_.begin(); itDir != modelicaModelsDirsPaths_.end(); ++itDir) {
    searchModelsFiles(itDir->path, modelicaModelsExtension_, noFileExtensionsForbidden, pathsToIgnore_,
        itDir->isRecursive, !packageNeedsRecursive, stopWhenSeePackage,
            moFilesCompilation_);

    searchModelsFiles(itDir->path, modelicaModelsExtension_, noFileExtensionsForbidden, pathsToIgnore_,
        itDir->isRecursive, packageNeedsRecursive, !stopWhenSeePackage,
            moFilesAll_);
    searchModelsFiles(itDir->path, ".extvar", fileExtensionsForbiddenXML, pathsToIgnore_,
        itDir->isRecursive, packageNeedsRecursive, !stopWhenSeePackage, extVarFiles_);
  }
  Trace::debug(Trace::compile()) << DYNLog(CompileFiles) << Trace::endline;
  for (std::map<string, string>::const_iterator itFile = moFilesCompilation_.begin(); itFile != moFilesCompilation_.end(); ++itFile) {
    Trace::debug(Trace::compile()) << (itFile->second) << Trace::endline;
  }
  Trace::debug(Trace::compile()) << "" << Trace::endline;

  Trace::debug(Trace::compile()) << "External variable files" << Trace::endline;
  for (std::map<string, string>::const_iterator itFile = extVarFiles_.begin(); itFile != extVarFiles_.end(); ++itFile) {
    Trace::debug(Trace::compile()) << itFile->second << Trace::endline;
  }
  Trace::debug(Trace::compile()) << "" << Trace::endline;
}

void
Compiler::compileModelTemplateExpansionDescription(const std::shared_ptr<ModelDescription>& modelTemplateExpansionDescription) {
  if (modelTemplateExpansionDescription->getType() != dynamicdata::Model::MODEL_TEMPLATE_EXPANSION) {
    throw DYNError(Error::MODELER, NotModelTemplateExpansion, modelTemplateExpansionDescription->getID());
  }

  string id = DYNLog(CompilingModel, modelTemplateExpansionDescription->getID()).str();
  int l = static_cast<int>(id.size() / 2);
  Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;
  Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
  Trace::info(Trace::compile()) << "¦" << std::setw(50 + l) << id << std::setw(50 - l - 1) << "¦" << Trace::endline;
  Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
  Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;
  string modelID(modelTemplateExpansionDescription->getID());
  if (compiledModelDescriptions_.find(modelID) != compiledModelDescriptions_.end()) {
    Trace::info(Trace::compile()) << DYNLog(AlreadyCompiledModel, modelID) << Trace::endline;
    return;
  }

  modelTemplateExpansionDescription->setCompiledModelId(modelID);

  std::shared_ptr<dynamicdata::ModelTemplateExpansion> modelTemplateExpansion;
  modelTemplateExpansion = std::dynamic_pointer_cast<dynamicdata::ModelTemplateExpansion>(modelTemplateExpansionDescription->getModel());


  if (modelTemplateDescriptions_.find(modelTemplateExpansion->getTemplateId()) != modelTemplateDescriptions_.end()) {
    string libtmp = modelTemplateDescriptions_[ modelTemplateExpansion->getTemplateId() ]->getLib();
    Trace::info(Trace::compile()) <<  DYNLog(SetLib, modelTemplateExpansion->getTemplateId(), libtmp) << Trace::endline;
    modelTemplateExpansionDescription->setLib(libtmp);
  } else {
    throw DYNError(Error::MODELER, UnableToFindLib, modelTemplateExpansion->getTemplateId());
  }

  // Everything is ok -> model added in already compiled models
  compiledModelDescriptions_[modelID] = modelTemplateExpansionDescription;
  modelTemplateExpansionDescription->hasCompiledModel(true);
  Trace::info(Trace::compile()) << DYNLog(ModelTemplateExpansionCompiled, modelID) << Trace::endline;
  Trace::info(Trace::compile()) << DYNLog(CompiledModelID, modelID) << Trace::endline;
}

void
Compiler::compileBlackBoxModelDescription(const std::shared_ptr<ModelDescription>& blackBoxModelDescription) {
  if (blackBoxModelDescription->getType() != dynamicdata::Model::BLACK_BOX_MODEL) {
    throw DYNError(Error::MODELER, NotBlackBoxModel, blackBoxModelDescription->getID());
  }

  string id = DYNLog(CompilingModel, blackBoxModelDescription->getID()).str();
  int l = static_cast<int>(id.size() / 2);
  Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;
  Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
  Trace::info(Trace::compile()) << "¦" << std::setw(50 + l) << id << std::setw(50 - l - 1) << "¦" << Trace::endline;
  Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
  Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;
  string modelID(blackBoxModelDescription->getID());
  if (compiledModelDescriptions_.find(modelID) != compiledModelDescriptions_.end()) {
    Trace::info(Trace::compile()) << DYNLog(AlreadyCompiledModel, modelID) << Trace::endline;
    return;
  }

  blackBoxModelDescription->setCompiledModelId(modelID);

  std::shared_ptr<dynamicdata::BlackBoxModel> blackBoxModel = std::dynamic_pointer_cast<dynamicdata::BlackBoxModel>(blackBoxModelDescription->getModel());

  if (libFiles_.find(blackBoxModel->getLib() + precompiledModelsExtension_) != libFiles_.end()) {
    blackBoxModelDescription->setLib(libFiles_[blackBoxModel->getLib() + precompiledModelsExtension_]);
    Trace::info(Trace::compile()) << DYNLog(SetLib, blackBoxModel->getLib(), libFiles_[blackBoxModel->getLib()]) << Trace::endline;
  } else {
    throw DYNError(Error::MODELER, UnableToFindLib, blackBoxModel->getLib());
  }

  // Everything is ok -> model added in already compiled models
  compiledModelDescriptions_[modelID] = blackBoxModelDescription;
  blackBoxModelDescription->hasCompiledModel(true);
  Trace::info(Trace::compile()) << DYNLog(BlackBoxModelCompiled, modelID) << Trace::endline;
  Trace::info(Trace::compile()) << DYNLog(CompiledModelID, modelID) << Trace::endline;
}

void
Compiler::compileModelicaModelDescription(const std::shared_ptr<ModelDescription>& modelDescription) {
  if (modelDescription->getType() != dynamicdata::Model::MODELICA_MODEL
          && modelDescription->getType() != dynamicdata::Model::MODEL_TEMPLATE) {
    throw DYNError(Error::MODELER, NotModelicaModel, modelDescription->getID());
  }

  bool isModelTemplate = modelDescription->getType() == dynamicdata::Model::MODEL_TEMPLATE;
  string libName;
  string modelID;
  map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> > unitDynamicModels;
  bool useAliasing = true;
  bool genCalculatedVariables = true;
  if (isModelTemplate) {
    // create compiled model for model template
    modelDescription->hasCompiledModel(true);
    modelDescription->setCompiledModelId(modelDescription->getID());
    std::shared_ptr<dynamicdata::ModelTemplate> modelicaModel = std::dynamic_pointer_cast<dynamicdata::ModelTemplate>(modelDescription->getModel());
    libName = modelicaModel->getId() + sharedLibraryExtension();
    unitDynamicModels = modelicaModel->getUnitDynamicModels();
    modelID = modelicaModel->getId();
    useAliasing = modelicaModel->getUseAliasing();
    genCalculatedVariables = modelicaModel->getGenerateCalculatedVariables();
  } else {
    // compile(modelicaModel) compile the modelica model already mapped;
    std::shared_ptr<dynamicdata::ModelicaModel> modelicaModel = std::dynamic_pointer_cast<dynamicdata::ModelicaModel>(modelDescription->getModel());
    libName = modelicaModel->getId() + sharedLibraryExtension();
    unitDynamicModels = modelicaModel->getUnitDynamicModels();
    modelID = modelicaModel->getId();
    useAliasing = modelicaModel->getUseAliasing();
    genCalculatedVariables = modelicaModel->getGenerateCalculatedVariables();
  }

  string thisCompiledId = modelDescription->getCompiledModelId();

  string id = DYNLog(CompilingModel, modelDescription->getID()).str();
  int l = static_cast<int>(id.size() / 2);
  Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;
  Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
  Trace::info(Trace::compile()) << "¦" << std::setw(50 + l) << id << std::setw(50 - l - 1) << "¦" << Trace::endline;
  Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
  Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;

  // concat models
  concatModel(modelDescription);  // for .mo, .extvar, -init.mo

  throwIfAllModelicaFilesAreNotAvailable(unitDynamicModels);

  // Compilation and post-treatment on concatenated files
  string installDir = getMandatoryEnvVar("DYNAWO_INSTALL_DIR");
  string compileDirPath = createAbsolutePath(thisCompiledId, modelDirPath_);
  string compileCommand = prettyPath(installDir + "/sbin")
    + "/compileModelicaModel --model " + thisCompiledId + " --model-dir " + modelDirPath_ + " --compilation-dir " + compileDirPath + " --lib " + libName +
    " --useAliasing " + (useAliasing?"true":"false") + " --generateCalculatedVariables " + (genCalculatedVariables?"true":"false");

  if (moFilesCompilation_.size() > 0) {
    string moFilesList = "";
    for (std::map<string, string>::const_iterator itFile = moFilesCompilation_.begin(); itFile != moFilesCompilation_.end(); ++itFile) {
      moFilesList += " " + (itFile->second);
    }

    compileCommand += " --moFiles" + moFilesList + " --initFiles" + moFilesList;
  }

  if (!additionalHeaderFiles_.empty()) {
    string additionalHeaderList = "";
    for (std::size_t i = 0, iEnd = additionalHeaderFiles_.size(); i < iEnd; ++i) {
      additionalHeaderList += " " + additionalHeaderFiles_[i];
    }

    compileCommand += " --additionalHeaderList" + additionalHeaderList;
  }

  Trace::info(Trace::compile()) << DYNLog(CompileCommmand, compileCommand) << Trace::endline;

  stringstream ss;
  executeCommand(compileCommand, ss);
  Trace::info(Trace::compile()) << ss.str() << Trace::endline;

#ifdef __linux__
    bool hasUndefinedSymbol = (ss.str().find("undefined symbol") != string::npos);
#else
  bool hasUndefinedSymbol = false;
#endif

  // testing if the lib was successfully compiled (test if it exists, and if no undefined symbol was noticed)
  string lib = absolute(libName, modelDirPath_);
  if ((!exists(lib)) || hasUndefinedSymbol)
    throw DYNError(Error::MODELER, CompilationFailed, libName);

#ifdef _DEBUG_
  static_cast<void>(rmModels_);  // shut up clang -Wunused-private-field
#else
  // remove .mo, -init.mo
  if (rmModels_) {
    remove(modelConcatFile_);
    remove(initConcatFile_);
  }
#endif

  Trace::info(Trace::compile()) << DYNLog(SetLib, modelID, lib) << Trace::endline;
  modelDescription->setLib(lib);

  if (isModelTemplate)
    modelTemplateDescriptions_[modelID] = modelDescription;

  // Everything is ok -> model added in already compiled models
  compiledModelDescriptions_[modelDescription->getID()] = modelDescription;
  compiledLib_.push_back(lib);
  Trace::info(Trace::compile()) << DYNLog(CompiledModelID, modelDescription->getCompiledModelId()) << Trace::endline;
}

void
Compiler::throwIfAllModelicaFilesAreNotAvailable(const map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >& unitDynamicModels) const {
  // Get needed Modelica Model Files list and needed Init ModelFiles list
  vector <string> requiredModelicaFiles;
  for (map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >::const_iterator itUdm = unitDynamicModels.begin();
        itUdm != unitDynamicModels.end();
        ++itUdm) {
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
}

void
Compiler::concatModel(const std::shared_ptr<ModelDescription>& modelicaModelDescription) {
  if (modelicaModelDescription->getType() != dynamicdata::Model::MODELICA_MODEL &&
          modelicaModelDescription->getType() != dynamicdata::Model::MODEL_TEMPLATE) {
    throw DYNError(Error::MODELER, ConcatModelNotModelica, modelicaModelDescription->getID());
  }

  map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> > unitDynamicModels;
  map<string, std::shared_ptr<dynamicdata::Connector> > pinConnects;
  map<string, std::shared_ptr<dynamicdata::MacroConnect> > macroConnects;
  string modelID;
  if (modelicaModelDescription->getType() == dynamicdata::Model::MODELICA_MODEL) {
    std::shared_ptr<dynamicdata::ModelicaModel> model = std::dynamic_pointer_cast<dynamicdata::ModelicaModel>(modelicaModelDescription->getModel());
    unitDynamicModels = model->getUnitDynamicModels();
    pinConnects = model->getConnectors();
    modelID = model->getId();
    macroConnects = model->getMacroConnects();
  } else {
    std::shared_ptr<dynamicdata::ModelTemplate> model = std::dynamic_pointer_cast<dynamicdata::ModelTemplate>(modelicaModelDescription->getModel());
    unitDynamicModels = model->getUnitDynamicModels();
    pinConnects = model->getConnectors();
    modelID = model->getId();
    macroConnects = model->getMacroConnects();
  }

  ///< all external variables (including ones which may have been internally connected)
  map<string, std::shared_ptr<externalVariables::VariablesCollection> > allExternalVariables;
  bool hasInit = false;
  // Go through unit dynamic models to get init models and external variables files
  map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >::const_iterator itUnitDynamicModel;
  for (itUnitDynamicModel = unitDynamicModels.begin(); itUnitDynamicModel != unitDynamicModels.end(); ++itUnitDynamicModel) {
    std::shared_ptr<dynamicdata::UnitDynamicModel> unitDynamicModel = itUnitDynamicModel->second;
    string modelName = unitDynamicModel->getDynamicModelName();
    if (extVarFiles_.find(modelName) != extVarFiles_.end()) {
      Trace::info(Trace::compile()) << DYNLog(ParsingExtVarFile, extVarFiles_[modelName]) << Trace::endline;
      externalVariables::XmlImporter extVarImporter;
      std::shared_ptr<externalVariables::VariablesCollection> unitModelExternalVariables = extVarImporter.importFromFile(extVarFiles_[modelName]);

      allExternalVariables[unitDynamicModel->getId()] = unitModelExternalVariables;
    } else {
      Trace::info(Trace::compile()) << DYNLog(ExtVarFileNotFound, modelName) << Trace::endline;
    }

    // Test if there is an initialization model for current unit dynamic model
    string initName = unitDynamicModel->getInitModelName();
    if (initName != "")
      hasInit = true;
  }

  // Go through connects to keep only "internal" ones made at compile time
  vector<std::shared_ptr<dynamicdata::Connector> > internalConnects;
  for (map<string, std::shared_ptr<dynamicdata::Connector> >::const_iterator itPinConnect = pinConnects.begin();
      itPinConnect != pinConnects.end(); ++itPinConnect) {
    std::shared_ptr<dynamicdata::Connector> pinConnect = itPinConnect->second;

    if (unitDynamicModels.find(pinConnect->getFirstModelId()) != unitDynamicModels.end() &&
        unitDynamicModels.find(pinConnect->getSecondModelId()) != unitDynamicModels.end()) {
      internalConnects.push_back(pinConnect);
    }
  }

  vector<shared_ptr<dynamicdata::Connector> > macroConnection;
  collectMacroConnections(macroConnects, macroConnection);
  // .mo file generation
  modelConcatFile_ = writeConcatModelicaFile(modelID, modelicaModelDescription, macroConnection,
      unitDynamicModels, internalConnects);

  // .extvar file generation
  writeExtvarFile(modelicaModelDescription, macroConnection,
      unitDynamicModels, internalConnects, allExternalVariables);

  // _init.mo file generation
  initConcatFile_ = "";
  if (hasInit) {
    initConcatFile_ = writeInitFile(modelicaModelDescription, unitDynamicModels, macroConnects);
  }
}

void
Compiler::collectMacroConnections(const map<string, std::shared_ptr<dynamicdata::MacroConnect> >& macroConnects,
    vector<shared_ptr<dynamicdata::Connector> >& macroConnection) const {
  for (map<string, std::shared_ptr<dynamicdata::MacroConnect> >::const_iterator itMC = macroConnects.begin();
      itMC != macroConnects.end(); ++itMC) {
    string connector = itMC->second->getConnector();
    string model1 = itMC->second->getFirstModelId();
    string model2 = itMC->second->getSecondModelId();

    std::shared_ptr<dynamicdata::MacroConnector> macroConnector = dyd_->getDynamicModelsCollection()->findMacroConnector(connector);
    // for each connect, create a system connect
    const map<string, std::unique_ptr<dynamicdata::MacroConnection> >& connectors = macroConnector->getConnectors();
    for (map<string, std::unique_ptr<dynamicdata::MacroConnection> >::const_iterator iter = connectors.begin();
        iter != connectors.end(); ++iter) {
      string var1 = iter->second->getFirstVariableId();
      string var2 = iter->second->getSecondVariableId();
      replaceMacroInVariableId(itMC->second->getIndex1(), itMC->second->getName1(), model1, model2, connector, var1);
      replaceMacroInVariableId(itMC->second->getIndex2(), itMC->second->getName2(), model1, model2, connector, var2);

      macroConnection.push_back(shared_ptr<dynamicdata::Connector>(new dynamicdata::Connector(model1, var1, model2, var2)));
    }
  }
}

const string
Compiler::writeConcatModelicaFile(const std::string& modelID, const std::shared_ptr<ModelDescription>& modelicaModelDescription,
    const vector<shared_ptr<dynamicdata::Connector> >& macroConnection,
    const map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >& unitDynamicModels,
    const vector<std::shared_ptr<dynamicdata::Connector> >& internalConnects) const {
  string modelConcatName = modelicaModelDescription->getCompiledModelId();

  string modelConcatFile = absolute(modelConcatName + ".mo", modelDirPath_);
  Trace::info(Trace::compile()) << DYNLog(GenerateModelicaConcatFile, modelConcatFile, modelID, modelicaModelDescription->getID()) << Trace::endline;
  std::ofstream fOut;

  fOut.open(modelConcatFile.c_str(), std::fstream::out);
  fOut << "model " << modelConcatName << std::endl;

  for (map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >::const_iterator itUnitDynamicModel =
      unitDynamicModels.begin(); itUnitDynamicModel != unitDynamicModels.end(); ++itUnitDynamicModel) {
    fOut << "  " << itUnitDynamicModel->second->getDynamicModelName() << " " << itUnitDynamicModel->first << "() ;" << std::endl;
    Trace::info(Trace::compile()) << itUnitDynamicModel->second->getDynamicModelName() << " " << itUnitDynamicModel->first << "() ;" << Trace::endline;
  }
  fOut << "equation" << std::endl;

  for (vector<std::shared_ptr<dynamicdata::Connector> >::const_iterator itInternConnect = internalConnects.begin();
      itInternConnect != internalConnects.end(); ++itInternConnect) {
    fOut << "  connect(" << (*itInternConnect)->getFirstModelId() << "." << (*itInternConnect)->getFirstVariableId()
                  << "," << (*itInternConnect)->getSecondModelId() << "." << (*itInternConnect)->getSecondVariableId() << ") ;" << std::endl;
  }

  // expand macro connect
  for (vector<shared_ptr<dynamicdata::Connector> >::const_iterator itInternConnect = macroConnection.begin();
      itInternConnect != macroConnection.end(); ++itInternConnect) {
    fOut << "  connect(" << (*itInternConnect)->getFirstModelId() << "." << (*itInternConnect)->getFirstVariableId() << ","
        << (*itInternConnect)->getSecondModelId() << "." << (*itInternConnect)->getSecondVariableId() << ");" << std::endl;
  }
  fOut << "end " << modelConcatName << ";" << std::endl;
  fOut.close();

  return modelConcatFile;
}

void
Compiler::collectConnectedExtVar(string itUnitDynamicModelName,
    const vector<boost::shared_ptr<dynamicdata::Connector> >& macroConnection,
    const vector<std::shared_ptr<dynamicdata::Connector> >& internalConnects, set<string>& extVarConnected) const {
  for (vector<std::shared_ptr<dynamicdata::Connector> >::const_iterator itInternConnect = internalConnects.begin();
      itInternConnect != internalConnects.end(); ++itInternConnect) {
    if ((*itInternConnect)->getFirstModelId() == itUnitDynamicModelName)
      extVarConnected.insert((*itInternConnect)->getFirstVariableId());
    if ((*itInternConnect)->getSecondModelId() == itUnitDynamicModelName)
      extVarConnected.insert((*itInternConnect)->getSecondVariableId());
  }

  for (vector<shared_ptr<dynamicdata::Connector> >::const_iterator itInternConnect = macroConnection.begin();
      itInternConnect != macroConnection.end(); ++itInternConnect) {
    if ((*itInternConnect)->getFirstModelId() ==  itUnitDynamicModelName)
      extVarConnected.insert((*itInternConnect)->getFirstVariableId());
    if ((*itInternConnect)->getSecondModelId() == itUnitDynamicModelName)
      extVarConnected.insert((*itInternConnect)->getSecondVariableId());
  }
}

struct DiscreteExtVar {
  size_t connectionId;
  string fullVarId;
  std::shared_ptr<externalVariables::Variable> correspondingVar;

  DiscreteExtVar(size_t id, string varId, std::shared_ptr<externalVariables::Variable> var):
    connectionId(id), fullVarId(varId), correspondingVar(var) {}

  DiscreteExtVar():fullVarId(0) {}
};
void
Compiler::writeExtvarFile(const std::shared_ptr<ModelDescription>& modelicaModelDescription,
    const vector<shared_ptr<dynamicdata::Connector> >& macroConnection,
    const map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >& unitDynamicModels,
    const vector<std::shared_ptr<dynamicdata::Connector> >& internalConnects,
    const map<string, std::shared_ptr<externalVariables::VariablesCollection> >& allExternalVariables) const {
  // only keep external variables for which no internal connect has already been conducted
  shared_ptr<externalVariables::VariablesCollection> modelExternalvariables = externalVariables::VariablesCollectionFactory::newCollection();
  bool atLeastOneExternalVariable = false;
  unordered_set<string> extvarIds;
  unordered_map<string, std::shared_ptr<externalVariables::Variable> > connectedDiscreteExtVar;
  for (map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >::const_iterator itUnitDynamicModel = unitDynamicModels.begin();
      itUnitDynamicModel != unitDynamicModels.end(); ++itUnitDynamicModel) {
    string itUnitDynamicModelName = itUnitDynamicModel->first;
    set<string> extVarConnected;
    collectConnectedExtVar(itUnitDynamicModelName, macroConnection, internalConnects, extVarConnected);

    if (allExternalVariables.find(itUnitDynamicModelName) != allExternalVariables.end()) {
      std::shared_ptr<externalVariables::VariablesCollection> unitModelExternalVariables = allExternalVariables.find(itUnitDynamicModelName)->second;
      for (externalVariables::variable_iterator itExternalVariable = unitModelExternalVariables->beginVariable();
          itExternalVariable != unitModelExternalVariables->endVariable(); ++itExternalVariable) {
        const string& variableName = (*itExternalVariable)->getId();

        // remove all sub-structures from the external variable identifier,
        // in order to retrieve the native Modelica (macro) object name
        string modelicaObjectName = variableName;
        string leftovers;
        size_t found = variableName.find(".");
        if (found != string::npos) {
          modelicaObjectName = variableName.substr(0, found);
          leftovers = variableName.substr(found+1, variableName.size());
        }
        bool foundConnectedExtVar = false;

        while (!foundConnectedExtVar && found != string::npos) {
          if (extVarConnected.find(modelicaObjectName) != extVarConnected.end()) {
            foundConnectedExtVar = true;
            break;
          }
          found = leftovers.find(".");
          if (found != string::npos) {
            modelicaObjectName += "."+leftovers.substr(0, found);
            leftovers = leftovers.substr(found+1, leftovers.size());
          }
        }

        if (!foundConnectedExtVar && !leftovers.empty())
          modelicaObjectName += "."+leftovers;
        if (!foundConnectedExtVar && extVarConnected.find(modelicaObjectName) != extVarConnected.end()) {
          foundConnectedExtVar = true;
        }
        if (!foundConnectedExtVar) {
          std::shared_ptr<externalVariables::Variable> variable = *itExternalVariable;
          variable->setId(itUnitDynamicModelName + "." + variableName);
          if (extvarIds.find(variable->getId()) == extvarIds.end()) {
            modelExternalvariables->addVariable(variable);
            Trace::info(Trace::compile()) << DYNLog(AddingExtVar, itUnitDynamicModelName + "." + variableName) << Trace::endline;
            atLeastOneExternalVariable = true;
            extvarIds.insert(variable->getId());
          }
        } else if ((*itExternalVariable)->getType() == externalVariables::Variable::Type::DISCRETE) {
          connectedDiscreteExtVar.insert(std::make_pair(itUnitDynamicModelName + "." + modelicaObjectName, *itExternalVariable));
        }
      }
    }
  }
  size_t index = 0;
  unordered_map<string, DiscreteExtVar> varNameToConnIndex;
  for (vector<std::shared_ptr<dynamicdata::Connector> >::const_iterator itInternConnect = internalConnects.begin();
      itInternConnect != internalConnects.end(); ++itInternConnect) {
    std::string firstVar = (*itInternConnect)->getFirstModelId()+"."+(*itInternConnect)->getFirstVariableId();
    unordered_map<string, std::shared_ptr<externalVariables::Variable> >::const_iterator it = connectedDiscreteExtVar.find(firstVar);
    std::string secondVar = (*itInternConnect)->getSecondModelId()+"."+(*itInternConnect)->getSecondVariableId();
    unordered_map<string, std::shared_ptr<externalVariables::Variable> >::const_iterator it2 = connectedDiscreteExtVar.find(secondVar);
    if (it != connectedDiscreteExtVar.end() && it2 != connectedDiscreteExtVar.end()) {
      string var1FullName = (*itInternConnect)->getFirstModelId()+"."+it->second->getId();
      string var2FullName = (*itInternConnect)->getSecondModelId()+"."+it2->second->getId();
      bool firstVarFound = (varNameToConnIndex.find(firstVar) != varNameToConnIndex.end());
      bool secondVarFound = (varNameToConnIndex.find(secondVar) != varNameToConnIndex.end());
      if (firstVarFound && !secondVarFound) {
        varNameToConnIndex.insert(std::make_pair(secondVar, DiscreteExtVar(varNameToConnIndex[firstVar].connectionId, var2FullName, it2->second)));
      } else if (!firstVarFound && secondVarFound) {
        varNameToConnIndex.insert(std::make_pair(firstVar, DiscreteExtVar(varNameToConnIndex[secondVar].connectionId, var1FullName, it->second)));
      } else if (firstVarFound && secondVarFound) {
        size_t indexToKeep = varNameToConnIndex[firstVar].connectionId;
        size_t indexToDrop = varNameToConnIndex[secondVar].connectionId;
        for (unordered_map<string, DiscreteExtVar>::iterator itVarName = varNameToConnIndex.begin(), itVarNameEnd = varNameToConnIndex.end();
            itVarName != itVarNameEnd; ++itVarName) {
          if (itVarName->second.connectionId == indexToDrop)
            itVarName->second.connectionId = indexToKeep;
        }
      } else {
        varNameToConnIndex.insert(std::make_pair(firstVar, DiscreteExtVar(index, var1FullName, it->second)));
        varNameToConnIndex.insert(std::make_pair(secondVar, DiscreteExtVar(index, var2FullName, it2->second)));
        ++index;
      }
    }
  }

  for (vector<shared_ptr<dynamicdata::Connector> >::const_iterator itInternConnect = macroConnection.begin();
      itInternConnect != macroConnection.end(); ++itInternConnect) {
    std::string firstVar = (*itInternConnect)->getFirstModelId()+"."+(*itInternConnect)->getFirstVariableId();
    unordered_map<string, std::shared_ptr<externalVariables::Variable> >::const_iterator it = connectedDiscreteExtVar.find(firstVar);
    std::string secondVar = (*itInternConnect)->getSecondModelId()+"."+(*itInternConnect)->getSecondVariableId();
    unordered_map<string, std::shared_ptr<externalVariables::Variable> >::const_iterator it2 = connectedDiscreteExtVar.find(secondVar);
    if (it != connectedDiscreteExtVar.end() && it2 != connectedDiscreteExtVar.end()) {
      bool firstVarFound = (varNameToConnIndex.find(firstVar) != varNameToConnIndex.end());
      bool secondVarFound = (varNameToConnIndex.find(secondVar) != varNameToConnIndex.end());
      string var1FullName = (*itInternConnect)->getFirstModelId()+"."+it->second->getId();
      string var2FullName = (*itInternConnect)->getSecondModelId()+"."+it2->second->getId();
      if (firstVarFound && !secondVarFound) {
        varNameToConnIndex.insert(std::make_pair(secondVar, DiscreteExtVar(varNameToConnIndex[firstVar].connectionId, var2FullName, it2->second)));
      } else if (!firstVarFound && secondVarFound) {
        varNameToConnIndex.insert(std::make_pair(firstVar, DiscreteExtVar(varNameToConnIndex[secondVar].connectionId, var1FullName, it->second)));
      } else if (firstVarFound && secondVarFound) {
        size_t indexToKeep = varNameToConnIndex[firstVar].connectionId;
        size_t indexToDrop = varNameToConnIndex[secondVar].connectionId;
        for (unordered_map<string, DiscreteExtVar>::iterator itVarName = varNameToConnIndex.begin(), itVarNameEnd = varNameToConnIndex.end();
            itVarName != itVarNameEnd; ++itVarName) {
          if (itVarName->second.connectionId == indexToDrop)
            itVarName->second.connectionId = indexToKeep;
        }
      } else {
        varNameToConnIndex.insert(std::make_pair(firstVar, DiscreteExtVar(index, var1FullName, it->second)));
        varNameToConnIndex.insert(std::make_pair(secondVar, DiscreteExtVar(index, var2FullName, it2->second)));
        ++index;
      }
    }
  }

  for (size_t idx = 0; idx < index; ++idx) {
    vector<string> connectedDiscreteVarNames;
    for (unordered_map<string, DiscreteExtVar>::const_iterator it = varNameToConnIndex.begin(), itEnd = varNameToConnIndex.end();
        it != itEnd; ++it) {
      if (it->second.connectionId == idx) {
        connectedDiscreteVarNames.push_back(it->first);
      }
    }
    // 2 or more discrete external discrete variables are connected together. We need to keep only one as external variable.
    if (connectedDiscreteVarNames.size() > 1) {
      string firstVar = connectedDiscreteVarNames[0];
      if (extvarIds.find(firstVar) == extvarIds.end()) {
        std::shared_ptr<externalVariables::Variable> variable = varNameToConnIndex[firstVar].correspondingVar;
        variable->setId(varNameToConnIndex[firstVar].fullVarId);
        modelExternalvariables->addVariable(variable);
        Trace::info(Trace::compile()) << DYNLog(AddingDiscreteExtVar, variable->getId()) << Trace::endline;
        atLeastOneExternalVariable = true;
        extvarIds.insert(variable->getId());
      }
    }
  }

  if (atLeastOneExternalVariable) {
    string modelConcatName = modelicaModelDescription->getCompiledModelId();
    const string extVarFlatPath = absolute(modelConcatName + ".extvar", modelDirPath_);
    externalVariables::XmlExporter extVarExporter;
    extVarExporter.exportToFile(*modelExternalvariables, extVarFlatPath);
  }
}

const string
Compiler::writeInitFile(const std::shared_ptr<ModelDescription>& modelicaModelDescription,
    const map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >& unitDynamicModels,
    const map<string, std::shared_ptr<dynamicdata::MacroConnect> >& macroConnects) const {
  string modelConcatName = modelicaModelDescription->getCompiledModelId();
  string initConcatName = modelConcatName + "_INIT";
  string initConcatFile = absolute(initConcatName + ".mo", modelDirPath_);

  std::ofstream fOut;
  fOut.open(initConcatFile.c_str(), std::fstream::out);
  fOut << "model " << initConcatName << std::endl;
  for (map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >::const_iterator itUnitDynamicModel = unitDynamicModels.begin();
      itUnitDynamicModel != unitDynamicModels.end(); ++itUnitDynamicModel) {
    if (itUnitDynamicModel->second->getInitModelName() != "")
      fOut << "  " << itUnitDynamicModel->second->getInitModelName() << " " << itUnitDynamicModel->first << "() ;" << std::endl;
  }
  fOut << "equation" << std::endl;
  map<string, std::shared_ptr<dynamicdata::Connector> > initConnects;
  if (modelicaModelDescription->getType() == dynamicdata::Model::MODELICA_MODEL) {
    std::shared_ptr<dynamicdata::ModelicaModel> modelicaModel = std::dynamic_pointer_cast<dynamicdata::ModelicaModel>(modelicaModelDescription->getModel());
    initConnects = modelicaModel->getInitConnectors();
  } else {
    std::shared_ptr<dynamicdata::ModelTemplate> modelicaModel = std::dynamic_pointer_cast<dynamicdata::ModelTemplate>(modelicaModelDescription->getModel());
    initConnects = modelicaModel->getInitConnectors();
  }
  for (map<string, std::shared_ptr<dynamicdata::Connector> >::const_iterator itInitConnect = initConnects.begin();
      itInitConnect != initConnects.end(); ++itInitConnect) {
    fOut << "  connect(" << itInitConnect->second->getFirstModelId() << "." << itInitConnect->second->getFirstVariableId()
                << "," << itInitConnect->second->getSecondModelId() << "." << itInitConnect->second->getSecondVariableId() << ") ;" << std::endl;
  }

  // expand init macro connect
  // expand macro connect
  for (map<string, std::shared_ptr<dynamicdata::MacroConnect> >::const_iterator itMC = macroConnects.begin();
      itMC != macroConnects.end(); ++itMC) {
    string connector = itMC->second->getConnector();
    string model1 = itMC->second->getFirstModelId();
    string model2 = itMC->second->getSecondModelId();

    std::shared_ptr<dynamicdata::MacroConnector> macroConnector = dyd_->getDynamicModelsCollection()->findMacroConnector(connector);
    // for each connect, create a system connect
    const map<string, std::unique_ptr<dynamicdata::MacroConnection> >& connectors = macroConnector->getInitConnectors();
    for (map<string, std::unique_ptr<dynamicdata::MacroConnection> >::const_iterator iter = connectors.begin();
        iter != connectors.end(); ++iter) {
      string var1 = iter->second->getFirstVariableId();
      string var2 = iter->second->getSecondVariableId();

      replaceMacroInVariableId(itMC->second->getIndex1(), itMC->second->getName1(), model1, model2, connector, var1);
      replaceMacroInVariableId(itMC->second->getIndex2(), itMC->second->getName2(), model1, model2, connector, var2);

      fOut << "  connect(" << model1 << "." << var1 << "," << model2 << "." << var2 << ");" << std::endl;
    }
  }
  fOut << "end " << initConcatName << ";" << std::endl;
  fOut.close();

  return initConcatFile;
}

void
Compiler::concatRefs() {
  // translate unitDynamic Model name to new unitDynamic Model name
  // reset old static ref and add new static ref
  map<string, std::shared_ptr<ModelDescription> >::iterator iMd;
  for (iMd = compiledModelDescriptions_.begin(); iMd != compiledModelDescriptions_.end(); ++iMd) {
    std::shared_ptr<ModelDescription> model = iMd->second;

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
      std::shared_ptr<dynamicdata::MacroStaticReference> macroStaticReference = dyd_->getDynamicModelsCollection()->findMacroStaticReference(macroStaticRefId);
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
Compiler::connectVariableName(const std::shared_ptr<ModelDescription>& model, const string& rawVariableName) {
  if (model->getType() == dynamicdata::Model::MODELICA_MODEL) {
    const map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >& unitDynamicModels = (std::dynamic_pointer_cast<dynamicdata::ModelicaModel>(model->getModel()))->getUnitDynamicModels();  // NOLINT(whitespace/line_length)
    return modelicaModelVariableName(rawVariableName, model->getID(), unitDynamicModels);
  } else {
    return rawVariableName;
  }
}

string
Compiler::modelicaModelVariableName(const string& rawVariableName, const string& modelId,
        const map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >& unitDynamicModels) {
  map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >::const_iterator itUnitDynamicModel;
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
  const vector<std::shared_ptr<dynamicdata::Connector> >& systemConnects = dyd_->getSystemConnects();
  for (vector<std::shared_ptr<dynamicdata::Connector> >::const_iterator itConnector = systemConnects.begin();
          itConnector != systemConnects.end(); ++itConnector) {
    std::shared_ptr<dynamicdata::Connector> connector = *itConnector;
    std::unique_ptr<ConnectInterface> connect(new ConnectInterface());

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

    dyd_->addConnectInterface(std::move(connect));
  }
}

}  // namespace DYN
