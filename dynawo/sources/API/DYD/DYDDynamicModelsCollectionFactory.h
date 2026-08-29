//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file DYDDynamicModelsCollectionFactory.h
 * @brief Dynamic models collection factory : header file
 *
 */

#ifndef API_DYD_DYDDYNAMICMODELSCOLLECTIONFACTORY_H_
#define API_DYD_DYDDYNAMICMODELSCOLLECTIONFACTORY_H_

#include "DYDDynamicModelsCollection.h"

#include <boost/shared_ptr.hpp>
namespace dynamicdata {

/**
 * @class DynamicModelsCollectionFactory
 * @brief DynamicModelsCollection factory class
 *
 * DynamicModelsCollectionFactory encapsulate methods for creating new
 * @p DynamicModelsCollection objects.
 */
class DynamicModelsCollectionFactory {
 public:
  /**
   * @brief Create new DynamicModelsCollection instance
   *
   * @return Shared pointer to a new empty @p DynamicModelsCollection
   */
  static boost::shared_ptr<DynamicModelsCollection> newCollection();

  /**
   * @brief Create new DynamicModelsCollection instance as a clone of given instance
   *
   * @param[in] original DynamicModelsCollection to be cloned
   *
   * @return Shared pointer to a new @p DynamicModelsCollection copied from original
   */
  static boost::shared_ptr<DynamicModelsCollection> copyCollection(const boost::shared_ptr<DynamicModelsCollection>& original);
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDDYNAMICMODELSCOLLECTIONFACTORY_H_
