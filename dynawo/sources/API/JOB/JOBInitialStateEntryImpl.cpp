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
 * @file JOBInitialStateEntryImpl.cpp
 * @brief Initial state entries description : implementation file
 *
 */

#include "JOBInitialStateEntryImpl.h"

#include <boost/make_shared.hpp>

namespace job {

InitialStateEntry::Impl::Impl() :
initialStateFile_("") {
}

InitialStateEntry::Impl::~Impl() {
}

boost::shared_ptr<InitialStateEntry>
InitialStateEntry::Impl::clone() const {
  return boost::make_shared<InitialStateEntry::Impl>(*this);
}

void
InitialStateEntry::Impl::setInitialStateFile(const std::string & initialStateFile) {
  initialStateFile_ = initialStateFile;
}

std::string
InitialStateEntry::Impl::getInitialStateFile() const {
  return initialStateFile_;
}

}  // namespace job
