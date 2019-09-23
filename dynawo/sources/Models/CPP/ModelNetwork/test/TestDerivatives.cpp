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
#include "gtest_dynawo.h"
#include "DYNDerivative.h"

namespace DYN {

TEST(ModelsModelNetwork, ModelNetworkDerivative) {
  Derivatives derivatives;
  ASSERT_EQ(derivatives.getValues().size(), 0);
  ASSERT_EQ(derivatives.empty(), true);

  derivatives.addValue(42, 5.);
  ASSERT_EQ(derivatives.getValues().size(), 1);
  ASSERT_EQ((*derivatives.getValues().find(42)).second, 5.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.addValue(8, 42.);
  ASSERT_EQ(derivatives.getValues().size(), 2);
  ASSERT_EQ((*derivatives.getValues().find(42)).second, 5.);
  ASSERT_EQ((*derivatives.getValues().find(8)).second, 42.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.addValue(42, 8.);
  ASSERT_EQ(derivatives.getValues().size(), 2);
  ASSERT_EQ((*derivatives.getValues().find(42)).second, 13.);
  ASSERT_EQ((*derivatives.getValues().find(8)).second, 42.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.reset();
  ASSERT_EQ(derivatives.getValues().size(), 0);
  ASSERT_EQ(derivatives.empty(), true);
}

TEST(ModelsModelNetwork, ModelNetworkBusDerivative) {
  BusDerivatives derivatives;
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 0);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 0);
  ASSERT_EQ(derivatives.empty(), true);

  derivatives.addDerivative(IR_DERIVATIVE, 42, 5.);
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 1);
  ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(42)).second, 5.);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 0);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.addDerivative(II_DERIVATIVE, 4, 16.);
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 1);
  ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(42)).second, 5.);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 1);
  ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(4)).second, 16.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.addDerivative(IR_DERIVATIVE, 8, 42.);
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 2);
  ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(42)).second, 5.);
  ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 1);
  ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(4)).second, 16.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.addDerivative(II_DERIVATIVE, 8, 42.);
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 2);
  ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(42)).second, 5.);
  ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 2);
  ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(4)).second, 16.);
  ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.addDerivative(IR_DERIVATIVE, 42, 8.);
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 2);
  ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(42)).second, 13.);
  ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 2);
  ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(4)).second, 16.);
  ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.addDerivative(II_DERIVATIVE, 4, 8.);
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 2);
  ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(42)).second, 13.);
  ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 2);
  ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(4)).second, 24.);
  ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.reset();
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 0);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 0);
  ASSERT_EQ(derivatives.empty(), true);


  ASSERT_THROW_DYNAWO(derivatives.addDerivative((typeDerivative_t)42, 4, 8.), Error::MODELER, KeyError_t::InvalidDerivativeType);
  ASSERT_THROW_DYNAWO(derivatives.getValues((typeDerivative_t)42), Error::MODELER, KeyError_t::InvalidDerivativeType);
}
}  // namespace DYN
