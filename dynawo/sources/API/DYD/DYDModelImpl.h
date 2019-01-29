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
 * @file DYDModelImpl.h
 * @brief Model description : header file
 *
 */

#ifndef API_DYD_DYDMODELIMPL_H_
#define API_DYD_DYDMODELIMPL_H_

#include "DYDModel.h"

namespace dynamicdata {
class Identifiable;
class StaticRef;
class MacroStaticRef;

/**
 * @class Model::Impl
 * @brief Model implemented class
 *
 * Model is a virtual base class for all model types
 */
class Model::Impl : public Model {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Impl();

  /**
   * @copydoc Model::getId()
   */
  std::string getId() const;

  /**
   * @copydoc Model::getType()
   */
  ModelType getType() const;

  /**
   * @copydoc Model::addStaticRef(const std::string& var, const std::string& staticVar)
   */
  Model& addStaticRef(const std::string& var, const std::string& staticVar);

  /**
   * @copydoc Model::addMacroStaticRef(const boost::shared_ptr<MacroStaticRef>& macroStaticRef)
   */
  void addMacroStaticRef(const boost::shared_ptr<MacroStaticRef>& macroStaticRef);

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
   * @copydoc Model::findStaticRef()
   */
  const boost::shared_ptr<StaticRef>& findStaticRef(const std::string& key);

  /**
   * @copydoc Model::findMacroStaticRef()
   */
  const boost::shared_ptr<MacroStaticRef>& findMacroStaticRef(const std::string& id);

  friend class StaticRefConstIteratorImpl;
  friend class StaticRefIteratorImpl;
  friend class MacroStaticRefConstIteratorImpl;
  friend class MacroStaticRefIteratorImpl;

 protected:
  /**
   * @brief Constructor
   *
   * @param[in] id Model's ID
   * @param[in] type Model's type
   * @returns New Model::Impl instance
   */
  Impl(const std::string& id, ModelType type);

 protected:
  boost::shared_ptr<Identifiable> id_;  ///< Model's ID
  ModelType type_;  ///< Model's type
  std::map<std::string, boost::shared_ptr<StaticRef> > staticRefs_;  ///< map of static ref
  std::map<std::string, boost::shared_ptr<MacroStaticRef> > macroStaticRefs_;  ///< map of the macroStaticRef

 private:
  /**
   * @brief Copy constructor
   *
   * @param[in] original Model to be copied
   * @returns Copy of Model::Impl instance
   */
  Impl(const Impl& original);

  /**
   * @brief default constructor
   */
  Impl();
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMODELIMPL_H_
