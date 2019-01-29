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

#include <string>

#include <boost/shared_ptr.hpp>

#include <gtest/gtest.h>

#include <archive_entry.h>

#include <libzip/ZipFile.h>
#include <libzip/ZipFileFactory.h>
#include <libzip/ZipEntry.h>
#include <libzip/ZipInputStream.h>
#include <libzip/ZipOutputStream.h>

TEST(libZip, Test1) {
    boost::shared_ptr<zip::ZipFile> archive = zip::ZipFileFactory::newInstance();
    archive->addEntry("testfile1.txt", "content of testfile1.txt");
    archive->addEntry("testfile2.txt", "content of testfile2.txt");
    archive->addEntry("testfile3.txt", "content of testfile3.txt");
    zip::ZipOutputStream::write("test1.zip", archive);

    boost::shared_ptr<zip::ZipFile> archive2 = zip::ZipInputStream::read("test1.zip");
    const std::map<std::string, boost::shared_ptr<zip::ZipEntry> >& entries = archive2->getEntries();
    std::map<std::string, boost::shared_ptr<zip::ZipEntry> >::const_iterator itE;
    for (itE = entries.begin(); itE != entries.end(); ++itE) {
        boost::shared_ptr<zip::ZipEntry> entry = itE->second;

        std::string expectedContent = std::string("content of ") + archive_entry_pathname(entry->getInfo());
        std::string content = entry->getData();

        ASSERT_EQ(content, expectedContent);
    }
}
