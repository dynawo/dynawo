//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNRTInputCommon.h
 *
 * @brief Input message header
 *
 */
#ifndef RT_COMMON_DYNRTOUTPUTCOMMON_H_
#define RT_COMMON_DYNRTOUTPUTCOMMON_H_
#include <string>
#include <memory>

enum class CurvesOutputFormat {
    BYTES,
    CSV,
    JSON,
    XML,
};

enum class TimelineOutputFormat {
    CSV,
    JSON,
    TXT,
    XML
};

enum class ConstraintsOutputFormat {
    JSON,
    TXT,
    XML
};

#endif  // RT_COMMON_DYNRTOUTPUTCOMMON_H_
