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
 * @file DYDModelicaModel.h
 * @brief Modelica model description : interface file
 *
 */

#ifndef API_DYD_DYDMODELICAMODEL_H_
#define API_DYD_DYDMODELICAMODEL_H_

#include "DYDConnector.h"
#include "DYDMacroConnect.h"
#include "DYDModel.h"
#include "DYDUnitDynamicModel.h"

#include <boost/shared_ptr.hpp>
#include <map>
#include <vector>

namespace dynamicdata {

/**
 * @class ModelicaModel
 * @brief Modelica model interface class
 *
 * Modelica model is a model that is composed of multiple models
 * Connected together. It also declares ports for external
 * connections.
 */
class ModelicaModel : public Model {
 public:
  /**
   * @brief ModelicaModel constructor
   *
   * ModelicaModel constructor.
   *
   * @param id Dynamic model ID
   *
   */
  explicit ModelicaModel(const std::string& id);

  /**
   * @brief Destructor
   */
  virtual ~ModelicaModel() = default;

  /**
   * @brief Network Identifiable device modeled getter

   * @returns Id of Network Identifiable device modeled
   */
  const std::string& getStaticId() const;

  /**
   * @brief Network Identifiable device modeled setter
   *
   * @param[in] staticId of modeledDevice Network Identifiable device modeled
   * @returns Reference to current Model instance
   */
  ModelicaModel& setStaticId(const std::string& staticId);

  /**
   * @brief Set compilation options
   * @param useAliasing activate OpenModelica aliasing
   * @param generateCalculatedVariables activate automatic computation of calculated variables
   */
  void setCompilationOptions(bool useAliasing, bool generateCalculatedVariables);

  /**
   * @brief whether the compilation should use aliasing or not
   * @return  whether the compilation should use aliasing or not
   */
  bool getUseAliasing() const;

  /**
   * @brief whether the compilation should use automatic computation of calculated variables
   * @return  whether the compilation should use automatic computation of calculated variables
   */
  bool getGenerateCalculatedVariables() const;

  /**
   * @brief Modelica models getter
   *
   * @returns Map of modelica models
   */
  const std::map<std::string, boost::shared_ptr<UnitDynamicModel> >& getUnitDynamicModels() const;

  /**
   * @brief Dynamic connectors getter
   *
   * @returns Map of connectors
   */
  const std::map<std::string, boost::shared_ptr<Connector> >& getConnectors() const;

  /**
   * @brief Initialization connectors getter
   *
   * @returns Map of initialization connectors
   */
  const std::map<std::string, boost::shared_ptr<Connector> >& getInitConnectors() const;

  /**
   * @brief macro connects getter
   * @returns Map of macro connects
   */
  const std::map<std::string, boost::shared_ptr<MacroConnect> >& getMacroConnects() const;

  /**
   * @brief Modelica model adder
   *
   * @param[in] unitDynamicModel Modelica model to add
   * @returns Reference to current ModelTemplate instance
   */
  ModelicaModel& addUnitDynamicModel(const boost::shared_ptr<UnitDynamicModel>& unitDynamicModel);

  /**
   * @brief Dynamic connector adder
   *
   * @param[in] model1 First model to connect
   * @param[in] var1 First model var to connect
   * @param[in] model2 Second model to connect
   * @param[in] var2 Second model var to connect
   * @returns Reference to the current ModelicaModel instance
   */
  ModelicaModel& addConnect(const std::string& model1, const std::string& var1, const std::string& model2, const std::string& var2);

  /**
   * @brief Initialization connector adder
   *
   * @param[in] modelid1 First model to connect
   * @param[in] var1 First model var to connect
   * @param[in] modelid2 Second model to connect
   * @param[in] var2 Second model var to connect
   * @return Reference to current ModelicaModel instance
   * @throws API exception if the one of the two models is not
   * part of composite model
   */
  ModelicaModel& addInitConnect(const std::string& modelid1, const std::string& var1, const std::string& modelid2, const std::string& var2);

  /**
   * @brief macro connect adder
   * @param[in] macroConnect Macro connect to add
   * @return reference to the current ModelicaModel instance
   */
  ModelicaModel& addMacroConnect(const boost::shared_ptr<MacroConnect>& macroConnect);

