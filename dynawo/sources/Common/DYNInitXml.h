//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file DYNInitXml.h
 *
 * @brief Init xml parsers
 *
 */
#ifndef COMMON_DYNINITXML_H_
#define COMMON_DYNINITXML_H_

#include "config.h"

#include <xercesc/util/PlatformUtils.hpp>
#ifdef DYNAWO_USE_LIBXML2
#include <libxml/parser.h>
#endif

namespace DYN {

/**
 * Helper class to load/unload properly Xerces
 */
class InitXerces {
 public:
  InitXerces() {
    xercesc::XMLPlatformUtils::Initialize();
  }

  ~InitXerces() {
    xercesc::XMLPlatformUtils::Terminate();
  }
};

/**
 * Helper class to load/unload properly LibXml2
 */
class InitLibXml2 {
 public:
  InitLibXml2() {
#ifdef DYNAWO_USE_LIBXML2
    xmlInitParser();
#endif
  }

  ~InitLibXml2() {
#ifdef DYNAWO_USE_LIBXML2
    xmlCleanupParser();
#endif
  }
};

}  // namespace DYN

#endif  // COMMON_DYNINITXML_H_
