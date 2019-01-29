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
 * @file PARExport.h
 * @brief Export definitions for WIN32 compatibility
 *
 */

#ifndef API_PAR_PAREXPORT_H_
#define API_PAR_PAREXPORT_H_

#if ((defined _WIN32) && (!defined DYNAWO_PAR_STATIC))
# ifdef DYNAWO_PAR_EXPORTS
#  define __DYNAWO_PAR_EXPORT __declspec(dllexport)
# else
#  define __DYNAWO_PAR_EXPORT __declspec(dllimport)
# endif
#else
# define __DYNAWO_PAR_EXPORT
#endif  // WIN32

#endif  // API_PAR_PAREXPORT_H_
