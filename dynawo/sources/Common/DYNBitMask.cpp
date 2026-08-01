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

#include "DYNBitMask.h"

namespace DYN {

BitMask::BitMask() : bitmask_(0)
{}

void
BitMask::setFlags(const unsigned char& flag) {
  bitmask_ |= flag;
}

void
BitMask::unsetFlags(const unsigned char& flag) {
  bitmask_ &= ~flag;
}

void
BitMask::reset() {
  unsetFlags(0xFF);
}

bool
BitMask::getFlags(const unsigned char& flag) const {
  return (bitmask_& flag) == flag;
}


bool
BitMask::noFlagSet() const {
  return bitmask_ == 0x00;
}

} /* namespace DYN */
