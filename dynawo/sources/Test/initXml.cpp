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

#include "gtest_dynawo.h"
#include "DYNInitXml.h"

class XmlEnvironment : public testing::Environment {
 public:
  ~XmlEnvironment() override;

  // Override this to define how to set up the environment.
  void SetUp() override {
    xercesc::XMLPlatformUtils::Initialize();
#ifdef DYNAWO_USE_LIBXML2
      xmlInitParser();
#endif
  }

  // Override this to define how to tear down the environment.
  void TearDown() override {
    xercesc::XMLPlatformUtils::Terminate();
#ifdef DYNAWO_USE_LIBXML2
    xmlCleanupParser();
#endif
  }
};

XmlEnvironment::~XmlEnvironment() {}

testing::Environment* initXmlEnvironment();

testing::Environment* initXmlEnvironment() {
  return testing::AddGlobalTestEnvironment(new XmlEnvironment);
}
