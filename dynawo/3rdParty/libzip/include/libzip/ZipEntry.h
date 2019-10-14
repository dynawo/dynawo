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

#ifndef __ZIP_ENTRY_H__
#define __ZIP_ENTRY_H__

#include <string>

struct archive_entry;

namespace zip {

class ZipEntry {
public:
    virtual struct archive_entry* getInfo() const = 0;

    virtual const std::string& getData() const = 0;

    class Impl;
};

}

#endif /* __ZIP_ENTRY_H__ */
