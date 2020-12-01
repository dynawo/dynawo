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

class SubModelMock : public SubModel {
 public:
  SubModelMock(unsigned nbY, unsigned nbZ) : SubModel() {
    sizeZ_ = nbZ;
    sizeY_ = nbY;
  }

  virtual ~SubModelMock() {}

  void init(const double& t0) {
    // Dummy class used for testing
  }

  std::string modelType() const {
    // Dummy class used for testing
    return "";
  }

  void dumpParameters(std::map<std::string, std::string>& mapParameters) {
    // Dummy class used for testing
  }

  void getSubModelParameterValue(const std::string& nameParameter, double& value, bool& found) {
    // Dummy class used for testing
  }

  void dumpVariables(std::map<std::string, std::string>& mapVariables) {
    // Dummy class used for testing
  }

  void loadParameters(const std::string& parameters) {
    // Dummy class used for testing
  }

  void loadVariables(const std::string& variables) {
    // Dummy class used for testing
  }

  void evalF(double t, propertyF_t type) {
    // Dummy class used for testing
  }

  void evalG(const double& t) {
    // Dummy class used for testing
  }

  void evalZ(const double& t) {
    // Dummy class used for testing
  }

  void evalCalculatedVars() {
    // Dummy class used for testing
  }

  void evalJt(const double& t, const double& cj, SparseMatrix& Jt, const int& rowOffset) {
    // Dummy class used for testing
  }

  void evalJtPrim(const double& t, const double& cj, SparseMatrix& Jt, const int& rowOffset) {
    // Dummy class used for testing
  }

  void checkDataCoherence(const double& t) {
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

  void evalYType() {
    // Dummy class used for testing
  }

  void evalFType() {
    // Dummy class used for testing
  }

  void collectSilentZ(bool* silentZTable) {
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

  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
    // Dummy class used for testing
  }

  void initializeStaticData() {
    // Dummy class used for testing
  }

  void initializeFromData(const boost::shared_ptr<DataInterface>& data) {
    // Dummy class used for testing
  }

  void printInitValues(const std::string& directory) {
    // Dummy class used for testing
  }

  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) {
    // Dummy class used for testing
  }

  void defineParameters(std::vector<ParameterModeler>& parameters) {
    // Dummy class used for testing
  }

  void defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables) {
    // Dummy class used for testing
  }

  void defineParametersInit(std::vector<ParameterModeler>& parameters) {
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

  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const {
    // Dummy class used for testing
  }

  void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const {
    // Dummy class used for testing
  }

  double evalCalculatedVarI(unsigned iCalculatedVar) const {
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

  modeChangeType_t evalMode(const double& t) {
    // Dummy class used for testing
    return NO_MODE;
  }
};

class SubModelMock1 : public SubModelMock {
 public:
  SubModelMock1(unsigned nbY, unsigned nbZ) : SubModelMock(nbY, nbZ) {
    sizeF_ = 2;
  }

  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) {
    variables.push_back(VariableNativeFactory::create("VarC", CONTINUOUS, true));
    variables.push_back(VariableNativeFactory::create("VarD", DISCRETE, true));
    variables.push_back(VariableNativeFactory::create("VarF", FLOW, true));
  }

  void setFequations() {
    fEquationIndex_[0] = "Eq1";
    fEquationIndex_[1] = "Eq2";
  }
};

class SubModelMock2 : public SubModelMock {
 public:
  SubModelMock2(unsigned nbY, unsigned nbZ) : SubModelMock(nbY, nbZ) {
    sizeF_ = 1;
  }

  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) {
    variables.push_back(VariableNativeFactory::create("VarF2", FLOW, true));
  }

  void setFequations() {
    fEquationIndex_[0] = "Eq2_1";
  }
};

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
