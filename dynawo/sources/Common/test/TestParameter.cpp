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
 * @file Common/Test.cpp
 * @brief Unit tests for Common lib
 *
 */

#include "gtest_dynawo.h"
#include "DYNParameter.h"

namespace DYN {

class ParameterCommonMock : public ParameterCommon {
 public:
  ParameterCommonMock(const std::string& name, const typeVarC_t& valueType, bool mandatory);

  virtual ~ParameterCommonMock();

  boost::any getAnyValue() const {
    // unused
    return boost::any();
  }

  bool hasValue() const {
    // unused
    return false;
  }

  Error::TypeError_t getTypeError() const {
    // unused
    return Error::UNDEFINED;
  }
};

ParameterCommonMock::ParameterCommonMock(const std::string& name, const typeVarC_t& valueType, bool mandatory) : ParameterCommon(name, valueType, mandatory) {
}

ParameterCommonMock::~ParameterCommonMock() {}

TEST(CommonTest, testClassParameter) {
  ParameterCommonMock parameter("Parameter1", VAR_TYPE_DOUBLE, true);
  ASSERT_EQ(parameter.getName(), "Parameter1");
  ASSERT_EQ(parameter.getValueType(), VAR_TYPE_DOUBLE);
  ASSERT_EQ(parameter.indexSet(), false);
  ASSERT_TRUE(parameter.isMandatory());
  parameter.setIndex(1);
  ASSERT_EQ(parameter.getIndex(), 1);
  ASSERT_EQ(parameter.indexSet(), true);
  ParameterCommonMock parameter2("Parameter1", VAR_TYPE_DOUBLE, false);
  ASSERT_FALSE(parameter2.isMandatory());
}
}  // namespace DYN
