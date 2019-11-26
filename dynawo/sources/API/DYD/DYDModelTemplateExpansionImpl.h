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
 * @file DYDModelTemplateExpansionImpl.h
 * @brief model template expansion implementation : header file
 *
 */

#ifndef API_DYD_DYDMODELTEMPLATEEXPANSIONIMPL_H_
#define API_DYD_DYDMODELTEMPLATEEXPANSIONIMPL_H_

#include "DYDModelTemplateExpansion.h"
#include "DYDModelImpl.h"
#include "DYDIterators.h"

namespace dynamicdata {

/**
 * @class ModelTemplateExpansion::Impl
 * @brief Model template expansion implemented class
 *
 * ModelTemplateExpansion objects describe black box models
 * objects connected with other models through
 */
class ModelTemplateExpansion::Impl : public ModelTemplateExpansion, public Model::Impl {
 public:
  /**
   * @brief Constructor
   *
   * @param id Model template expansion's ID
   * @returns New ModelTemplateExpansion::Impl instance
   */
  explicit Impl(const std::string& id);

  /**
   * @brief Destructor
   */
  ~Impl();

  /**
   * @copydoc ModelTemplateExpansion::getTemplateId()
   */
  virtual std::string getTemplateId() const;

  /**
   * @copydoc ModelTemplateExpansion::setTemplateId()
   */
  virtual ModelTemplateExpansion& setTemplateId(const std::string& templateId);

  /**
   * @copydoc ModelTemplateExpansion::getStaticId()
   */
  std::string getStaticId() const;

  /**
   * @copydoc ModelTemplateExpansion::setStaticId(const std::string& staticId);
   */
  ModelTemplateExpansion& setStaticId(const std::string& staticId);

  /**
   * @copydoc ModelTemplateExpansion::setParFile(const std::string& parFile);
   */
  ModelTemplateExpansion& setParFile(const std::string& parFile);

  /**
   * @copydoc ModelTemplateExpansion::setParId(const std::string& parId);
   */
  ModelTemplateExpansion& setParId(const std::string& parId);

  /**
   * @copydoc ModelTemplateExpansion::getParFile() const
   */
  std::string getParFile() const;

  /**
   * @copydoc ModelTemplateExpansion::getParId() const
   */
  std::string getParId() const;

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

  std::string templateId_; /**< template model id*/
  std::string staticId_;  ///< Identifiable device modeled by dynamic model
  std::string parFile_;  ///< name of the parameter file
  std::string parId_;  ///< id of the set of parameter for the model
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMODELTEMPLATEEXPANSIONIMPL_H_
