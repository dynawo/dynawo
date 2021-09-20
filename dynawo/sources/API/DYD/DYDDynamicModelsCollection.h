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
 * @file DYDDynamicModelsCollection.h
 * @brief Dynamic models collection description : interface file
 *
 */

#ifndef API_DYD_DYDDYNAMICMODELSCOLLECTION_H_
#define API_DYD_DYDDYNAMICMODELSCOLLECTION_H_

#include "DYDIterators.h"
#include "DYDMacroConnect.h"
#include "DYDMacroConnector.h"
#include "DYDMacroStaticReference.h"
#include "DYDModel.h"

#include <boost/shared_ptr.hpp>
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
  void addModel(const boost::shared_ptr<Model>& model);

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
  void addMacroConnector(const boost::shared_ptr<MacroConnector>& macroConnector);

  /**
   * @brief Add a new macro connect in the collection
   *
   * @param[in] macroConnect : macro connect to add in the collection
   */
  void addMacroConnect(const boost::shared_ptr<MacroConnect>& macroConnect);

  /**
   * @brief Add a new macroStaticReference in the collection
   *
   * @param[in] macroStaticReference : macroStaticReference to add in the collection
   * @throws  Error::API exception if the macroStaticReference already exists
   */
  void addMacroStaticReference(const boost::shared_ptr<MacroStaticReference>& macroStaticReference);

  /**
   * @brief Implementation class
   */
  class Impl;

  /**
   * @brief model iterator : begin of model
   * @return beginning of model
   */
  dynamicModel_const_iterator cbeginModel() const;

  /**
   * @brief model iterator : end of model
   * @return end of model
   */
  dynamicModel_const_iterator cendModel() const;

  /**
   * @brief connector iterator : beginning of connector
   * @return beginning of connector
   */
  connector_const_iterator cbeginConnector() const;

  /**
   * @brief connector iterator end of connector
   * @return end of connector
   */
  connector_const_iterator cendConnector() const;

  /**
   * @brief macroConnector iterator : beginning of macroConnector
   * @return beginning of macroConnector
   */
  macroConnector_const_iterator cbeginMacroConnector() const;

  /**
   * @brief macroConnector iterator : end of macroConnector
   * @return end of macroConnector
   */
  macroConnector_const_iterator cendMacroConnector() const;

  /**
   * @brief macroConnect iterator : beginning of macroConnect
   * @return beginning of macroConnect
   */
  macroConnect_const_iterator cbeginMacroConnect() const;

  /**
   * @brief macroConnect iterator : end of macroConnect
   * @return end of macroConnect
   */
  macroConnect_const_iterator cendMacroConnect() const;

  /**
   * @brief macroStaticReference iterator : beginning of macroStaticReferences
   * @return beginning of macroStaticReferences
   */
  macroStaticReference_const_iterator cbeginMacroStaticReference() const;

  /**
   * @brief macroStaticReference iterator : end of macroStaticReferences
   * @return end of macroStaticReferences
   */
  macroStaticReference_const_iterator cendMacroStaticReference() const;

  /**
   * @brief model iterator: beginning of model
   * @return beginning of model
   */
  dynamicModel_iterator beginModel();

  /**
   * @brief model iterator: end of model
   * @return end of model
   */
  dynamicModel_iterator endModel();

  /**
   * @brief connector iterator : beginning of connector
   * @return beginning of connector iterator
   */
  connector_iterator beginConnector();

  /**
   * @brief connector iterator : end of connector
   * @return end of connector
   */
  connector_iterator endConnector();

  /**
   * @brief macroConnector iterator : beginning of macroConnector
   * @return beginning of macroConnector
   */
  macroConnector_iterator beginMacroConnector();

  /**
   * @brief macroConnector iterator : end of macroConnector
   * @return end of macroConnector
   */
  macroConnector_iterator endMacroConnector();

  /**
   * @brief macroConnect iterator : beginning of macroConnect
   * @return beginning of macroConnect
   */
  macroConnect_iterator beginMacroConnect();

  /**
   * @brief macroConnect iterator : end of macroConnect
   * @return end of macroConnect
   */
  macroConnect_iterator endMacroConnect();

  /**
   * @brief macroStaticReference iterator : beginning of macroStaticReferences
   * @return beginning of macroStaticReferences
   */
  macroStaticReference_iterator beginMacroStaticReference();

  /**
   * @brief macroStaticReference iterator : end of macroStaticReferences
   * @return end of macroStaticReferences
   */
  macroStaticReference_iterator endMacroStaticReference();

  /**
   * @brief find a macroConnector thanks to its name
   * @param connector name of the macroConnector to be found
   * @return the macroConnector associated to the name
   */
  const boost::shared_ptr<MacroConnector>& findMacroConnector(const std::string& connector);

  /**
   * @brief find a macroStaticReference thanks to its id
   * @param id id of the macroStaticReference to be found
   * @return the macroStaticReference associated to the id
   */
  const boost::shared_ptr<MacroStaticReference>& findMacroStaticReference(const std::string& id);

  friend class dynamicModel_iterator;
  friend class dynamicModel_const_iterator;
  friend class connector_iterator;
  friend class connector_const_iterator;
  friend class macroConnector_iterator;
  friend class macroConnector_const_iterator;
  friend class macroConnect_iterator;
  friend class macroConnect_const_iterator;
  friend class staticRef_iterator;
  friend class staticRef_const_iterator;
  friend class macroStaticRef_iterator;
  friend class macroStaticRef_const_iterator;
  friend class macroStaticReference_iterator;
  friend class macroStaticReference_const_iterator;

 private:
  std::map<std::string, boost::shared_ptr<Model> > models_;                               /**< Map of the models **/
  std::vector<boost::shared_ptr<Connector> > connectors_;                                 /**< Vector of the connectors between models **/
  std::map<std::string, boost::shared_ptr<MacroConnector> > macroConnectors_;             /**< map of the macro connectors **/
  std::vector<boost::shared_ptr<MacroConnect> > macroConnects_;                           /**< vector of the macro connectors between models **/
  std::map<std::string, boost::shared_ptr<MacroStaticReference> > macroStaticReferences_; /**< map of the macro static references **/
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDDYNAMICMODELSCOLLECTION_H_
