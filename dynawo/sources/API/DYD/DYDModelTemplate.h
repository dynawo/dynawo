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
 * @file DYDModelTemplate.h
 * @brief model template description : interface file
 *
 */

#ifndef API_DYD_DYDMODELTEMPLATE_H_
#define API_DYD_DYDMODELTEMPLATE_H_

#include "DYDConnector.h"
#include "DYDMacroConnect.h"
#include "DYDModel.h"
#include "DYDUnitDynamicModel.h"

#include <map>


namespace dynamicdata {

/**
 * @class ModelTemplate
 * @brief Model template interface class
 *
 */
class ModelTemplate : public Model {
 public:
  /**
   * @brief ModelTemplate constructor
   *
   * ModelTemplate constructor.
   *
   * @param id Dynamic model ID
   *
   */
  explicit ModelTemplate(const std::string& id);

  /**
   * @brief Destructor
   */
  ~ModelTemplate() override;

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
  const std::map<std::string, std::shared_ptr<UnitDynamicModel> >& getUnitDynamicModels() const;

  /**
   * @brief Dynamic connectors getter
   *
   * @returns Map of connectors
   */
  const std::map<std::string, std::shared_ptr<Connector> >& getConnectors() const;

  /**
   * @brief Initialization connectors getter
   *
   * @returns Map of initialization connectors
   */
  const std::map<std::string, std::shared_ptr<Connector> >& getInitConnectors() const;

  /**
   * @brief Macro connects getter
   * @return Map of macroConnects
   */
  const std::map<std::string, std::shared_ptr<MacroConnect> >& getMacroConnects() const;

  /**
   * @brief Modelica model adder
   *
   * @param[in] unitDynamicModel Modelica model to add
   * @returns Reference to current ModelTemplate instance
   */
  ModelTemplate& addUnitDynamicModel(const std::shared_ptr<UnitDynamicModel>& unitDynamicModel);

  /**
   * @brief Dynamic connector adder
   *
   * @param[in] model1 First model to connect
   * @param[in] var1 First model var to connect
   * @param[in] model2 Second model to connect
   * @param[in] var2 Second model var to connect
   * @returns Reference to the current ModelTemplate instance
   */
  ModelTemplate& addConnect(const std::string& model1, const std::string& var1, const std::string& model2, const std::string& var2);

  /**
   * @brief Initialization connector adder
   *
   * @param[in] modelid1 First model to connect
   * @param[in] var1 First model var to connect
   * @param[in] modelid2 Second model to connect
   * @param[in] var2 Second model var to connect
   * @return Reference to current ModelTemplate instance
   * @throws API exception if the one of the two models is not
   * part of composite model
   */
  ModelTemplate& addInitConnect(const std::string& modelid1, const std::string& var1, const std::string& modelid2, const std::string& var2);

  /**
   * @brief macro connect adder
   * @param[in] macroConnect MacroConnect to add
   * @return reference to the current ModelTemplate instance
   */
  ModelTemplate& addMacroConnect(const std::shared_ptr<MacroConnect>& macroConnect);

 private:
  bool useAliasing_;                  ///< true if OpenModelica aliasing is used
  bool generateCalculatedVariables_;  ///< true if calculated variables are computed automatically for compiled models
  std::map<std::string, std::shared_ptr<UnitDynamicModel> > unitDynamicModelsMap_;  ///< Unit Dynamic model parts
  std::map<std::string, std::shared_ptr<Connector> > initConnectorsMap_;            ///< Unit Dynamic model initialization connectors
  std::map<std::string, std::shared_ptr<Connector> > connectorsMap_;                ///<  model connectors
  std::map<std::string, std::shared_ptr<MacroConnect> > macroConnectsMap_;          ///< model macro connects
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMODELTEMPLATE_H_
