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

#include "ZipFileImpl.h"

#include <sstream>

#include <boost/algorithm/string.hpp>

#include <libzip/ZipInputStream.h>

#include "ZipEntryImpl.h"
#include "ZipExceptionImpl.h"

namespace zip {

class ZipEntryNamePredicate {
public:
    explicit ZipEntryNamePredicate(const std::string& value) :
        m_value(value) {
    }

    bool operator()(const std::pair<std::string, boost::shared_ptr<ZipEntry> >& entry) {
        return boost::iequals(m_value, entry.first);
    }

private:
    std::string m_value;
};

ZipFile::Impl::Impl() :
    m_entries() {
}

ZipFile::Impl::~Impl() {
}

unsigned long ZipFile::Impl::size() const {
    return m_entries.size();
}

bool ZipFile::Impl::existEntry(const std::string& name, bool caseSensitive) const {
    std::map<std::string, boost::shared_ptr<ZipEntry> >::const_iterator itE;
    if (caseSensitive) {
        itE = m_entries.find(name);
    } else {
        ZipEntryNamePredicate predicate(name);

        itE = std::find_if(m_entries.begin(), m_entries.end(), predicate);
    }

    return (itE != m_entries.end());
}

const boost::shared_ptr<ZipEntry>& ZipFile::Impl::getEntry(const std::string& name, bool caseSensitive) const {
    std::map<std::string, boost::shared_ptr<ZipEntry> >::const_iterator itE;
    if (caseSensitive) {
        itE = m_entries.find(name);
    } else {
        ZipEntryNamePredicate predicate(name);

        itE = std::find_if(m_entries.begin(), m_entries.end(), predicate);
    }

    if (itE == m_entries.end())
        throw ZipException::Impl(Error::FILE_NOT_FOUND, name);

    return itE->second;
}

const std::map<std::string, boost::shared_ptr<ZipEntry> >& ZipFile::Impl::getEntries() const {
    return m_entries;
}

void ZipFile::Impl::addEntry(const std::string& filename) {
    std::map<std::string, boost::shared_ptr<ZipEntry> >::iterator itE = m_entries.find(filename);
    if (itE != m_entries.end())
        m_entries.erase(itE);

    boost::shared_ptr<ZipEntry> entry(new ZipEntry::Impl(filename));
#if defined LANG_CXX11 || defined LANG_CXX0X
    m_entries.insert(std::make_pair(filename, entry));
#else
    m_entries.insert(std::pair<std::string, boost::shared_ptr<ZipEntry> >(filename, entry));
#endif
}

void ZipFile::Impl::addEntry(const std::string& name, const std::string& data) {
    std::map<std::string, boost::shared_ptr<ZipEntry> >::iterator itE = m_entries.find(name);
    if (itE != m_entries.end())
        m_entries.erase(itE);

    boost::shared_ptr<ZipEntry> entry(new ZipEntry::Impl(name, data));
#if defined LANG_CXX11 || defined LANG_CXX0X
    m_entries.insert(std::make_pair(name, entry));
#else
    m_entries.insert(std::pair<std::string, boost::shared_ptr<ZipEntry> >(name, entry));
#endif
}

void ZipFile::Impl::addEntry(const std::string& name, const boost::shared_ptr<ZipEntry>& entry) {
    std::map<std::string, boost::shared_ptr<ZipEntry> >::iterator itE = m_entries.find(name);
    if (itE != m_entries.end())
        m_entries.erase(itE);

#if defined LANG_CXX11 || defined LANG_CXX0X
    m_entries.insert(std::make_pair(name, entry));
#else
    m_entries.insert(std::pair<std::string, boost::shared_ptr<ZipEntry> >(name, entry));
#endif
}

/**
 * Flatten each element of a zip to level 0.
 */
void ZipFile::Impl::flattenZip(const ZipFlattenPolicy& policy) {
    bool hasInternalZips;
    do {
        const std::vector<std::string>& internalZips = getIncludedZips();
        hasInternalZips = !internalZips.empty();

        for (std::vector<std::string>::const_iterator it = internalZips.begin(); it != internalZips.end(); ++it) {
            // Unzip.
            std::istringstream stream(m_entries[*it]->getData());
            const boost::shared_ptr<ZipFile>& internalZip = zip::ZipInputStream::read(stream);

            removeEntry(*it);
            addZippedFile(internalZip, policy);
        }
    } while (hasInternalZips);
}

/**
 * Add the contents of a inner zip to the current one.
 */
void ZipFile::Impl::addZippedFile(const boost::shared_ptr<ZipFile>& zipFile, const ZipFlattenPolicy& policy) {
    const std::map<std::string, boost::shared_ptr<ZipEntry> >& entries = zipFile->getEntries();
    for (std::map<std::string, boost::shared_ptr<ZipEntry> >::const_iterator itE = entries.begin();
         itE != entries.end(); ++itE) {
        const std::string& entryName = policy.apply(*this, itE->first);
        addEntry(entryName, itE->second);
    }
}

/**
 * Remove an entry from the instance.
 */
void ZipFile::Impl::removeEntry(const std::string& name) {
    m_entries.erase(name);
}

/**
 * Get all the files names.
 * Return : std::vector<std::string>
 */
std::vector<std::string> ZipFile::Impl::getIncludedZips() {
    std::vector<std::string> internalZips;
    for (std::map<std::string, boost::shared_ptr<ZipEntry> >::const_iterator itE = m_entries.begin();
         itE != m_entries.end(); ++itE) {
        const std::string& fileName = itE->first;
        if (boost::iequals(fileName.substr(fileName.size() - 4), ".zip")) {
            internalZips.push_back(fileName);
        }
    }
    return internalZips;
}

}
