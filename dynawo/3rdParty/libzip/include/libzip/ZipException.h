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
#include <libzip/ZipErrorCode.h>
#include <string>

namespace zip {

class ZipException : public std::exception {
 public:
  ZipException(Error::Code code, const std::string& message) throw();
  virtual ~ZipException() throw() {}

  const Error::Code& getErrorCode() const;

  const char* what() const throw();

 private:
  Error::Code m_code;
  std::string m_message;
};

}  // namespace zip

#endif /* __ZIP_EXCEPTION_H__ */
