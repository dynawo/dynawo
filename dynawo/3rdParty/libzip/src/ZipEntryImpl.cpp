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

#include <fstream>
#include <sstream>

#include <time.h>
#include <sys/stat.h>

#include <archive_entry.h>

#include "ZipExceptionImpl.h"

#include "ZipEntryImpl.h"

namespace zip {

ZipEntry::Impl::Impl(const std::string& filename) {
    struct stat st;
    if (stat(filename.c_str(), &st) != 0)
        throw ZipException::Impl(Error::CANNOT_OPEN_FILE, filename);

    // Lecture du contenu du fichier
    std::ifstream stream(filename.c_str(), std::ios::binary);
    if (!stream.good())
        throw ZipException::Impl(Error::CANNOT_OPEN_FILE, filename);
    std::stringstream buffer;
    buffer << stream.rdbuf();
    stream.close();

    m_info = archive_entry_new();
    archive_entry_copy_stat(m_info, &st);
    archive_entry_set_pathname(m_info, filename.c_str());

    m_data = buffer.str();
}

ZipEntry::Impl::Impl(const std::string& name, const std::string& data) {
    m_info = archive_entry_new();
    archive_entry_set_pathname(m_info, name.c_str());
    archive_entry_set_size(m_info, data.size());
    archive_entry_set_filetype(m_info, AE_IFREG);
    archive_entry_set_perm(m_info, 0644);

    // Modification de atime, ctime et mtime
    time_t now;
    time(&now);
    archive_entry_set_atime(m_info, now, 0);
    archive_entry_set_ctime(m_info, now, 0);
    archive_entry_set_mtime(m_info, now, 0);

    m_data = data;
}

ZipEntry::Impl::Impl(struct archive_entry* info, const std::string& data) {
    m_info = archive_entry_clone(info);
    m_data = data;
}

ZipEntry::Impl::~Impl() {
    if (m_info != NULL) {
        archive_entry_free(m_info);
        m_info = NULL;
    }
}

struct archive_entry* ZipEntry::Impl::getInfo() const {
    return m_info;
}

const std::string& ZipEntry::Impl::getData() const {
    return m_data;
}

}

