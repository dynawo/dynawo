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
 * @file JOBNetworkEntryImpl.cpp
 * @brief Network entry description : implementation file
 *
 */

#include "JOBNetworkEntryImpl.h"

namespace job {

NetworkEntry::Impl::Impl() :
iidmFile_(""),
networkParFile_(""),
networkParId_("") {
}

NetworkEntry::Impl::~Impl() {
}

void
NetworkEntry::Impl::setIidmFile(const std::string& iidmFile) {
  iidmFile_ = iidmFile;
}

std::string
NetworkEntry::Impl::getIidmFile() const {
  return iidmFile_;
}

void
NetworkEntry::Impl::setNetworkParFile(const std::string& networkParFile) {
  networkParFile_ = networkParFile;
}

std::string
NetworkEntry::Impl::getNetworkParFile() const {
  return networkParFile_;
}

void
NetworkEntry::Impl::setNetworkParId(const std::string& parId) {
  networkParId_ = parId;
}

std::string
NetworkEntry::Impl::getNetworkParId() const {
  return networkParId_;
}

}  // namespace job
