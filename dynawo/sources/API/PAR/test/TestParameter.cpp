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
 * @file API/PAR/test/TestParameter.cpp
 * @brief Unit tests for API_PAR
 */

#include <boost/shared_ptr.hpp>

#include "gtest_dynawo.h"

#include "PARParameter.h"
#include "PARParameterFactory.h"

using boost::shared_ptr;
using std::string;

namespace parameters {

//-----------------------------------------------------
// TEST check parameter factory + set and get functions
//-----------------------------------------------------

TEST(APIPARTest, Parameter) {
  shared_ptr<Parameter> paramBool = ParameterFactory::newParameter("paramBool", true);
  shared_ptr<Parameter> paramInt = ParameterFactory::newParameter("paramInt", 1);
  shared_ptr<Parameter> paramDouble = ParameterFactory::newParameter("paramDouble", 1.5);
  shared_ptr<Parameter> paramString = ParameterFactory::newParameter("paramString", string("description"));

  // Test types
  ASSERT_EQ(paramBool->getType(), Parameter::BOOL);
  ASSERT_EQ(paramInt->getType(), Parameter::INT);
  ASSERT_EQ(paramDouble->getType(), Parameter::DOUBLE);
  ASSERT_EQ(paramString->getType(), Parameter::STRING);

  // Test names
  ASSERT_EQ(paramBool->getName(), "paramBool");
  ASSERT_EQ(paramInt->getName(), "paramInt");
  ASSERT_EQ(paramDouble->getName(), "paramDouble");
  ASSERT_EQ(paramString->getName(), "paramString");

  // Test used attribute
  ASSERT_EQ(paramBool->getUsed(), false);
  ASSERT_EQ(paramInt->getUsed(), false);
  ASSERT_EQ(paramDouble->getUsed(), false);
  ASSERT_EQ(paramString->getUsed(), false);

  // Test values
  ASSERT_EQ(paramBool->getBool(), true);
  ASSERT_EQ(paramInt->getInt(), 1);
  ASSERT_EQ(paramDouble->getDouble(), 1.5);
  ASSERT_EQ(paramString->getString(), "description");

  // Test wrong method call (wrong type): it should raise an error
  ASSERT_THROW_DYNAWO(paramBool->getInt(), DYN::Error::API, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(paramInt->getDouble(), DYN::Error::API, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(paramDouble->getString(), DYN::Error::API, DYN::KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(paramString->getBool(), DYN::Error::API, DYN::KeyError_t::ParameterInvalidTypeRequested);

  // Change used attribute
  paramBool->setUsed(true);
  ASSERT_EQ(paramBool->getUsed(), true);
}

}  // namespace parameters
