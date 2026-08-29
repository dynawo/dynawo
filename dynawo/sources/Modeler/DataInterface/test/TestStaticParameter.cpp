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
 * @file Modeler/DataInterface/test/TestStaticParameter.cpp
 * @brief Unit tests for DataInterface/StaticParameter class
 *
 */

#include "gtest_dynawo.h"
#include "DYNStaticParameter.h"

namespace DYN {

TEST(DataInterfaceTest, testStaticParameter) {
  StaticParameter staticParameter;
  // check default attributes
  ASSERT_EQ(staticParameter.getType(), StaticParameter::DOUBLE);
  ASSERT_EQ(staticParameter.getName(), "");
  ASSERT_EQ(staticParameter.valueAffected(), false);

  // check for int type
  StaticParameter intParameter("intParameter", StaticParameter::INT);
  ASSERT_EQ(intParameter.getType(), StaticParameter::INT);
  ASSERT_EQ(intParameter.getName(), "intParameter");
  ASSERT_EQ(intParameter.valueAffected(), false);

  int value = 1;
  intParameter.setValue(value);
  ASSERT_EQ(intParameter.valueAffected(), true);
  ASSERT_EQ(intParameter.getValue<int>(), value);
  ASSERT_THROW_DYNAWO(intParameter.getValue<double>(), Error::MODELER, KeyError_t::StaticParameterBadCast);
  ASSERT_THROW_DYNAWO(intParameter.getValue<bool>(), Error::MODELER, KeyError_t::StaticParameterBadCast);

  ASSERT_THROW_DYNAWO(intParameter.setValue(false), Error::MODELER, KeyError_t::StaticParameterWrongType);
  ASSERT_THROW_DYNAWO(intParameter.setValue(1.1), Error::MODELER, KeyError_t::StaticParameterWrongType);


  // check for double type
  StaticParameter doubleParameter("doubleParameter", StaticParameter::DOUBLE);
  ASSERT_EQ(doubleParameter.getType(), StaticParameter::DOUBLE);
  ASSERT_EQ(doubleParameter.getName(), "doubleParameter");
  ASSERT_EQ(doubleParameter.valueAffected(), false);

  doubleParameter.setValue(1.1);
  ASSERT_EQ(doubleParameter.valueAffected(), true);
  ASSERT_EQ(doubleParameter.getValue<double>(), 1.1);
  ASSERT_THROW_DYNAWO(doubleParameter.getValue<int>(), Error::MODELER, KeyError_t::StaticParameterBadCast);
  ASSERT_THROW_DYNAWO(doubleParameter.getValue<bool>(), Error::MODELER, KeyError_t::StaticParameterBadCast);

  ASSERT_THROW_DYNAWO(doubleParameter.setValue(false), Error::MODELER, KeyError_t::StaticParameterWrongType);
  ASSERT_THROW_DYNAWO(doubleParameter.setValue(static_cast<int>(1)), Error::MODELER, KeyError_t::StaticParameterWrongType);


  // check for boolean type
  StaticParameter boolParameter("boolParameter", StaticParameter::BOOL);
  ASSERT_EQ(boolParameter.getType(), StaticParameter::BOOL);
  ASSERT_EQ(boolParameter.getName(), "boolParameter");
  ASSERT_EQ(boolParameter.valueAffected(), false);

  boolParameter.setValue(true);
  ASSERT_EQ(boolParameter.valueAffected(), true);
  ASSERT_EQ(boolParameter.getValue<bool>(), true);
  ASSERT_THROW_DYNAWO(boolParameter.getValue<int>(), Error::MODELER, KeyError_t::StaticParameterBadCast);
  ASSERT_THROW_DYNAWO(boolParameter.getValue<double>(), Error::MODELER, KeyError_t::StaticParameterBadCast);

  ASSERT_THROW_DYNAWO(boolParameter.setValue(static_cast<int>(1)), Error::MODELER, KeyError_t::StaticParameterWrongType);

  boolParameter.setValue(1.);
  ASSERT_EQ(boolParameter.getValue<bool>(), true);

  boolParameter.setValue(-1.);
  ASSERT_EQ(boolParameter.getValue<bool>(), false);

  // check copy constructor
  StaticParameter par2 = boolParameter;
  ASSERT_EQ(par2.getType(), StaticParameter::BOOL);
  ASSERT_EQ(par2.getName(), "boolParameter");
  ASSERT_EQ(par2.valueAffected(), true);
  ASSERT_EQ(par2.getValue<bool>(), false);

  // check assignement operator
  StaticParameter par3;
  par3 = intParameter;
  ASSERT_EQ(par3.getType(), StaticParameter::INT);
  ASSERT_EQ(par3.getName(), "intParameter");
  ASSERT_EQ(par3.valueAffected(), true);
  ASSERT_EQ(par3.getValue<int>(), 1);
}

}  // namespace DYN
