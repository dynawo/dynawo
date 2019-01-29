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
 * @file JOBAppenderEntryImpl.cpp
 * @brief Appender entry description : implementation file
 *
 */

#include "JOBAppenderEntryImpl.h"

namespace job {

AppenderEntry::Impl::Impl() :
tag_(""),
filePath_(""),
lvlFilter_(""),
showLevelTag_(true),
separator_(" | "),
timeStampFormat_("%Y-%m-%d %H:%M:%S") {
}

AppenderEntry::Impl::~Impl() {
}

std::string
AppenderEntry::Impl::getTag() const {
  return tag_;
}

std::string
AppenderEntry::Impl::getFilePath() const {
  return filePath_;
}

std::string
AppenderEntry::Impl::getLvlFilter() const {
  return lvlFilter_;
}

bool
AppenderEntry::Impl::getShowLevelTag() const {
  return showLevelTag_;
}

std::string
AppenderEntry::Impl::getSeparator() const {
  return separator_;
}

std::string
AppenderEntry::Impl::getTimeStampFormat() const {
  return timeStampFormat_;
}

void
AppenderEntry::Impl::setTag(const std::string& tag) {
  tag_ = tag;
}

void
AppenderEntry::Impl::setFilePath(const std::string& filePath) {
  filePath_ = filePath;
}

void
AppenderEntry::Impl::setLvlFilter(const std::string& lvlFilter) {
  lvlFilter_ = lvlFilter;
}

void
AppenderEntry::Impl::setShowLevelTag(const bool showTag) {
  showLevelTag_ = showTag;
}

void
AppenderEntry::Impl::setSeparator(const std::string& separator) {
  separator_ = separator;
}

void
AppenderEntry::Impl::setTimeStampFormat(const std::string& format) {
  timeStampFormat_ = format;
}

}  // namespace job
