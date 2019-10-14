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

#ifndef __ZIP_EXCEPTION_H__
#define __ZIP_EXCEPTION_H__

#include <exception>
#include <string>

#include <libzip/ZipErrorCode.h>

namespace zip {

class ZipException : public std::exception {
public:
    virtual const Error::Code& getErrorCode() const = 0;

    class Impl;
};

}

#endif /* __ZIP_EXCEPTION_H__ */
