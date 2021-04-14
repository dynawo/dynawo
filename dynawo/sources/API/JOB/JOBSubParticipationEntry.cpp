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
 * @file JOBSUBPARTICIPATIONEntryImpl.cpp
 * @brief SubParticipation entry description : implementation file
 *
 */

#include "JOBSubParticipationEntry.h"

namespace job {


void
SubParticipationEntry::setSubParticipationTime(const double & subparticipationTime) {
  subparticipationTime_ = subparticipationTime;
}

double
SubParticipationEntry::getSubParticipationTime() const {
  return subparticipationTime_;
}

void
SubParticipationEntry::setSubParticipationNbMode(const double & subparticipationNbMode) {
  subparticipationNbMode_ = subparticipationNbMode;
}

double
SubParticipationEntry::getSubParticipationNbMode() const {
  return subparticipationNbMode_;
}

}  // namespace job
