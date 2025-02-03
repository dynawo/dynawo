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
 * @file  LEQLostEquipmentFactory.h
 *
 * @brief Dynawo lost equipment factory: header file
 *
 */
#ifndef API_LEQ_LEQLOSTEQUIPMENTFACTORY_H_
#define API_LEQ_LEQLOSTEQUIPMENTFACTORY_H_

#include "LEQLostEquipment.h"

#include <memory>


namespace lostEquipments {
/**
 * @class LostEquipmentFactory
 * @brief Lost equipment factory class
 *
 * LostEquipmentFactory encapsulate methods for creating new
 * @p LostEquipment objects.
 */
class LostEquipmentFactory {
 public:
  /**
   * @brief Create new LostEquipment instance
   *
   * @return unique pointer to a new empty @p LostEquipment
   */
  static std::unique_ptr<LostEquipment> newLostEquipment();

  /**
   * @brief Create new LostEquipment instance
   * @param id Lost equipment's id
   * @param type Lost equipment's type
   * @return unique pointer to a new @p LostEquipment
   */
  static std::unique_ptr<LostEquipment> newLostEquipment(const std::string& id, const std::string& type);
};
}  // namespace lostEquipments

#endif  // API_LEQ_LEQLOSTEQUIPMENTFACTORY_H_
