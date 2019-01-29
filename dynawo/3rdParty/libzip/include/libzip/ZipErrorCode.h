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

#ifndef __ZIP_ERROR_CODE_H__
#define __ZIP_ERROR_CODE_H__

namespace zip {

namespace Error {

enum Code {
    LIBARCHIVE_INTERNAL_ERROR, // Erreur interne de libarchive

    FILE_NOT_FOUND,
    CANNOT_OPEN_FILE,
    FILE_ALREADY_EXISTS
};

}

}

#endif /* __ZIP_ERROR_CODE_H__ */
