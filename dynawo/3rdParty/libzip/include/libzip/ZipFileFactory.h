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

#ifndef __ZIP_FILE_FACTORY_H__
#define __ZIP_FILE_FACTORY_H__

#include <boost/shared_ptr.hpp>

namespace zip {

class ZipFile;

class ZipFileFactory {
public:
    static boost::shared_ptr<ZipFile> newInstance();

private:
    ZipFileFactory();

    ZipFileFactory(const ZipFileFactory&);

    ZipFileFactory& operator=(const ZipFileFactory&);
};

}

#endif /* __ZIP_FILE_FACTORY_H__ */
