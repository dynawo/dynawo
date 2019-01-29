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
#include <iostream>

#include <archive_entry.h>

#include <libzip/ZipEntry.h>
#include <libzip/ZipException.h>
#include <libzip/ZipFile.h>
#include <libzip/ZipInputStream.h>

int main(int argc, char** argv) {
    if (argc != 2) {
        std::cerr << "Usage: sample1 <archive.zip>" << std::endl;
        exit(-1);
    }

    const std::string nomArchive(argv[1]);

    try {
        boost::shared_ptr<zip::ZipFile> zipFile = zip::ZipInputStream::read(nomArchive);

        std::cout << "Content of " << nomArchive << std::endl;

        const std::map<std::string, boost::shared_ptr<zip::ZipEntry> >& entries = zipFile->getEntries();
        std::map<std::string, boost::shared_ptr<zip::ZipEntry> >::const_iterator itE;
        for (itE = entries.begin(); itE != entries.end(); ++itE) {
            boost::shared_ptr<zip::ZipEntry> entry = itE->second;

            std::cout << archive_entry_pathname(entry->getInfo()) << "\t" << archive_entry_size(entry->getInfo())
                      << std::endl;
        }

        std::cout << zipFile->size() << " files read" << std::endl;
    }
    catch (std::exception& exc) {
        std::cerr << exc.what() << std::endl;
    }
}
