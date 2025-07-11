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

#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNExecUtils.h"
#include "DYNFileSystemUtils.h"

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
  for (const auto& blackBoxModelDescriptionPair : dyd_->getBlackBoxModelDescriptions())
    compileBlackBoxModelDescription(blackBoxModelDescriptionPair.second);

  for (const auto& modelTemplateDescriptionPair : dyd_->getModelTemplateDescriptionsToBeCompiled())
    compileModelicaModelDescription(modelTemplateDescriptionPair.second);

  // compile model template expansion. compile model template expansion after all the model templates are compiled
  for (const auto& modelTemplateExpansionPair : dyd_->getModelTemplateExpansionDescriptions()) {
    compileModelTemplateExpansionDescription(modelTemplateExpansionPair.second);
  }

  // compile all the reference models from refLib
  for (const auto& referenceModelicaModel : dyd_->getReferenceModelicaModels())
    compileModelicaModelDescription(referenceModelicaModel);

  // in map refMap, the key is the modelicamodel, the value is the reference model
  // for other modelica models, set their libs as their reference models lib; concat parameters; add to compiled lib
  for (const auto&  modelicaModelReferencePair : dyd_->getModelicaModelReferenceMap()) {
    const auto& modelicaModel = modelicaModelReferencePair.first;
    const auto& modelicaModelReference = modelicaModelReferencePair.second;
    const auto& modelicaModelId = modelicaModel->getID();
    const auto& modelicaModelReferenceCompiledModelId = modelicaModelReference->getCompiledModelId();
    if (compiledModelDescriptions_.find(modelicaModelId) == compiledModelDescriptions_.end()) {
      modelicaModel->setLib(modelicaModelReference->getLib());  // set the lib of modelica model as its reference model
      modelicaModel->setCompiledModelId(modelicaModelReferenceCompiledModelId);  // set the compiled model ID as its reference model

      compiledModelDescriptions_[modelicaModelId] = modelicaModel;  // add the modelica model to already compiled lib

      Trace::info(Trace::compile()) << modelicaModelId << " " << DYNLog(CompiledModelID, modelicaModelReferenceCompiledModelId) << Trace::endline;
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
  constexpr bool searchInSubDirsStandardModels = true;
  constexpr bool searchInSubDirsCustomModels = false;
  constexpr bool packageNeedsRecursive = true;
  constexpr bool stopWhenSeePackage = true;
  const string packageName = "package";
  vector <string> fileExtensionsForbiddenXML;
  fileExtensionsForbiddenXML.emplace_back(".desc.xml");
  fileExtensionsForbiddenXML.emplace_back(".cvg.xml");
  const vector<string> noFileExtensionsForbidden;

  // look for standard precompiled models
  if (useStandardPrecompiledModels_) {
    Trace::info(Trace::compile()) << DYNLog(DDBDir, DDBDir) << Trace::endline;
    searchFilesAccordingToExtension(DDBDir, sharedLibraryExtension(), noFileExtensionsForbidden, searchInSubDirsStandardModels, libraryFiles);
  }

  for (const auto& precompiledModelsDirsPath : precompiledModelsDirsPaths_) {
    Trace::info(Trace::compile()) << DYNLog(CustomDir, precompiledModelsDirsPath.path, precompiledModelsExtension_) << Trace::endline;
    searchFilesAccordingToExtension(precompiledModelsDirsPath.path, precompiledModelsExtension_, noFileExtensionsForbidden,
      searchInSubDirsCustomModels, libraryFiles);
  }

  // check for duplicate libs
  for (const auto& libraryFile : libraryFiles) {
    const auto& fileName = fileNameFromPath(libraryFile);
    if (libFiles_.find(fileName) != libFiles_.end()) {
      throw DYNError(Error::MODELER, DuplicateLibFile, fileName);
    }
    libFiles_[fileName] = libraryFile;
    Trace::debug(Trace::compile()) << libraryFile << Trace::endline;
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

  for (const auto& modelicaModelsDirsPath : modelicaModelsDirsPaths_) {
    const auto& modelicaModelsDirPath = modelicaModelsDirsPath.path;
    const bool modelicaModelsDirPathIsRecursive = modelicaModelsDirsPath.isRecursive;
    searchModelsFiles(modelicaModelsDirPath, modelicaModelsExtension_, noFileExtensionsForbidden, pathsToIgnore_,
        modelicaModelsDirPathIsRecursive, !packageNeedsRecursive, stopWhenSeePackage,
            moFilesCompilation_);

    searchModelsFiles(modelicaModelsDirPath, modelicaModelsExtension_, noFileExtensionsForbidden, pathsToIgnore_,
        modelicaModelsDirPathIsRecursive, packageNeedsRecursive, !stopWhenSeePackage,
            moFilesAll_);
    searchModelsFiles(modelicaModelsDirPath, ".extvar", fileExtensionsForbiddenXML, pathsToIgnore_,
        modelicaModelsDirPathIsRecursive, packageNeedsRecursive, !stopWhenSeePackage, extVarFiles_);
  }
  Trace::debug(Trace::compile()) << DYNLog(CompileFiles) << Trace::endline;
  for (const auto& moFileCompilationPair : moFilesCompilation_) {
    Trace::debug(Trace::compile()) << (moFileCompilationPair.second) << Trace::endline;
  }
  Trace::debug(Trace::compile()) << "" << Trace::endline;

  Trace::debug(Trace::compile()) << "External variable files" << Trace::endline;
  for (const auto& extVarFilePair : extVarFiles_) {
    Trace::debug(Trace::compile()) << extVarFilePair.second << Trace::endline;
  }
  Trace::debug(Trace::compile()) << "" << Trace::endline;
}

void
Compiler::compileModelTemplateExpansionDescription(const std::shared_ptr<ModelDescription>& modelTemplateExpansionDescription) {
  if (modelTemplateExpansionDescription->getType() != dynamicdata::Model::MODEL_TEMPLATE_EXPANSION) {
    throw DYNError(Error::MODELER, NotModelTemplateExpansion, modelTemplateExpansionDescription->getID());
  }

  const string id = DYNLog(CompilingModel, modelTemplateExpansionDescription->getID()).str();
  const int l = static_cast<int>(id.size() / 2);
  Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;
  Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
  Trace::info(Trace::compile()) << "¦" << std::setw(50 + l) << id << std::setw(50 - l - 1) << "¦" << Trace::endline;
  Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
  Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;
  const string& modelID = modelTemplateExpansionDescription->getID();
  if (compiledModelDescriptions_.find(modelID) != compiledModelDescriptions_.end()) {
    Trace::info(Trace::compile()) << DYNLog(AlreadyCompiledModel, modelID) << Trace::endline;
    return;
  }

  modelTemplateExpansionDescription->setCompiledModelId(modelID);

  const auto& modelTemplateExpansion =
    std::dynamic_pointer_cast<dynamicdata::ModelTemplateExpansion>(modelTemplateExpansionDescription->getModel());

  const auto& modelTemplateExpansionId = modelTemplateExpansion->getTemplateId();
  if (modelTemplateDescriptions_.find(modelTemplateExpansionId) != modelTemplateDescriptions_.end()) {
    const string& libtmp = modelTemplateDescriptions_[modelTemplateExpansionId]->getLib();
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

  const string id = DYNLog(CompilingModel, blackBoxModelDescription->getID()).str();
  const int l = static_cast<int>(id.size() / 2);
  Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;
  Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
  Trace::info(Trace::compile()) << "¦" << std::setw(50 + l) << id << std::setw(50 - l - 1) << "¦" << Trace::endline;
  Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
  Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;
  const string& modelID = blackBoxModelDescription->getID();
  if (compiledModelDescriptions_.find(modelID) != compiledModelDescriptions_.end()) {
    Trace::info(Trace::compile()) << DYNLog(AlreadyCompiledModel, modelID) << Trace::endline;
    return;
  }

  blackBoxModelDescription->setCompiledModelId(modelID);

  const auto& blackBoxModel = std::dynamic_pointer_cast<dynamicdata::BlackBoxModel>(blackBoxModelDescription->getModel());

  const auto& blackBoxModelLib = blackBoxModel->getLib();
  const string blackBoxModelLibWithExtension = blackBoxModelLib + precompiledModelsExtension_;
  if (libFiles_.find(blackBoxModelLibWithExtension) != libFiles_.end()) {
    blackBoxModelDescription->setLib(libFiles_[blackBoxModelLibWithExtension]);
    Trace::info(Trace::compile()) << DYNLog(SetLib, blackBoxModelLib, libFiles_[blackBoxModelLib]) << Trace::endline;
  } else {
    throw DYNError(Error::MODELER, UnableToFindLib, blackBoxModelLib);
  }

  // Everything is ok -> model added in already compiled models
  compiledModelDescriptions_[modelID] = blackBoxModelDescription;
  blackBoxModelDescription->hasCompiledModel(true);
  Trace::info(Trace::compile()) << DYNLog(BlackBoxModelCompiled, modelID) << Trace::endline;
  Trace::info(Trace::compile()) << DYNLog(CompiledModelID, modelID) << Trace::endline;
}

void
Compiler::compileModelicaModelDescription(const std::shared_ptr<ModelDescription>& modelicaModelDescription) {
  const auto modelicaModelDescriptionType = modelicaModelDescription->getType();
  const auto& modelicaModelDescriptionId = modelicaModelDescription->getID();

  if (modelicaModelDescriptionType != dynamicdata::Model::MODELICA_MODEL
          && modelicaModelDescriptionType != dynamicdata::Model::MODEL_TEMPLATE) {
    throw DYNError(Error::MODELER, NotModelicaModel, modelicaModelDescriptionId);
  }

  const bool isModelTemplate = modelicaModelDescriptionType == dynamicdata::Model::MODEL_TEMPLATE;
  string libName;
  string modelID;
  map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> > unitDynamicModels;
  bool useAliasing;
  bool genCalculatedVariables;
  if (isModelTemplate) {
    // create compiled model for model template
    modelicaModelDescription->hasCompiledModel(true);
    modelicaModelDescription->setCompiledModelId(modelicaModelDescriptionId);
    const auto& modelicaModel = std::dynamic_pointer_cast<dynamicdata::ModelTemplate>(modelicaModelDescription->getModel());
    libName = modelicaModel->getId() + sharedLibraryExtension();
    unitDynamicModels = modelicaModel->getUnitDynamicModels();
    modelID = modelicaModel->getId();
    useAliasing = modelicaModel->getUseAliasing();
    genCalculatedVariables = modelicaModel->getGenerateCalculatedVariables();
  } else {
    // compile(modelicaModel) compile the modelica model already mapped;
    const auto& modelicaModel = std::dynamic_pointer_cast<dynamicdata::ModelicaModel>(modelicaModelDescription->getModel());
    libName = modelicaModel->getId() + sharedLibraryExtension();
    unitDynamicModels = modelicaModel->getUnitDynamicModels();
    modelID = modelicaModel->getId();
    useAliasing = modelicaModel->getUseAliasing();
    genCalculatedVariables = modelicaModel->getGenerateCalculatedVariables();
  }

  const string& thisCompiledId = modelicaModelDescription->getCompiledModelId();

  const string id = DYNLog(CompilingModel, modelicaModelDescriptionId).str();
  const int l = static_cast<int>(id.size() / 2);
  Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;
  Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
  Trace::info(Trace::compile()) << "¦" << std::setw(50 + l) << id << std::setw(50 - l - 1) << "¦" << Trace::endline;
  Trace::info(Trace::compile()) << "¦                                                                                                  ¦" << Trace::endline;
  Trace::info(Trace::compile()) << "====================================================================================================" << Trace::endline;

  // concat models
  concatModel(modelicaModelDescription);  // for .mo, .extvar, -init.mo

  throwIfAllModelicaFilesAreNotAvailable(unitDynamicModels);

  // Compilation and post-treatment on concatenated files
  string installDir = getMandatoryEnvVar("DYNAWO_INSTALL_DIR");
  string compileDirPath = createAbsolutePath(thisCompiledId, modelDirPath_);
  string compileCommand = prettyPath(installDir + "/sbin")
    + "/compileModelicaModel --model " + thisCompiledId + " --model-dir " + modelDirPath_ + " --compilation-dir " + compileDirPath + " --lib " + libName +
    " --useAliasing " + (useAliasing?"true":"false") + " --generateCalculatedVariables " + (genCalculatedVariables?"true":"false");

  if (!moFilesCompilation_.empty()) {
    string moFilesList = "";
    for (std::map<string, string>::const_iterator itFile = moFilesCompilation_.begin(); itFile != moFilesCompilation_.end(); ++itFile) {
      moFilesList += " " + (itFile->second);
    }

    compileCommand += " --moFiles" + moFilesList + " --initFiles" + moFilesList;
  }

  if (!additionalHeaderFiles_.empty()) {
    string additionalHeaderList = "";
    for (const auto& additionalHeaderFile : additionalHeaderFiles_) {
      additionalHeaderList += " " + additionalHeaderFile;
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
  modelicaModelDescription->setLib(lib);

  if (isModelTemplate)
    modelTemplateDescriptions_[modelID] = modelicaModelDescription;

  // Everything is ok -> model added in already compiled models
  compiledModelDescriptions_[modelicaModelDescriptionId] = modelicaModelDescription;
  compiledLib_.push_back(lib);
  Trace::info(Trace::compile()) << DYNLog(CompiledModelID, thisCompiledId) << Trace::endline;
}

void
Compiler::throwIfAllModelicaFilesAreNotAvailable(const map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >& unitDynamicModels) const {
  // Get needed Modelica Model Files list and needed Init ModelFiles list
  vector<string> requiredModelicaFiles;
  for (const auto& unitDynamicModelPair : unitDynamicModels) {
    const auto& unitDynamicModel = unitDynamicModelPair.second;
    string moFileName = unitDynamicModel->getDynamicFileName();
    if (!moFileName.empty() && std::find(requiredModelicaFiles.begin(), requiredModelicaFiles.end(), moFileName) == requiredModelicaFiles.end()) {
      requiredModelicaFiles.push_back(moFileName);
    }

    if (!unitDynamicModel->getInitFileName().empty()) {
      moFileName = unitDynamicModel->getInitFileName();
      if (moFileName.empty() && std::find(requiredModelicaFiles.begin(), requiredModelicaFiles.end(), moFileName) == requiredModelicaFiles.end()) {
        requiredModelicaFiles.push_back(moFileName);
      }
    }
  }

  vector <string> availableModelicaFiles;
  for (const auto& moFilePair : moFilesAll_) {
    const string moFileName = fileNameFromPath(moFilePair.second);
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

  if (!missingModelicaModels.empty()) {
    string missingFiles = "";
    bool firstItem = true;
    for (const auto& missingModelicaModel : missingModelicaModels) {
      if (!firstItem) {
        missingFiles += ",";
      } else {
        firstItem = false;
      }
      missingFiles += " " + missingModelicaModel;
    }
    throw DYNError(Error::MODELER, UnknownModelFile, missingFiles);
  }
}

void
Compiler::concatModel(const std::shared_ptr<ModelDescription>& modelicaModelDescription) {
  const auto modelicaModelDescriptionType = modelicaModelDescription->getType();
  const auto& modelicaModelDescriptionId = modelicaModelDescription->getID();

  if (modelicaModelDescriptionType != dynamicdata::Model::MODELICA_MODEL &&
          modelicaModelDescriptionType != dynamicdata::Model::MODEL_TEMPLATE) {
    throw DYNError(Error::MODELER, ConcatModelNotModelica, modelicaModelDescriptionId);
  }

  map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> > unitDynamicModels;
  map<string, std::shared_ptr<dynamicdata::Connector> > pinConnects;
  map<string, std::shared_ptr<dynamicdata::MacroConnect> > macroConnects;
  string modelID;
  if (modelicaModelDescriptionType == dynamicdata::Model::MODELICA_MODEL) {
    const auto& model = std::dynamic_pointer_cast<dynamicdata::ModelicaModel>(modelicaModelDescription->getModel());
    unitDynamicModels = model->getUnitDynamicModels();
    pinConnects = model->getConnectors();
    modelID = model->getId();
    macroConnects = model->getMacroConnects();
  } else {
    const auto& model = std::dynamic_pointer_cast<dynamicdata::ModelTemplate>(modelicaModelDescription->getModel());
    unitDynamicModels = model->getUnitDynamicModels();
    pinConnects = model->getConnectors();
    modelID = model->getId();
    macroConnects = model->getMacroConnects();
  }

  ///< all external variables (including ones which may have been internally connected)
  map<string, std::shared_ptr<externalVariables::VariablesCollection> > allExternalVariables;
  bool hasInit = false;
  // Go through unit dynamic models to get init models and external variables files
  for (const auto& unitDynamicModelPair : unitDynamicModels) {
    const std::shared_ptr<dynamicdata::UnitDynamicModel>& unitDynamicModel = unitDynamicModelPair.second;
    const string& modelName = unitDynamicModel->getDynamicModelName();
    const string& unitDynamicModelId = unitDynamicModel->getId();
    if (extVarFiles_.find(modelName) != extVarFiles_.end()) {
      Trace::info(Trace::compile()) << DYNLog(ParsingExtVarFile, extVarFiles_[modelName]) << Trace::endline;
      externalVariables::XmlImporter extVarImporter;
      const std::shared_ptr<externalVariables::VariablesCollection> unitModelExternalVariables = extVarImporter.importFromFile(extVarFiles_[modelName]);

      allExternalVariables[unitDynamicModelId] = unitModelExternalVariables;
    } else {
      Trace::info(Trace::compile()) << DYNLog(ExtVarFileNotFound, modelName) << Trace::endline;
    }

    // Test if there is an initialization model for current unit dynamic model
    const string& initName = unitDynamicModel->getInitModelName();
    if (!initName.empty())
      hasInit = true;
  }

  // Go through connects to keep only "internal" ones made at compile time
  vector<std::shared_ptr<dynamicdata::Connector> > internalConnects;
  for (const auto& pinConnectPair : pinConnects) {
    const std::shared_ptr<dynamicdata::Connector>& pinConnect = pinConnectPair.second;

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
  for (const auto& macroConnectPair : macroConnects) {
    const auto& macroConnect = macroConnectPair.second;
    const string& connector = macroConnect->getConnector();
    const string& model1 = macroConnect->getFirstModelId();
    const string& model2 = macroConnect->getSecondModelId();

    const std::shared_ptr<dynamicdata::MacroConnector>& macroConnector = dyd_->getDynamicModelsCollection()->findMacroConnector(connector);
    // for each connect, create a system connect
    for (const auto& macroConnectorConnectorPair : macroConnector->getConnectors()) {
      const auto& macroConnectorConnector = macroConnectorConnectorPair.second;
      string var1 = macroConnectorConnector->getFirstVariableId();
      string var2 = macroConnectorConnector->getSecondVariableId();
      replaceMacroInVariableId(macroConnect->getIndex1(), macroConnect->getName1(), model1, model2, connector, var1);
      replaceMacroInVariableId(macroConnect->getIndex2(), macroConnect->getName2(), model1, model2, connector, var2);

      macroConnection.push_back(boost::make_shared<dynamicdata::Connector>(model1, var1, model2, var2));
    }
  }
}

string
Compiler::writeConcatModelicaFile(const std::string& modelID, const std::shared_ptr<ModelDescription>& modelicaModelDescription,
    const vector<shared_ptr<dynamicdata::Connector> >& macroConnection,
    const map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >& unitDynamicModels,
    const vector<std::shared_ptr<dynamicdata::Connector> >& internalConnects) const {
  const string& modelConcatName = modelicaModelDescription->getCompiledModelId();

  string modelConcatFile = absolute(modelConcatName + ".mo", modelDirPath_);
  Trace::info(Trace::compile()) << DYNLog(GenerateModelicaConcatFile, modelConcatFile, modelID, modelicaModelDescription->getID()) << Trace::endline;
  std::ofstream fOut;

  fOut.open(modelConcatFile.c_str(), std::fstream::out);
  fOut << "model " << modelConcatName << std::endl;

  for (const auto& unitDynamicModelPair : unitDynamicModels) {
    const auto& unitDynamicModel = unitDynamicModelPair.second;
    const auto& unitDynamicModelName = unitDynamicModelPair.first;
    const auto& unitDynamicModelDynamicName = unitDynamicModel->getDynamicModelName();
    fOut << "  " << unitDynamicModelDynamicName << " " << unitDynamicModelName << "() ;" << std::endl;
    Trace::info(Trace::compile()) << unitDynamicModelDynamicName << " " << unitDynamicModelName << "() ;" << Trace::endline;
  }
  fOut << "equation" << std::endl;

  for (const auto& internalConnect : internalConnects) {
    fOut << "  connect(" << internalConnect->getFirstModelId() << "." << internalConnect->getFirstVariableId()
                  << "," << internalConnect->getSecondModelId() << "." << internalConnect->getSecondVariableId() << ") ;" << std::endl;
  }

  // expand macro connect
  for (const auto& internConnect : macroConnection) {
    fOut << "  connect(" << internConnect->getFirstModelId() << "." << internConnect->getFirstVariableId() << ","
        << internConnect->getSecondModelId() << "." << internConnect->getSecondVariableId() << ");" << std::endl;
  }
  fOut << "end " << modelConcatName << ";" << std::endl;
  fOut.close();

  return modelConcatFile;
}

void
Compiler::collectConnectedExtVar(const string& itUnitDynamicModelName,
    const vector<boost::shared_ptr<dynamicdata::Connector> >& macroConnection,
    const vector<std::shared_ptr<dynamicdata::Connector> >& internalConnects, set<string>& extVarConnected) const {
  for (const auto& internalConnect : internalConnects) {
    if (internalConnect->getFirstModelId() == itUnitDynamicModelName)
      extVarConnected.insert(internalConnect->getFirstVariableId());
    if (internalConnect->getSecondModelId() == itUnitDynamicModelName)
      extVarConnected.insert(internalConnect->getSecondVariableId());
  }

  for (const auto& internalConnect : macroConnection) {
    if (internalConnect->getFirstModelId() ==  itUnitDynamicModelName)
      extVarConnected.insert(internalConnect->getFirstVariableId());
    if (internalConnect->getSecondModelId() == itUnitDynamicModelName)
      extVarConnected.insert(internalConnect->getSecondVariableId());
  }
}

struct DiscreteExtVar {
  size_t connectionId;
  string fullVarId;
  std::shared_ptr<externalVariables::Variable> correspondingVar;

  DiscreteExtVar(const size_t id, const string& varId, const std::shared_ptr<externalVariables::Variable>& var):
    connectionId(id), fullVarId(varId), correspondingVar(var) {}

  DiscreteExtVar() : connectionId(0), fullVarId("") {}
};
void
Compiler::writeExtvarFile(const std::shared_ptr<ModelDescription>& modelicaModelDescription,
    const vector<shared_ptr<dynamicdata::Connector> >& macroConnection,
    const map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >& unitDynamicModels,
    const vector<std::shared_ptr<dynamicdata::Connector> >& internalConnects,
    const map<string, std::shared_ptr<externalVariables::VariablesCollection> >& allExternalVariables) const {
  // only keep external variables for which no internal connect has already been conducted
  const std::shared_ptr<externalVariables::VariablesCollection> modelExternalvariables = externalVariables::VariablesCollectionFactory::newCollection();
  bool atLeastOneExternalVariable = false;
  unordered_set<string> extvarIds;
  unordered_map<string, std::shared_ptr<externalVariables::Variable> > connectedDiscreteExtVar;
  for (const auto& unitDynamicModelPair : unitDynamicModels) {
    const string& itUnitDynamicModelName = unitDynamicModelPair.first;
    set<string> extVarConnected;
    collectConnectedExtVar(itUnitDynamicModelName, macroConnection, internalConnects, extVarConnected);

    if (allExternalVariables.find(itUnitDynamicModelName) != allExternalVariables.end()) {
      const std::shared_ptr<externalVariables::VariablesCollection>& unitModelExternalVariables = allExternalVariables.find(itUnitDynamicModelName)->second;
      for (const auto& unitModelExternalVariablePair : unitModelExternalVariables->getVariables()) {
        const auto& externalVariable = unitModelExternalVariablePair.second;
        const string& variableName = externalVariable->getId();

        // remove all sub-structures from the external variable identifier,
        // in order to retrieve the native Modelica (macro) object name
        string modelicaObjectName = variableName;
        string leftovers;
        size_t found = variableName.find('.');
        if (found != string::npos) {
          modelicaObjectName = variableName.substr(0, found);
          leftovers = variableName.substr(found + 1, variableName.size());
        }
        bool foundConnectedExtVar = false;

        while (!foundConnectedExtVar && found != string::npos) {
          if (extVarConnected.find(modelicaObjectName) != extVarConnected.end()) {
            foundConnectedExtVar = true;
            break;
          }
          found = leftovers.find('.');
          if (found != string::npos) {
            modelicaObjectName += "." + leftovers.substr(0, found);
            leftovers = leftovers.substr(found + 1, leftovers.size());
          }
        }

        if (!foundConnectedExtVar && !leftovers.empty())
          modelicaObjectName += "." + leftovers;
        if (!foundConnectedExtVar && extVarConnected.find(modelicaObjectName) != extVarConnected.end()) {
          foundConnectedExtVar = true;
        }
        if (!foundConnectedExtVar) {
          externalVariable->setId(itUnitDynamicModelName + "." + variableName);
          if (extvarIds.find(externalVariable->getId()) == extvarIds.end()) {
            modelExternalvariables->addVariable(externalVariable);
            Trace::info(Trace::compile()) << DYNLog(AddingExtVar, itUnitDynamicModelName + "." + variableName) << Trace::endline;
            atLeastOneExternalVariable = true;
            extvarIds.insert(externalVariable->getId());
          }
        } else if (externalVariable->getType() == externalVariables::Variable::Type::DISCRETE) {
          connectedDiscreteExtVar.insert(std::make_pair(itUnitDynamicModelName + "." + modelicaObjectName, externalVariable));
        }
      }
    }
  }
  size_t index = 0;
  unordered_map<string, DiscreteExtVar> varNameToConnIndex;
  for (const auto& internalConnect : internalConnects) {
    const auto& internalConnectFirstModelId = internalConnect->getFirstModelId();
    const auto& internalConnectFirstVariableId = internalConnect->getFirstVariableId();
    const auto& internalConnectSecondModelId = internalConnect->getSecondModelId();
    const auto& internalConnectSecondVariableId = internalConnect->getSecondVariableId();
    std::string firstVar = internalConnectFirstModelId + "." + internalConnectFirstVariableId;
    std::string secondVar = internalConnectSecondModelId + "." + internalConnectSecondVariableId;
    const auto& it = connectedDiscreteExtVar.find(firstVar);
    const auto& it2 = connectedDiscreteExtVar.find(secondVar);
    if (it != connectedDiscreteExtVar.end() && it2 != connectedDiscreteExtVar.end()) {
      string var1FullName = internalConnectFirstModelId + "." + it->second->getId();
      string var2FullName = internalConnectSecondModelId + "." + it2->second->getId();
      const bool firstVarFound = varNameToConnIndex.find(firstVar) != varNameToConnIndex.end();
      const bool secondVarFound = varNameToConnIndex.find(secondVar) != varNameToConnIndex.end();
      if (firstVarFound && !secondVarFound) {
        varNameToConnIndex.insert(std::make_pair(secondVar, DiscreteExtVar(varNameToConnIndex[firstVar].connectionId, var2FullName, it2->second)));
      } else if (!firstVarFound && secondVarFound) {
        varNameToConnIndex.insert(std::make_pair(firstVar, DiscreteExtVar(varNameToConnIndex[secondVar].connectionId, var1FullName, it->second)));
      } else if (firstVarFound && secondVarFound) {
        size_t indexToKeep = varNameToConnIndex[firstVar].connectionId;
        size_t indexToDrop = varNameToConnIndex[secondVar].connectionId;
        for (auto& varNameToConnIndexPair : varNameToConnIndex) {
          auto& discreteExtVar = varNameToConnIndexPair.second;
          if (discreteExtVar.connectionId == indexToDrop)
            discreteExtVar.connectionId = indexToKeep;
        }
      } else {
        varNameToConnIndex.insert(std::make_pair(firstVar, DiscreteExtVar(index, var1FullName, it->second)));
        varNameToConnIndex.insert(std::make_pair(secondVar, DiscreteExtVar(index, var2FullName, it2->second)));
        ++index;
      }
    }
  }

  for (const auto& internConnect : macroConnection) {
    std::string firstVar = internConnect->getFirstModelId() + "." + internConnect->getFirstVariableId();
    std::string secondVar = internConnect->getSecondModelId() + "." + internConnect->getSecondVariableId();
    const auto& it = connectedDiscreteExtVar.find(firstVar);
    const auto& it2 = connectedDiscreteExtVar.find(secondVar);
    if (it != connectedDiscreteExtVar.end() && it2 != connectedDiscreteExtVar.end()) {
      const bool firstVarFound = varNameToConnIndex.find(firstVar) != varNameToConnIndex.end();
      const bool secondVarFound = varNameToConnIndex.find(secondVar) != varNameToConnIndex.end();
      string var1FullName = internConnect->getFirstModelId() + "." + it->second->getId();
      string var2FullName = internConnect->getSecondModelId() + "." + it2->second->getId();
      if (firstVarFound && !secondVarFound) {
        varNameToConnIndex.insert(std::make_pair(secondVar, DiscreteExtVar(varNameToConnIndex[firstVar].connectionId, var2FullName, it2->second)));
      } else if (!firstVarFound && secondVarFound) {
        varNameToConnIndex.insert(std::make_pair(firstVar, DiscreteExtVar(varNameToConnIndex[secondVar].connectionId, var1FullName, it->second)));
      } else if (firstVarFound && secondVarFound) {
        size_t indexToKeep = varNameToConnIndex[firstVar].connectionId;
        size_t indexToDrop = varNameToConnIndex[secondVar].connectionId;
        for (auto& varNameToConnIndexPair : varNameToConnIndex) {
          auto& discreteExtVar = varNameToConnIndexPair.second;
          if (discreteExtVar.connectionId == indexToDrop)
            discreteExtVar.connectionId = indexToKeep;
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
    for (const auto& varNameToConnIndexPair : varNameToConnIndex) {
      if (varNameToConnIndexPair.second.connectionId == idx) {
        connectedDiscreteVarNames.push_back(varNameToConnIndexPair.first);
      }
    }
    // 2 or more discrete external discrete variables are connected together. We need to keep only one as external variable.
    if (connectedDiscreteVarNames.size() > 1) {
      const string& firstVar = connectedDiscreteVarNames[0];
      if (extvarIds.find(firstVar) == extvarIds.end()) {
        const std::shared_ptr<externalVariables::Variable>& variable = varNameToConnIndex[firstVar].correspondingVar;
        variable->setId(varNameToConnIndex[firstVar].fullVarId);
        modelExternalvariables->addVariable(variable);
        Trace::info(Trace::compile()) << DYNLog(AddingDiscreteExtVar, variable->getId()) << Trace::endline;
        atLeastOneExternalVariable = true;
        extvarIds.insert(variable->getId());
      }
    }
  }

  if (atLeastOneExternalVariable) {
    const string& modelConcatName = modelicaModelDescription->getCompiledModelId();
    const string extVarFlatPath = absolute(modelConcatName + ".extvar", modelDirPath_);
    externalVariables::XmlExporter extVarExporter;
    extVarExporter.exportToFile(*modelExternalvariables, extVarFlatPath);
  }
}

string
Compiler::writeInitFile(const std::shared_ptr<ModelDescription> & modelicaModelDescription,
    const map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >& unitDynamicModels,
    const map<string, std::shared_ptr<dynamicdata::MacroConnect> >& macroConnects) const {
  const string& modelConcatName = modelicaModelDescription->getCompiledModelId();
  const string initConcatName = modelConcatName + "_INIT";
  const string initConcatFile = absolute(initConcatName + ".mo", modelDirPath_);

  std::ofstream fOut;
  fOut.open(initConcatFile.c_str(), std::fstream::out);
  fOut << "model " << initConcatName << std::endl;
  for (const auto& unitDynamicModelPair : unitDynamicModels) {
    const auto& unitDynamicModel = unitDynamicModelPair.second;
    if (!unitDynamicModel->getInitModelName().empty())
      fOut << "  " << unitDynamicModel->getInitModelName() << " " << unitDynamicModelPair.first << "() ;" << std::endl;
  }
  fOut << "equation" << std::endl;
  map<string, std::shared_ptr<dynamicdata::Connector> > initConnects;
  if (modelicaModelDescription->getType() == dynamicdata::Model::MODELICA_MODEL) {
    const auto& modelicaModel = std::dynamic_pointer_cast<dynamicdata::ModelicaModel>(modelicaModelDescription->getModel());
    initConnects = modelicaModel->getInitConnectors();
  } else {
    const auto& modelicaModel = std::dynamic_pointer_cast<dynamicdata::ModelTemplate>(modelicaModelDescription->getModel());
    initConnects = modelicaModel->getInitConnectors();
  }
  for (const auto& initConnectPair : initConnects) {
    const auto& initConnect = initConnectPair.second;
    fOut << "  connect(" << initConnect->getFirstModelId() << "." << initConnect->getFirstVariableId()
                << "," << initConnect->getSecondModelId() << "." << initConnect->getSecondVariableId() << ") ;" << std::endl;
  }

  // expand init macro connect
  // expand macro connect
  for (const auto& macroConnectPair : macroConnects) {
    const auto& macroConnect = macroConnectPair.second;
    const string& connector = macroConnect->getConnector();
    const string& model1 = macroConnect->getFirstModelId();
    const string& model2 = macroConnect->getSecondModelId();

    const std::shared_ptr<dynamicdata::MacroConnector>& macroConnector = dyd_->getDynamicModelsCollection()->findMacroConnector(connector);
    // for each connect, create a system connect
    for (const auto& initConnectorPair : macroConnector->getInitConnectors()) {
      const auto& initConnector = initConnectorPair.second;
      string var1 = initConnector->getFirstVariableId();
      string var2 = initConnector->getSecondVariableId();

      replaceMacroInVariableId(macroConnect->getIndex1(), macroConnect->getName1(), model1, model2, connector, var1);
      replaceMacroInVariableId(macroConnect->getIndex2(), macroConnect->getName2(), model1, model2, connector, var2);

      fOut << "  connect(" << model1 << "." << var1 << "," << model2 << "." << var2 << ");" << std::endl;
    }
  }
  fOut << "end " << initConcatName << ";" << std::endl;
  fOut.close();

  return initConcatFile;
}

void
Compiler::concatRefs() const {
  // translate unitDynamic Model name to new unitDynamic Model name
  // reset old static ref and add new static ref
  for (const auto& compiledModelDescription : compiledModelDescriptions_) {
    const std::shared_ptr<ModelDescription>& model = compiledModelDescription.second;

    // --------------------------------
    // retrieve StaticRef elements
    // --------------------------------
    for (const auto& staticRefPair : model->getModel()->getStaticRefs()) {
      const auto& staticRef = staticRefPair.second;
      string modelId = model->getID();
      string modelVar = staticRef->getModelVar();
      string staticVar = staticRef->getStaticVar();

      shared_ptr<StaticRefInterface> newStaticRefInterface(new StaticRefInterface());
      newStaticRefInterface->setModelID(modelId);
      newStaticRefInterface->setModelVar(modelVar);
      newStaticRefInterface->setStaticVar(staticVar);

      model->addStaticRefInterface(newStaticRefInterface);
    }

    // --------------------------------
    // retrieve StaticRef elements from MacroStaticReference
    //---------------------------------
    for (const auto& macroStaticRefPair : model->getModel()->getMacroStaticRefs()) {
      // use the MacroStaticRef id to find the correspondant MacroStaticReference
      const string& macroStaticRefId = macroStaticRefPair.second->getId();
      const std::shared_ptr<dynamicdata::MacroStaticReference>& macroStaticReference =
        dyd_->getDynamicModelsCollection()->findMacroStaticReference(macroStaticRefId);
      // retrieve the StaticRef elements contained in the MacroStaticRefenence
      for (const auto& staticRefPair : macroStaticReference->getStaticReferences()) {
        const auto& staticRef = staticRefPair.second;
        const string& modelId = model->getID();
        const string& modelVar = staticRef->getModelVar();
        const string& staticVar = staticRef->getStaticVar();

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
Compiler::connectVariableName(const std::shared_ptr<ModelDescription>& model, const string& rawVariableName) const {
  if (model->getType() == dynamicdata::Model::MODELICA_MODEL) {
    const auto& unitDynamicModels = (std::dynamic_pointer_cast<dynamicdata::ModelicaModel> (model->getModel()))->getUnitDynamicModels();
    return modelicaModelVariableName(rawVariableName, model->getID(), unitDynamicModels);
  } else {
    return rawVariableName;
  }
}

string
Compiler::modelicaModelVariableName(const string& rawVariableName, const string& modelId,
        const map<string, std::shared_ptr<dynamicdata::UnitDynamicModel> >& unitDynamicModels) const {
  for (const auto& unitDynamicModelPair : unitDynamicModels) {
    const auto& unitDynamicModelName = unitDynamicModelPair.first;
    const auto& unitDynamicModel = unitDynamicModelPair.second;
    if (boost::starts_with(rawVariableName, unitDynamicModelName + "_")) {
      string newVariableName = rawVariableName;
      newVariableName.replace(0, unitDynamicModelName.length(), unitDynamicModelsMap_.find(unitDynamicModel)->second->getId());
      return newVariableName;
    }
  }
  throw DYNError(Error::MODELER, ConnectorVarNotFound, rawVariableName, modelId);
}

void
Compiler::concatConnects() {
  for (const auto& connector : dyd_->getSystemConnects()) {
    std::unique_ptr<ConnectInterface> connect(new ConnectInterface());

    assert(connector->getFirstModelId() != connector->getSecondModelId() && "fully internal connects should not be set with system dynamic connects");

    bool model1Ok = false;
    bool model2Ok = false;

    const auto& connectorFirstModelId = connector->getFirstModelId();
    const auto& connectorSecondModelId = connector->getSecondModelId();
    const auto& connectorFirstVariableId = connector->getFirstVariableId();
    const auto& connectorSecondVariableId = connector->getSecondVariableId();

    if (connectorFirstModelId == "NETWORK") {
      connect->setConnectedModel1("NETWORK");
      connect->setModel1Var(connectorFirstVariableId);
      model1Ok = true;
    } else if (connectorSecondModelId == "NETWORK") {
      connect->setConnectedModel2("NETWORK");
      connect->setModel2Var(connectorSecondVariableId);
      model2Ok = true;
    }

    if (compiledModelDescriptions_.find(connectorFirstModelId) != compiledModelDescriptions_.end()) {
      connect->setConnectedModel1(connectorFirstModelId);
      connect->setModel1Var(connectVariableName(compiledModelDescriptions_[connectorFirstModelId], connectorFirstVariableId));
      model1Ok = true;
    }

    if (compiledModelDescriptions_.find(connectorSecondModelId) != compiledModelDescriptions_.end()) {
      connect->setConnectedModel2(connectorSecondModelId);
      connect->setModel2Var(connectVariableName(compiledModelDescriptions_[connectorSecondModelId], connectorSecondVariableId));
      model2Ok = true;
    }

    if (!model1Ok || !model2Ok) {
      const string unknownModel = !model1Ok ? connectorFirstModelId : connectorSecondModelId;
      throw DYNError(Error::MODELER, InvalidDynamicConnect, connectorFirstModelId, connectorFirstVariableId,
              connectorSecondModelId, connectorSecondVariableId, unknownModel);
    }

    dyd_->addConnectInterface(std::move(connect));
  }
}

}  // namespace DYN
