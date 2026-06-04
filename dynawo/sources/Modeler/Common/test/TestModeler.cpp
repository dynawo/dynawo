//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
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
 * @file Modeler/Common/test/TestModeler.cpp
 * @brief Unit tests for DYNModeler node-macro resolution
 */

#include <map>
#include <sstream>
#include <utility>

#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>

#include "gtest_dynawo.h"

#include "DYNModeler.h"
#include "DYNDataInterface.h"
#include "DYNSubModel.h"
#include "DYNNetworkInterface.h"
#include "DYNServiceManagerInterface.h"
#include "DYNComponentInterface.h"

#include "CRTCriteriaCollection.h"
#include "LEQLostEquipmentsCollection.h"
#include "LEQLostEquipmentsCollectionFactory.h"
#include "TLTimeline.h"

#include "DYNElement.h"
#include "DYNCommonModeler.h"

using boost::shared_ptr;
using boost::make_shared;

namespace DYN {

// ── Minimal DataInterface mock ────────────────────────────────────────────────

class DataInterfaceMock : public DataInterface {
 public:
  std::map<std::pair<std::string, std::string>, std::string> busNames;
  std::map<std::string, std::string> voltageLevelIds;
  std::map<std::pair<std::string, int>, std::string> busFromNodes;

  bool canUseVariant() const override { return false; }
  void selectVariant(const std::string&) override {}
  boost::shared_ptr<NetworkInterface> getNetwork() const override { return nullptr; }
  void hasDynamicModel(const std::string&) override {}
  void setDynamicModel(const std::string&, const boost::shared_ptr<SubModel>&) override {}
  void setModelNetwork(const boost::shared_ptr<SubModel>&) override {}
  void setReference(const std::string&, const std::string&, const std::string&, const std::string&) override {}
  void mapConnections() override {}
  void updateFromModel(bool) override {}
  void getStateVariableReference() override {}
  void exportStateVariables() override {}
  std::shared_ptr<std::vector<std::shared_ptr<ComponentInterface>>> findConnectedComponents() override { return nullptr; }
  std::unique_ptr<lostEquipments::LostEquipmentsCollection>
      findLostEquipments(const std::shared_ptr<std::vector<std::shared_ptr<ComponentInterface>>>&) override {
    return lostEquipments::LostEquipmentsCollectionFactory::newInstance();
  }
  void importStaticParameters() override {}
  void configureCriteria(const std::shared_ptr<criteria::CriteriaCollection>&) override {}
  bool checkCriteria(double, bool) override { return true; }
  void getFailingCriteria(std::vector<std::pair<double, std::string>>&) const override {}
  double getStaticParameterDoubleValue(const std::string&, const std::string&) override { return 0.; }
  int getStaticParameterIntValue(const std::string&, const std::string&) override { return 0; }
  bool getStaticParameterBoolValue(const std::string&, const std::string&) override { return false; }
  void dumpToFile(const std::string&) const override {}
  void dumpToFile(std::stringstream&) const override {}
  boost::shared_ptr<ServiceManagerInterface> getServiceManager() const override { return nullptr; }
  boost::shared_ptr<DataInterface> clone() const override { return nullptr; }
  bool instantiateNetwork() const override { return false; }
  void setTimeline(const boost::shared_ptr<timeline::Timeline>&) override {}

  std::string getBusName(const std::string& id, const std::string& label) override {
    auto it = busNames.find({id, label});
    return it != busNames.end() ? it->second : "";
  }

  std::string getVoltageLevelId(const std::string& id) override {
    auto it = voltageLevelIds.find(id);
    return it != voltageLevelIds.end() ? it->second : "";
  }

  std::string getBusNameFromNode(const std::string& vlId, int node) override {
    auto it = busFromNodes.find({vlId, node});
    return it != busFromNodes.end() ? it->second : "";
  }
};

// ── Minimal SubModel mock ─────────────────────────────────────────────────────

class SubModelMockSimple : public SubModel {
 public:
  SubModelMockSimple() { sizeY_ = 1; sizeZ_ = 1; calculatedVars_.resize(1); }