  /**
   * @brief hasSameStructureAs()
   * @param modelicaModel reference modelica model
   * @param unitDynamicModelsMap_ unit dynamic models map
   * @return whether has the same structure
   */
  bool hasSameStructureAs(const boost::shared_ptr<ModelicaModel>& modelicaModel,
                          std::map<boost::shared_ptr<UnitDynamicModel>, boost::shared_ptr<UnitDynamicModel> >& unitDynamicModelsMap_);

 private:
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
                                     std::map<boost::shared_ptr<UnitDynamicModel>, boost::shared_ptr<UnitDynamicModel> >& unitDynModelsMap,
                                     const std::map<std::string, std::string>& modelsName1, const std::map<std::string, std::string>& modelsInitName1,
                                     const std::map<std::string, std::string>& modelsName2, const std::map<std::string, std::string>& modelsInitName2) const;

  /**
   * @brief test equivalence of connection names
   *
   * @param modelicaModel reference modelica model
   * @param modelsName1 local map: model[ID] = Name
   * @param modelsName2 map: model[ID] = Name for modelicaModel
   *
   * @returns true if the connection names are equivalent, false otherwise
   */
  bool connectionStringIdentical(const boost::shared_ptr<ModelicaModel>& modelicaModel, const std::map<std::string, std::string>& modelsName1,
                                 const std::map<std::string, std::string>& modelsName2) const;

  /**
   * @brief Check whether the different types of Init connected variables involve in the same amount of UDMs between two modelica models
   *
   * @param modelicaModel reference modelica model
   * @param modelsName1 local map: model[ID] = Name
   * @param modelsName2 map: model[ID] = Name for modelicaModel
   *
   * @returns true if the different types of Init connected variables involve in the same amount of UDMs, false otherwise
   */
  bool initConnectIdentical(const boost::shared_ptr<ModelicaModel>& modelicaModel, const std::map<std::string, std::string>& modelsName1,
                            const std::map<std::string, std::string>& modelsName2) const;

  /**
   * @brief Check whether the different types of Pin connected variables involve in the same amount of UDMs between two modelica models
   *
   * @param modelicaModel reference modelica model
   * @param modelsName1 local map: model[ID] = Name
   * @param modelsName2 map: model[ID] = Name for modelicaModel
   *
   * @returns true if the different types of Pin connected variables involve in the same amount of UDMs, false otherwise
   */
  bool connectIdentical(const boost::shared_ptr<ModelicaModel>& modelicaModel, const std::map<std::string, std::string>& modelsName1,
                        const std::map<std::string, std::string>& modelsName2) const;

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
  bool initConnectDynamicMappingIdentical(const boost::shared_ptr<ModelicaModel>& modelicaModel, const std::map<std::string, std::string>& modelsInitName1,
                                          const std::map<std::string, std::string>& modelsInitName2,
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
  bool connectDynamicMappingIdentical(const boost::shared_ptr<ModelicaModel>& modelicaModel, const std::map<std::string, std::string>& modelsName1,
                                      const std::map<std::string, std::string>& modelsName2,
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
  bool
  macroConnectDynamicMappingIdentical(const boost::shared_ptr<ModelicaModel>& modelicaModel, const std::map<std::string, std::string>& modelsName1,
                                      const std::map<std::string, std::string>& modelsName2,
                                      std::map<boost::shared_ptr<UnitDynamicModel>, boost::shared_ptr<UnitDynamicModel> >& localUnitDynamicModelsMap) const;

 private:
  std::string staticId_;              ///< Identifiable device modeled by dynamic model
  bool useAliasing_;                  ///< true if OpenModelica aliasing is used
  bool generateCalculatedVariables_;  ///< true if calculated variables are computed automatically for compiled models
  std::map<std::string, boost::shared_ptr<UnitDynamicModel> > unitDynamicModelsMap_;  ///< Unit Dynamic model parts
  std::map<std::string, boost::shared_ptr<Connector> > initConnectorsMap_;            ///< Unit Dynamic model initialization connectors
  std::map<std::string, boost::shared_ptr<Connector> > connectorsMap_;                ///<  model connectors
  std::map<std::string, boost::shared_ptr<MacroConnect> > macroConnectsMap_;          ///< model macro connects
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMODELICAMODEL_H_
