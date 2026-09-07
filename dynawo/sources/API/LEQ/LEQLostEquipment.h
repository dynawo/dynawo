//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file  LEQLostEquipment.h
 *
 * @brief Dynawo lost equipment : interface file
 *
 */
#ifndef API_LEQ_LEQLOSTEQUIPMENT_H_
#define API_LEQ_LEQLOSTEQUIPMENT_H_

#include <string>

namespace lostEquipments {

/**
 * @brief LostEquipment
 */
class LostEquipment {
 public:
  /**
   * @brief Constructor
   */
  LostEquipment() = default;

  /**
   * @brief Constructor
   * @param id Lost equipment's id
   * @param type Lost equipment's type
   */
  LostEquipment(const std::string& id, const std::string& type);

  /**
   * @brief Setter for lost equipment's id
   * @param id Lost equipment's id
   */
  void setId(const std::string& id);

  /**
   * @brief Setter for lost equipment's type
   * @param type Lost equipment's type
   */
  void setType(const std::string& type);

  /**
   * @brief Getter for lost equipment's id
   * @return Lost equipment's id
   */
  const std::string& getId() const;

  /**
   * @brief Getter for lost equipment's type
   * @return Lost equipment's type
   */
  const std::string& getType() const;

 private:
  std::string id_;    ///< Id of the lost equipment
  std::string type_;  ///< Type of the lost equipment
};
}  // namespace lostEquipments

#endif  // API_LEQ_LEQLOSTEQUIPMENT_H_
