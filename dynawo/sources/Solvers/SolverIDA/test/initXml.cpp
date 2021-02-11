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

#include "gtest_dynawo.h"
#include <xercesc/util/PlatformUtils.hpp>
#ifdef LANG_CXX11
#include <libxml/parser.h>
#endif

class Environment : public testing::Environment {
 public:
  ~Environment() {}

  // Override this to define how to set up the environment.
  void SetUp() {
    xercesc::XMLPlatformUtils::Initialize();
#ifdef LANG_CXX11
      xmlInitParser();
#endif
  }

  // Override this to define how to tear down the environment.
  void TearDown() {
    xercesc::XMLPlatformUtils::Terminate();
#ifdef LANG_CXX11
    xmlCleanupParser();
#endif
  }
};

testing::Environment* const foo_env =
    testing::AddGlobalTestEnvironment(new Environment);
