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

#include "ZipExceptionImpl.h"

namespace zip {

ZipException::Impl::Impl(Error::Code code, const std::string& message)
    : m_code(code),
      m_message(message) {
}

ZipException::Impl::~Impl() throw() {
}

const Error::Code& ZipException::Impl::getErrorCode() const {
    return m_code;
}

const char* ZipException::Impl::what() const throw() {
    return m_message.c_str();
}

}
