//
// Copyright (c) 2023, RTE (http://www.rte-france.com)
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

#include "DYNXmlCharConversion.h"

namespace DYN {

std::string XML2S(const xmlChar* str) {
    // NOLINTNEXTLINE: signed/unsigned bitwise representation are equals
    return reinterpret_cast<const char*>(str);
}

const xmlChar* S2XML(const std::string& str) {
    // NOLINTNEXTLINE: signed/unsigned bitwise representation are equals
    return reinterpret_cast<const xmlChar*>(str.c_str());
}

}  // end of namespace DYN
