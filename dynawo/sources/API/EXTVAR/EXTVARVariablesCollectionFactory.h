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
 * @file EXTVARVariablesCollectionFactory.h
 * @brief External variables collection factory : header file
 *
 */

#ifndef API_EXTVAR_EXTVARVARIABLESCOLLECTIONFACTORY_H_
#define API_EXTVAR_EXTVARVARIABLESCOLLECTIONFACTORY_H_

#include <boost/shared_ptr.hpp>

#include "EXTVARExport.h"

namespace externalVariables {
class VariablesCollection;

/**
 * @class VariablesCollectionFactory
 * @brief VariablesCollectionFactory factory class
 *
 * VariablesCollectionFactory encapsulate methods for creating new
 * @p VariablesCollection objects.
 */
class __DYNAWO_EXTVAR_EXPORT VariablesCollectionFactory {
 public:
  /**
   * @brief Create new VariablesCollection instance
   * @return Shared pointer to a new empty @p VariablesCollection
   */
  static boost::shared_ptr<VariablesCollection> newCollection();

  /**
   * @brief Create new VariablesCollection instance as a clone of given instance
   * @param[in] original VariablesCollection to be cloned
   * @return Shared pointer to a new @p VariablesCollection copied from original
   */
  static boost::shared_ptr<VariablesCollection> copyCollection(boost::shared_ptr<VariablesCollection> original);
};

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARVARIABLESCOLLECTIONFACTORY_H_
