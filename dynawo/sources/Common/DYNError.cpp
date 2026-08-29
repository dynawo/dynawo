//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNError.cpp
 *
 * @brief Error implementation
 *
 * Error use the message class to access to the description of the error
 * and access to the description where each error message are described
 */
#include <sstream>
#include <stdio.h>
#include "DYNCommon.h"
#include "DYNFileSystemUtils.h"
#include "DYNError.h"

namespace DYN {

using std::stringstream;
using std::string;

Error::Error(const TypeError_t type, const int key, const std::string& file, const int line, const Message& m) :
std::exception(),
key_(key),
type_(type) {
  stringstream msg;
  msg << m.str();
  if (file != "") {
    const std::string fileName = fileNameFromPath(file);  // to retrieve the filename from the full path
    msg << " ( " << fileName << ":" << line << " )";
  }
  msgToReturn_ = msg.str();
}

Error::Error(const Error& e) :
std::exception(e),
key_(e.key_),
type_(e.type_),
msgToReturn_(e.msgToReturn_) {
}

const char* Error::what() const noexcept {
  return (msgToReturn_.c_str());
}

Error::TypeError_t Error::type() const {
  return type_;
}

int Error::key() const {
  return key_;
}

MessageError::MessageError(const MessageError& e) :
std::exception(),
msgToReturn_(e.msgToReturn_) {
}

MessageError::MessageError(const std::string& message) :
std::exception(),
msgToReturn_(message) {
}

const char * MessageError::what() const noexcept {
  return (msgToReturn_.c_str());
}

std::string MessageError::message() const {
  return msgToReturn_;
}

}  // namespace DYN
