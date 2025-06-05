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

/*
 * @file Modeler/Common/test/Test.cpp
 * @brief Unit tests for common Modeler methods
 *
 */
#include <vector>
#include <map>
#include <sstream>

#include <boost/shared_ptr.hpp>
#include <boost/pointer_cast.hpp>

#include "DYNParameterModeler.h"
#include "gtest_dynawo.h"

#include "DYNVariableNative.h"
#include "DYNVariableNativeFactory.h"
#include "DYNVariableAlias.h"
#include "DYNVariableAliasFactory.h"
#include "DYNVariableMultiple.h"
#include "DYNVariableMultipleFactory.h"

#include "DYNConnector.h"

#include "DYNElement.h"
#include "DYNCommonModeler.h"
#include "DYNModelMulti.h"
#include "DYNSubModel.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"
#include "DYNDynamicData.h"

#include "DYNError.h"
#include "DYNErrorQueue.h"
#include "DYNStaticRefInterface.h"

using boost::shared_ptr;
using boost::dynamic_pointer_cast;

using parameters::ParametersSet;
using parameters::ParametersSetFactory;

namespace DYN {

class SubModelMockBase : public SubModel {
 public:
  SubModelMockBase(unsigned nbY, unsigned nbZ) {
    sizeZ_ = nbZ;
    sizeY_ = nbY;
    calculatedVars_.resize(1);
  }

  void init(const double) override {
    // Dummy class used for testing
  }

  const std::string& modelType() const override {
    // Dummy class used for testing
    static std::string type = "";
    return type;
  }

  void dumpParameters(std::map< std::string, std::string >&) override {
    // Dummy class used for testing
  }

  void getSubModelParameterValue(const std::string&, std::string&, bool&) override {
    // Dummy class used for testing
  }

  void dumpVariables(std::map< std::string, std::string >&) override {
    // Dummy class used for testing
  }

  void loadParameters(const std::string&) override {
    // Dummy class used for testing
  }

  void loadVariables(const std::string&) override {
    // Dummy class used for testing
  }

  void evalF(double, propertyF_t) override {
    // Dummy class used for testing
  }

  void evalG(const double) override {
    // Dummy class used for testing
  }

  void evalZ(const double) override {
    // Dummy class used for testing
  }

  void evalCalculatedVars() override {
    calculatedVars_[0] = getCurrentTime();
  }

  void evalJt(const double, const double, const int, SparseMatrix&) override {
    // Dummy class used for testing
  }

  void evalJtPrim(const double, const double, const int, SparseMatrix&) override {
    // Dummy class used for testing
  }

  modeChangeType_t evalMode(double) override = 0;

  void checkParametersCoherence() const override {
    // Dummy class used for testing
  }

  void setFequations() override {
    // Dummy class used for testing
  }

  void setGequations() override {
    // Dummy class used for testing
  }

  void setFequationsInit() override {
    // Dummy class used for testing
  }

  void setGequationsInit() override {
    // Dummy class used for testing
  }

  void getY0() override {
    // Dummy class used for testing
  }

  void initSubBuffers() override {
    // Dummy class used for testing
  }

  void evalStaticYType() override {
    // Dummy class used for testing
  }

  void evalStaticFType() override {
    // Dummy class used for testing
  }

  void evalDynamicYType() override {
    // Dummy class used for testing
  }

  void evalDynamicFType() override {
    // Dummy class used for testing
  }

  void collectSilentZ(BitMask*) override {
    // Dummy class used for testing
  }

  void updateYType() {
    // Dummy class used for testing
  }

  void updateFType() {
    // Dummy class used for testing
  }

  void getSize() override {
    // Dummy class used for testing
  }