  void init(const double) override {}
  const std::string& modelType() const override { static std::string t; return t; }
  void dumpParameters(std::map<std::string, std::string>&) override {}
  void getSubModelParameterValue(const std::string&, std::string&, bool&) override {}
  void dumpVariables(std::map<std::string, std::string>&) override {}
  void loadParameters(const std::string&) override {}
  void loadVariables(const std::string&) override {}
  void evalF(double, propertyF_t) override {}
  void evalG(const double) override {}
  void evalZ(const double) override {}
  void evalCalculatedVars() override {}
  void evalJt(const double, const double, const int, SparseMatrix&) override {}
  void evalJtPrim(const double, const double, const int, SparseMatrix&) override {}
  modeChangeType_t evalMode(double) override { return NO_MODE; }
  void checkParametersCoherence() const override {}
  void setFequations() override {}
  void setGequations() override {}
  void setFequationsInit() override {}
  void setGequationsInit() override {}
  void getY0() override {}
  void initSubBuffers() override {}
  void evalStaticYType() override {}
  void evalStaticFType() override {}
  void evalDynamicYType() override {}
  void evalDynamicFType() override {}
  void collectSilentZ(BitMask*) override {}
  void getSize() override {}
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) override {
    addElement("var", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "var", Element::TERMINAL, name(), modelType(), elements, mapElement);
  }
  void initializeStaticData() override {}
  void initializeFromData(const boost::shared_ptr<DataInterface>&) override {}
  void defineVariables(std::vector<boost::shared_ptr<Variable>>&) override {}
  void defineParameters(std::vector<ParameterModeler>&) override {}
  void defineVariablesInit(std::vector<boost::shared_ptr<Variable>>&) override {}
  void defineParametersInit(std::vector<ParameterModeler>&) override {}
  void setSharedParametersDefaultValues() override {}
  void setSharedParametersDefaultValuesInit() override {}
  void rotateBuffers() override {}
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned, std::vector<int>&) const override {}
  void evalJCalculatedVarI(unsigned, std::vector<double>&) const override {}
  double evalCalculatedVarI(unsigned) const override { return 0.; }
  void setSubModelParameters() override {}
  void initParams() override {}
  void notifyTimeStep() override {}
};

// ── Test wrapper exposing protected methods ───────────────────────────────────

class ModelerTester : public Modeler {
 public:
  std::string testFindNodeConnectorName(const std::string& id, const std::string& label) {
    return findNodeConnectorName(id, label);
  }

  void testReplaceStaticAndNodeMacro(const boost::shared_ptr<SubModel>& sm1, std::string& v1,
                                     const boost::shared_ptr<SubModel>& sm2, std::string& v2) {
    replaceStaticAndNodeMacroInVariableName(sm1, v1, sm2, v2);
  }
};

static ModelerTester makeModeler(const shared_ptr<DataInterfaceMock>& data) {
  ModelerTester m;
  m.setDataInterface(data);
  return m;
}

static shared_ptr<SubModel> makeSubModel(const std::string& modelName, const std::string& staticId) {
  auto sm = make_shared<SubModelMockSimple>();
  sm->name(modelName);
  sm->staticId(staticId);
  return boost::dynamic_pointer_cast<SubModel>(sm);
}

// ── findNodeConnectorName ─────────────────────────────────────────────────────

TEST(ModelerNodeMacroTest, FindNodeConnectorName_NoPattern) {
  auto data = make_shared<DataInterfaceMock>();
  ModelerTester m = makeModeler(data);

  ASSERT_EQ(m.testFindNodeConnectorName("terminal_V", "@NODE@"), "terminal_V");
}

TEST(ModelerNodeMacroTest, FindNodeConnectorName_StaticIdPattern) {
  auto data = make_shared<DataInterfaceMock>();
  data->busNames[{"GEN1", "@NODE@"}] = "BUS1";
  ModelerTester m = makeModeler(data);

  ASSERT_EQ(m.testFindNodeConnectorName("@GEN1@@NODE@_ACPIN", "@NODE@"), "BUS1_ACPIN");
}

TEST(ModelerNodeMacroTest, FindNodeConnectorName_StaticIdPattern_BusNotFound) {
  auto data = make_shared<DataInterfaceMock>();
  ModelerTester m = makeModeler(data);

  ASSERT_THROW_DYNAWO(m.testFindNodeConnectorName("@GEN1@@NODE@_ACPIN", "@NODE@"),
                      Error::MODELER, KeyError_t::MacroNotResolved);
}

TEST(ModelerNodeMacroTest, FindNodeConnectorName_NodeBreakerPattern) {
  auto data = make_shared<DataInterfaceMock>();
  data->busFromNodes[{"VL1", 5}] = "CALC_BUS_5";
  ModelerTester m = makeModeler(data);

  ASSERT_EQ(m.testFindNodeConnectorName("@VL1@@NODE@@5@_ACPIN", "@NODE@"), "CALC_BUS_5_ACPIN");
}

TEST(ModelerNodeMacroTest, FindNodeConnectorName_NodeBreakerPattern_NodeZero) {
  auto data = make_shared<DataInterfaceMock>();
  data->busFromNodes[{"VL2", 0}] = "CALC_BUS_0";
  ModelerTester m = makeModeler(data);

  ASSERT_EQ(m.testFindNodeConnectorName("@VL2@@NODE@@0@_terminal", "@NODE@"), "CALC_BUS_0_terminal");
}

TEST(ModelerNodeMacroTest, FindNodeConnectorName_NodeBreakerPattern_BusNotFound) {
  auto data = make_shared<DataInterfaceMock>();
  ModelerTester m = makeModeler(data);

  ASSERT_THROW_DYNAWO(m.testFindNodeConnectorName("@VL1@@NODE@@5@_ACPIN", "@NODE@"),
                      Error::MODELER, KeyError_t::MacroNotResolved);
}

TEST(ModelerNodeMacroTest, FindNodeConnectorName_NodeBreakerPattern_InvalidIndex) {
  auto data = make_shared<DataInterfaceMock>();
  ModelerTester m = makeModeler(data);

  ASSERT_THROW_DYNAWO(m.testFindNodeConnectorName("@VL1@@NODE@@abc@_ACPIN", "@NODE@"),
                      Error::MODELER, KeyError_t::MacroNotResolved);
}

TEST(ModelerNodeMacroTest, FindNodeConnectorName_NodeBreakerPattern_IndexOutOfRange) {
  auto data = make_shared<DataInterfaceMock>();
  ModelerTester m = makeModeler(data);

  ASSERT_THROW_DYNAWO(m.testFindNodeConnectorName("@VL1@@NODE@@99999999999999999999@_ACPIN", "@NODE@"),
                      Error::MODELER, KeyError_t::MacroNotResolved);
}

// ── replaceStaticAndNodeMacroInVariableName ───────────────────────────────────

TEST(ModelerNodeMacroTest, ReplaceStaticAndNode_StaticIdResolution) {
  // @STATIC_ID@ in var1 is replaced with subModel2's static id, then @NODE@ resolved.
  auto data = make_shared<DataInterfaceMock>();
  data->busNames[{"GEN2", "@NODE@"}] = "BUS_GEN2";

  ModelerTester m = makeModeler(data);
  auto sm1 = makeSubModel("model1", "GEN1");
  auto sm2 = makeSubModel("model2", "GEN2");

  std::string var1 = "@STATIC_ID@@NODE@_ACPIN";
  std::string var2 = "plain_var";
  m.testReplaceStaticAndNodeMacro(sm1, var1, sm2, var2);

  ASSERT_EQ(var1, "BUS_GEN2_ACPIN");
  ASSERT_EQ(var2, "plain_var");
}

TEST(ModelerNodeMacroTest, ReplaceStaticAndNode_VoltageLevelResolution) {
  // @VOLTAGE_LEVEL@ in var1 is replaced with VL of subModel2, then @NODE@@N@ resolved.
  auto data = make_shared<DataInterfaceMock>();
  data->voltageLevelIds["LOAD1"] = "VL_A";
  data->busFromNodes[{"VL_A", 3}] = "CALC_BUS_A3";

  ModelerTester m = makeModeler(data);
  auto sm1 = makeSubModel("model1", "GEN1");
  auto sm2 = makeSubModel("model2", "LOAD1");

  std::string var1 = "@VOLTAGE_LEVEL@@NODE@@3@_terminal";
  std::string var2 = "plain_var";
  m.testReplaceStaticAndNodeMacro(sm1, var1, sm2, var2);

  ASSERT_EQ(var1, "CALC_BUS_A3_terminal");
  ASSERT_EQ(var2, "plain_var");
}

TEST(ModelerNodeMacroTest, ReplaceStaticAndNode_VoltageLevelNotFound) {
  // getVoltageLevelId returns "" → MacroNotResolved error.
  auto data = make_shared<DataInterfaceMock>();
  ModelerTester m = makeModeler(data);
  auto sm1 = makeSubModel("model1", "GEN1");
  auto sm2 = makeSubModel("model2", "UNKNOWN");

  std::string var1 = "@VOLTAGE_LEVEL@@NODE@@3@_terminal";
  std::string var2 = "plain_var";
  ASSERT_THROW_DYNAWO(m.testReplaceStaticAndNodeMacro(sm1, var1, sm2, var2),
                      Error::MODELER, KeyError_t::MacroNotResolved);
}

TEST(ModelerNodeMacroTest, ReplaceStaticAndNode_BothSidesNodeBreaker) {
  // Both var1 and var2 use @VOLTAGE_LEVEL@@NODE@@N@; both must be resolved independently.
  auto data = make_shared<DataInterfaceMock>();
  data->voltageLevelIds["LOAD1"] = "VL_A";
  data->voltageLevelIds["GEN1"] = "VL_B";
  data->busFromNodes[{"VL_A", 3}] = "BUS_A3";
  data->busFromNodes[{"VL_B", 7}] = "BUS_B7";

  ModelerTester m = makeModeler(data);
  auto sm1 = makeSubModel("model1", "GEN1");
  auto sm2 = makeSubModel("model2", "LOAD1");

  // var1 uses VL of sm2 (LOAD1 → VL_A), var2 uses VL of sm1 (GEN1 → VL_B)
  std::string var1 = "@VOLTAGE_LEVEL@@NODE@@3@_terminal";
  std::string var2 = "@VOLTAGE_LEVEL@@NODE@@7@_terminal";
  m.testReplaceStaticAndNodeMacro(sm1, var1, sm2, var2);

  ASSERT_EQ(var1, "BUS_A3_terminal");
  ASSERT_EQ(var2, "BUS_B7_terminal");
}

}  // namespace DYN
