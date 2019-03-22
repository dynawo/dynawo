//
// Copyright (c) 2013-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libzip, a library to handle zip archives.
//

#ifndef __ZIP_EXPORT_H__
#define __ZIP_EXPORT_H__

#if ((defined _WIN32) && (!defined LIBZIP_STATIC))
# ifdef LIBZIP_EXPORTS
#   define __LIBZIP_EXPORT __declspec(dllexport)
# else
#   define __LIBZIP_EXPORT __declspec(dllimport)
# endif
#else
# define __LIBZIP_EXPORT
#endif // WIN32

#endif /* __ZIP_EXPORT_H__ */
