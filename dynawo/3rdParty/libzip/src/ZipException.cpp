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

#include <libzip/ZipException.h>

namespace zip {

ZipException::ZipException(Error::Code code, const std::string& message) throw() : m_code(code), m_message(message) {}

const Error::Code&
ZipException::getErrorCode() const {
  return m_code;
}

const char*
ZipException::what() const throw() {
  return m_message.c_str();
}

}  // namespace zip
