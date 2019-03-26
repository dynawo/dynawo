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

#include <boost/shared_ptr.hpp>

#include "DYDExport.h"

namespace dynamicdata {

class connector_const_iterator;
class connector_iterator;
class model_const_iterator;
class model_iterator;
class macroConnector_const_iterator;
class macroConnector_iterator;
class macroConnect_const_iterator;
class macroConnect_iterator;
class macroStaticReference_const_iterator;
class macroStaticReference_iterator;
class MacroConnector;
class MacroConnect;
class MacroStaticReference;
class Model;

/**
 * @class DynamicModelsCollection
 * @brief Dynamic models collection interface class
 *
 * DynamicModelsCollection objects describe a set of dynamic models for
 * Dynawo that can be blackbox models or Modelica models
 */
class __DYNAWO_DYD_EXPORT DynamicModelsCollection {
 public:
  /**
   * @brief Destructor
   */
  virtual ~DynamicModelsCollection() {}
  /**
   * @brief Add a model in the collection
   *
   * @param model model to add in the collection
   * @throws  Error::API exception if model already exists
   */
  virtual void addModel(const boost::shared_ptr<Model>& model) = 0;

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
  virtual void addConnect(const std::string& model1, const std::string& var1,
          const std::string& model2, const std::string& var2) = 0;

  /**
   * @brief Add a new macro connector in the collection
   *
   * @param[in] macroConnector : macro connector to add in the collection
   * @throws  Error::API exception if the macro connector already exists
   */
  virtual void addMacroConnector(const boost::shared_ptr<MacroConnector>& macroConnector) = 0;

  /**
   * @brief Add a new macro connect in the collection
   *
   * @param[in] macroConnect : macro connect to add in the collection
   */
  virtual void addMacroConnect(const boost::shared_ptr<MacroConnect>& macroConnect) = 0;

  /**
   * @brief Add a new macroStaticReference in the collection
   *
   * @param[in] macroStaticReference : macroStaticReference to add in the collection
   * @throws  Error::API exception if the macroStaticReference already exists
   */
  virtual void addMacroStaticReference(const boost::shared_ptr<MacroStaticReference>& macroStaticReference) = 0;

  /**
   * @brief Implementation class
   */
  class Impl;

  /**
   * @brief model iterator : begin of model
   * @return beginning of model
   */
  virtual model_const_iterator cbeginModel() const = 0;

  /**
   * @brief model iterator : end of model
   * @return end of model
   */
  virtual model_const_iterator cendModel() const = 0;

  /**
   * @brief connector iterator ;beginning of connector
   * @return beginning of connector
   */
  virtual connector_const_iterator cbeginConnector() const = 0;

  /**
   * @brief connector iterator end of connector
   * @return end of connector
   */
  virtual connector_const_iterator cendConnector() const = 0;

  /**
   * @brief macroConnector iterator : beginning of macroConnector
   * @return beginning of macroConnector
   */
  virtual macroConnector_const_iterator cbeginMacroConnector() const = 0;

  /**
   * @brief macroConnector iterator : end of macroConnector
   * @return end of macroConnector
   */
  virtual macroConnector_const_iterator cendMacroConnector() const = 0;

  /**
   * @brief macroConnect iterator : beginning of macroConnect
   * @return beginning of macroConnect
   */
  virtual macroConnect_const_iterator cbeginMacroConnect() const = 0;

  /**
   * @brief macroConnect iterator : end of macroConnect
   * @return end of macroConnect
   */
  virtual macroConnect_const_iterator cendMacroConnect() const = 0;

  /**
   * @brief macroStaticReference iterator : beginning of macroStaticReferences
   * @return beginning of macroStaticReferences
   */
  virtual macroStaticReference_const_iterator cbeginMacroStaticReference() const = 0;

  /**
   * @brief macroStaticReference iterator : end of macroStaticReferences
   * @return end of macroStaticReferences
   */
  virtual macroStaticReference_const_iterator cendMacroStaticReference() const = 0;

  /**
   * @brief model iterator: beginning of model
   * @return beginning of model
   */
  virtual model_iterator beginModel() = 0;

  /**
   * @brief model iterator: end of model
   * @return end of model
   */
  virtual model_iterator endModel() = 0;

  /**
   * @brief connector iterator : beginning of connector
   * @return beginning of connector iterator
   */
  virtual connector_iterator beginConnector() = 0;

  /**
   * @brief connector iterator : end of connector
   * @return end of connector
   */
  virtual connector_iterator endConnector() = 0;

  /**
   * @brief macroConnector iterator : beginning of macroConnector
   * @return beginning of macroConnector
   */
  virtual macroConnector_iterator beginMacroConnector() = 0;

  /**
   * @brief macroConnector iterator : end of macroConnector
   * @return end of macroConnector
   */
  virtual macroConnector_iterator endMacroConnector() = 0;

  /**
   * @brief macroConnect iterator : beginning of macroConnect
   * @return beginning of macroConnect
   */
  virtual macroConnect_iterator beginMacroConnect() = 0;

  /**
   * @brief macroConnect iterator : end of macroConnect
   * @return end of macroConnect
   */
  virtual macroConnect_iterator endMacroConnect() = 0;

  /**
   * @brief macroStaticReference iterator : beginning of macroStaticReferences
   * @return beginning of macroStaticReferences
   */
  virtual macroStaticReference_iterator beginMacroStaticReference() = 0;

  /**
   * @brief macroStaticReference iterator : end of macroStaticReferences
   * @return end of macroStaticReferences
   */
  virtual macroStaticReference_iterator endMacroStaticReference() = 0;

  /**
   * @brief find a macroConnector thanks to its name
   * @param connector name of the macroConnector to be found
   * @return the macroConnector associated to the name
   */
  virtual const boost::shared_ptr<MacroConnector>& findMacroConnector(const std::string& connector) = 0;

  /**
   * @brief find a macroStaticReference thanks to its id
   * @param id: id of the macroStaticReference to be found
   * @return the macroStaticReference associated to the id
   */
  virtual const boost::shared_ptr<MacroStaticReference>& findMacroStaticReference(const std::string& id) = 0;
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDDYNAMICMODELSCOLLECTION_H_
