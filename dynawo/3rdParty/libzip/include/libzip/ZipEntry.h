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
  ZipEntry(const std::string& filename);
  ZipEntry(const std::string& name, const std::string& data);
  ZipEntry(struct archive_entry* info, const std::string& data);
  ~ZipEntry();

  struct archive_entry* getInfo() const;
  const std::string& getData() const;

 private:
  struct archive_entry* m_info;

  std::string m_data;
};

}  // namespace zip

#endif /* __ZIP_ENTRY_H__ */
