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
#include <libzip/ZipInputStream.h>

namespace zip {

const int BUFFER_SIZE = 10240;

struct BufferedInputStream {
  std::istream* stream;
  char buffer[BUFFER_SIZE];
};

__LA_SSIZE_T
bis_read(struct archive* /*archive*/, void* client_data, const void** buffer) {
  struct BufferedInputStream* bis = (struct BufferedInputStream*)client_data;

  *buffer = bis->buffer;

  bis->stream->read(bis->buffer, BUFFER_SIZE);

  return bis->stream->gcount();
}

boost::shared_ptr<ZipFile>
ZipInputStream::read(const std::string& filename) {
  std::ifstream stream(filename.c_str(), std::ios::binary);
  if (!stream.good())
    throw ZipException(Error::FILE_NOT_FOUND, filename);

  boost::shared_ptr<ZipFile> zip = read(stream);

  stream.close();

  return zip;
}

boost::shared_ptr<ZipFile>
ZipInputStream::read(std::istream& stream) {
  boost::shared_ptr<ZipFile> zip(new ZipFile());

  struct archive* archive = archive_read_new();
  archive_read_support_format_zip(archive);
#if ARCHIVE_VERSION_NUMBER < 3000000
  archive_read_support_compression_all(archive);
#else
  archive_read_support_filter_all(archive);
#endif

  BufferedInputStream bis;
  bis.stream = &stream;

  int status = archive_read_open(archive, &bis, NULL, bis_read, NULL);
  if (status != ARCHIVE_OK) {
    const std::string message(archive_error_string(archive));
#if ARCHIVE_VERSION_NUMBER < 3000000
    archive_read_finish(archive);
#else
    archive_read_free(archive);
#endif

    throw ZipException(Error::LIBARCHIVE_INTERNAL_ERROR, message);
  }

  struct archive_entry* info = archive_entry_new();
  while (archive_read_next_header2(archive, info) == ARCHIVE_OK) {
    const std::string pathname(archive_entry_pathname(info));

    // Lecture des donnees
    const int bufferSize = 1024;
    char buffer[1024];

    std::ostringstream stream(std::ios_base::out | std::ios_base::binary);
    int size = archive_read_data(archive, buffer, bufferSize);
    while (size > 0) {
      stream.write(buffer, size);

      size = archive_read_data(archive, buffer, bufferSize);
    }

    // Mise a jour de l'entete
    const std::string& data = stream.str();
    archive_entry_set_size(info, data.size());

    boost::shared_ptr<ZipEntry> entry(new ZipEntry(info, data));
    zip->addEntry(pathname, entry);
  }
  archive_entry_free(info);
#if ARCHIVE_VERSION_NUMBER < 3000000
  archive_read_finish(archive);
#else
  archive_read_free(archive);
#endif

  return zip;
}

}  // namespace zip
