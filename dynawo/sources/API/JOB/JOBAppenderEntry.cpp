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
 * @file JOBAppenderEntry.cpp
 * @brief Appender entry description : implementation file
 *
 */

#include "JOBAppenderEntry.h"

namespace job {

AppenderEntry::AppenderEntry() : tag_(""), filePath_(""), lvlFilter_(""), showLevelTag_(true), separator_(" | "), timeStampFormat_("%Y-%m-%d %H:%M:%S") {}

const std::string&
AppenderEntry::getTag() const {
  return tag_;
}

const std::string&
AppenderEntry::getFilePath() const {
  return filePath_;
}

const std::string&
AppenderEntry::getLvlFilter() const {
  return lvlFilter_;
}

bool
AppenderEntry::getShowLevelTag() const {
  return showLevelTag_;
}

const std::string&
AppenderEntry::getSeparator() const {
  return separator_;
}

const std::string&
AppenderEntry::getTimeStampFormat() const {
  return timeStampFormat_;
}

void
AppenderEntry::setTag(const std::string& tag) {
  tag_ = tag;
}

void
AppenderEntry::setFilePath(const std::string& filePath) {
  filePath_ = filePath;
}

void
AppenderEntry::setLvlFilter(const std::string& lvlFilter) {
  lvlFilter_ = lvlFilter;
}

void
AppenderEntry::setShowLevelTag(const bool showTag) {
  showLevelTag_ = showTag;
}

void
AppenderEntry::setSeparator(const std::string& separator) {
  separator_ = separator;
}

void
AppenderEntry::setTimeStampFormat(const std::string& format) {
  timeStampFormat_ = format;
}

}  // namespace job
