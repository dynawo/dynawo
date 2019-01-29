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
  shared_ptr<Reference> refencePar = ReferenceFactory::newReference("standardRef");

  // Test default attributes
  ASSERT_EQ(refencePar->getType(), "");
  ASSERT_EQ(refencePar->getName(), "standardRef");
  ASSERT_EQ(refencePar->getOrigName(), "");
  ASSERT_EQ(refencePar->getComponentId(), "");

  // Test set methods
  refencePar->setType("DOUBLE");
  ASSERT_NO_THROW(refencePar->setOrigData("IIDM"));
  ASSERT_THROW_DYNAWO(refencePar->setOrigData("MyData"), DYN::Error::API, DYN::KeyError_t::ReferenceUnknownOriginData);
  refencePar->setOrigName("RefOrigin");
  refencePar->setComponentId("CompId");

  // Test get methods
  ASSERT_EQ(refencePar->getType(), "DOUBLE");
  ASSERT_EQ(refencePar->getName(), "standardRef");
  ASSERT_EQ(refencePar->getOrigData(), Reference::IIDM);
  ASSERT_EQ(refencePar->getOrigDataStr(), "IIDM");
  ASSERT_EQ(refencePar->getOrigName(), "RefOrigin");
  ASSERT_EQ(refencePar->getComponentId(), "CompId");
}

}  // namespace parameters
