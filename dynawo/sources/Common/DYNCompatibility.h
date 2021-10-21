//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
//

/**
 * @file DYNCompatibility.h
 * @brief define macros for languages and standards compatibility
 */
#ifndef COMMON_DYNCOMPATIBILITY_H_
#define COMMON_DYNCOMPATIBILITY_H_

#ifdef LANG_CXX11
#define DYN_NOEXCEPT noexcept
#else
#define DYN_NOEXCEPT throw()
#endif

#endif  // COMMON_DYNCOMPATIBILITY_H_