  void defineElements(std::vector<Element>& elements, std::map<std::string, int >& mapElement) override {
    addElement("MyVar", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "MyVar", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("MyAliasVar", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "MyAliasVar", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("MyDiscreteVar", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "MyDiscreteVar", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("MyDiscreteVarCalculated", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "MyDiscreteVarCalculated", Element::TERMINAL, name(), modelType(), elements, mapElement);
  }

  void initializeStaticData() override {
    // Dummy class used for testing
  }

  void initializeFromData(const boost::shared_ptr<DataInterface>&) override {
    // Dummy class used for testing
  }

  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) override;

  void defineParameters(std::vector<ParameterModeler>&) override {
    // Dummy class used for testing
  }

  void defineVariablesInit(std::vector<boost::shared_ptr<Variable> >&) override {
    // Dummy class used for testing
  }

  void defineParametersInit(std::vector<ParameterModeler>&) override {
    // Dummy class used for testing
  }

  void setSharedParametersDefaultValues() override {
    // Dummy class used for testing
  }

  void setSharedParametersDefaultValuesInit() override {
    // Dummy class used for testing
  }

  void rotateBuffers() override {
    // Dummy class used for testing
  }

  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned, std::vector<int>&) const override {
    // Dummy class used for testing
  }

  void evalJCalculatedVarI(unsigned, std::vector<double>&) const override {
    // Dummy class used for testing
  }

  double evalCalculatedVarI(unsigned) const override {
    return getCurrentTime();
  }

  void setSubModelParameters() override {
    // Dummy class used for testing
  }

  void initParams() override {
    // Dummy class used for testing
  }

  void notifyTimeStep() override {
    // Dummy class used for testing
  }
};

void SubModelMockBase::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState("MyVar_value", CONTINUOUS));
  variables.push_back(VariableAliasFactory::create("MyAliasVar_value", "MyVar_value", FLOW, false));
  variables.push_back(VariableNativeFactory::createState("MyDiscreteVar_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createCalculated("MyDiscreteVarCalculated_value", DISCRETE));
}

class SubModelMock : public SubModelMockBase {
 public:
  SubModelMock(unsigned nbY, unsigned nbZ) : SubModelMockBase(nbY, nbZ) {}

  SubModelMock() : SubModelMockBase(1, 1) {}

  modeChangeType_t evalMode(const double) override;
};

modeChangeType_t SubModelMock::evalMode(const double) {
  // Dummy class used for testing
  return NO_MODE;
}

class SubModelMode : public SubModelMockBase {
 public:
  SubModelMode(unsigned nbY, unsigned nbZ) : SubModelMockBase(nbY, nbZ) {}

  SubModelMode() : SubModelMockBase(1, 1) {}

  modeChangeType_t evalMode(const double t) override;
};

modeChangeType_t SubModelMode::evalMode(const double t) {
  if (doubleEquals(t, 1))
    return DIFFERENTIAL_MODE;
  else if (doubleEquals(t, 2))
    return ALGEBRAIC_MODE;
  else if (doubleEquals(t, 3))
    return DIFFERENTIAL_MODE;
  else if (doubleEquals(t, 4))
    return ALGEBRAIC_J_UPDATE_MODE;
  return NO_MODE;
}

//-----------------------------------------------------
// TEST DYNParameter
//-----------------------------------------------------

TEST(ModelerCommonTest, ParameterUnitary) {   // Test for unitary parameters
  // Create a vector of parameters with no values
  std::vector<ParameterModeler> parameters;
  parameters.push_back(ParameterModeler("name_bool", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("name_int", VAR_TYPE_INT, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("name_double", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("name_string", VAR_TYPE_STRING, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("test", VAR_TYPE_STRING, EXTERNAL_PARAMETER));

  // Test attributes given from contructor
  ASSERT_EQ(parameters[0].getName(), "name_bool");
  ASSERT_EQ(parameters[0].getValueType(), VAR_TYPE_BOOL);
  ASSERT_EQ(parameters[0].getScope(), EXTERNAL_PARAMETER);
  ASSERT_EQ(parameters[0].getCardinality(), "1");
  ASSERT_EQ(parameters[0].indexSet(), false);
  ASSERT_THROW_DYNAWO(parameters[0].getIndex(), Error::MODELER, KeyError_t::ParameterHasNoIndex);
  ASSERT_THROW_DYNAWO(parameters[0].getValue<bool>(), Error::MODELER, KeyError_t::ParameterHasNoValue);
  ASSERT_THROW_DYNAWO(parameters[0].getOrigin(), Error::MODELER, KeyError_t::ParameterHasNoValue);
  ASSERT_THROW_DYNAWO(parameters[0].getCardinalityInformator(), Error::MODELER, KeyError_t::ParameterUnitary);

  const int index = 15;
  parameters[0].setIndex(index);
  ASSERT_THROW_DYNAWO(parameters[0].setIndex(index), Error::MODELER, KeyError_t::ParameterIndexAlreadySet);
  ASSERT_THROW_DYNAWO(parameters[0].setIndex(17), Error::MODELER, KeyError_t::ParameterIndexAlreadySet);
  ASSERT_EQ(parameters[0].indexSet(), true);
  ASSERT_EQ(parameters[0].getIndex(), index);

  ASSERT_EQ(parameters[1].indexSet(), false);
  ASSERT_EQ(parameters[1].getValueType(), VAR_TYPE_INT);
  ASSERT_THROW_DYNAWO(parameters[1].getValue<int>(), Error::MODELER, KeyError_t::ParameterHasNoValue);

  ASSERT_EQ(parameters[2].getValueType(), VAR_TYPE_DOUBLE);
  ASSERT_THROW_DYNAWO(parameters[2].getValue<double>(), Error::MODELER, KeyError_t::ParameterHasNoValue);

  ASSERT_EQ(parameters[3].getValueType(), VAR_TYPE_STRING);
  ASSERT_THROW_DYNAWO(parameters[3].getValue<std::string>(), Error::MODELER, KeyError_t::ParameterHasNoValue);
  ASSERT_THROW_DYNAWO(parameters[3].getOrigin(), Error::MODELER, KeyError_t::ParameterHasNoValue);

  // Test methode isUnitary()
  ASSERT_EQ(parameters[0].isUnitary(), true);
  ASSERT_EQ(parameters[0].getIsNonUnitaryParameterInstance(), false);

  // Test set and get for attribute value (bool, int, double, string)
  ASSERT_NO_THROW(parameters[0].setValue(true, LOCAL_INIT));
  ASSERT_NO_THROW(parameters[1].setValue(2, PAR));
  ASSERT_NO_THROW(parameters[2].setValue(1.12, FINAL));
  ASSERT_NO_THROW(parameters[3].setValue(std::string("ok"), PAR));

  ASSERT_THROW_DYNAWO(parameters[0].setValue(1, LOCAL_INIT), Error::MODELER, KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(parameters[0].setValue(1.12, LOCAL_INIT), Error::MODELER, KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(parameters[0].setValue(std::string("ok"), LOCAL_INIT), Error::MODELER, KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(parameters[1].setValue(true, LOCAL_INIT), Error::MODELER, KeyError_t::ParameterInvalidTypeRequested);

  ASSERT_EQ(parameters[0].hasValue(), true);
  ASSERT_EQ(parameters[1].hasValue(), true);
  ASSERT_EQ(parameters[2].hasValue(), true);
  ASSERT_EQ(parameters[3].hasValue(), true);
  ASSERT_EQ(parameters[4].hasValue(), false);

  ASSERT_EQ(parameters[0].getValue<bool>(), true);
  ASSERT_EQ(parameters[0].getDoubleValue(), 1);
  ASSERT_EQ(parameters[1].getValue<int>(), 2);
  ASSERT_EQ(parameters[1].getDoubleValue(), 2);
  ASSERT_EQ(parameters[2].getValue<double>(), 1.12);
  ASSERT_EQ(parameters[2].getDoubleValue(), 1.12);
  ASSERT_EQ(parameters[3].getValue<std::string>(), "ok");
  ASSERT_THROW_DYNAWO(parameters[3].getDoubleValue(), Error::MODELER, KeyError_t::ParameterUnableToConvertToDouble);

  ASSERT_THROW_DYNAWO(parameters[1].getValue<bool>(), Error::MODELER, KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(parameters[2].getValue<int>(), Error::MODELER, KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(parameters[3].getValue<double>(), Error::MODELER, KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_THROW_DYNAWO(parameters[0].getValue<std::string>(), Error::MODELER, KeyError_t::ParameterInvalidTypeRequested);

  ASSERT_EQ(parameters[0].getOrigin(), LOCAL_INIT);
  ASSERT_EQ(parameters[3].getOrigin(), PAR);

  ASSERT_EQ(parameters[0].hasOrigin(LOCAL_INIT), true);
  ASSERT_EQ(parameters[1].hasOrigin(PAR), true);
  ASSERT_EQ(parameters[2].hasOrigin(FINAL), true);
  ASSERT_EQ(parameters[3].hasOrigin(PAR), true);
  ASSERT_EQ(parameters[0].hasOrigin(MO), false);
  ASSERT_EQ(parameters[1].hasOrigin(MO), false);
  ASSERT_EQ(parameters[2].hasOrigin(MO), false);
  ASSERT_EQ(parameters[3].hasOrigin(MO), false);

  // Test update of origin
  ASSERT_NO_THROW(parameters[0].setValue(true, PAR));
  ASSERT_EQ(parameters[0].getOrigin(), LOCAL_INIT);
  ASSERT_NO_THROW(parameters[0].setValue(true, LOCAL_INIT));
  ASSERT_EQ(parameters[0].getOrigin(), LOCAL_INIT);

  ASSERT_NO_THROW(parameters[3].setValue(std::string("mo"), LOADED_DUMP));
  ASSERT_EQ(parameters[3].getOrigin(), PAR);
  ASSERT_NO_THROW(parameters[3].setValue(std::string("init"), LOCAL_INIT));
  ASSERT_EQ(parameters[3].getOrigin(), LOCAL_INIT);
  ASSERT_EQ(parameters[3].getValue<std::string>(), "init");

  ASSERT_THROW_DYNAWO(parameters[4].setValue(true, PAR), Error::MODELER, KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_NO_THROW(parameters[4].setValue(std::string("LOADED_DUMP"), LOADED_DUMP));
  ASSERT_EQ(parameters[4].getOrigin(), LOADED_DUMP);
  ASSERT_EQ(parameters[4].getValue<std::string>(), "LOADED_DUMP");
  ASSERT_NO_THROW(parameters[4].setValue(std::string("PAR"), PAR));
  ASSERT_EQ(parameters[4].getOrigin(), PAR);
  ASSERT_EQ(parameters[4].getValue<std::string>(), "PAR");
  ASSERT_NO_THROW(parameters[4].setValue(std::string("LOADED_DUMP"), LOADED_DUMP));
  ASSERT_EQ(parameters[4].getOrigin(), PAR);
  ASSERT_EQ(parameters[4].getValue<std::string>(), "PAR");

  // Test for parameters with multiple origin
  ASSERT_NO_THROW(parameters[1].setValue(1, PAR));
  ASSERT_NO_THROW(parameters[1].setValue(3, IIDM));
  ASSERT_EQ(parameters[1].getValue<int>(), 3);

  // Test the impossibility to set a cardinality informator for an unitary parameter
  ASSERT_THROW_DYNAWO(parameters[0].setCardinalityInformator("nbGen"), Error::MODELER, KeyError_t::ParameterUnitary);
}

TEST(ModelerCommonTest, ParameterMultipleCardinality) {   // Test for parameters with multiple cardinality
  // Create parameter with multiple cardinality
  ParameterModeler paramMultiBool = ParameterModeler("name_bool", VAR_TYPE_BOOL, EXTERNAL_PARAMETER, "*");
  ParameterModeler paramMultiInt = ParameterModeler("name_int", VAR_TYPE_INT, EXTERNAL_PARAMETER, "*", "nbGen");
  ParameterModeler paramMultiDouble = ParameterModeler("name_double", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGen");
  ParameterModeler paramMultiString = ParameterModeler("name_string", VAR_TYPE_STRING, EXTERNAL_PARAMETER, "*", "nbGen");

  // Test attributes given from contructor
  ASSERT_EQ(paramMultiBool.getCardinality(), "*");
  ASSERT_THROW_DYNAWO(paramMultiBool.getCardinalityInformator(), Error::MODELER, KeyError_t::ParameterNoCardinalityInformator);
  paramMultiBool.setCardinalityInformator("nbGen");
  ASSERT_EQ(paramMultiBool.getCardinalityInformator(), "nbGen");

  // Test methode isUnitary()
  ASSERT_EQ(paramMultiBool.isUnitary(), false);

  // Test set and get for attribute cardinality_informator
  ASSERT_NO_THROW(paramMultiBool.setCardinalityInformator("nbGen2"));
  ASSERT_EQ(paramMultiBool.getCardinalityInformator(), "nbGen2");

  // Test set and get for attribute cardinality_
  ASSERT_NO_THROW(paramMultiBool.setCardinality("2"));
  ASSERT_EQ(paramMultiBool.getCardinality(), "2");

  // Test instantiate multiple parameter
  ParameterModeler paramMultiBoolInstance = ParameterModeler("name_bool_1", VAR_TYPE_BOOL, EXTERNAL_PARAMETER, "");
  paramMultiBoolInstance.setIsNonUnitaryParameterInstance(true);
  ASSERT_EQ(paramMultiBoolInstance.getIsNonUnitaryParameterInstance(), true);
  ASSERT_EQ(paramMultiBool.getIsNonUnitaryParameterInstance(), false);


  // Test impossibility to set a value for a non unitary parameter
  ASSERT_THROW_DYNAWO(paramMultiBool.setValue(true, PAR), Error::MODELER, KeyError_t::ParameterNotUnitary);
  ASSERT_THROW_DYNAWO(paramMultiInt.setValue(2, PAR), Error::MODELER, KeyError_t::ParameterNotUnitary);
  ASSERT_THROW_DYNAWO(paramMultiDouble.setValue(1.12, PAR), Error::MODELER, KeyError_t::ParameterNotUnitary);
  ASSERT_THROW_DYNAWO(paramMultiString.setValue(std::string("ok"), PAR), Error::MODELER, KeyError_t::ParameterNotUnitary);
}

//-----------------------------------------------------
// TEST DYNSubModel
//----------------------------------------------------

TEST(ModelerCommonTest, SetParameterFromPARFile) {
  const bool isInitParam = false;

  // Create a parameter set
  std::shared_ptr<parameters::ParametersSet> parametersSet = ParametersSetFactory::newParametersSet("Parameterset");
  std::string string_value = "ok";
  parametersSet->createParameter("name_bool", false)
          ->createParameter("name_int", 2)
          ->createParameter("name_double", 1.12)
          ->createParameter("name_string", string_value)
          ->createParameter("wrong_type", true);

  // Create unitary parameters
  ParameterModeler paramBool = ParameterModeler("name_bool", VAR_TYPE_BOOL, EXTERNAL_PARAMETER);
  ParameterModeler paramInt = ParameterModeler("name_int", VAR_TYPE_INT, EXTERNAL_PARAMETER);
  ParameterModeler paramDouble = ParameterModeler("name_double", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  ParameterModeler paramDoubleShared = ParameterModeler("shared_par", VAR_TYPE_DOUBLE, SHARED_PARAMETER);
  ParameterModeler paramDoubleInternal = ParameterModeler("internal_par", VAR_TYPE_DOUBLE, INTERNAL_PARAMETER);
  ParameterModeler paramString = ParameterModeler("name_string", VAR_TYPE_STRING, EXTERNAL_PARAMETER);
  ParameterModeler paramNotInSet = ParameterModeler("not_in_set", VAR_TYPE_BOOL, EXTERNAL_PARAMETER);
  ParameterModeler paramNotUnitary = ParameterModeler("not_unitary", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "name_int");

  // Create submodel
  SubModelMock submodel = SubModelMock();
  submodel.addParameter(paramBool, isInitParam);
  ASSERT_THROW_DYNAWO(submodel.addParameter(paramBool, isInitParam), Error::MODELER, KeyError_t::ParameterAlreadyExists);
  submodel.addParameter(paramInt, isInitParam);
  submodel.addParameter(paramDouble, isInitParam);
  submodel.addParameter(paramDoubleShared, isInitParam);
  submodel.addParameter(paramDoubleInternal, isInitParam);
  submodel.addParameter(paramString, isInitParam);
  submodel.addParameter(paramNotInSet, isInitParam);
  submodel.addParameter(paramNotUnitary, isInitParam);

  // Set submodel readParameters_ attribute
  ASSERT_NO_THROW(submodel.setPARParameters(parametersSet));

  // Set unitary parameters values with parameters set values
  ASSERT_NO_THROW(submodel.setParameterFromPARFile(paramBool.getName(), isInitParam));
  ASSERT_NO_THROW(submodel.setParameterFromPARFile(paramInt.getName(), isInitParam));
  ASSERT_NO_THROW(submodel.setParameterFromPARFile(paramDouble.getName(), isInitParam));
  ASSERT_NO_THROW(submodel.setParameterFromPARFile(paramString.getName(), isInitParam));

  // Check the setted values
  ASSERT_EQ(submodel.findParameterDynamic(paramBool.getName()).getValue<bool>(), false);
  ASSERT_EQ(submodel.findParameterDynamic(paramInt.getName()).getValue<int>(), 2);
  ASSERT_EQ(submodel.findParameterDynamic(paramDouble.getName()).getValue<double>(), 1.12);
  ASSERT_EQ(submodel.findParameterDynamic(paramString.getName()).getValue<std::string>(), string_value);
  ASSERT_EQ(submodel.findParameterDynamic(paramDoubleShared.getName()).originWriteAllowed(MO), true);
  ASSERT_EQ(submodel.findParameterDynamic(paramDoubleShared.getName()).originWriteAllowed(PAR), true);
  ASSERT_EQ(submodel.findParameterDynamic(paramDoubleShared.getName()).originWriteAllowed(IIDM), true);
  // ASSERT_EQ (submodel.findParameterDynamic (paramDoubleInternal.getName()).originWriteAllowed(MO), false);
  ASSERT_EQ(submodel.findParameterDynamic(paramDoubleInternal.getName()).originWriteAllowed(PAR), false);
  ASSERT_EQ(submodel.findParameterDynamic(paramDoubleInternal.getName()).originWriteAllowed(IIDM), false);

  ASSERT_THROW_DYNAWO(submodel.findParameterDynamic(paramDoubleInternal.getName()).writeChecks(IIDM), Error::MODELER, KeyError_t::ParameterNoWriteRights);
  ASSERT_NO_THROW(submodel.findParameterDynamic(paramDoubleShared.getName()).writeChecks(PAR));

  // Test fail cases
  ASSERT_THROW_DYNAWO(paramDoubleInternal.setValue(9.2, PAR), Error::MODELER, KeyError_t::ParameterNoWriteRights);
  ASSERT_THROW_DYNAWO(submodel.setParameterFromPARFile(paramNotUnitary.getName(), isInitParam), Error::MODELER, KeyError_t::ParameterNotUnitary);

  // If parameter not in set, write a log but don't throw an exception
  ASSERT_NO_THROW(submodel.setParameterFromPARFile(paramNotInSet.getName(), isInitParam));
}

TEST(ModelerCommonTest, SetParametersFromPARFile) {
  const bool isInitParam = false;

  // Create parameter set
  std::shared_ptr<parameters::ParametersSet> parametersSet = ParametersSetFactory::newParametersSet("Parameterset");
  const std::string string_value = "ok";
  parametersSet->createParameter("name_bool", false)
          ->createParameter("name_int", 2)
          ->createParameter("name_double", 1.12)
          ->createParameter("name_string", string_value)
          ->createParameter("not_unitary_int_0", 5)
          ->createParameter("not_unitary_int_1", 6)
          ->createParameter("not_unitary_double_0", 5.12)
          ->createParameter("not_unitary_double_1", 6.12);

  // Create unitary parameters
  ParameterModeler paramBool = ParameterModeler("name_bool", VAR_TYPE_BOOL, EXTERNAL_PARAMETER);
  ParameterModeler paramInt = ParameterModeler("name_int", VAR_TYPE_INT, EXTERNAL_PARAMETER);
  ParameterModeler paramDouble = ParameterModeler("name_double", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  ParameterModeler paramString = ParameterModeler("name_string", VAR_TYPE_STRING, EXTERNAL_PARAMETER);
  ParameterModeler paramNotUnitaryInt = ParameterModeler("not_unitary_int", VAR_TYPE_INT, EXTERNAL_PARAMETER, "*", "name_int");
  ParameterModeler paramNotUnitaryDouble = ParameterModeler("not_unitary_double", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "name_int");

  // Create submodel
  SubModelMock submodel = SubModelMock();

  // Set submodel readParameters_ attribute
  ASSERT_NO_THROW(submodel.setPARParameters(parametersSet));

  // Create a vector of parameters
  std::vector<ParameterModeler> parameters;
  parameters.push_back(paramBool);
  parameters.push_back(paramInt);
  parameters.push_back(paramDouble);
  parameters.push_back(paramString);
  parameters.push_back(paramNotUnitaryInt);
  parameters.push_back(paramNotUnitaryDouble);

  // Fill the submodel's attribute parameters_
  submodel.addParameters(parameters, isInitParam);
  ASSERT_EQ(submodel.getParametersDynamic().size(), 6);

  // Set parameters values with parameters set values
  ASSERT_NO_THROW(submodel.setParametersFromPARFile());

  // Check the assigned values
  ASSERT_EQ(submodel.findParameterDynamic("name_bool").getValue<bool>(), false);
  ASSERT_EQ(submodel.findParameterDynamic("name_int").getValue<int>(), 2);
  ASSERT_EQ(submodel.findParameterDynamic("name_double").getValue<double>(), 1.12);
  ASSERT_EQ(submodel.findParameterDynamic("name_string").getValue<std::string>(), "ok");
  ASSERT_EQ(submodel.findParameterDynamic("not_unitary_int_0").getValue<int>(), 5);
  ASSERT_EQ(submodel.findParameterDynamic("not_unitary_int_1").getValue<int>(), 6);
  ASSERT_EQ(submodel.findParameterDynamic("not_unitary_double_0").getValue<double>(), 5.12);
  ASSERT_EQ(submodel.findParameterDynamic("not_unitary_double_1").getValue<double>(), 6.12);
}

TEST(ModelerCommonTest, FindParameter) {
  const bool isInitParam = false;

  // Create submodel
  SubModelMock submodel = SubModelMock();

  // Create a vector of parameters
  std::vector<ParameterModeler> parameters;
  ParameterModeler paramBool = ParameterModeler("name_bool", VAR_TYPE_BOOL, EXTERNAL_PARAMETER);
  parameters.push_back(paramBool);

  // Fill the submodel's attribute parameters_
  submodel.addParameters(parameters, isInitParam);

  // Look for a desired parameter with given name in the attribute parameters_
  ASSERT_NO_THROW(submodel.findParameterDynamic("name_bool"));
  ASSERT_THROW_DYNAWO(submodel.findParameterDynamic("param_undefined"), Error::MODELER, KeyError_t::ParameterNotDefined);
}

//-----------------------------------------------------
// TEST native variables (all types and methods)
//-----------------------------------------------------

TEST(ModelerCommonTest, VariableNative) {
  const bool isAlias = false;

  const std::string varName = "testVar1";
  const bool varIsNegated = false;
  const bool isState = true;
  const bool isNotState = false;

  boost::shared_ptr<VariableNative> variableBool;
  ASSERT_NO_THROW(variableBool = VariableNativeFactory::createState(varName, BOOLEAN, varIsNegated));

  ASSERT_EQ(variableBool->isState(), isState);
  ASSERT_EQ(variableBool->getType(), BOOLEAN);
  ASSERT_EQ(variableBool->getName(), varName);
  ASSERT_EQ(variableBool->getNegated(), varIsNegated);
  ASSERT_EQ(variableBool->isAlias(), isAlias);

  const std::string varNameInt = "testVarInt";
  const bool varIntIsNegated = true;
  boost::shared_ptr<VariableNative> variableInt;
  ASSERT_NO_THROW(variableInt = VariableNativeFactory::createState(varNameInt, INTEGER, varIntIsNegated));

  ASSERT_EQ(variableInt->isState(), isState);
  ASSERT_EQ(variableInt->getType(), INTEGER);
  ASSERT_EQ(variableInt->getName(), varNameInt);
  ASSERT_EQ(variableInt->getNegated(), varIntIsNegated);
  ASSERT_EQ(variableInt->isAlias(), isAlias);

  const std::string varNameDiscrete = "testVarDiscrete";
  boost::shared_ptr<VariableNative> variableDiscrete;
  ASSERT_NO_THROW(variableDiscrete = VariableNativeFactory::createState(varNameDiscrete, DISCRETE, varIsNegated));

  ASSERT_EQ(variableDiscrete->getType(), DISCRETE);
  ASSERT_EQ(variableDiscrete->getName(), varNameDiscrete);
  ASSERT_EQ(variableDiscrete->isState(), isState);
  ASSERT_EQ(variableDiscrete->getNegated(), varIsNegated);
  ASSERT_EQ(variableDiscrete->isAlias(), isAlias);

  const std::string varNameContinuous = "testVarContinuous";
  boost::shared_ptr<VariableNative> variableContinuous;
  ASSERT_NO_THROW(variableContinuous = VariableNativeFactory::createState(varNameContinuous, CONTINUOUS, varIsNegated));

  ASSERT_EQ(variableContinuous->getType(), CONTINUOUS);
  ASSERT_EQ(variableContinuous->getName(), varNameContinuous);
  ASSERT_EQ(variableContinuous->isState(), isState);
  ASSERT_EQ(variableContinuous->getNegated(), varIsNegated);
  ASSERT_EQ(variableContinuous->isAlias(), isAlias);


  const std::string varNameFlow = "testVarFlow";
  boost::shared_ptr<VariableNative> variableFlow;
  ASSERT_NO_THROW(variableFlow = VariableNativeFactory::createState(varNameFlow, FLOW, varIsNegated));

  ASSERT_EQ(variableFlow->getType(), FLOW);
  ASSERT_EQ(variableFlow->getName(), varNameFlow);
  ASSERT_EQ(variableFlow->getNegated(), varIsNegated);
  ASSERT_EQ(variableFlow->isAlias(), isAlias);


  const std::string varNameCalculated = "testVarFlow";
  boost::shared_ptr<VariableNative> variableCalc;
  ASSERT_NO_THROW(variableCalc = VariableNativeFactory::createCalculated(varNameCalculated, FLOW, varIsNegated));

  ASSERT_EQ(variableCalc->getType(), FLOW);
  ASSERT_EQ(variableCalc->isState(), isNotState);
  ASSERT_EQ(variableCalc->getName(), varNameCalculated);
  ASSERT_EQ(variableCalc->getNegated(), varIsNegated);
  ASSERT_EQ(variableCalc->isAlias(), isAlias);

  ASSERT_NO_THROW(variableCalc->setIndex(12));
  ASSERT_EQ(variableCalc->getIndex(), 12);
  ASSERT_THROW_DYNAWO(variableCalc->setIndex(10), DYN::Error::MODELER, DYN::KeyError_t::VariableNativeIndexAlreadySet);
  ASSERT_THROW_DYNAWO(variableCalc->setIndex(12), DYN::Error::MODELER, DYN::KeyError_t::VariableNativeIndexAlreadySet);
}

//-----------------------------------------------------
// TEST alias variables (all types and methods)
//-----------------------------------------------------

TEST(ModelerCommonTest, VariableAlias) {
  const std::string varNameInt = "testVarInt";
  const bool varIsNegated = true;
  const int varIndex = 123785;
  const bool isState = true;
  boost::shared_ptr<VariableNative> variableInt;
  ASSERT_NO_THROW(variableInt = VariableNativeFactory::createState(varNameInt, INTEGER, varIsNegated));

  const boost::shared_ptr<VariableNative> continuousVar = VariableNativeFactory::createState("continuousVar", CONTINUOUS, varIsNegated);
  const boost::shared_ptr<VariableNative> discreteVar = VariableNativeFactory::createState("discreteVar", DISCRETE, varIsNegated);
  const boost::shared_ptr<VariableNative> flowVar = VariableNativeFactory::createState("flowVar", FLOW, varIsNegated);
  const boost::shared_ptr<VariableNative> boolVar = VariableNativeFactory::createState("boolVar", BOOLEAN, varIsNegated);

  const std::string aliasName1 = "alias1";
  const std::string aliasName2 = "alias2";
  const std::string aliasName3 = "alias3";

  boost::shared_ptr<VariableAlias> variableAlias1;
  boost::shared_ptr<VariableAlias> variableAlias2;
  boost::shared_ptr<VariableAlias> variableAlias3;

  ASSERT_NO_THROW(variableAlias1 = VariableAliasFactory::create(aliasName1, varNameInt));
  ASSERT_THROW_DYNAWO(variableAlias1->getIndex(), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasRefNotSet);
  ASSERT_THROW_DYNAWO(variableAlias1->getNegated(), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasRefNotSet);
  ASSERT_EQ(variableAlias1->getName(), aliasName1);
  ASSERT_EQ(variableAlias1->getReferenceVariableName(), varNameInt);
  ASSERT_THROW_DYNAWO(variableAlias1->getType(), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasRefNotSet);
  ASSERT_EQ(variableAlias1->getLocalType(), UNDEFINED_TYPE);

  ASSERT_EQ(variableAlias1->referenceVariableSet(), false);

  ASSERT_THROW_DYNAWO(variableAlias1->setReferenceVariable(continuousVar), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasRefIncoherent);
  ASSERT_NO_THROW(variableAlias1->setReferenceVariable(variableInt));

  ASSERT_EQ(variableAlias1->referenceVariableSet(), true);
  ASSERT_THROW_DYNAWO(variableAlias1->getIndex(), DYN::Error::MODELER, DYN::KeyError_t::VariableNativeIndexNotSet);
  ASSERT_EQ(variableAlias1->getType(), INTEGER);
  ASSERT_EQ(variableAlias1->getLocalType(), INTEGER);
  ASSERT_EQ(variableAlias1->isState(), isState);
  ASSERT_EQ(variableAlias1->getNegated(), varIsNegated);

  ASSERT_NO_THROW(variableAlias2 = VariableAliasFactory::create(aliasName2, variableInt, DISCRETE, true));
  ASSERT_THROW_DYNAWO(variableAlias2->getIndex(), DYN::Error::MODELER, DYN::KeyError_t::VariableNativeIndexNotSet);
  ASSERT_EQ(variableAlias2->getName(), aliasName2);
  ASSERT_EQ(variableAlias2->getType(), INTEGER);
  ASSERT_EQ(variableAlias2->getLocalType(), DISCRETE);
  ASSERT_EQ(variableAlias2->getNegated(), !varIsNegated);
  ASSERT_EQ(variableAlias2->isState(), isState);
  ASSERT_EQ(variableAlias2->getReferenceVariableName(), varNameInt);

  ASSERT_NO_THROW(variableInt->setIndex(varIndex));


  ASSERT_NO_THROW(variableAlias1->getIndex());
  ASSERT_EQ(variableAlias1->getIndex(), varIndex);

  ASSERT_NO_THROW(variableAlias2->getIndex());
  ASSERT_EQ(variableAlias2->getIndex(), varIndex);

  ASSERT_NO_THROW(variableAlias3 = VariableAliasFactory::create(aliasName3, variableInt, DISCRETE, false));
  ASSERT_EQ(variableAlias3->getName(), aliasName3);
  ASSERT_EQ(variableAlias3->getReferenceVariableName(), varNameInt);
  ASSERT_EQ(variableAlias3->getType(), INTEGER);
  ASSERT_EQ(variableAlias3->getLocalType(), DISCRETE);
  ASSERT_EQ(variableAlias3->getNegated(), true);
  ASSERT_EQ(variableAlias3->getIndex(), varIndex);

#ifndef _MSC_VER
  EXPECT_ASSERT_DYNAWO(VariableAliasFactory::create(aliasName3, boost::dynamic_pointer_cast<VariableNative> (variableAlias2), DISCRETE));
#endif

  // Test types compatibility
  ASSERT_NO_THROW(VariableAliasFactory::create("MyName", continuousVar, CONTINUOUS));
  ASSERT_NO_THROW(VariableAliasFactory::create("MyName", continuousVar, FLOW));
  ASSERT_THROW_DYNAWO(VariableAliasFactory::create("MyName", continuousVar, DISCRETE), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasIncoherentType);
  ASSERT_THROW_DYNAWO(VariableAliasFactory::create("MyName", continuousVar, INTEGER), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasIncoherentType);
  ASSERT_THROW_DYNAWO(VariableAliasFactory::create("MyName", continuousVar, BOOLEAN), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasIncoherentType);

  ASSERT_NO_THROW(VariableAliasFactory::create("MyName", flowVar, CONTINUOUS));
  ASSERT_NO_THROW(VariableAliasFactory::create("MyName", flowVar, FLOW));
  ASSERT_THROW_DYNAWO(VariableAliasFactory::create("MyName", flowVar, DISCRETE), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasIncoherentType);
  ASSERT_THROW_DYNAWO(VariableAliasFactory::create("MyName", flowVar, INTEGER), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasIncoherentType);
  ASSERT_THROW_DYNAWO(VariableAliasFactory::create("MyName", flowVar, BOOLEAN), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasIncoherentType);

  ASSERT_THROW_DYNAWO(VariableAliasFactory::create("MyName", discreteVar, CONTINUOUS), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasIncoherentType);
  ASSERT_THROW_DYNAWO(VariableAliasFactory::create("MyName", discreteVar, FLOW), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasIncoherentType);
  ASSERT_NO_THROW(VariableAliasFactory::create("MyName", discreteVar, DISCRETE));
  ASSERT_NO_THROW(VariableAliasFactory::create("MyName", discreteVar, INTEGER));
  ASSERT_NO_THROW(VariableAliasFactory::create("MyName", discreteVar, BOOLEAN));

  ASSERT_THROW_DYNAWO(VariableAliasFactory::create("MyName", variableInt, CONTINUOUS), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasIncoherentType);
  ASSERT_THROW_DYNAWO(VariableAliasFactory::create("MyName", variableInt, FLOW), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasIncoherentType);
  ASSERT_NO_THROW(VariableAliasFactory::create("MyName", variableInt, DISCRETE));
  ASSERT_NO_THROW(VariableAliasFactory::create("MyName", variableInt, INTEGER));
  ASSERT_NO_THROW(VariableAliasFactory::create("MyName", variableInt, BOOLEAN));

  ASSERT_THROW_DYNAWO(VariableAliasFactory::create("MyName", boolVar, CONTINUOUS), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasIncoherentType);
  ASSERT_THROW_DYNAWO(VariableAliasFactory::create("MyName", boolVar, FLOW), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasIncoherentType);
  ASSERT_NO_THROW(VariableAliasFactory::create("MyName", boolVar, DISCRETE));
  ASSERT_NO_THROW(VariableAliasFactory::create("MyName", boolVar, INTEGER));
  ASSERT_NO_THROW(VariableAliasFactory::create("MyName", boolVar, BOOLEAN));
}

//-----------------------------------------------------
// TEST multiple variable
//-----------------------------------------------------

TEST(ModelerCommonTest, VariableMultiple) {
  const std::string varName = "testVarMultiple";
  const std::string cardinalityName = "varCardinality";
  const bool varIsNegated = false;
  const unsigned int nbVars = 7;
  boost::shared_ptr<VariableMultiple> variableMulti;
  ASSERT_NO_THROW(variableMulti = VariableMultipleFactory::createState(varName, cardinalityName, INTEGER, varIsNegated));

  ASSERT_EQ(variableMulti->getName(), varName);
  ASSERT_EQ(variableMulti->getCardinalityName(), cardinalityName);
  ASSERT_EQ(variableMulti->getType(), INTEGER);
  ASSERT_EQ(variableMulti->getNegated(), varIsNegated);

  ASSERT_THROW_DYNAWO(variableMulti->getIndex(), DYN::Error::MODELER, DYN::KeyError_t::VariableMultipleHasNoIndex);
  ASSERT_THROW_DYNAWO(variableMulti->getCardinality(), DYN::Error::MODELER, DYN::KeyError_t::VariableCardinalityNotSet);

  ASSERT_NO_THROW(variableMulti->setCardinality(nbVars));
  ASSERT_EQ(variableMulti->getCardinality(), nbVars);

  // create individual variables linked with the multiple variable
  for (unsigned int varIndex = 0; varIndex < variableMulti->getCardinality(); ++varIndex) {
    std::stringstream indivVarName;
    indivVarName << varName << "_" << varIndex << "_value";
    ASSERT_NO_THROW(const boost::shared_ptr<VariableNative> anotherVar = VariableNativeFactory::createState(indivVarName.str(), INTEGER, varIsNegated));
  }
}

//-----------------------------------------------------
// TEST flow connectors (and connector container)
//-----------------------------------------------------

TEST(ModelerCommonTest, ConnectorsFlow) {
  boost::shared_ptr<ConnectorContainer> connectorContainer;
  connectorContainer.reset(new ConnectorContainer());

  boost::shared_ptr<Connector> connector(new Connector());

  ASSERT_NO_THROW(connectorContainer->addFlowConnector(connector));

  ASSERT_NO_THROW(connectorContainer->mergeConnectors());

  ASSERT_EQ(connectorContainer->nbFlowConnectors(), 1);
  ASSERT_EQ(connectorContainer->nbYConnectors(), 0);
  ASSERT_EQ(connectorContainer->nbZConnectors(), 0);
}

//-----------------------------------------------------
// TEST Z connectors (and connector container)
//-----------------------------------------------------

TEST(ModelerCommonTest, ConnectorsZ) {
  boost::shared_ptr<ConnectorContainer> connectorContainer;
  connectorContainer.reset(new ConnectorContainer());

  boost::shared_ptr<Connector> connector(new Connector());

  ASSERT_NO_THROW(connectorContainer->addDiscreteConnector(connector));

  ASSERT_NO_THROW(connectorContainer->mergeConnectors());

  ASSERT_EQ(connectorContainer->nbZConnectors(), 1);
  ASSERT_EQ(connectorContainer->nbYConnectors(), 0);
  ASSERT_EQ(connectorContainer->nbFlowConnectors(), 0);
}

//-----------------------------------------------------
// TEST Y connectors (and connector container)
//-----------------------------------------------------

TEST(ModelerCommonTest, ConnectorsY) {
  boost::shared_ptr<ConnectorContainer> connectorContainer;
  connectorContainer.reset(new ConnectorContainer());

  boost::shared_ptr<Connector> connector(new Connector());

  ASSERT_NO_THROW(connectorContainer->addContinuousConnector(connector));

  ASSERT_NO_THROW(connectorContainer->mergeConnectors());

  ASSERT_EQ(connectorContainer->nbYConnectors(), 0);  // 0 because no sub-model connected
  ASSERT_EQ(connectorContainer->nbZConnectors(), 0);
  ASSERT_EQ(connectorContainer->nbFlowConnectors(), 0);
}


//-----------------------------------------------------
// TEST Modeler Common utilities
//-----------------------------------------------------

TEST(ModelerCommonTest, ModelerCommonUtilities) {
  // propertyVar2Str
  propertyContinuousVar_t propertyContinuousVar = ALGEBRAIC;
  ASSERT_EQ(propertyVar2Str(propertyContinuousVar), "ALGEBRAIC");
  ASSERT_EQ(propertyVar2Str(DIFFERENTIAL), "DIFFERENTIAL");
  ASSERT_EQ(propertyVar2Str(EXTERNAL), "EXTERNAL");
  ASSERT_EQ(propertyVar2Str(UNDEFINED_PROPERTY), "UNDEFINED");

  // typeVar2Str
  ASSERT_EQ(typeVar2Str(DISCRETE), "DISCRETE");
  ASSERT_EQ(typeVar2Str(CONTINUOUS), "CONTINUOUS");
  ASSERT_EQ(typeVar2Str(FLOW), "FLOW");
  ASSERT_EQ(typeVar2Str(INTEGER), "INTEGER");
  ASSERT_EQ(typeVar2Str(BOOLEAN), "BOOLEAN");

  // toCTypeVar
  typeVarC_t typeVarC(VAR_TYPE_DOUBLE);
  ASSERT_NO_THROW(typeVarC = toCTypeVar(DISCRETE));
  ASSERT_EQ(typeVarC, VAR_TYPE_DOUBLE);
  ASSERT_EQ(toCTypeVar(CONTINUOUS), VAR_TYPE_DOUBLE);
  ASSERT_EQ(toCTypeVar(FLOW), VAR_TYPE_DOUBLE);
  ASSERT_EQ(toCTypeVar(INTEGER), VAR_TYPE_INT);
  ASSERT_EQ(toCTypeVar(BOOLEAN), VAR_TYPE_BOOL);

  // typeVarC2Str
  ASSERT_EQ(typeVarC2Str(typeVarC), "DOUBLE");
  ASSERT_EQ(typeVarC2Str(VAR_TYPE_STRING), "STRING");
  ASSERT_EQ(typeVarC2Str(VAR_TYPE_INT), "INT");
  ASSERT_EQ(typeVarC2Str(VAR_TYPE_BOOL), "BOOL");

  // str2TypeVarC
  ASSERT_EQ(str2TypeVarC("DOUBLE"), VAR_TYPE_DOUBLE);
  ASSERT_EQ(str2TypeVarC("INT"), VAR_TYPE_INT);
  ASSERT_EQ(str2TypeVarC("BOOL"), VAR_TYPE_BOOL);
  ASSERT_EQ(str2TypeVarC("STRING"), VAR_TYPE_STRING);

  ASSERT_THROW_DYNAWO(str2TypeVarC("ABCDEF"), Error::MODELER, KeyError_t::TypeVarCUnableToConvert);

  // toNativeBool
  ASSERT_EQ(toNativeBool(1), true);
  ASSERT_EQ(toNativeBool(1.0), true);
  ASSERT_EQ(toNativeBool(0), false);
  ASSERT_EQ(toNativeBool(-1), false);

  // fromNativeBool
  ASSERT_EQ(fromNativeBool(true), 1.0);
  ASSERT_EQ(fromNativeBool(false), -1.0);

  // modeChangeType2Str
  ASSERT_EQ(modeChangeType2Str(NO_MODE), "No mode change");
  ASSERT_EQ(modeChangeType2Str(DIFFERENTIAL_MODE), "Differential mode change");
  ASSERT_EQ(modeChangeType2Str(ALGEBRAIC_MODE), "Algebraic mode change");
  ASSERT_EQ(modeChangeType2Str(ALGEBRAIC_J_UPDATE_MODE), "Algebraic mode (with J recalculation) change");
}

TEST(ModelerCommonTest, testNoParFile) {
  boost::shared_ptr<DynamicData> dyd(new DynamicData());
  std::shared_ptr<parameters::ParametersSet> params;
  ASSERT_NO_THROW(params = dyd->getParametersSet("MyModel", "", ""));
  assert(!params);
}

TEST(ModelerCommonTest, testMissingParFile) {
  boost::shared_ptr<DynamicData> dyd(new DynamicData());
  dyd->getParametersSet("MyModel", "", "2");
  ASSERT_THROW_DYNAWO(DYN::DYNErrorQueue::instance().flush(), Error::API, KeyError_t::MissingParameterFile);
}

TEST(ModelerCommonTest, testMissingParId) {
  boost::shared_ptr<DynamicData> dyd(new DynamicData());
  dyd->getParametersSet("MyModel", "MyFile.par", "");
  ASSERT_THROW_DYNAWO(DYN::DYNErrorQueue::instance().flush(), Error::API, KeyError_t::MissingParameterId);
}

//-----------------------------------------------------
// TEST Model mode handling
//-----------------------------------------------------
TEST(ModelerCommonTest, testModeHandling) {
  // Create model multi
  boost::shared_ptr<ModelMulti> modelMulti(new ModelMulti());

  // Create a submodel
  boost::shared_ptr<SubModelMode> subModelMode(new SubModelMode());
  subModelMode->name("SubModelName");
  boost::shared_ptr<SubModel> subModel = boost::dynamic_pointer_cast<SubModel> (subModelMode);
  modelMulti->addSubModel(subModel, "SubModelMode");

  std::vector<double> y, yp, z;
  double time = 0;
  modelMulti->copyContinuousVariables(&y[0], &yp[0]);
  modelMulti->copyDiscreteVariables(&z[0]);
  modelMulti->evalMode(time);
  ASSERT_EQ(modelMulti->modeChange(), false);
  ASSERT_EQ(modelMulti->getModeChangeType(), NO_MODE);

  modelMulti->reinitMode();
  time = 1;
  modelMulti->copyContinuousVariables(&y[0], &yp[0]);
  modelMulti->copyDiscreteVariables(&z[0]);
  modelMulti->evalMode(time);
  ASSERT_EQ(modelMulti->modeChange(), true);
  ASSERT_EQ(modelMulti->getModeChangeType(), DIFFERENTIAL_MODE);
  // Emulating the behavior in the evalZMode method (calling the method several times without reinitializing the modes)
  time = 2;
  modelMulti->copyContinuousVariables(&y[0], &yp[0]);
  modelMulti->copyDiscreteVariables(&z[0]);
  modelMulti->evalMode(time);
  ASSERT_EQ(modelMulti->modeChange(), true);
  ASSERT_EQ(modelMulti->getModeChangeType(), ALGEBRAIC_MODE);
  time = 5;
  modelMulti->copyContinuousVariables(&y[0], &yp[0]);
  modelMulti->copyDiscreteVariables(&z[0]);
  modelMulti->evalMode(time);
  ASSERT_EQ(modelMulti->modeChange(), false);
  ASSERT_EQ(modelMulti->getModeChangeType(), ALGEBRAIC_MODE);
  ASSERT_EQ(subModel->evalModeSub(time), NO_MODE);
  ASSERT_EQ(subModel->modeChange(), false);
  time = 1;
  modelMulti->copyContinuousVariables(&y[0], &yp[0]);
  modelMulti->copyDiscreteVariables(&z[0]);
  modelMulti->evalMode(time);
  ASSERT_EQ(modelMulti->modeChange(), false);
  ASSERT_EQ(modelMulti->getModeChangeType(), ALGEBRAIC_MODE);
  ASSERT_EQ(subModel->evalModeSub(time), DIFFERENTIAL_MODE);
  ASSERT_EQ(subModel->modeChange(), false);
  time = 4;
  modelMulti->copyContinuousVariables(&y[0], &yp[0]);
  modelMulti->copyDiscreteVariables(&z[0]);
  modelMulti->evalMode(time);
  ASSERT_EQ(modelMulti->modeChange(), true);
  ASSERT_EQ(modelMulti->getModeChangeType(), ALGEBRAIC_J_UPDATE_MODE);
  ASSERT_EQ(subModel->modeChange(), true);
  ASSERT_EQ(subModel->evalModeSub(time), ALGEBRAIC_J_UPDATE_MODE);
  ASSERT_EQ(subModel->modeChange(), false);

  modelMulti->reinitMode();
  time = 2;
  modelMulti->copyContinuousVariables(&y[0], &yp[0]);
  modelMulti->copyDiscreteVariables(&z[0]);
  modelMulti->evalMode(time);
  ASSERT_EQ(modelMulti->modeChange(), true);
  ASSERT_EQ(modelMulti->getModeChangeType(), ALGEBRAIC_MODE);

  modelMulti->reinitMode();
  time = 3;
  modelMulti->copyContinuousVariables(&y[0], &yp[0]);
  modelMulti->copyDiscreteVariables(&z[0]);
  modelMulti->evalMode(time);
  ASSERT_EQ(modelMulti->modeChange(), true);
  ASSERT_EQ(modelMulti->getModeChangeType(), DIFFERENTIAL_MODE);
  ASSERT_EQ(subModel->modeChange(), true);
  ASSERT_EQ(subModel->evalModeSub(time), DIFFERENTIAL_MODE);

  modelMulti->reinitMode();
  time = 4;
  modelMulti->copyContinuousVariables(&y[0], &yp[0]);
  modelMulti->copyDiscreteVariables(&z[0]);
  modelMulti->evalMode(time);
  ASSERT_EQ(modelMulti->modeChange(), true);
  ASSERT_EQ(modelMulti->getModeChangeType(), ALGEBRAIC_J_UPDATE_MODE);

  modelMulti->reinitMode();
  ASSERT_EQ(modelMulti->getModeChangeType(), NO_MODE);
  ASSERT_EQ(subModel->modeChange(), false);
  modelMulti->setModeChangeType(DIFFERENTIAL_MODE);
  ASSERT_EQ(modelMulti->getModeChangeType(), DIFFERENTIAL_MODE);
}

TEST(ModelerCommonTest, SanityCheckOnSizeYZ) {
  // Create submodel
  boost::shared_ptr<SubModelMock> submodel = boost::shared_ptr<SubModelMock>(new SubModelMock(2, 1));
  boost::dynamic_pointer_cast< SubModel >(submodel)->defineVariables();
  submodel->defineNames();
  int sizeYGlob = 0;
  int sizeZGlob = 0;
  int sizeModeGlob = 0;
  int sizeFGlob = 0;
  int sizeGGlob = 0;
  ASSERT_THROW_DYNAWO(submodel->initSize(sizeYGlob, sizeZGlob, sizeModeGlob, sizeFGlob, sizeGGlob),
      Error::MODELER, KeyError_t::MismatchingVariableSizes);


  submodel = boost::shared_ptr<SubModelMock>(new SubModelMock(1, 2));
  boost::dynamic_pointer_cast< SubModel >(submodel)->defineVariables();
  submodel->defineNames();
  ASSERT_THROW_DYNAWO(submodel->initSize(sizeYGlob, sizeZGlob, sizeModeGlob, sizeFGlob, sizeGGlob),
      Error::MODELER, KeyError_t::MismatchingVariableSizes);


  submodel = boost::shared_ptr<SubModelMock>(new SubModelMock(1, 1));
  boost::dynamic_pointer_cast< SubModel >(submodel)->defineVariables();
  submodel->defineNames();
  ASSERT_NO_THROW(submodel->initSize(sizeYGlob, sizeZGlob, sizeModeGlob, sizeFGlob, sizeGGlob));
}


TEST(ModelerCommonTest, CommonModeler) {
  std::map<std::string, int> mapElement;
  std::vector<Element> elements;
  addElement("MyElement", Element::STRUCTURE, elements, mapElement);
  ASSERT_EQ(elements.size(), 1);
  ASSERT_EQ(elements[0].name(), "MyElement");
  ASSERT_EQ(elements[0].getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(mapElement.size(), 1);
  ASSERT_TRUE(mapElement.find("MyElement") != mapElement.end());
  ASSERT_EQ(mapElement["MyElement"], 0);

  addSubElement("MySubElement", "MyElement", Element::TERMINAL, "MyParentName", "MyParentType", elements, mapElement);
  ASSERT_EQ(elements.size(), 2);
  ASSERT_EQ(elements[0].name(), "MyElement");
  ASSERT_EQ(elements[0].getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(elements[1].name(), "MySubElement");
  ASSERT_EQ(elements[1].getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(mapElement.size(), 2);
  ASSERT_TRUE(mapElement.find("MyElement") != mapElement.end());
  ASSERT_EQ(mapElement["MyElement"], 0);
  ASSERT_TRUE(mapElement.find("MyElement_MySubElement") != mapElement.end());
  ASSERT_EQ(mapElement["MyElement_MySubElement"], 1);

  std::string var = "@NAME@_@INDEX@";
  ASSERT_THROW_DYNAWO(replaceMacroInVariableId("", "MyName", "Model1", "Model2", "Connector", var),
      Error::MODELER, KeyError_t::IncompleteMacroConnection);
  ASSERT_THROW_DYNAWO(replaceMacroInVariableId("42", "", "Model1", "Model2", "Connector", var),
      Error::MODELER, KeyError_t::IncompleteMacroConnection);
  replaceMacroInVariableId("42", "MyName", "Model1", "Model2", "Connector", var);
  ASSERT_EQ(var, "MyName_42");
}

TEST(ModelerCommonTest, StaticRefInterface) {
  StaticRefInterface sri;

  ASSERT_EQ(sri.getModelID(), "");
  ASSERT_EQ(sri.getModelVar(), "");
  ASSERT_EQ(sri.getStaticVar(), "");

  sri.setModelID("MyModelID");
  sri.setModelVar("MyModelVar");
  sri.setStaticVar("MyStaticVar");

  ASSERT_EQ(sri.getModelID(), "MyModelID");
  ASSERT_EQ(sri.getModelVar(), "MyModelVar");
  ASSERT_EQ(sri.getStaticVar(), "MyStaticVar");
}

TEST(ModelerCommonTest, ConnectionCalculatedVars) {
  boost::shared_ptr<ModelMulti> modelMulti(new ModelMulti());
  shared_ptr<SubModelMock> subModel1(new SubModelMock(1, 1));
  subModel1->name("subModel1");
  shared_ptr<SubModel> subModel1_ = boost::dynamic_pointer_cast<SubModel> (subModel1);
  subModel1_->name("subModel1");
  subModel1_->defineNames();
  subModel1_->defineVariables();
  modelMulti->addSubModel(subModel1_, "subModelMock");

  shared_ptr<SubModelMock> subModel2(new SubModelMock(1, 1));
  subModel2->name("subModel2");
  shared_ptr<SubModel> subModel2_ = boost::dynamic_pointer_cast<SubModel> (subModel2);
  subModel2_->name("subModel2");
  subModel2_->defineNames();
  subModel2_->defineVariables();
  modelMulti->addSubModel(subModel2_, "subModelMock");

  std::vector<double> y, yp;
  modelMulti->copyContinuousVariables(&y[0], &yp[0]);
  modelMulti->connectElements(modelMulti->findSubModelByName("subModel1"), "MyDiscreteVarCalculated_value",
                              modelMulti->findSubModelByName("subModel2"), "MyDiscreteVar_value");
  std::string name = subModel1_->name() + "_MyDiscreteVarCalculated_value";
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name));
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->getSize());
  std::vector<state_g> g(modelMulti->findSubModelByName(name)->sizeG(), ROOT_DOWN);
  modelMulti->findSubModelByName(name)->setBufferG(&g[0], 0);
  std::vector<double> z(modelMulti->findSubModelByName(name)->sizeZ(), 0);
  bool* zConnected = new bool[modelMulti->findSubModelByName(name)->sizeZ()];
  for (size_t i = 0; i < modelMulti->findSubModelByName(name)->sizeZ(); ++i)
    zConnected[i] = true;
  modelMulti->findSubModelByName(name)->setBufferZ(&z[0], zConnected, 0);
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->init(0));
  ASSERT_EQ(modelMulti->findSubModelByName(name)->modelType(), "ConnectorCalculatedDiscreteVariable");
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->evalCalculatedVars());
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->evalStaticFType());
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->evalStaticYType());
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->evalDynamicFType());
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->evalDynamicYType());
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->setFequationsInit());
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->setFequations());
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->setGequationsInit());
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->initSubBuffers());
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->getY0());
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->evalG(0));
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->evalZ(0));

  modelMulti->findSubModelByName(name)->setCurrentTime(1.0);
  subModel1_->setCurrentTime(1.0);
  subModel2_->setCurrentTime(1.0);
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->evalG(1));
  ASSERT_EQ(g[0], ROOT_UP);
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->evalZ(1));
  ASSERT_EQ(z[0], 1.);
  ASSERT_EQ(modelMulti->findSubModelByName(name)->evalMode(1), NO_MODE);
  ASSERT_NO_THROW(modelMulti->findSubModelByName(name)->setGequations());
}

}  // namespace DYN
