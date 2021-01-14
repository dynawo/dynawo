//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file DYNTraceAppender.cpp
 * @brief Implementation of Trace system appender
 *
 */

#include "DYNTraceAppender.h"

namespace DYN {

TraceAppender::TraceAppender():
    tag_(),
    filePath_(),
    lvlFilter_(INFO),
    showLevelTag_(false),
    separator_(),
    showTimeStamp_(false),
    timeStampFormat_(),
    append_(false),
    persistant_(false) { }

TraceAppender::~TraceAppender() { }

}  // namespace DYN
