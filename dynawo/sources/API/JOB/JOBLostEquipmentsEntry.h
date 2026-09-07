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
 * @file JOBLostEquipmentsEntry.h
 * @brief lostEquipments entries description : interface file
 *
 */

#ifndef API_JOB_JOBLOSTEQUIPMENTSENTRY_H_
#define API_JOB_JOBLOSTEQUIPMENTSENTRY_H_

namespace job {

/**
 * @class LostEquipmentsEntry
 * @brief lostEquipments entries container class
 */
class LostEquipmentsEntry {
 public:
  /**
   * @brief constructor
   */
  LostEquipmentsEntry();

  /**
   * @brief whether to dump lost equipments setter
   * @param dumpLostEquipments : whether to dump the lost equipments for the job
   */
  void setDumpLostEquipments(const bool dumpLostEquipments);

  /**
   * @brief whether to dump the lost equipments getter
   * @return whether to dump the lost equipments for the job
   */
  bool getDumpLostEquipments() const;

 private:
  bool dumpLostEquipments_;  ///< boolean indicating whether to dump the lost equipments in the outputs directory
};

}  // namespace job

#endif  // API_JOB_JOBLOSTEQUIPMENTSENTRY_H_
