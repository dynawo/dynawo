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
 * @file DYDModelicaModelImpl.h
 * @brief Modelica model description : header file
 *
 */

#ifndef API_DYD_DYDMODELICAMODELIMPL_H_
#define API_DYD_DYDMODELICAMODELIMPL_H_

#include "DYDModelicaModel.h"
#include "DYDModelImpl.h"
#include "DYDIterators.h"

namespace dynamicdata {
class UnitDynamicModel;
class Connector;
class MacroConnect;

/**
 * @class ModelicaModel::Impl
 * @brief Unit Dynamic model implemented class
 *
 * Modelica model is a model that is composed of multiple models
 * Connected together. It also declares ports for external
 * connections.
 */
class ModelicaModel::Impl : public ModelicaModel, public Model::Impl {
 public:
  /**
   * @brief ModelicaModel constructor
   *
   * ModelicaModel constructor.
   *
   * @param id Dynamic model ID
   *
   * @returns New ModelicaModel::Impl instance with given attributes
   */
  explicit Impl(const std::string& id);

  /**
   * @brief ModelicaModel destructor
   */
  ~Impl();

  /**
   * @copydoc ModelicaModel::getStaticId()
   */
  std::string getStaticId() const;

  /**
   * @copydoc ModelicaModel::setStaticId(const std::string& staticId);
   */
  ModelicaModel& setStaticId(const std::string& staticId);

  /**
   * @copydoc ModelicaModel::setCompilationOptions(bool useAliasing, bool generateCalculatedVariables)
   */
  void setCompilationOptions(bool useAliasing, bool generateCalculatedVariables);

  /**
   * @copydoc ModelicaModel::getUseAliasing() const
   */
  bool getUseAliasing() const;

  /**
   * @copydoc ModelicaModel::getGenerateCalculatedVariables() const
   */
  bool getGenerateCalculatedVariables() const;

  /**
   * @copydoc ModelicaModel::getUnitDynamicModels()
   */
  const std::map<std::string, boost::shared_ptr<UnitDynamicModel> >& getUnitDynamicModels() const;

  /**
   * @copydoc ModelicaModel::addUnitDynamicModel()
   */
  ModelicaModel& addUnitDynamicModel(const boost::shared_ptr<UnitDynamicModel>& unitDynamicModel);

  /**
   * @copydoc ModelicaModel::getConnectors()
   */
  const std::map<std::string, boost::shared_ptr<Connector> >& getConnectors() const;

  /**
   * @copydoc ModelicaModel::getInitConnectors()
   */
  const std::map<std::string, boost::shared_ptr<Connector> >& getInitConnectors() const;

  /**
   * @copydoc ModelicaModel::getMacroConnects()
   */
  const std::map<std::string, boost::shared_ptr<MacroConnect> >& getMacroConnects() const;

  /**
   * @copydoc ModelicaModel::addInitConnect()
   */
  ModelicaModel& addInitConnect(const std::string& modelid1, const std::string& var1,
          const std::string& modelid2, const std::string& var2);

  /**
   * @copydoc ModelicaModel::addMacroConnect()
   */
  ModelicaModel& addMacroConnect(const boost::shared_ptr<MacroConnect>& macroConnect);

  /**
   * @copydoc ModelicaModel::addConnect()
   */
  ModelicaModel& addConnect(const std::string& model1, const std::string& var1,
          const std::string& model2, const std::string& var2);

  /**
   * @copydoc ModelicaModel::hasSameStructureAs()
   */
  bool hasSameStructureAs(const boost::shared_ptr<ModelicaModel>& modelicaModel,
          std::map<boost::shared_ptr<UnitDynamicModel>, boost::shared_ptr<UnitDynamicModel> >& unitDynamicModelsMap_);

  /**
   * @copydoc Model::getId()
   */
  std::string getId() const;

  /**
   * @copydoc Model::getType()
   */
  Model::ModelType getType() const;

