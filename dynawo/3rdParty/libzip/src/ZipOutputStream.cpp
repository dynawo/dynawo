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

#include <archive.h>
#include <archive_entry.h>
#include <fstream>
#include <libzip/ZipEntry.h>
#include <libzip/ZipException.h>
#include <libzip/ZipFile.h>
#include <libzip/ZipOutputStream.h>

namespace zip {

struct BufferedOutputStream {
  std::ostream* stream;
};

__LA_SSIZE_T
bos_write(struct archive* /*archive*/, void* client_data, const void* buffer, size_t n) {
  struct BufferedOutputStream* bos = (struct BufferedOutputStream*)client_data;

  bos->stream->write((const char*)buffer, n);

  return n;
}

void
ZipOutputStream::write(const std::string& filename, const boost::shared_ptr<ZipFile>& zip) {
  std::ofstream stream(filename.c_str(), std::ios::binary);
  if (!stream.good())
    throw ZipException(Error::CANNOT_OPEN_FILE, filename);

  write(stream, zip);

  stream.close();
}

void
ZipOutputStream::write(std::ostream& stream, const boost::shared_ptr<ZipFile>& zip) {
  struct archive* archive = archive_write_new();
  archive_write_set_format_zip(archive);

  archive_write_set_bytes_per_block(archive, 1);

  BufferedOutputStream bos;
  bos.stream = &stream;

  int status = archive_write_open(archive, &bos, NULL, bos_write, NULL);
  if (status != ARCHIVE_OK) {
    const std::string message(archive_error_string(archive));
#if ARCHIVE_VERSION_NUMBER < 3000000
    archive_write_finish(archive);  // archive 2.8.3
#else
    archive_write_free(archive);  // archive 3.0.4
#endif

    throw ZipException(Error::LIBARCHIVE_INTERNAL_ERROR, message);
  }

  const std::map<std::string, boost::shared_ptr<ZipEntry> >& entries = zip->getEntries();
  std::map<std::string, boost::shared_ptr<ZipEntry> >::const_iterator itE;
  for (itE = entries.begin(); itE != entries.end(); ++itE) {
    const boost::shared_ptr<ZipEntry>& entry = itE->second;

    status = archive_write_header(archive, entry->getInfo());
    if (status != ARCHIVE_OK) {
      const std::string message(archive_error_string(archive));

      throw ZipException(Error::LIBARCHIVE_INTERNAL_ERROR, message);
    }

    archive_write_data(archive, entry->getData().c_str(), entry->getData().size());

    status = archive_write_finish_entry(archive);
    if (status != ARCHIVE_OK) {
      const std::string message(archive_error_string(archive));

      throw ZipException(Error::LIBARCHIVE_INTERNAL_ERROR, message);
    }
  }

  archive_write_close(archive);
#if ARCHIVE_VERSION_NUMBER < 3000000
  archive_write_finish(archive);  // archive 2.8.3
#else
  archive_write_free(archive);    // archive 3.0.4
#endif
}

}  // namespace zip
