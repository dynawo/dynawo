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

#include <libzip/ZipEntry.h>
#include <libzip/ZipException.h>
#include <libzip/ZipFile.h>
#include <libzip/ZipFileFactory.h>
#include <libzip/ZipInputStream.h>
#include <libzip/ZipOutputStream.h>

TEST(libZip, FlattenSimpleArchive) {
    // Build the test archive
    boost::shared_ptr<zip::ZipFile> archive = zip::ZipFileFactory::newInstance();
    archive->addEntry("testfile1.txt", "content of testfile1.txt");
    archive->addEntry("testfile2.txt", "content of testfile2.txt");
    archive->addEntry("testfile3.txt", "content of testfile3.txt");

    ASSERT_NO_THROW(archive->flattenZip(zip::ZipThrowPolicy()));
    ASSERT_EQ(3ul, archive->size());

    ASSERT_NO_THROW(archive->flattenZip(zip::ZipPostFixPolicy()));
    ASSERT_EQ(3ul, archive->size());
}

TEST(libZip, FlattenComplexArchive) {
    std::stringstream internalArchiveStream;
    std::stringstream archiveStream;

    boost::shared_ptr<zip::ZipFile> internalArchive = zip::ZipFileFactory::newInstance();
    internalArchive->addEntry("testfile4.txt", "content of testfile4.txt");
    internalArchive->addEntry("testfile5.txt", "content of testfile5.txt");
    internalArchive->addEntry("testfile6.txt", "content of testfile6.txt");
    zip::ZipOutputStream::write(internalArchiveStream, internalArchive);

    // Build the test archive
    boost::shared_ptr<zip::ZipFile> archive = zip::ZipFileFactory::newInstance();
    archive->addEntry("testfile1.txt", "content of testfile1.txt");
    archive->addEntry("testfile2.txt", "content of testfile2.txt");
    archive->addEntry("testfile3.txt", "content of testfile3.txt");
    archive->addEntry("test1.zip", internalArchiveStream.str());
    zip::ZipOutputStream::write(archiveStream, archive);

    ASSERT_NO_THROW(archive->flattenZip(zip::ZipThrowPolicy()));
    ASSERT_EQ(6ul, archive->size());

    // Reload the archive
    archive = zip::ZipInputStream::read(archiveStream);
    ASSERT_NO_THROW(archive->flattenZip(zip::ZipPostFixPolicy()));
    ASSERT_EQ(6ul, archive->size());
}

TEST(libZip, FlattenComplexArchiveWithConflicts) {
    //std::stringstream archive;
    std::stringstream archiveStream;
    std::stringstream archiveXStream;
    std::stringstream archiveYStream;
    std::stringstream archiveZStream;

    boost::shared_ptr<zip::ZipFile> archive_x = zip::ZipFileFactory::newInstance();
    archive_x->addEntry("testfile4.txt", "content of testfile4.txt");
    archive_x->addEntry("testfile5.txt", "content of testfile5(1).txt");
    zip::ZipOutputStream::write(archiveXStream, archive_x);

    boost::shared_ptr<zip::ZipFile> archive_z = zip::ZipFileFactory::newInstance();
    archive_z->addEntry("testfile5.txt", "content of testfile5(3).txt");
    archive_z->addEntry("foo/testfile3.txt", "content of foo/testfile3(1).txt");
    zip::ZipOutputStream::write(archiveZStream, archive_z);

    boost::shared_ptr<zip::ZipFile> archive_y = zip::ZipFileFactory::newInstance();
    archive_y->addEntry("testfile5.txt", "content of testfile5(2).txt");
    archive_y->addEntry("testfile7.txt", "content of testfile7.txt");
    archive_y->addEntry("z.zip", archiveZStream.str());
    zip::ZipOutputStream::write(archiveYStream, archive_y);

    boost::shared_ptr<zip::ZipFile> archive = zip::ZipFileFactory::newInstance();
    archive->addEntry("testfile1.txt", "content of testfile1.txt");
    archive->addEntry("testfile2.txt", "content of testfile2.txt");
    archive->addEntry("foo/testfile3.txt", "content of foo/testfile3.txt");
    archive->addEntry("x.zip", archiveXStream.str());
    archive->addEntry("y.zip", archiveYStream.str());
    archive->addEntry("testfile5.txt", "content of testfile5.txt");
    zip::ZipOutputStream::write(archiveStream, archive);

    ASSERT_THROW(archive->flattenZip(), zip::ZipException);

    // Reload the archive
    archive = zip::ZipInputStream::read(archiveStream);
    ASSERT_NO_THROW(archive->flattenZip(zip::ZipPostFixPolicy()));
    ASSERT_EQ(10ul, archive->size());

    // Check archive content
    const std::map<std::string, boost::shared_ptr<zip::ZipEntry> >& entries = archive->getEntries();
    std::map<std::string, boost::shared_ptr<zip::ZipEntry> >::const_iterator itE;
    for (itE = entries.begin(); itE != entries.end(); ++itE) {
        const boost::shared_ptr<zip::ZipEntry>& entry = itE->second;

        std::string expectedContent = std::string("content of ") + std::string(itE->first);
        const std::string& content = entry->getData();

        ASSERT_EQ(expectedContent, content);

    }

}
