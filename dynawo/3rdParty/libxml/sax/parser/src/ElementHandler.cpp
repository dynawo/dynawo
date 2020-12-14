//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libxml, a library to handle XML files parsing.
//

/**
 * @file ElementHandler.cpp
 * @brief ElementHandler : implementation file
 *
 */

#include <xml/sax/parser/ElementHandler.h>

namespace xml {
namespace sax {
namespace parser {

void ElementHandler::readCharacters(std::string const&) {}


ElementHandler& ElementHandler::onStart(start_observer const& f) {
  start_observers.push_back(f);
  return *this;
}

ElementHandler& ElementHandler::onEnd(end_observer const& f) {
  end_observers.push_back(f);
  return *this;
}


void ElementHandler::start() const {
  for (start_observers_type::const_iterator it=start_observers.begin(); it!=start_observers.end(); ++it) {
    (*it)();
  }
}

void ElementHandler::end() const {
  for (end_observers_type::const_iterator it=end_observers.begin(); it!=end_observers.end(); ++it) {
    (*it)();
  }
}

void ElementHandler::start() {
  for (start_observers_type::iterator it=start_observers.begin(); it!=start_observers.end(); ++it) {
    (*it)();
  }
}

void ElementHandler::end() {
  for (end_observers_type::iterator it=end_observers.begin(); it!=end_observers.end(); ++it) {
    (*it)();
  }
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
