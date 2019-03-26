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
 * @file DYDMacroStaticReferenceImpl.h
 * @brief MacroStaticReference description : header file
 *
 */

#ifndef API_DYD_DYDMACROSTATICREFERENCEIMPL_H_
#define API_DYD_DYDMACROSTATICREFERENCEIMPL_H_

#include "DYDMacroStaticReference.h"

namespace dynamicdata {

/**
 * @class MacroStaticReference::Impl
 * @brief MacroStaticReference implemented class
 */
class MacroStaticReference::Impl : public MacroStaticReference {
 public:
  /**
   * @brief MacroStaticReference constructor
   *
   * @param[in] id: id of the macroStaticReference
   *
   * @returns new MacroStaticReference::Impl instance with given attributes
   */
  explicit Impl(const std::string& id);

  /**
   * @brief MacroStaticReference destructor
   */
  virtual ~Impl();

  /**
   * @copydoc MacroStaticReference::getId()
   */
  std::string getId() const;

  /**
   * @copydoc MacroStaticReference::addStaticRef()
   */
  void addStaticRef(const std::string& var, const std::string& staticVar);

  /**
   * @copydoc MacroStaticReference::cbeginStaticRef() const
   */
  staticRef_const_iterator cbeginStaticRef() const;

  /**
   * @copydoc MacroStaticReference::cendStaticRef() const
   */
  staticRef_const_iterator cendStaticRef() const;

    /**
   * @copydoc MacroStaticReference::beginStaticRef()
   */
  staticRef_iterator beginStaticRef();

  /**
   * @copydoc MacroStaticReference::endStaticRef()
   */
  staticRef_iterator endStaticRef();

  /**
   * @copydoc MacroStaticReference::findStaticRef()
   */
  const boost::shared_ptr<StaticRef>& findStaticRef(const std::string& key);

  friend class StaticRefConstIteratorImpl;
  friend class StaticRefIteratorImpl;

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  std::string id_;  ///< id of the macroStaticReference
  std::map<std::string, boost::shared_ptr<StaticRef> > staticRefs_;  ///<  map of staticRefs
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROSTATICREFERENCEIMPL_H_
