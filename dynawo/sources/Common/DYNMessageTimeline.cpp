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

#include <boost/none.hpp>
#include "DYNMessageTimeline.h"
#include "DYNIoDico.h"

using std::stringstream;
using std::string;

namespace DYN {

MessageTimeline::MessageTimeline(const string& key) : Message("TIMELINE", key) {
  initialize(key);
}

MessageTimeline::MessageTimeline(const string& dicoName, const string& key) : Message(dicoName, key) {
  initialize(key);
}

void
MessageTimeline::initialize(const string& key) {
  priority_ = boost::none;
  static const string dicoName = "TIMELINE_PRIORITY";
  if (IoDicos::hasIoDico(dicoName)) {
    try {
      string priority = IoDicos::getIoDico(dicoName)->msg(key);
#ifdef LANG_CXX11
      priority_ = std::stoi(priority);
#else
      priority_ = std::atoi(priority.c_str());
#endif
    } catch (...) {}  // nothing to do, just try to find the error message
  }
}

MessageTimeline::MessageTimeline(const MessageTimeline& m) : Message(m) {
  priority_ = m.priority_;
}

}  // namespace DYN
