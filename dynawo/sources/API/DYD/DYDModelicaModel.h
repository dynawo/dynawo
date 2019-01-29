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

#include <map>
#include <vector>

#include <boost/shared_ptr.hpp>

#include "DYDExport.h"
#include "DYDModel.h"


namespace dynamicdata {
class Connector;
class Model;
class UnitDynamicModel;
class MacroConnect;

/**
 * @class ModelicaModel
 * @brief Modelica model interface class
 *
 * Modelica model is a model that is composed of multiple models
 * Connected together. It also declares ports for external
 * connections.
 */
class __DYNAWO_DYD_EXPORT ModelicaModel : public Model {
 public:
  /**
   * @brief Network Identifiable device modeled getter

   * @returns Id of Network Identifiable device modeled
   */
  virtual std::string getStaticId() const = 0;

  /**
   * @brief Network Identifiable device modeled setter
   *
   * @param[in] staticId of modeledDevice Network Identifiable device modeled
   * @returns Reference to current Model instance
   */
  virtual ModelicaModel& setStaticId(const std::string& staticId) = 0;

  /**
   * @brief Modelica models getter
   *
   * @returns Map of modelica models
   */
  virtual const std::map<std::string, boost::shared_ptr<UnitDynamicModel> >& getUnitDynamicModels() const = 0;

  /**
   * @brief Dynamic connectors getter
   *
   * @returns Map of connectors
   */
  virtual const std::map<std::string, boost::shared_ptr<Connector> >& getConnectors() const = 0;

  /**
   * @brief Initialization connectors getter
   *
   * @returns Map of initialization connectors
   */
  virtual const std::map<std::string, boost::shared_ptr<Connector> >& getInitConnectors() const = 0;

  /**
   * @brief macro connects getter
   * @returns Map of macro connects
   */
  virtual const std::map<std::string, boost::shared_ptr<MacroConnect> >& getMacroConnects() const = 0;

  /**
   * @brief Modelica model adder
   *
   * @param[in] unitDynamicModel Modelica model to add
   * @returns Reference to current ModelTemplate instance
   */
  virtual ModelicaModel& addUnitDynamicModel(const boost::shared_ptr<UnitDynamicModel>& unitDynamicModel) = 0;

  /**
   * @brief Dynamic connector adder
   *
   * @param[in] model1 First model to connect
   * @param[in] var1 First model var to connect
   * @param[in] model2 Second model to connect
   * @param[in] var2 Second model var to connect
   * @returns Reference to the current ModelicaModel instance
   */
  virtual ModelicaModel& addConnect(const std::string& model1, const std::string& var1,
          const std::string& model2, const std::string& var2) = 0;


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
  virtual ModelicaModel& addInitConnect(const std::string& modelid1, const std::string& var1,
          const std::string& modelid2, const std::string& var2) = 0;

  /**
   * @brief macro connect adder
   * @param[in] macroConnect Macro connect to add
   * @return reference to the current ModelicaModel instance
   */
  virtual ModelicaModel& addMacroConnect(const boost::shared_ptr<MacroConnect>& macroConnect) = 0;

  /**
   * @brief hasSameStructureAs()
   * @param modelicaModel reference modelica model
   * @param unitDynamicModelsMap_ unit dynamic models map
   * @return whether has the same structure
   */
  virtual bool hasSameStructureAs(const boost::shared_ptr<ModelicaModel>& modelicaModel, std::map<boost::shared_ptr<UnitDynamicModel>,
          boost::shared_ptr<UnitDynamicModel> >& unitDynamicModelsMap_) = 0;

  class Impl;  ///< Implemented class
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMODELICAMODEL_H_
