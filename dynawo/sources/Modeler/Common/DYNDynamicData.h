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
 * @file DYNDynamicData.h
 * @brief Dynawo data structure header file
 */
#ifndef MODELER_COMMON_DYNDYNAMICDATA_H_
#define MODELER_COMMON_DYNDYNAMICDATA_H_

#include "DYNConnectInterface.h"
#include "DYDBlackBoxModel.h"
#include "PARParameter.h"

#include <map>
#include <set>
#include <string>
#include <vector>
#include <unordered_map>
#include <boost/shared_ptr.hpp>
#include <boost/noncopyable.hpp>

namespace parameters {
class ParametersSet;
class ParametersSetCollection;
}  // namespace parameters

namespace dynamicdata {
class DynamicModelsCollection;
class UnitDynamicModel;
class Model;
class Connector;
class NetworkConnector;
}  // namespace dynamicdata

namespace DYN {
class ModelDescription;
class SubModel;
class DataInterface;

/**
 * @class DynamicData
 * @brief Dynamic Data container class
 */
class DynamicData : public boost::noncopyable {
 public:
  /**
   * @brief initiation dynamic data from dyd files
   * @param fileNames the path to the file from which to build the dynamic data model
   * fills the dynamic data object or may throw exceptions
   */
  void initFromDydFiles(const std::vector <std::string>& fileNames);

  /**
  * @brief set of dynamic models collection
  * @param dynamicModelsCollection the dynamic data model
  */
  void setDynamicModelsCollection(const boost::shared_ptr<dynamicdata::DynamicModelsCollection>& dynamicModelsCollection);

  /**
   * @brief get network parameters from a directory
   * @param parFile parameter file
   * @param parSet parameter set
   */
  void getNetworkParameters(const std::string& parFile, const std::string& parSet);

  /**
   * @brief set network parameters
   * @param parameters parameters set
   */
  inline void setNetworkParameters(const std::shared_ptr<parameters::ParametersSet>& parameters) {
    networkParameters_ = parameters;
  }

  /**
   * @brief get network parameters
   * @returns parameters set
   */
  inline const std::shared_ptr<parameters::ParametersSet>& getNetworkParameters() const {
    return networkParameters_;
  }

  /**
   * @brief initialize the parameter sets that were already read
   * @param parametersRef filepath->parameter sets collection
   */
  inline void setParametersReference(const std::unordered_map<std::string, std::shared_ptr<parameters::ParametersSetCollection> >& parametersRef) {
    referenceParameters_ = parametersRef;
  }

  /**
   * @brief get all dynamic model descriptions
   * @return list of model descriptions
   */
  inline const std::map<std::string, std::shared_ptr<ModelDescription> >& getModelDescriptions() const {
    return modelDescriptions_;
  }

  /**
   * @brief get all system-wide (i.e. not within Modelica model) connects
   * @return list of connects
   */
  inline const std::vector<std::shared_ptr<dynamicdata::Connector> >& getSystemConnects() const {
    return systemConnects_;
  }

  /**
   * @brief add a connect interface to the list of all connectors
   *
   * @param connect connect interface to add
   */
  void addConnectInterface(std::unique_ptr<ConnectInterface> connect);

  /**
   * @brief return the list of all connectors
   * @return list of all connectors
   */
  inline const std::map<std::string, std::unique_ptr<ConnectInterface> >& getConnectInterfaces() const {
    return connects_;
  }

  /**
   * @brief set static data
   * @param data static data
   */
  inline void setDataInterface(const boost::shared_ptr<DataInterface>& data) {
    dataInterface_ = data;
  }

  /**
   * @brief find a set of parameters thanks to its file and its id
   * read the file if it's not already read
   * @param modelId : parent model id
   * @param parFile : file of the set of parameters
   * @param parId : id of the set of parameters
   * @return set of the parameters associate to the file and the id
   */
  std::shared_ptr<parameters::ParametersSet> getParametersSet(const std::string& modelId, const std::string& parFile, const std::string& parId);

 public:
  /**
   * @brief get black box model descriptions
   * @return list of black box model descriptions
   */
  inline const std::map<std::string, std::shared_ptr<ModelDescription> >& getBlackBoxModelDescriptions() const {
    return blackBoxModels_;
  }

  /**
   * @brief get model template expansion descriptions
   * @return list of model template expansion descriptions
   */
  inline const std::map<std::string, std::shared_ptr<ModelDescription> >& getModelTemplateExpansionDescriptions() const {
    return modelTemplateExpansions_;
  }

  /**
   * @brief get model template descriptions to be compiled
   * @return list of model template descriptions to be compiled
   */
  inline const std::map<std::string, std::shared_ptr<ModelDescription> >& getModelTemplateDescriptionsToBeCompiled() const {
    return usefulModelTemplates_;
  }

  /**
   * @brief get unit dynamic models map
   * @return map of unit dynamic models
   */
  inline const std::map<std::shared_ptr<dynamicdata::UnitDynamicModel>, std::shared_ptr<dynamicdata::UnitDynamicModel> >& getUnitDynamicModelsMap() const {
    return unitDynamicModelsMap_;
  }

