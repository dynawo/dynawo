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
 * @file JOBNetworkEntry.cpp
 * @brief Network entry description : implementation file
 *
 */

#include "JOBNetworkEntry.h"

namespace job {

void
NetworkEntry::setIidmFile(const std::string& iidmFile) {
  iidmFile_ = iidmFile;
}

const std::string&
NetworkEntry::getIidmFile() const {
  return iidmFile_;
}

void
NetworkEntry::setNetworkParFile(const std::string& networkParFile) {
  networkParFile_ = networkParFile;
}

const std::string&
NetworkEntry::getNetworkParFile() const {
  return networkParFile_;
}

void
NetworkEntry::setNetworkParId(const std::string& parId) {
  networkParId_ = parId;
}

const std::string&
NetworkEntry::getNetworkParId() const {
  return networkParId_;
}

}  // namespace job
