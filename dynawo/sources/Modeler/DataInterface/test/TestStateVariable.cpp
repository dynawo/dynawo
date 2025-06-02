//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file Modeler/DataInterface/test/TestStateVariable.cpp
 * @brief Unit tests for DataInterface/StateVariable class
 *
 */

#include "gtest_dynawo.h"
#include "DYNStateVariable.h"
#include "DYNVariableNative.h"

using boost::shared_ptr;

namespace DYN {

TEST(DataInterfaceTest, testStateVariable) {
  StateVariable stateVariable;
  // check default attributes
  ASSERT_EQ(stateVariable.getType(), StateVariable::DOUBLE);
  ASSERT_EQ(stateVariable.getName(), "");
  ASSERT_EQ(stateVariable.valueAffected(), false);
  ASSERT_EQ(stateVariable.getModelId(), "");
  ASSERT_EQ(stateVariable.getVariableId(), "");
  ASSERT_EQ(stateVariable.getVariable(), boost::shared_ptr<Variable>());

  // check for int type
  StateVariable intVariable("intVariable", StateVariable::INT);
  ASSERT_EQ(intVariable.getType(), StateVariable::INT);
  ASSERT_EQ(intVariable.getName(), "intVariable");
  ASSERT_EQ(intVariable.valueAffected(), false);

  int value = 1;
  intVariable.setValue(value);
  ASSERT_EQ(intVariable.valueAffected(), true);
  ASSERT_EQ(intVariable.getValue<int>(), value);
  ASSERT_THROW_DYNAWO(intVariable.getValue<double>(), Error::MODELER, KeyError_t::StateVariableBadCast);
  ASSERT_THROW_DYNAWO(intVariable.getValue<bool>(), Error::MODELER, KeyError_t::StateVariableBadCast);

  ASSERT_THROW_DYNAWO(intVariable.setValue(2.5), Error::MODELER, KeyError_t::StateVariableWrongType);
  ASSERT_EQ(intVariable.getValue<int>(), 1);

  intVariable.setModelId("ModelIntVariable");
  intVariable.setVariableId("variableIntVariable");
  shared_ptr<Variable> variableForInt = shared_ptr<Variable>(new VariableNative("variableForInt", INTEGER, false, false));
  intVariable.setVariable(variableForInt);

  ASSERT_EQ(intVariable.getModelId(), "ModelIntVariable");
  ASSERT_EQ(intVariable.getVariableId(), "variableIntVariable");
  ASSERT_EQ(intVariable.getVariable(), variableForInt);

  // check for double type
  StateVariable doubleVariable("doubleVariable", StateVariable::DOUBLE);
  ASSERT_EQ(doubleVariable.getType(), StateVariable::DOUBLE);
  ASSERT_EQ(doubleVariable.getName(), "doubleVariable");
  ASSERT_EQ(doubleVariable.valueAffected(), false);

  doubleVariable.setValue(1.1);
  ASSERT_EQ(doubleVariable.valueAffected(), true);
  ASSERT_EQ(doubleVariable.getValue<double>(), 1.1);
  ASSERT_THROW_DYNAWO(doubleVariable.getValue<int>(), Error::MODELER, KeyError_t::StateVariableBadCast);
  ASSERT_THROW_DYNAWO(doubleVariable.getValue<bool>(), Error::MODELER, KeyError_t::StateVariableBadCast);

  // check for boolean type
  StateVariable boolVariable("boolVariable", StateVariable::BOOL);
  ASSERT_EQ(boolVariable.getType(), StateVariable::BOOL);
  ASSERT_EQ(boolVariable.getName(), "boolVariable");
  ASSERT_EQ(boolVariable.valueAffected(), false);

  boolVariable.setValue(true);
  ASSERT_EQ(boolVariable.valueAffected(), true);
  ASSERT_EQ(boolVariable.getValue<bool>(), true);
  ASSERT_THROW_DYNAWO(boolVariable.getValue<int>(), Error::MODELER, KeyError_t::StateVariableBadCast);
  ASSERT_THROW_DYNAWO(boolVariable.getValue<double>(), Error::MODELER, KeyError_t::StateVariableBadCast);

#ifdef _DEBUG_
  ASSERT_THROW_DYNAWO(boolVariable.setValue(2), Error::MODELER, KeyError_t::StateVariableWrongType);
  ASSERT_THROW_DYNAWO(boolVariable.setValue(-2.2), Error::MODELER, KeyError_t::StateVariableWrongType);
#endif

  boolVariable.setValue(1.);
  ASSERT_EQ(boolVariable.getValue<bool>(), true);

  boolVariable.setValue(-1.);
  ASSERT_EQ(boolVariable.getValue<bool>(), false);

  boolVariable.setModelId("ModelBoolVariable");
  boolVariable.setVariableId("variableBoolVariable");
  shared_ptr<Variable> variableForBool = shared_ptr<Variable>(new VariableNative("variableForBool", BOOLEAN, false, false));
  boolVariable.setVariable(variableForBool);

  ASSERT_EQ(boolVariable.getModelId(), "ModelBoolVariable");
  ASSERT_EQ(boolVariable.getVariableId(), "variableBoolVariable");
  ASSERT_EQ(boolVariable.getVariable(), variableForBool);


  // check copy constructor
  StateVariable var2 = boolVariable;
  ASSERT_EQ(var2.getType(), StateVariable::BOOL);
  ASSERT_EQ(var2.getName(), "boolVariable");
  ASSERT_EQ(var2.valueAffected(), true);
  ASSERT_EQ(var2.getValue<bool>(), false);
  ASSERT_EQ(var2.getModelId(), "ModelBoolVariable");
  ASSERT_EQ(var2.getVariableId(), "variableBoolVariable");
  ASSERT_EQ(var2.getVariable(), variableForBool);

  // check assignment operator
  StateVariable var3;
  var3 = intVariable;
  ASSERT_EQ(var3.getType(), StateVariable::INT);
  ASSERT_EQ(var3.getName(), "intVariable");
  ASSERT_EQ(var3.valueAffected(), true);
  ASSERT_EQ(var3.getValue<int>(), 1);
  ASSERT_EQ(var3.getModelId(), "ModelIntVariable");
  ASSERT_EQ(var3.getVariableId(), "variableIntVariable");
  ASSERT_EQ(var3.getVariable(), variableForInt);
}

}  // namespace DYN