  /**
   * @brief get modelica model reference map
   * @return map of modelica model reference
   */
  inline const std::map<std::shared_ptr<ModelDescription>, std::shared_ptr<ModelDescription> >& getModelicaModelReferenceMap() const {
    return modelicaModelReferenceMap_;
  }

  /**
   * @brief get reference modelica models
   * @return list of reference modelica models
   */
  inline std::vector<std::shared_ptr<ModelDescription> > getReferenceModelicaModels() const {
    return referenceModelicaModels_;
  }

  /**
   * @brief set the directory to use as root when reading dyd file
   * @param rootDirectory directory to use as root
   */
  inline void setRootDirectory(const std::string& rootDirectory) {
    rootDirectory_ = rootDirectory;
  }

  /**
   * @brief get the current dynamicModelsCollection used
   * @return the current dynamicModelsCollection used
   */
  inline const boost::shared_ptr<dynamicdata::DynamicModelsCollection>& getDynamicModelsCollection() {
    return dynamicModelsCollection_;
  }

 private:
  /**
   * @brief resolve par references by creating one parameter per reference in modelSet
   * @param model model which references in parameters set have to be resolved
   * @param modelSet model parameters set
   */
  void resolveParReferences(const std::shared_ptr<dynamicdata::Model>& model,
                            const std::shared_ptr<parameters::ParametersSet>& modelSet);

  /**
   * @brief create model descriptions
   */
  void createModelDescriptions();

  /**
   * @brief merge unit dynamic models parameters in one set of parameters
   * @param concatParams : set of parameters where udm parameters should be merged
   * @param udmName : name of the unit dynamic model
   * @param udmSet : set of parameters associated to the unit dynamic model
   */
  void mergeParameters(const std::shared_ptr<parameters::ParametersSet>& concatParams, const std::string& udmName,
                       const std::shared_ptr<parameters::ParametersSet>& udmSet);

  /**
   * @brief associate set of parameters with models descriptions
   */
  void associateParameters();

  /**
   * @brief analyse dynamic data
   */
  void analyzeDynamicData();

  /**
   * @brief create a reference modelica models map. mark modelica models with the same structure.
   */
  void markModelTemplatesCalledByExpansions();

  /**
   * @brief mark model Templates called by model template expansions, saved them in a map.
   */
  void mappingModelicaModels();

 private:
  std::string rootDirectory_;  ///< directory to use as root when reading file
  std::unordered_map<std::string,
          std::shared_ptr<parameters::ParametersSetCollection> > referenceParameters_;  ///< association between file name and parameters collection

  boost::shared_ptr<dynamicdata::DynamicModelsCollection> dynamicModelsCollection_;  ///< dynamic models collection, input from API DYD

  boost::shared_ptr<DataInterface> dataInterface_;  ///< static data interface
  std::shared_ptr<parameters::ParametersSet> networkParameters_;  ///< network parameters

  /// warning : keep map container to be sure that models are always sorted with the same order whatever is the order in input file to avoid mathematical issues
  std::map<std::string, std::shared_ptr<ModelDescription> > modelDescriptions_;  ///< map of model descriptions
  std::vector<std::shared_ptr<dynamicdata::Connector> > systemConnects_;  ///< connects which are not fully inside a model
  std::map<std::string, std::unique_ptr<ConnectInterface> > connects_;  ///< connects interfaces

  // generate by classifyModelDescriptions in DydAnalyser
  std::map<std::string, std::shared_ptr<ModelDescription> > modelicaModels_;  ///< modelica models presented in dynamic data
  std::map<std::string, std::shared_ptr<ModelDescription> > blackBoxModels_;  ///< black box models presented in dynamic data
  std::map<std::string, std::shared_ptr<ModelDescription> > modelTemplateExpansions_;  ///< model templates expansions presented in dynamic data
  std::map<std::string, std::shared_ptr<ModelDescription> > modelTemplates_;  ///< model templates presented in dynamic data

  // generate by markModelTemplatesCalledByExpansions in DydAnalyser
  std::map<std::string, std::shared_ptr<ModelDescription> > usefulModelTemplates_;  ///< useful model template called by at least one expansion
  // generate by mappingModelicaModels in DydAnalyser
  std::map< std::shared_ptr<dynamicdata::UnitDynamicModel>,
            std::shared_ptr<dynamicdata::UnitDynamicModel> > unitDynamicModelsMap_;  ///< map of unit dynamic model between two composed modelica models
  std::vector<std::shared_ptr<ModelDescription> > mappedModelDescriptions_;  ///< model descriptions already mapped
  std::map< std::shared_ptr<ModelDescription>,
            std::shared_ptr<ModelDescription> > modelicaModelReferenceMap_;  ///< map between a modelica model and its reference modelica model descriptions
  std::vector<std::shared_ptr<ModelDescription> > referenceModelicaModels_;  ///< reference modelica models descriptions list
};  ///< Dynamic data class

}  // namespace DYN

#endif  // MODELER_COMMON_DYNDYNAMICDATA_H_