  /**
   * @copydoc Model::addStaticRef(const std::string& var, const std::string& staticVar)
   */
  Model& addStaticRef(const std::string& var, const std::string& staticVar);

  /**
   * @copydoc Model::addMacroStaticRef(const boost::shared_ptr<MacroStaticRef>& macroStaticRef)
   */
  void addMacroStaticRef(const boost::shared_ptr<MacroStaticRef>& macroStaticRef);

  /**
   * @copydoc Model::beginStaticRef()
   */
  staticRef_iterator beginStaticRef();

  /**
   * @copydoc Model::endStaticRef()
   */
  staticRef_iterator endStaticRef();

  /**
   * @copydoc Model::beginMacroStaticRef()
   */
  macroStaticRef_iterator beginMacroStaticRef();

  /**
   * @copydoc Model::endMacroStaticRef()
   */
  macroStaticRef_iterator endMacroStaticRef();

  /**
   * @copydoc Model::cbeginStaticRef() const
   */
  staticRef_const_iterator cbeginStaticRef() const;

  /**
   * @copydoc Model::cendStaticRef() const
   */
  staticRef_const_iterator cendStaticRef() const;

  /**
   * @copydoc Model::cbeginMacroStaticRef() const
   */
  macroStaticRef_const_iterator cbeginMacroStaticRef() const;

  /**
   * @copydoc Model::cendMacroStaticRef() const
   */
  macroStaticRef_const_iterator cendMacroStaticRef() const;

  /**
   * @copydoc Model::findStaticRef()
   */
  const boost::shared_ptr<StaticRef>& findStaticRef(const std::string& key);

  /**
   * @copydoc Model::findMacroStaticRef()
   */
  const boost::shared_ptr<MacroStaticRef>& findMacroStaticRef(const std::string& id);

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  /**
   * @brief test equivalence of modelica models if there is no connection
   *
   * @param modelicaModel reference modelica model
   * @param unitDynModelsMap unit dynamic models map
   * @param modelsName1 local map: model[ID] = Name
   * @param modelsInitName1 local map: model[ID] = InitName
   * @param modelsName2 map: model[ID] = Name for modelicaModel
   * @param modelsInitName2 map: model[ID] = InitName for modelicaModel
   *
   * @returns true if this has the same structure as modelicaModel, false otherwise
   */
  bool hasSameStructureAsUnconnected(const boost::shared_ptr<ModelicaModel>& modelicaModel,
      std::map< boost::shared_ptr<UnitDynamicModel>, boost::shared_ptr<UnitDynamicModel> >& unitDynModelsMap,
      const std::map<std::string, std::string >& modelsName1, const std::map<std::string, std::string >& modelsInitName1,
      const std::map<std::string, std::string >& modelsName2, const std::map<std::string, std::string >& modelsInitName2) const;

  /**
   * @brief test equivalence of connection names
   *
   * @param modelicaModel reference modelica model
   * @param modelsName1 local map: model[ID] = Name
   * @param modelsName2 map: model[ID] = Name for modelicaModel
   *
   * @returns true if the connection names are equivalent, false otherwise
   */
  bool connectionStringIdentical(const boost::shared_ptr<ModelicaModel>& modelicaModel,
      const std::map<std::string, std::string >& modelsName1, const std::map<std::string, std::string >& modelsName2) const;

  /**
   * @brief Check whether the different types of Init connected variables involve in the same amount of UDMs between two modelica models
   *
   * @param modelicaModel reference modelica model
   * @param modelsName1 local map: model[ID] = Name
   * @param modelsName2 map: model[ID] = Name for modelicaModel
   *
   * @returns true if the different types of Init connected variables involve in the same amount of UDMs, false otherwise
   */
  bool initConnectIdentical(const boost::shared_ptr<ModelicaModel>& modelicaModel,
      const std::map<std::string, std::string >& modelsName1, const std::map<std::string, std::string >& modelsName2) const;

