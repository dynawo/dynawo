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

#include <libzip/ZipEntry.h>
#include <libzip/ZipException.h>
#include <libzip/ZipFile.h>
#include <libzip/ZipInputStream.h>
#include <sstream>

#if __GNUC__ >= 8
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wparentheses"
#include <boost/algorithm/string.hpp>
#pragma GCC diagnostic pop
#elif __clang_major__ >= 7
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-local-typedef"
#include <boost/algorithm/string.hpp>
#pragma clang diagnostic pop
#else
#include <boost/algorithm/string.hpp>
#endif

#include <archive_entry.h>

namespace zip {

class ZipEntryNamePredicate {
 public:
  explicit ZipEntryNamePredicate(const std::string& value) : m_value(value) {}

  bool operator()(const std::pair<std::string, boost::shared_ptr<ZipEntry> >& entry) {
    return boost::iequals(m_value, entry.first);
  }

 private:
  std::string m_value;
};

ZipFile::ZipFile() : m_entries() {}

unsigned long
ZipFile::size() const {
  return m_entries.size();
}

bool
ZipFile::existEntry(const std::string& name, bool caseSensitive) const {
  std::map<std::string, boost::shared_ptr<ZipEntry> >::const_iterator itE;
  if (caseSensitive) {
    itE = m_entries.find(name);
  } else {
    ZipEntryNamePredicate predicate(name);

    itE = std::find_if(m_entries.begin(), m_entries.end(), predicate);
  }

  return (itE != m_entries.end());
}

const boost::shared_ptr<ZipEntry>&
ZipFile::getEntry(const std::string& name, bool caseSensitive) const {
  std::map<std::string, boost::shared_ptr<ZipEntry> >::const_iterator itE;
  if (caseSensitive) {
    itE = m_entries.find(name);
  } else {
    ZipEntryNamePredicate predicate(name);

    itE = std::find_if(m_entries.begin(), m_entries.end(), predicate);
  }

  if (itE == m_entries.end())
    throw ZipException(Error::FILE_NOT_FOUND, name);

  return itE->second;
}

const std::map<std::string, boost::shared_ptr<ZipEntry> >&
ZipFile::getEntries() const {
  return m_entries;
}

void
ZipFile::addEntry(const std::string& filename) {
  std::map<std::string, boost::shared_ptr<ZipEntry> >::iterator itE = m_entries.find(filename);
  if (itE != m_entries.end())
    m_entries.erase(itE);

  boost::shared_ptr<ZipEntry> entry(new ZipEntry(filename));
  m_entries.insert(std::make_pair(filename, entry));
}

void
ZipFile::addEntry(const std::string& name, const std::string& data) {
  std::map<std::string, boost::shared_ptr<ZipEntry> >::iterator itE = m_entries.find(name);
  if (itE != m_entries.end())
    m_entries.erase(itE);

  boost::shared_ptr<ZipEntry> entry(new ZipEntry(name, data));
  m_entries.insert(std::make_pair(name, entry));
}

void
ZipFile::addEntry(const std::string& name, const boost::shared_ptr<ZipEntry>& entry) {
  std::map<std::string, boost::shared_ptr<ZipEntry> >::iterator itE = m_entries.find(name);
  if (itE != m_entries.end())
    m_entries.erase(itE);

  m_entries.insert(std::make_pair(name, entry));
}

/**
 * Flatten each element of a zip to level 0.
 */
void
ZipFile::flattenZip(const ZipFlattenPolicy& policy) {
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

  std::map<std::string, boost::shared_ptr<ZipEntry> >::iterator itE = m_entries.begin();
  while (itE != m_entries.end()) {
    if (archive_entry_filetype(itE->second->getInfo()) == AE_IFDIR) {
      std::map<std::string, boost::shared_ptr<ZipEntry> >::iterator itErr = itE++;
      m_entries.erase(itErr);
    } else {
      ++itE;
    }
  }
}

/**
 * Add the contents of a inner zip to the current one.
 */
void
ZipFile::addZippedFile(const boost::shared_ptr<ZipFile>& zipFile, const ZipFlattenPolicy& policy) {
  const std::map<std::string, boost::shared_ptr<ZipEntry> >& entries = zipFile->getEntries();
  for (std::map<std::string, boost::shared_ptr<ZipEntry> >::const_iterator itE = entries.begin(); itE != entries.end(); ++itE) {
    const std::string& entryName = policy.apply(*this, itE->first);
    addEntry(entryName, itE->second);
  }
}

/**
 * Remove an entry from the instance.
 */
void
ZipFile::removeEntry(const std::string& name) {
  m_entries.erase(name);
}

/**
 * Get all the files names.
 * Return : std::vector<std::string>
 */
std::vector<std::string>
ZipFile::getIncludedZips() {
  std::vector<std::string> internalZips;
  for (std::map<std::string, boost::shared_ptr<ZipEntry> >::const_iterator itE = m_entries.begin(); itE != m_entries.end(); ++itE) {
    const std::string& fileName = itE->first;
    if (fileName.size() > 3 && boost::iequals(fileName.substr(fileName.size() - 4), ".zip")) {
      internalZips.push_back(fileName);
    }
  }
  return internalZips;
}

}  // namespace zip
