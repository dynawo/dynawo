//
// Copyright (c) 2020, RTE (http://www.rte-france.com)
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
 * @file TestGetNames.cpp
 * @brief Unit tests for Common lib
 *
 */

#include "DYNModelMulti.h"
#include "DYNSubModel.h"
#include "DYNVariableNative.h"
#include "DYNVariableNativeFactory.h"
#include "gtest_dynawo.h"

#include <boost/make_shared.hpp>
#include <vector>

namespace DYN {

class SubModelMock0 : public SubModel {
 public:
  SubModelMock0(unsigned nbY, unsigned nbZ) : SubModel() {
    sizeZ_ = nbZ;
    sizeY_ = nbY;
  }

  void init(const double) {
    // Dummy class used for testing
  }

  const std::string& modelType() const {
    // Dummy class used for testing
    static std::string type = "";
    return type;
  }

  void dumpParameters(std::map<std::string, std::string>&) {
    // Dummy class used for testing
  }

  void getSubModelParameterValue(const std::string&, std::string&, bool&) {
    // Dummy class used for testing
  }

  void dumpVariables(std::map<std::string, std::string>&) {
    // Dummy class used for testing
  }

  void loadParameters(const std::string&) {
    // Dummy class used for testing
  }

  void loadVariables(const std::string&) {
    // Dummy class used for testing
  }

  void evalF(double, propertyF_t) {
    // Dummy class used for testing
  }

  void evalG(const double) {
    // Dummy class used for testing
  }

  void evalZ(const double) {
    // Dummy class used for testing
  }

  void evalCalculatedVars() {
    // Dummy class used for testing
  }

  void evalJt(const double, const double, const int, SparseMatrix&) {
    // Dummy class used for testing
  }

  void evalJtPrim(const double, const double, const int, SparseMatrix&) {
    // Dummy class used for testing
  }

  void checkDataCoherence(const double) {
    // Dummy class used for testing
  }

  void checkParametersCoherence() const {
    // Dummy class used for testing
  }

  void setFequations() {
    // Dummy class used for testing
  }

  void setGequations() {
    // Dummy class used for testing
  }

  void setFequationsInit() {
    // Dummy class used for testing
  }

  void setGequationsInit() {
    // Dummy class used for testing
  }

  void getY0() {
    // Dummy class used for testing
  }

  void initSubBuffers() {
    // Dummy class used for testing
  }

  void evalStaticYType() {
    // Dummy class used for testing
  }

  void evalDynamicYType() {
    // Dummy class used for testing
  }

  void evalStaticFType() {
    // Dummy class used for testing
  }

  void evalDynamicFType() {
    // Dummy class used for testing
  }

  void collectSilentZ(BitMask*) {
    // Dummy class used for testing
  }

  void updateYType() {
    // Dummy class used for testing
  }

  void updateFType() {
    // Dummy class used for testing
  }

  void getSize() {
    // Dummy class used for testing
  }

  void defineElements(std::vector<Element>&, std::map<std::string, int>&) {
    // Dummy class used for testing
  }

  void initializeStaticData() {
    // Dummy class used for testing
  }

  void initializeFromData(const boost::shared_ptr<DataInterface>&) {
    // Dummy class used for testing
  }

  void defineVariables(std::vector<boost::shared_ptr<Variable> >&);

  void defineParameters(std::vector<ParameterModeler>&) {
    // Dummy class used for testing
  }

  void defineVariablesInit(std::vector<boost::shared_ptr<Variable> >&) {
    // Dummy class used for testing
  }

  void defineParametersInit(std::vector<ParameterModeler>&) {
    // Dummy class used for testing
  }

  void setSharedParametersDefaultValues() {
    // Dummy class used for testing
  }

  void setSharedParametersDefaultValuesInit() {
    // Dummy class used for testing
  }

  void rotateBuffers() {
    // Dummy class used for testing
  }

  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned, std::vector<int>&) const {
    // Dummy class used for testing
  }

  void evalJCalculatedVarI(unsigned, std::vector<double>&) const {
    // Dummy class used for testing
  }

  double evalCalculatedVarI(unsigned) const {
    // Dummy class used for testing
    return 0.;
  }

  void setSubModelParameters() {
    // Dummy class used for testing
  }

  void initParams() {
    // Dummy class used for testing
  }

  void notifyTimeStep() {
    // Dummy class used for testing
  }

  modeChangeType_t evalMode(const double) {
    // Dummy class used for testing
    return NO_MODE;
  }
};

void SubModelMock0::defineVariables(std::vector<boost::shared_ptr<Variable> >&) {
  // Dummy class used for testing
}

class SubModelMock1 : public SubModelMock0 {
 public:
  SubModelMock1(unsigned nbY, unsigned nbZ) : SubModelMock0(nbY, nbZ) {
    sizeF_ = 2;
  }

  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  void setFequations() {
    fEquationIndex_[0] = "Eq1";
    fEquationIndex_[1] = "Eq2";
  }
};

void SubModelMock1::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::create("VarC", CONTINUOUS, true));
  variables.push_back(VariableNativeFactory::create("VarD", DISCRETE, true));
  variables.push_back(VariableNativeFactory::create("VarF", FLOW, true));
}

class SubModelMock2 : public SubModelMock0 {
 public:
  SubModelMock2(unsigned nbY, unsigned nbZ) : SubModelMock0(nbY, nbZ) {
    sizeF_ = 1;
  }

  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  void setFequations() {
    fEquationIndex_[0] = "Eq2_1";
  }
};

void SubModelMock2::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::create("VarF2", FLOW, true));
}

TEST(TestGetName, getVariableName) {
  ModelMulti model;
  boost::shared_ptr<DYN::SubModel> sub = boost::make_shared<DYN::SubModelMock1>(2, 1);
  model.addSubModel(sub, "");

  sub = boost::make_shared<DYN::SubModelMock2>(1, 0);
  model.addSubModel(sub, "");

  model.initBuffers();

  ASSERT_EQ("_VarC", model.getVariableName(0));
  ASSERT_EQ("_VarF", model.getVariableName(1));
  ASSERT_EQ("_VarF2", model.getVariableName(2));
}

TEST(TestGetName, getFInfos) {
  ModelMulti model;
  boost::shared_ptr<DYN::SubModel> sub = boost::make_shared<DYN::SubModelMock1>(2, 1);
  sub->name("MOCK1");
  model.addSubModel(sub, "");

  sub = boost::make_shared<DYN::SubModelMock2>(1, 0);
  sub->name("MOCK2");
  model.addSubModel(sub, "");

  model.initBuffers();
  model.setFequationsModel();

  std::string name;
  int index;
  std::string eq;
  model.getFInfos(0, name, index, eq);
  ASSERT_EQ("MOCK1", name);
  ASSERT_EQ(0, index);
  ASSERT_EQ("Eq1", eq);

  model.getFInfos(1, name, index, eq);
  ASSERT_EQ("MOCK1", name);
  ASSERT_EQ(1, index);
  ASSERT_EQ("Eq2", eq);

  model.getFInfos(2, name, index, eq);
  ASSERT_EQ("MOCK2", name);
  ASSERT_EQ(0, index);
  ASSERT_EQ("Eq2_1", eq);
}

}  // namespace DYN
