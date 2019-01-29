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

#ifndef __ZIP_FILE_H__
#define __ZIP_FILE_H__

#include <map>
#include <vector>
#include <string>

#include <boost/shared_ptr.hpp>

#include <libzip/ZipExport.h>
#include <libzip/ZipFlattenPolicy.h>

namespace zip {

class ZipEntry;


class __LIBZIP_EXPORT ZipFile {
public:
    virtual unsigned long size() const = 0;

    virtual bool existEntry(const std::string& name, bool caseSensitive = true) const = 0;

    virtual const boost::shared_ptr<ZipEntry>& getEntry(const std::string& name, bool caseSensitive = true) const = 0;

    virtual const std::map<std::string, boost::shared_ptr<ZipEntry> >& getEntries() const = 0;

    virtual void addEntry(const std::string& filename) = 0;

    virtual void addEntry(const std::string& name, const std::string& data) = 0;

    virtual void addEntry(const std::string& name, const boost::shared_ptr<ZipEntry>& entry) = 0;

    virtual void addZippedFile(const boost::shared_ptr<ZipFile>& zipFile, const ZipFlattenPolicy& policy) = 0;

    virtual void removeEntry(const std::string& name) = 0;

    virtual void flattenZip(const ZipFlattenPolicy& policy = ZipThrowPolicy()) = 0;

    class Impl;
};

}

#endif /* __ZIP_FILE_H__ */

