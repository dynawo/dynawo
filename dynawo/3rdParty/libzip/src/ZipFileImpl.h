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

#ifndef __ZIP_FILE_IMPL_H__
#define __ZIP_FILE_IMPL_H__

#include <libzip/ZipFile.h>

namespace zip {

class ZipFile::Impl : public ZipFile {
public:
    Impl();

    virtual ~Impl();

    virtual unsigned long size() const;

    virtual bool existEntry(const std::string& name, bool caseSensitive = true) const;

    virtual const boost::shared_ptr<ZipEntry>& getEntry(const std::string& name, bool caseSensitive = true) const;

    virtual const std::map<std::string, boost::shared_ptr<ZipEntry> >& getEntries() const;

    virtual void addEntry(const std::string& filename);

    virtual void addEntry(const std::string& name, const std::string& data);

    virtual void addEntry(const std::string& name, const boost::shared_ptr<ZipEntry>& entry);

    virtual void removeEntry(const std::string& name);

    virtual void addZippedFile(const boost::shared_ptr<ZipFile>& zipFile, const ZipFlattenPolicy& policy);

    virtual void flattenZip(const ZipFlattenPolicy& policy);

private:
    std::map<std::string, boost::shared_ptr<ZipEntry> > m_entries;

    std::vector<std::string> getIncludedZips();

};

}

#endif /* __ZIP_FILE_IMPL_H__ */
