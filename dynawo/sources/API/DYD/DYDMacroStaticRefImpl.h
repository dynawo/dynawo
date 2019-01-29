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
 * @file DYDMacroStaticRefImpl.h
 * @brief MacroStaticRef description : header file
 *
 */

#ifndef API_DYD_DYDMACROSTATICREFIMPL_H_
#define API_DYD_DYDMACROSTATICREFIMPL_H_

#include "DYDMacroStaticRef.h"

namespace dynamicdata {

/**
 * @class MacroStaticRef::Impl
 * @brief MacroStaticRef implemented class
 */
class MacroStaticRef::Impl : public MacroStaticRef {
 public:
  /**
   * @brief MacroStaticRef::Impl constructor
   *
   * MacroStaticRef::Impl constructor.
   *
   * @param[in] id: id of the macroStaticRef
   *
   * @returns New MacroStaticRef::Impl instance with given attributes
   */
  explicit Impl(const std::string& id);

  /**
   * @brief MacroStaticRef destructor
   */
  virtual ~Impl();

  /**
   * @copydoc MacroStaticRef::getId()
   */
  std::string getId() const;

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  std::string id_;  ///< id of the macroStaticRef
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROSTATICREFIMPL_H_
