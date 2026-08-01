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
 * @file API/JOB/test/TestNetworkEntry.cpp
 * @brief Unit tests for API_JOB/JOBNetworkEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBNetworkEntry.h"

namespace job {

TEST(APIJOBTest, testNetworkEntry) {
  boost::shared_ptr<NetworkEntry> network = boost::shared_ptr<NetworkEntry>(new NetworkEntry());
  // check default attributes
  ASSERT_EQ(network->getNetworkParFile(), "");
  ASSERT_EQ(network->getNetworkParId(), "");
  ASSERT_EQ(network->getIidmFile(), "");

  network->setNetworkParFile("/tmp/networkParameters.par");
  network->setNetworkParId("network_par");
  network->setIidmFile("/tmp/iidm.xml");

  ASSERT_EQ(network->getNetworkParFile(), "/tmp/networkParameters.par");
  ASSERT_EQ(network->getNetworkParId(), "network_par");
  ASSERT_EQ(network->getIidmFile(), "/tmp/iidm.xml");
}

}  // namespace job
