//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNMessage.cpp
 *
 * @brief Message implementation
 *
 *  Message are used to access to dictionnary log where log are described
 *  with the boost::format convention
 */

#include <iostream>
#include <string>
#include <sstream>
#include "DYNMessage.hpp"
#include "DYNIoDico.h"


using std::stringstream;
using std::string;

namespace DYN {

const char Message::TIMELINE_KEY[] = "TIMELINE";
const char Message::ERROR_KEY[] = "ERROR";
const char Message::CONSTRAINT_KEY[] = "CONSTRAINT";
const char Message::LOG_KEY[] = "LOG";

Message::Message(const std::string& dicoName, const std::string& key) {
  initialize(dicoName, key);
}

void
Message::initialize(const std::string& dicoName, const std::string& key) {
  key_ = key;
  fmt_.clear_binds();
  hasFmt_ = false;
  string fmt = "";
  if (dicoName != "" && IoDicos::hasIoDico(dicoName)) {
    try {
      fmt = IoDicos::getIoDico(dicoName)->msg(key);
      hasFmt_ = true;
      fmt_ = boost::format(fmt.c_str());
    } catch (...) {}  // nothing to do, just try to find the error message
  } else {
    hasFmt_ = false;
    fmtss_ << key;
  }
}

Message::Message(const Message& m) {
  fmt_ = m.fmt_;
  fmtss_ << m.fmtss_.str();
  hasFmt_ = m.hasFmt_;
  key_ = m.key_;
}

std::string
Message::str() const {
  stringstream message;
  if (hasFmt_) {
    try {
      message << fmt_.str();
    }    catch (boost::io::too_many_args& exc) {
      std::cerr << exc.what() << std::endl;
    }    catch (boost::io::too_few_args& exc) {
      std::cerr << exc.what() << std::endl;
    }
  } else {
    message << fmtss_.str();
  }
  return (message.str());
}

}  // namespace DYN
