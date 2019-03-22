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

#ifndef __ZIP_POLICY_H__
#define __ZIP_POLICY_H__

#include <string>

#include <libzip/ZipExport.h>

namespace zip {

class ZipFile;

class __LIBZIP_EXPORT ZipFlattenPolicy {
public:
    virtual ~ZipFlattenPolicy();

    virtual std::string apply(const ZipFile& zipFile, const std::string& entryName) const = 0;

};

class __LIBZIP_EXPORT ZipThrowPolicy : public ZipFlattenPolicy {
public:
    virtual ~ZipThrowPolicy();

    virtual std::string apply(const ZipFile& zipFile, const std::string& entryName) const;

};

class __LIBZIP_EXPORT ZipPostFixPolicy : public ZipFlattenPolicy {
public:
    virtual ~ZipPostFixPolicy();

    virtual std::string apply(const ZipFile& zipFile, const std::string& entryName) const;

};

}

#endif /* __ZIP_POLICY_H__ */
