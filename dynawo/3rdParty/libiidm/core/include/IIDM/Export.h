//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libiidm, a library to model IIDM networks and allows
// importing and exporting them to files.
//

#ifndef LIBIIDM_GUARD_EXPORT_H
#define LIBIIDM_GUARD_EXPORT_H

#if ((defined _WIN32) && (! defined LIBIIDM_STATIC))
#  ifdef API_IIDM_EXPORTS
#    define IIDM_EXPORT __declspec(dllexport)
#  else
#    define IIDM_EXPORT __declspec(dllimport)
#  endif
#else
#  define IIDM_EXPORT
#endif // WIN32

#endif
