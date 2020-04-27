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
 * @file DYDModelTemplateImpl.h
 * @brief Model template description : header file
 *
 */

#ifndef API_DYD_DYDMODELTEMPLATEIMPL_H_
#define API_DYD_DYDMODELTEMPLATEIMPL_H_

#include "DYDModelTemplate.h"
#include "DYDModelImpl.h"
#include "DYDIterators.h"

namespace dynamicdata {

class UnitDynamicModel;
class MacroConnect;
class Connector;

/**
 * @class ModelTemplate::Impl
 * @brief Model Template implemented class
 *
 */
class ModelTemplate::Impl : public ModelTemplate, public Model::Impl {
 public:
  /**
   * @brief ModelTemplate constructor
   *
   * ModelTemplate constructor.
   *
   * @param id Dynamic model ID
   *
   * @returns New ModelTemplate::Impl instance with given attributes
   */
  explicit Impl(const std::string& id);

  /**
   * @brief ModelTemplate destructor
   */
  ~Impl();

  /**
   * @copydoc ModelTemplate::setCompilationOptions(bool useAlias, bool generateCalculatedVariables)
   */
  void setCompilationOptions(bool useAlias, bool generateCalculatedVariables);

  /**
   * @copydoc ModelTemplate::getUseAlias() const
   */
  bool getUseAlias() const;

  /**
   * @copydoc ModelTemplate::getGenerateCalculatedVariables() const
   */
  bool getGenerateCalculatedVariables() const;

  /**
   * @copydoc ModelTemplate::getUnitDynamicModels()
   */
  const std::map<std::string, boost::shared_ptr<UnitDynamicModel> >& getUnitDynamicModels() const;

  /**
   * @copydoc ModelTemplate::getConnectors()
   */
  const std::map<std::string, boost::shared_ptr<Connector> >& getConnectors() const;

  /**
   * @copydoc ModelTemplate::getInitConnectors()
   */
  const std::map<std::string, boost::shared_ptr<Connector> >& getInitConnectors() const;

  /**
   * @copydoc ModelTemplate::getMacroConnects()
   */
  const std::map<std::string, boost::shared_ptr<MacroConnect> >& getMacroConnects() const;

  /**
   * @copydoc ModelTemplate::addUnitDynamicModel()
   */
  ModelTemplate& addUnitDynamicModel(const boost::shared_ptr<UnitDynamicModel>& unitDynamicModel);

  /**
   * @copydoc ModelTemplate::addConnect()
   */
  ModelTemplate& addConnect(const std::string& model1, const std::string& var1,
          const std::string& model2, const std::string& var2);

  /**
   * @copydoc ModelTemplate::addInitConnect()
   */
  ModelTemplate& addInitConnect(const std::string& modelid1, const std::string& var1,
          const std::string& modelid2, const std::string& var2);

  /**
   * @copydoc ModelTemplate::addMacroConnect()
   */
  ModelTemplate& addMacroConnect(const boost::shared_ptr<MacroConnect>& macroConnect);

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
   * @copydoc Model::cbeginMacroStaticRef() const
   */
  macroStaticRef_const_iterator cbeginMacroStaticRef() const;

  /**
   * @copydoc Model::cendMacroStaticRef() const
   */
  macroStaticRef_const_iterator cendMacroStaticRef() const;

  /**
   * @copydoc Model::beginStaticRef()
   */
  staticRef_iterator beginStaticRef();

  /**
   * @copydoc Model::endStaticRef()
   */
  staticRef_iterator endStaticRef();

  /**
   * @copydoc Model::cbeginStaticRef() const
   */
  staticRef_const_iterator cbeginStaticRef() const;

  /**
   * @copydoc Model::cendStaticRef() const
   */
  staticRef_const_iterator cendStaticRef() const;

  /**
   * @copydoc Model::beginMacroStaticRef()
   */
  macroStaticRef_iterator beginMacroStaticRef();

  /**
   * @copydoc Model::endMacroStaticRef()
   */
  macroStaticRef_iterator endMacroStaticRef();

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

  bool useAliasing_;  ///< true if OpenModelica aliasing is used
  bool generateCalculatedVariables_;  ///< true if calculated variables are computed automatically for compiled models
  std::map<std::string, boost::shared_ptr<UnitDynamicModel> > unitDynamicModelsMap_;  ///< Unit Dynamic model parts
  std::map<std::string, boost::shared_ptr<Connector> > initConnectorsMap_;  ///< Unit Dynamic model initialization connectors
  std::map<std::string, boost::shared_ptr<Connector> > connectorsMap_;  ///<  model connectors
  std::map<std::string, boost::shared_ptr<MacroConnect> > macroConnectsMap_;  ///< model macro connects
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMODELTEMPLATEIMPL_H_
