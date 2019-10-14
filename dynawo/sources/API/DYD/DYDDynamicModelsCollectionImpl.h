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
 * @file DYDDynamicModelsCollectionImpl.h
 * @brief Dynamic models collection description : header file
 *
 */

#ifndef API_DYD_DYDDYNAMICMODELSCOLLECTIONIMPL_H_
#define API_DYD_DYDDYNAMICMODELSCOLLECTIONIMPL_H_

#include <map>
#include <vector>

#include "DYDDynamicModelsCollection.h"

namespace dynamicdata {
class Model;
class MacroConnector;
class MacroConnect;
class Connector;
class MacroStaticReference;

/**
 * @class DynamicModelsCollection::Impl
 * @brief Dynamic models collection implemented class
 *
 * DynamicModelsCollection objects describe a set of dynamic models for
 * Dynawo that can be blackbox models or Modelica models
 */
class DynamicModelsCollection::Impl : public DynamicModelsCollection {
 public:
  /**
   * @brief Constructor
   *
   * @returns New DynamicModelsCollection::Impl instance
   */
  Impl();

  /**
   * @brief InitConnect destructor
   */
  virtual ~Impl();

  /**
   * @copydoc DynamicModelsCollection::addModel(const boost::shared_ptr<Model>& model)
   */
  void addModel(const boost::shared_ptr<Model>& model);

  /**
   * @copydoc DynamicModelsCollection::addConnect()
   */
  void addConnect(const std::string& model1, const std::string& var1,
          const std::string& model2, const std::string& var2);

  /**
   * @copydoc DynamicModelsCollection::addMacroConnector()
   */
  void addMacroConnector(const boost::shared_ptr<MacroConnector>& macroConnector);

  /**
   * @copydoc DynamicModelsCollection::addMacroConnect()
   */
  void addMacroConnect(const boost::shared_ptr<MacroConnect>& macroConnect);

  /**
   * @copydoc DynamicModelsCollection::addMacroStaticReference()
   */
  void addMacroStaticReference(const boost::shared_ptr<MacroStaticReference>& macroStaticReference);

  /**
   * @copydoc DynamicModelsCollection::cbeginModel() const
   */
  dynamicModel_const_iterator cbeginModel() const;
  /**
   * @copydoc DynamicModelsCollection::cendModel() const
   */
  dynamicModel_const_iterator cendModel() const;

  /**
   * @copydoc DynamicModelsCollection::cbeginConnector() const
   */
  connector_const_iterator cbeginConnector() const;
  /**
   * @copydoc DynamicModelsCollection::cendConnector() const
   */
  connector_const_iterator cendConnector() const;

  /**
   * @copydoc DynamicModelsCollection::cbeginMacroConnector() const
   */
  macroConnector_const_iterator cbeginMacroConnector() const;

  /**
   * @copydoc DynamicModelsCollection::cendMacroConnector() const
   */
  macroConnector_const_iterator cendMacroConnector() const;

  /**
   * @copydoc DynamicModelsCollection::cbeginMacroConnect() const
   */
  macroConnect_const_iterator cbeginMacroConnect() const;

  /**
   * @copydoc DynamicModelsCollection::cendMacroConnect() const
   */
  macroConnect_const_iterator cendMacroConnect() const;

  /**
   * @copydoc DynamicModelsCollection::cbeginMacroStaticReference() const
   */
  macroStaticReference_const_iterator cbeginMacroStaticReference() const;

  /**
   * @copydoc DynamicModelsCollection::cendMacroStaticReference() const
   */
  macroStaticReference_const_iterator cendMacroStaticReference() const;

  /**
   * @copydoc DynamicModelsCollection::beginModel()
   */
  dynamicModel_iterator beginModel();

  /**
   * @copydoc DynamicModelsCollection::endModel()
   */
  dynamicModel_iterator endModel();

  /**
   * @copydoc DynamicModelsCollection::beginConnector()
   */
  connector_iterator beginConnector();

  /**
   * @copydoc DynamicModelsCollection::endConnector()
   */
  connector_iterator endConnector();

  /**
   * @copydoc DynamicModelsCollection::beginMacroConnector()
   */
  macroConnector_iterator beginMacroConnector();

  /**
   * @copydoc DynamicModelsCollection::endMacroConnector()
   */
  macroConnector_iterator endMacroConnector();

  /**
   * @copydoc DynamicModelsCollection::beginMacroConnect()
   */
  macroConnect_iterator beginMacroConnect();

  /**
   * @copydoc DynamicModelsCollection::endMacroConnect()
   */
  macroConnect_iterator endMacroConnect();

  /**
   * @copydoc DynamicModelsCollection::beginMacroStaticReference()
   */
  macroStaticReference_iterator beginMacroStaticReference();

  /**
   * @copydoc DynamicModelsCollection::endMacroStaticReference()
   */
  macroStaticReference_iterator endMacroStaticReference();

  /**
   * @copydoc DynamicModelsCollection::findMacroConnector()
   */
  const boost::shared_ptr<MacroConnector>& findMacroConnector(const std::string& connector);

  /**
   * @copydoc DynamicModelsCollection::findMacroStaticReference()
   */
  const boost::shared_ptr<MacroStaticReference>& findMacroStaticReference(const std::string& id);

  friend class ConnectorConstIteratorImpl;
  friend class ConnectorIteratorImpl;
  friend class ModelConstIteratorImpl;
  friend class ModelIteratorImpl;
  friend class MacroConnectorConstIteratorImpl;
  friend class MacroConnectorIteratorImpl;
  friend class MacroConnectConstIteratorImpl;
  friend class MacroConnectIteratorImpl;
  friend class MacroStaticReferenceConstIteratorImpl;
  friend class MacroStaticReferenceIteratorImpl;

 private:
  std::map<std::string, boost::shared_ptr<Model> > models_;  /**< Map of the models **/
  std::vector<boost::shared_ptr<Connector> > connectors_;  /**< Vector of the connectors between models **/
  std::map<std::string, boost::shared_ptr<MacroConnector> > macroConnectors_; /**< map of the macro connectors **/
  std::vector<boost::shared_ptr<MacroConnect> > macroConnects_; /**< vector of the macro connectors between models **/
  std::map<std::string, boost::shared_ptr<MacroStaticReference> > macroStaticReferences_; /**< map of the macro static references **/
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDDYNAMICMODELSCOLLECTIONIMPL_H_
