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
 * @file  DYNRTOutputCommon.h
 *
 * @brief Output message formats
 *
 */
#ifndef RT_COMMON_DYNRTOUTPUTCOMMON_H_
#define RT_COMMON_DYNRTOUTPUTCOMMON_H_
#include <string>
#include <memory>

namespace DYN {

/**
 * @enum CurvesStreamFormat
 * @brief Supported formats for curve outputs.
 */
enum class CurvesStreamFormat {
  BYTES,  ///< Raw bytes
  CSV,    ///< CSV format
  JSON,   ///< JSON format
  XML     ///< XML format
};

/**
 * @enum TimelineStreamFormat
 * @brief Supported formats for timeline outputs.
 */
enum class TimelineStreamFormat {
  CSV,   ///< CSV format
  JSON,  ///< JSON format
  TXT,   ///< Plain text format
  XML    ///< XML format
};

/**
 * @enum ConstraintsStreamFormat
 * @brief Supported formats for constraints outputs.
 */
enum class ConstraintsStreamFormat {
  JSON,  ///< JSON format
  TXT,   ///< Plain text format
  XML    ///< XML format
};

}  // end of namespace DYN

#endif  // RT_COMMON_DYNRTOUTPUTCOMMON_H_
