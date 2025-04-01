//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file  LEQLostEquipmentsCollectionFactory.h
 *
 * @brief Dynawo lost equipments collection factory : interface file
 *
 */
#ifndef API_LEQ_LEQLOSTEQUIPMENTSCOLLECTIONFACTORY_H_
#define API_LEQ_LEQLOSTEQUIPMENTSCOLLECTIONFACTORY_H_

#include <boost/shared_ptr.hpp>

namespace lostEquipments {
class LostEquipmentsCollection;

/**
 * @class LostEquipmentsCollectionFactory
 * @brief LostEquipments collection factory class
 *
 * LostEquipmentsCollectionFactory encapsulate methods for creating new
 * @p LostEquipmentsCollection objects.
 */
class LostEquipmentsCollectionFactory {
 public:
  /**
   * @brief Create new LostEquipmentsCollection instance
   *
   * @return shared pointer to a new empty @p LostEquipmentsCollection
   */
  static boost::shared_ptr<LostEquipmentsCollection> newInstance();
};
}  // namespace lostEquipments

#endif  // API_LEQ_LEQLOSTEQUIPMENTSCOLLECTIONFACTORY_H_
