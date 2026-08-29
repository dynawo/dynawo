//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file DYDDynamicModelsCollection.h
 * @brief Dynamic models collection description : interface file
 *
 */

#ifndef API_DYD_DYDDYNAMICMODELSCOLLECTION_H_
#define API_DYD_DYDDYNAMICMODELSCOLLECTION_H_

#include "DYDMacroConnect.h"
#include "DYDMacroConnector.h"
#include "DYDMacroStaticReference.h"
#include "DYDModel.h"

#include <map>
#include <string>
#include <vector>

namespace dynamicdata {

/**
 * @class DynamicModelsCollection
 * @brief Dynamic models collection interface class
 *
 * DynamicModelsCollection objects describe a set of dynamic models for
 * Dynawo that can be blackbox models or Modelica models
 */
class DynamicModelsCollection {
 public:
  /**
   * @brief Add a model in the collection
   *
   * @param model model to add in the collection
   * @throws  Error::API exception if model already exists
   */
  void addModel(const std::shared_ptr<Model>& model);

  /**
   * @brief Add a new connector in the collection
   *
   * @param[in] model1 First model to connect
   * @param[in] var1 First model var to connect
   * @param[in] model2 Second model to connect
   * @param[in] var2 Second model var to connect
   * @throws API exception if the one of the two models is not
   * part of collection
   */
  void addConnect(const std::string& model1, const std::string& var1, const std::string& model2, const std::string& var2);

  /**
   * @brief Add a new macro connector in the collection
   *
   * @param[in] macroConnector : macro connector to add in the collection
   * @throws  Error::API exception if the macro connector already exists
   */
  void addMacroConnector(const std::shared_ptr<MacroConnector>& macroConnector);

  /**
   * @brief Add a new macro connect in the collection
   *
   * @param[in] macroConnect : macro connect to add in the collection
   */
  void addMacroConnect(const std::shared_ptr<MacroConnect>& macroConnect);

  /**
   * @brief Add a new macroStaticReference in the collection
   *
   * @param[in] macroStaticReference : macroStaticReference to add in the collection
   * @throws  Error::API exception if the macroStaticReference already exists
   */
  void addMacroStaticReference(const std::shared_ptr<MacroStaticReference>& macroStaticReference);

  /**
   * @brief find a macroConnector thanks to its name
   * @param connector name of the macroConnector to be found
   * @return the macroConnector associated to the name
   */
  const std::shared_ptr<MacroConnector>& findMacroConnector(const std::string& connector);

  /**
   * @brief find a macroStaticReference thanks to its id
   * @param id id of the macroStaticReference to be found
   * @return the macroStaticReference associated to the id
   */
  const std::shared_ptr<MacroStaticReference>& findMacroStaticReference(const std::string& id);

  /**
  * @brief get the models
  *
  * @return models
  */
  const std::map<std::string, std::shared_ptr<Model> >& getModels() const {
    return models_;
  }

  /**
  * @brief get the connectors
  *
  * @return connectors
  */
  const std::vector<std::shared_ptr<Connector> >& getConnectors() const {
    return connectors_;
  }

  /**
  * @brief get the macro connectors
  *
  * @return macroConnectors
  */
  const std::map<std::string, std::shared_ptr<MacroConnector> >& getMacroConnectors() const {
    return macroConnectors_;
  }

  /**
  * @brief get the macro connects
  *
  * @return macro connects
  */
  const std::vector<std::shared_ptr<MacroConnect> >& getMacroConnects() const {
    return macroConnects_;
  }

  /**
  * @brief get the macro static refs
  *
  * @return macro static refs
  */
  const std::map<std::string, std::shared_ptr<MacroStaticReference> >& getMacroStaticReferences() const {
    return macroStaticReferences_;
  }

 private:
  std::map<std::string, std::shared_ptr<Model> > models_;                               /**< Map of the models **/
  std::vector<std::shared_ptr<Connector> > connectors_;                                 /**< Vector of the connectors between models **/
  std::map<std::string, std::shared_ptr<MacroConnector> > macroConnectors_;             /**< map of the macro connectors **/
  std::vector<std::shared_ptr<MacroConnect> > macroConnects_;                           /**< vector of the macro connectors between models **/
  std::map<std::string, std::shared_ptr<MacroStaticReference> > macroStaticReferences_; /**< map of the macro static references **/
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDDYNAMICMODELSCOLLECTION_H_
