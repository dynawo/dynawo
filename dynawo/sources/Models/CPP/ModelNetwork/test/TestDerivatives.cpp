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
  auto& values = derivatives.getValues();
  auto& indices = derivatives.getIndices();
  auto it = std::find(indices.begin(), indices.end(), 42);
  unsigned int index = it - indices.begin();
  ASSERT_EQ(values[index], 5.);
  // ASSERT_EQ((*derivatives.getValues().find(42)).second, 5.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.addValue(8, 42.);
  ASSERT_EQ(derivatives.getValues().size(), 2);
  it = std::find(indices.begin(), indices.end(), 42);
  index = it - indices.begin();
  ASSERT_EQ(values[index], 5.);
  it = std::find(indices.begin(), indices.end(), 8);
  index = it - indices.begin();
  ASSERT_EQ(values[index], 42.);
  // ASSERT_EQ((*derivatives.getValues().find(42)).second, 5.);
  // ASSERT_EQ((*derivatives.getValues().find(8)).second, 42.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.addValue(42, 8.);
  ASSERT_EQ(derivatives.getValues().size(), 2);
  it = std::find(indices.begin(), indices.end(), 42);
  index = it - indices.begin();
  ASSERT_EQ(values[index], 13);
  // ASSERT_EQ((*derivatives.getValues().find(42)).second, 13.);
  it = std::find(indices.begin(), indices.end(), 8);
  index = it - indices.begin();
  ASSERT_EQ(values[index], 42.);
  // ASSERT_EQ((*derivatives.getValues().find(8)).second, 42.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.reset();
  ASSERT_EQ(derivatives.getValues().size(), 2);
  ASSERT_EQ(derivatives.empty(), false);
}

TEST(ModelsModelNetwork, ModelNetworkBusDerivative) {
  BusDerivatives derivatives;
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 0);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 0);
  ASSERT_EQ(derivatives.empty(), true);

  derivatives.addDerivative(IR_DERIVATIVE, 42, 5.);
  auto& irValues = derivatives.getValues(IR_DERIVATIVE);
  auto& irIndices = derivatives.getIndices(IR_DERIVATIVE);
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 1);
  auto itiR = std::find(irIndices.begin(), irIndices.end(), 42);
  unsigned int index = itiR - irIndices.begin();
  ASSERT_EQ(irValues[index], 5.);
  // ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(42)).second, 5.);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 0);
  ASSERT_EQ(derivatives.empty(), false);

  auto& iiValues = derivatives.getValues(II_DERIVATIVE);
  auto& iiIndices = derivatives.getIndices(II_DERIVATIVE);
  derivatives.addDerivative(II_DERIVATIVE, 4, 16.);
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 1);
  itiR = std::find(irIndices.begin(), irIndices.end(), 42);
  index = itiR - irIndices.begin();
  ASSERT_EQ(irValues[index], 5.);
  // ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(42)).second, 5.);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 1);
  auto itii = std::find(iiIndices.begin(), iiIndices.end(), 4);
  index = itii - iiIndices.begin();
  ASSERT_EQ(iiValues[index], 16.);
  // ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(4)).second, 16.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.addDerivative(IR_DERIVATIVE, 8, 42.);
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 2);
  itiR = std::find(irIndices.begin(), irIndices.end(), 42);
  index = itiR - irIndices.begin();
  ASSERT_EQ(irValues[index], 5.);
  // ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(42)).second, 5.);
  itiR = std::find(irIndices.begin(), irIndices.end(), 8);
  index = itiR - irIndices.begin();
  ASSERT_EQ(irValues[index], 42.);
  // ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 1);
  itii = std::find(iiIndices.begin(), iiIndices.end(), 4);
  index = itii - iiIndices.begin();
  ASSERT_EQ(iiValues[index], 16.);
  // ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(4)).second, 16.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.addDerivative(II_DERIVATIVE, 8, 42.);
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 2);
  itiR = std::find(irIndices.begin(), irIndices.end(), 42);
  index = itiR - irIndices.begin();
  ASSERT_EQ(irValues[index], 5.);
  // ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(42)).second, 5.);
  itiR = std::find(irIndices.begin(), irIndices.end(), 8);
  index = itiR - irIndices.begin();
  ASSERT_EQ(irValues[index], 42.);
 //  ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 2);
  itii = std::find(iiIndices.begin(), iiIndices.end(), 4);
  index = itii - iiIndices.begin();
  ASSERT_EQ(iiValues[index], 16.);
  // ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(4)).second, 16.);
  itii = std::find(iiIndices.begin(), iiIndices.end(), 8);
  index = itii - iiIndices.begin();
  ASSERT_EQ(iiValues[index], 42.);
  // ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.addDerivative(IR_DERIVATIVE, 42, 8.);
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 2);
  itiR = std::find(irIndices.begin(), irIndices.end(), 42);
  index = itiR - irIndices.begin();
  ASSERT_EQ(irValues[index], 13.);
  // ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(42)).second, 13.);
  itiR = std::find(irIndices.begin(), irIndices.end(), 8);
  index = itiR - irIndices.begin();
  ASSERT_EQ(irValues[index], 42.);
  // ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 2);
  itii = std::find(iiIndices.begin(), iiIndices.end(), 4);
  index = itii - iiIndices.begin();
  ASSERT_EQ(iiValues[index], 16.);
  // ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(4)).second, 16.);
  itii = std::find(iiIndices.begin(), iiIndices.end(), 8);
  index = itii - iiIndices.begin();
  ASSERT_EQ(iiValues[index], 42.);
  // ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.addDerivative(II_DERIVATIVE, 4, 8.);
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 2);
  itiR = std::find(irIndices.begin(), irIndices.end(), 42);
  index = itiR - irIndices.begin();
  ASSERT_EQ(irValues[index], 13.);
  // ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(42)).second, 13.);
  itiR = std::find(irIndices.begin(), irIndices.end(), 8);
  index = itiR - irIndices.begin();
  ASSERT_EQ(irValues[index], 42.);
  // ASSERT_EQ((*derivatives.getValues(IR_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 2);
  itii = std::find(iiIndices.begin(), iiIndices.end(), 4);
  index = itii - iiIndices.begin();
  ASSERT_EQ(iiValues[index], 24.);
  // ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(4)).second, 24.);
  itii = std::find(iiIndices.begin(), iiIndices.end(), 8);
  index = itii - iiIndices.begin();
  ASSERT_EQ(iiValues[index], 42.);
  // ASSERT_EQ((*derivatives.getValues(II_DERIVATIVE).find(8)).second, 42.);
  ASSERT_EQ(derivatives.empty(), false);

  derivatives.reset();
  ASSERT_EQ(derivatives.getValues(IR_DERIVATIVE).size(), 2);
  ASSERT_EQ(derivatives.getValues(II_DERIVATIVE).size(), 2);
  ASSERT_EQ(derivatives.empty(), false);


  ASSERT_THROW_DYNAWO(derivatives.addDerivative(static_cast<typeDerivative_t>(42), 4, 8.), Error::MODELER, KeyError_t::InvalidDerivativeType);
  ASSERT_THROW_DYNAWO(derivatives.getValues(static_cast<typeDerivative_t>(42)), Error::MODELER, KeyError_t::InvalidDerivativeType);
}
}  // namespace DYN
