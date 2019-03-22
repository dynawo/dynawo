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

#ifndef __ZIP_OUTPUT_STREAM_H__
#define __ZIP_OUTPUT_STREAM_H__

#include <sstream>
#include <string>

#include <boost/shared_ptr.hpp>

#include <libzip/ZipExport.h>

namespace zip {

class ZipFile;

class __LIBZIP_EXPORT ZipOutputStream {
public:
    static void write(const std::string& filename, const boost::shared_ptr<ZipFile>& zip);

    static void write(std::ostream& stream, const boost::shared_ptr<ZipFile>& zip);

protected:

private:

};

}

#endif /* __ZIP_OUTPUT_STREAM_H__ */
