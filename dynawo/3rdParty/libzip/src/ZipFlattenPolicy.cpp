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

#include <libzip/ZipFlattenPolicy.h>

#include <map>
#include <sstream>

#include "ZipExceptionImpl.h"
#include "ZipFileImpl.h"

namespace zip {

ZipFlattenPolicy::~ZipFlattenPolicy() {
}

ZipThrowPolicy::~ZipThrowPolicy() {
}

std::string ZipThrowPolicy::apply(const ZipFile& zipFile, const std::string& entryName) const {
    if (zipFile.getEntries().find(entryName) != zipFile.getEntries().end()) {
        throw ZipException::Impl(Error::FILE_ALREADY_EXISTS, entryName);
    }
    return entryName;
}

ZipPostFixPolicy::~ZipPostFixPolicy() {
}

std::string ZipPostFixPolicy::apply(const ZipFile& zipFile, const std::string& entryName) const {
    std::string localName = entryName;
    unsigned long cpt = 0;

    while (zipFile.getEntries().find(localName) != zipFile.getEntries().end()) {
        localName = entryName;
        std::ostringstream o;
        o << "(" << ++cpt << ")";
        localName.insert(localName.rfind('.'), o.str());
    }
    return localName;
}

}
