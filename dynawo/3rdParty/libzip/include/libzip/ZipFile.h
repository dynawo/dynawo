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

#include <boost/shared_ptr.hpp>
#include <libzip/ZipEntry.h>
#include <libzip/ZipFlattenPolicy.h>
#include <map>
#include <string>
#include <vector>

namespace zip {

class ZipFile {
 public:
  ZipFile();

  unsigned long size() const;

  bool existEntry(const std::string& name, bool caseSensitive = true) const;

  const boost::shared_ptr<ZipEntry>& getEntry(const std::string& name, bool caseSensitive = true) const;

  const std::map<std::string, boost::shared_ptr<ZipEntry> >& getEntries() const;

  void addEntry(const std::string& filename);

  void addEntry(const std::string& name, const std::string& data);

  void addEntry(const std::string& name, const boost::shared_ptr<ZipEntry>& entry);

  void removeEntry(const std::string& name);

  void addZippedFile(const boost::shared_ptr<ZipFile>& zipFile, const ZipFlattenPolicy& policy);

  void flattenZip(const ZipFlattenPolicy& policy);

 private:
  std::map<std::string, boost::shared_ptr<ZipEntry> > m_entries;

  std::vector<std::string> getIncludedZips();
};

}  // namespace zip

#endif /* __ZIP_FILE_H__ */