  /**
   * @brief Check whether the different types of Pin connected variables involve in the same amount of UDMs between two modelica models
   *
   * @param modelicaModel reference modelica model
   * @param modelsName1 local map: model[ID] = Name
   * @param modelsName2 map: model[ID] = Name for modelicaModel
   *
   * @returns true if the different types of Pin connected variables involve in the same amount of UDMs, false otherwise
   */
  bool connectIdentical(const boost::shared_ptr<ModelicaModel>& modelicaModel,
      const std::map<std::string, std::string >& modelsName1, const std::map<std::string, std::string >& modelsName2) const;

  /**
   * @brief Check whether the Init connected UDMs are the same between two modelica models
   *
   * @param modelicaModel reference modelica model
   * @param modelsInitName1 local map: model[ID] = InitName
   * @param modelsInitName2 map: model[ID] = InitName for modelicaModel
   * @param localUnitDynamicModelsMap map: output - map UDM model at side1 to  UDM model at side2
   *
   * @returns true if the Init connected UDMs are the same, false otherwise
   */
  bool initConnectDynamicMappingIdentical(const boost::shared_ptr<ModelicaModel>& modelicaModel,
      const std::map<std::string, std::string >& modelsInitName1,
      const std::map<std::string, std::string >& modelsInitName2,
      std::map<boost::shared_ptr<UnitDynamicModel>, boost::shared_ptr<UnitDynamicModel> >& localUnitDynamicModelsMap) const;

  /**
   * @brief Check whether the connected UDMs are the same between two modelica models
   *
   * @param modelicaModel reference modelica model
   * @param modelsName1 local map: model[ID] = Name
   * @param modelsName2 map: model[ID] = Name for modelicaModel
   * @param localUnitDynamicModelsMap map: output - map UDM model at side1 to  UDM model at side2
   *
   * @returns true if the connected UDMs are the same, false otherwise
   */
  bool connectDynamicMappingIdentical(const boost::shared_ptr<ModelicaModel>& modelicaModel,
      const std::map<std::string, std::string >& modelsName1, const std::map<std::string, std::string >& modelsName2,
      std::map<boost::shared_ptr<UnitDynamicModel>, boost::shared_ptr<UnitDynamicModel> >& localUnitDynamicModelsMap) const;

  /**
   * @brief Check whether the macro connected UDMs are the same between two modelica models
   *
   * @param modelicaModel reference modelica model
   * @param modelsName1 local map: model[ID] = Name
   * @param modelsName2 map: model[ID] = Name for modelicaModel
   * @param localUnitDynamicModelsMap map: output - map UDM model at side1 to  UDM model at side2
   *
   * @returns true if the macro connected UDMs are the same, false otherwise
   */
  bool macroConnectDynamicMappingIdentical(const boost::shared_ptr<ModelicaModel>& modelicaModel,
      const std::map<std::string, std::string >& modelsName1, const std::map<std::string, std::string >& modelsName2,
      std::map<boost::shared_ptr<UnitDynamicModel>, boost::shared_ptr<UnitDynamicModel> >& localUnitDynamicModelsMap) const;

 private:
  std::string staticId_;  ///< Identifiable device modeled by dynamic model
  bool useAliasing_;  ///< true if OpenModelica aliasing is used
  bool generateCalculatedVariables_;  ///< true if calculated variables are computed automatically for compiled models
  std::map<std::string, boost::shared_ptr<UnitDynamicModel> > unitDynamicModelsMap_;  ///< Unit Dynamic model parts
  std::map<std::string, boost::shared_ptr<Connector> > initConnectorsMap_;  ///< Unit Dynamic model initialization connectors
  std::map<std::string, boost::shared_ptr<Connector> > connectorsMap_;  ///<  model connectors
  std::map<std::string, boost::shared_ptr<MacroConnect> > macroConnectsMap_;  ///< model macro connects
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMODELICAMODELIMPL_H_
