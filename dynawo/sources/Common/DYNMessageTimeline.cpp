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
#include "DYNMacrosMessage.h"

using std::string;

namespace DYN {

MessageTimeline::MessageTimeline(const string& key) : Message(Message::TIMELINE_KEY, key) {
  initialize(key);
}

MessageTimeline::MessageTimeline(const string& dicoName, const string& key) : Message(dicoName, key) {
  initialize(key);
}

MessageTimeline::~MessageTimeline() {}

void
MessageTimeline::initialize(const string& key) {
  priority_ = boost::none;
  static const string dicoName = "TIMELINE_PRIORITY";
  if (IoDicos::hasIoDico(dicoName)) {
    try {
      const string priority = IoDicos::getIoDico(dicoName)->msg(key);
      priority_ = std::stoi(priority);
    } catch (const MessageError&) {
      std::cerr << "Could not load the message associated to key " << key << std::endl;
    }
  }
}

MessageTimeline::MessageTimeline(const MessageTimeline& m) :
Message(m),
priority_(m.priority_) { }

}  // namespace DYN
