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
 * @file API/PAR/test/TestReference.cpp
 * @brief Unit tests for API_PAR
 */

#include <boost/shared_ptr.hpp>

#include "gtest_dynawo.h"

#include "PARReference.h"
#include "PARReferenceFactory.h"

using boost::shared_ptr;

namespace parameters {

//-----------------------------------------------------
// TEST check reference factory + set and get functions
//-----------------------------------------------------

TEST(APIPARTest, Reference) {
  shared_ptr<Reference> refencePar = ReferenceFactory::newReference("standardRef", Reference::OriginData::IIDM);

  // Test default attributes
  ASSERT_TRUE(refencePar->getType().empty());
  ASSERT_EQ(refencePar->getName(), "standardRef");
  ASSERT_EQ(refencePar->getOrigData(), Reference::OriginData::IIDM);
  ASSERT_EQ(refencePar->getOrigDataStr(), "IIDM");
  ASSERT_TRUE(refencePar->getOrigName().empty());
  ASSERT_TRUE(refencePar->getComponentId().empty());
  ASSERT_TRUE(refencePar->getParId().empty());
  ASSERT_TRUE(refencePar->getParFile().empty());

  // Test set methods
  refencePar->setType("DOUBLE");
  refencePar->setOrigName("RefOrigin");
  refencePar->setComponentId("CompId");
  refencePar->setParId("42");
  refencePar->setParFile("myPar.par");

  // Test get methods
  ASSERT_EQ(refencePar->getType(), "DOUBLE");
  ASSERT_EQ(refencePar->getName(), "standardRef");
  ASSERT_EQ(refencePar->getOrigName(), "RefOrigin");
  ASSERT_EQ(refencePar->getComponentId(), "CompId");
  ASSERT_EQ(refencePar->getParId(), "42");
  ASSERT_EQ(refencePar->getParFile(), "myPar.par");

  // Test Reference constructor
  shared_ptr<Reference> refencePar2 = ReferenceFactory::newReference("standardRef2", Reference::PAR);
  ASSERT_EQ(refencePar2->getOrigData(), Reference::PAR);
  ASSERT_EQ(refencePar2->getOrigDataStr(), "PAR");
}

}  // namespace parameters
