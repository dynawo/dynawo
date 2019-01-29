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
 * @file PARReferenceImpl.h
 * @brief Dynawo references : header file
 *
 */

#ifndef API_PAR_PARREFERENCEIMPL_H_
#define API_PAR_PARREFERENCEIMPL_H_

#include "PARReference.h"

namespace parameters {

/**
 * @class Reference::Impl
 * @brief Reference implemented class
 *
 * Implementation of Reference interface class.
 */
class Reference::Impl : public Reference {
 public:
  /**
   * @brief Constructor of reference
   *
   * @param[in] name: reference name
   */
  explicit Impl(const std::string& name);

  /**
   * @brief Destructor
   */
  virtual ~Impl();

  /**
   * @copydoc Reference::setType( const std::string& type)
   */
  void setType(const std::string& type);

  /**
   * @copydoc Reference::setOrigData( const std::string& origData)
   */
  void setOrigData(const std::string& origData);

  /**
   * @copydoc Reference::setOrigData( const OriginData& origData)
   */
  void setOrigData(const OriginData& origData);

  /**
   * @copydoc Reference::setOrigName( const std::string& origName)
   */
  void setOrigName(const std::string& origName);

  /**
   * @copydoc Reference::setComponentId( const std::string& id)
   */
  void setComponentId(const std::string& id);

  /**
   * @copydoc Reference::getType()
   */
  std::string getType() const;

  /**
   * @copydoc Reference::getName()
   */
  std::string getName() const;

  /**
   * @copydoc Reference::getOrigData()
   */
  Reference::OriginData getOrigData() const;

  /**
   * @copydoc Reference::getOrigDataStr()
   */
  std::string getOrigDataStr() const;

  /**
   * @copydoc Reference::getOrigName()
   */
  std::string getOrigName() const;

  /**
   * @copydoc Reference::getComponentId()
   */
  std::string getComponentId() const;

 private:
#ifdef LANG_CXX11
  Impl() = delete;  // Private default constructor
#else
  Impl();  // Private default constructor
#endif

  std::string type_;  ///< Reference's type
  std::string name_;  ///< Reference's name
  Reference::OriginData origData_;  ///< Reference's origin data
  std::string origName_;  ///< Reference's origin name
  std::string componentId_;  ///< Reference's component id
};

}  // namespace parameters

#endif  // API_PAR_PARREFERENCEIMPL_H_
