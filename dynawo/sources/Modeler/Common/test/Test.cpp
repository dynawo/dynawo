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
#include "DYNSubModel.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"
#include "DYNDynamicData.h"

#include "DYNError.h"

using boost::shared_ptr;
using boost::dynamic_pointer_cast;

using parameters::ParametersSet;
using parameters::ParametersSetFactory;

namespace DYN {

class SubModelMock : public SubModel {
  void init(const double& t0) {
    // Dummy class used for testing
  }

  std::string modelType() const {
    // Dummy class used for testing
  }

  void dumpParameters(std::map< std::string, std::string > & mapParameters) {
    // Dummy class used for testing
  }

  void getSubModelParameterValue(const std::string & nameParameter, double & value, bool & found) {
    // Dummy class used for testing
  }

  void dumpVariables(std::map< std::string, std::string > & mapVariables) {
    // Dummy class used for testing
  }

  void loadParameters(const std::string &parameters) {
    // Dummy class used for testing
  }

  void loadVariables(const std::string &variables) {
    // Dummy class used for testing
  }

  void evalF(const double & t) {
    // Dummy class used for testing
  }

  void evalG(const double & t) {
    // Dummy class used for testing
  }

  void evalZ(const double & t) {
    // Dummy class used for testing
  }

  void evalCalculatedVars() {
    // Dummy class used for testing
  }

  void evalJt(const double & t, const double & cj, SparseMatrix& Jt, const int& rowOffset) {
    // Dummy class used for testing
  }

  void evalJtPrim(const double & t, const double & cj, SparseMatrix& Jt, const int& rowOffset) {
    // Dummy class used for testing
  }

  void evalMode(const double & t) {
    // Dummy class used for testing
  }

  void checkDataCoherence(const double & t) {
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

  void getSize() {
    // Dummy class used for testing
  }

  void defineElements(std::vector<Element> &elements, std::map<std::string, int >& mapElement) {
    // Dummy class used for testing
  }

  void initializeStaticData() {
    // Dummy class used for testing
  }

  void initializeFromData(const boost::shared_ptr<DataInterface>& data) {
    // Dummy class used for testing
  }

  void printInitValues(const std::string & directory) {
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

  std::vector<int> getDefJCalculatedVarI(int iCalculatedVar) {
    // Dummy class used for testing
  }

  void evalJCalculatedVarI(int iCalculatedVar, double* y, double* yp, std::vector<double>& res) {
    // Dummy class used for testing
  }

  double evalCalculatedVarI(int iCalculatedVar, double* y, double* yp) {
    // Dummy class used for testing
  }

  void setSubModelParameters() {
    // Dummy class used for testing
  }

  void initParams() {
    // Dummy class used for testing
  }
};
//-----------------------------------------------------
// TEST DYNParameter
//-----------------------------------------------------

TEST(ModelerCommonTest, ParameterUnitary) {   // Test for unitary parameters
  // Create a vector of parameters with no values
  std::vector<ParameterModeler> parameters;
  parameters.push_back(ParameterModeler("name_bool", BOOL, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("name_int", INT, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("name_double", DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("name_string", STRING, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("test", STRING, EXTERNAL_PARAMETER));

  // Test attributes given from contructor
  ASSERT_EQ(parameters[0].getName(), "name_bool");
  ASSERT_EQ(parameters[0].getValueType(), BOOL);
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
  ASSERT_EQ(parameters[1].getValueType(), INT);
  ASSERT_THROW_DYNAWO(parameters[1].getValue<int>(), Error::MODELER, KeyError_t::ParameterHasNoValue);

  ASSERT_EQ(parameters[2].getValueType(), DOUBLE);
  ASSERT_THROW_DYNAWO(parameters[2].getValue<double>(), Error::MODELER, KeyError_t::ParameterHasNoValue);

  ASSERT_EQ(parameters[3].getValueType(), STRING);
  ASSERT_THROW_DYNAWO(parameters[3].getValue<std::string>(), Error::MODELER, KeyError_t::ParameterHasNoValue);
  ASSERT_THROW_DYNAWO(parameters[3].getOrigin(), Error::MODELER, KeyError_t::ParameterHasNoValue);

  // Test methode isUnitary()
  ASSERT_EQ(parameters[0].isUnitary(), true);
  ASSERT_EQ(parameters[0].getIsNonUnitaryParameterInstance(), false);

  // Test set and get for attribute value (bool, int, double, string)
  ASSERT_NO_THROW(parameters[0].setValue(true, LOCAL_INIT));
  ASSERT_NO_THROW(parameters[1].setValue(2, PAR));
  ASSERT_NO_THROW(parameters[2].setValue(1.12, FINAL));
  ASSERT_NO_THROW(parameters[3].setValue(std::string("ok"), LOCAL_INIT));

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
  ASSERT_EQ(parameters[3].getOrigin(), LOCAL_INIT);

  ASSERT_EQ(parameters[0].hasOrigin(LOCAL_INIT), true);
  ASSERT_EQ(parameters[1].hasOrigin(PAR), true);
  ASSERT_EQ(parameters[2].hasOrigin(FINAL), true);
  ASSERT_EQ(parameters[3].hasOrigin(LOCAL_INIT), true);
  ASSERT_EQ(parameters[0].hasOrigin(MO), false);
  ASSERT_EQ(parameters[1].hasOrigin(MO), false);
  ASSERT_EQ(parameters[2].hasOrigin(MO), false);
  ASSERT_EQ(parameters[3].hasOrigin(MO), false);

  // Test update of origin
  ASSERT_NO_THROW(parameters[0].setValue(true, PAR));
  ASSERT_EQ(parameters[0].getOrigin(), LOCAL_INIT);
  ASSERT_NO_THROW(parameters[0].setValue(true, LOCAL_INIT));
  ASSERT_EQ(parameters[0].getOrigin(), LOCAL_INIT);

  ASSERT_NO_THROW(parameters[3].setValue(std::string("mo"), PAR));
  ASSERT_EQ(parameters[3].getOrigin(), LOCAL_INIT);
  ASSERT_NO_THROW(parameters[3].setValue(std::string("init"), LOADED_DUMP));
  ASSERT_EQ(parameters[3].getOrigin(), LOADED_DUMP);
  ASSERT_EQ(parameters[3].getValue<std::string>(), "init");

  ASSERT_THROW_DYNAWO(parameters[4].setValue(true, PAR), Error::MODELER, KeyError_t::ParameterInvalidTypeRequested);
  ASSERT_NO_THROW(parameters[4].setValue(std::string("PAR"), PAR));
  ASSERT_EQ(parameters[4].getOrigin(), PAR);
  ASSERT_EQ(parameters[4].getValue<std::string>(), "PAR");
  ASSERT_NO_THROW(parameters[4].setValue(std::string("LOADED_DUMP"), LOADED_DUMP));
  ASSERT_EQ(parameters[4].getOrigin(), LOADED_DUMP);
  ASSERT_EQ(parameters[4].getValue<std::string>(), "LOADED_DUMP");

  // Test for parameters with multiple origin
  ASSERT_NO_THROW(parameters[1].setValue(1, PAR));
  ASSERT_NO_THROW(parameters[1].setValue(3, IIDM));
  ASSERT_EQ(parameters[1].getValue<int>(), 3);

  // Test the impossibility to set a cardinality informator for an unitary parameter
  ASSERT_THROW_DYNAWO(parameters[0].setCardinalityInformator("nbGen"), Error::MODELER, KeyError_t::ParameterUnitary);
}

TEST(ModelerCommonTest, ParameterMultipleCardinality) {   // Test for parameters with multiple cardinality
  // Create parameter with multiple cardinality
  ParameterModeler paramMultiBool = ParameterModeler("name_bool", BOOL, EXTERNAL_PARAMETER, "*");
  ParameterModeler paramMultiInt = ParameterModeler("name_int", INT, EXTERNAL_PARAMETER, "*", "nbGen");
  ParameterModeler paramMultiDouble = ParameterModeler("name_double", DOUBLE, EXTERNAL_PARAMETER, "*", "nbGen");
  ParameterModeler paramMultiString = ParameterModeler("name_string", STRING, EXTERNAL_PARAMETER, "*", "nbGen");

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
  ParameterModeler paramMultiBoolInstance = ParameterModeler("name_bool_1", BOOL, EXTERNAL_PARAMETER, "");
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
  boost::shared_ptr<parameters::ParametersSet> parametersSet = ParametersSetFactory::newInstance("Parameterset");
  std::string string_value = "ok";
  parametersSet->createParameter("name_bool", false)
          ->createParameter("name_int", 2)
          ->createParameter("name_double", 1.12)
          ->createParameter("name_string", string_value)
          ->createParameter("wrong_type", true);

  // Create unitary parameters
  ParameterModeler paramBool = ParameterModeler("name_bool", BOOL, EXTERNAL_PARAMETER);
  ParameterModeler paramInt = ParameterModeler("name_int", INT, EXTERNAL_PARAMETER);
  ParameterModeler paramDouble = ParameterModeler("name_double", DOUBLE, EXTERNAL_PARAMETER);
  ParameterModeler paramDoubleShared = ParameterModeler("shared_par", DOUBLE, SHARED_PARAMETER);
  ParameterModeler paramDoubleInternal = ParameterModeler("internal_par", DOUBLE, INTERNAL_PARAMETER);
  ParameterModeler paramString = ParameterModeler("name_string", STRING, EXTERNAL_PARAMETER);
  ParameterModeler paramNotInSet = ParameterModeler("not_in_set", BOOL, EXTERNAL_PARAMETER);
  ParameterModeler paramNotUnitary = ParameterModeler("not_unitary", DOUBLE, EXTERNAL_PARAMETER, "*", "name_int");

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
  boost::shared_ptr<parameters::ParametersSet> parametersSet = ParametersSetFactory::newInstance("Parameterset");
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
  ParameterModeler paramBool = ParameterModeler("name_bool", BOOL, EXTERNAL_PARAMETER);
  ParameterModeler paramInt = ParameterModeler("name_int", INT, EXTERNAL_PARAMETER);
  ParameterModeler paramDouble = ParameterModeler("name_double", DOUBLE, EXTERNAL_PARAMETER);
  ParameterModeler paramString = ParameterModeler("name_string", STRING, EXTERNAL_PARAMETER);
  ParameterModeler paramNotUnitaryInt = ParameterModeler("not_unitary_int", INT, EXTERNAL_PARAMETER, "*", "name_int");
  ParameterModeler paramNotUnitaryDouble = ParameterModeler("not_unitary_double", DOUBLE, EXTERNAL_PARAMETER, "*", "name_int");

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
  ParameterModeler paramBool = ParameterModeler("name_bool", BOOL, EXTERNAL_PARAMETER);
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
  const int defaultIndex = -1;
  const bool isState = true;
  boost::shared_ptr<VariableNative> variableInt;
  ASSERT_NO_THROW(variableInt = VariableNativeFactory::createState(varNameInt, INTEGER, varIsNegated));

  const boost::shared_ptr<VariableNative> anotherVar = VariableNativeFactory::createState("anotherVar", CONTINUOUS, varIsNegated);

  const std::string aliasName1 = "alias1";
  const std::string aliasName2 = "alias2";
  const std::string aliasName3 = "alias3";

  boost::shared_ptr <VariableAlias> variableAlias1;
  boost::shared_ptr <VariableAlias> variableAlias2;
  boost::shared_ptr <VariableAlias> variableAlias3;

  ASSERT_NO_THROW(variableAlias1 = VariableAliasFactory::create(aliasName1, varNameInt));
  ASSERT_THROW_DYNAWO(variableAlias1->getIndex(), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasRefNotSet);
  ASSERT_THROW_DYNAWO(variableAlias1->getType(), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasRefNotSet);
  ASSERT_THROW_DYNAWO(variableAlias1->getNegated(), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasRefNotSet);
  ASSERT_EQ(variableAlias1->getName(), aliasName1);
  ASSERT_EQ(variableAlias1->getReferenceVariableName(), varNameInt);

  ASSERT_EQ(variableAlias1->referenceVariableSet(), false);

  ASSERT_THROW_DYNAWO(variableAlias1->setReferenceVariable(anotherVar), DYN::Error::MODELER, DYN::KeyError_t::VariableAliasRefIncoherent);
  ASSERT_NO_THROW(variableAlias1->setReferenceVariable(variableInt));

  ASSERT_EQ(variableAlias1->referenceVariableSet(), true);
  ASSERT_THROW_DYNAWO(variableAlias1->getIndex(), DYN::Error::MODELER, DYN::KeyError_t::VariableNativeIndexNotSet);
  ASSERT_EQ(variableAlias1->getType(), INTEGER);
  ASSERT_EQ(variableAlias1->isState(), isState);
  ASSERT_EQ(variableAlias1->getNegated(), varIsNegated);

  ASSERT_NO_THROW(variableAlias2 = VariableAliasFactory::create(aliasName2, variableInt, true));
  ASSERT_THROW_DYNAWO(variableAlias2->getIndex(), DYN::Error::MODELER, DYN::KeyError_t::VariableNativeIndexNotSet);
  ASSERT_EQ(variableAlias2->getName(), aliasName2);
  ASSERT_EQ(variableAlias2->getType(), INTEGER);
  ASSERT_EQ(variableAlias2->getNegated(), !varIsNegated);
  ASSERT_EQ(variableAlias2->isState(), isState);
  ASSERT_EQ(variableAlias2->getReferenceVariableName(), varNameInt);

  ASSERT_NO_THROW(variableInt->setIndex(varIndex));


  ASSERT_NO_THROW(variableAlias1->getIndex());
  ASSERT_EQ(variableAlias1->getIndex(), varIndex);

  ASSERT_NO_THROW(variableAlias2->getIndex());
  ASSERT_EQ(variableAlias2->getIndex(), varIndex);

  ASSERT_NO_THROW(variableAlias3 = VariableAliasFactory::create(aliasName3, variableInt, false));
  ASSERT_EQ(variableAlias3->getName(), aliasName3);
  ASSERT_EQ(variableAlias3->getReferenceVariableName(), varNameInt);
  ASSERT_EQ(variableAlias3->getType(), INTEGER);
  ASSERT_EQ(variableAlias3->getNegated(), true);
  ASSERT_EQ(variableAlias3->getIndex(), varIndex);

  EXPECT_ASSERT_DYNAWO(VariableAliasFactory::create(aliasName3, dynamic_pointer_cast<VariableNative> (variableAlias2)));
}

//-----------------------------------------------------
// TEST multiple variable
//-----------------------------------------------------

TEST(ModelerCommonTest, VariableMultiple) {
  const std::string varName = "testVarMultiple";
  const std::string cardinalityName = "varCardinality";
  const bool varIsNegated = false;
  const bool isState = true;
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
  propertyContinuousVar_t propertyContinuousVar = ALGEBRIC;
  ASSERT_EQ(propertyVar2Str(propertyContinuousVar), "ALGEBRIC");
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
  typeVarC_t typeVarC;
  ASSERT_NO_THROW(typeVarC = toCTypeVar(DISCRETE));
  ASSERT_EQ(typeVarC, DOUBLE);
  ASSERT_EQ(toCTypeVar(CONTINUOUS), DOUBLE);
  ASSERT_EQ(toCTypeVar(FLOW), DOUBLE);
  ASSERT_EQ(toCTypeVar(INTEGER), INT);
  ASSERT_EQ(toCTypeVar(BOOLEAN), BOOL);

  // typeVarC2Str
  ASSERT_EQ(typeVarC2Str(typeVarC), "DOUBLE");
  ASSERT_EQ(typeVarC2Str(STRING), "STRING");
  ASSERT_EQ(typeVarC2Str(INT), "INT");
  ASSERT_EQ(typeVarC2Str(BOOL), "BOOL");

  // str2TypeVarC
  ASSERT_EQ(str2TypeVarC("DOUBLE"), DOUBLE);
  ASSERT_EQ(str2TypeVarC("INT"), INT);
  ASSERT_EQ(str2TypeVarC("BOOL"), BOOL);
  ASSERT_EQ(str2TypeVarC("STRING"), STRING);

  ASSERT_THROW_DYNAWO(str2TypeVarC("ABCDEF"), Error::MODELER, KeyError_t::TypeVarCUnableToConvert);

  // toNativeBool
  ASSERT_EQ(toNativeBool(1), true);
  ASSERT_EQ(toNativeBool(1.0), true);
  ASSERT_EQ(toNativeBool(0), false);
  ASSERT_EQ(toNativeBool(-1), false);

  // fromNativeBool
  ASSERT_EQ(fromNativeBool(true), 1.0);
  ASSERT_EQ(fromNativeBool(false), -1.0);
}

TEST(ModelerCommonTest, testNoParFile) {
  boost::shared_ptr<DynamicData> dyd(new DynamicData());
  boost::shared_ptr<parameters::ParametersSet> params;
  ASSERT_NO_THROW(params = dyd->getParametersSet("MyModel", "", ""));
  assert(!params);
}

TEST(ModelerCommonTest, testMissingParFile) {
  boost::shared_ptr<DynamicData> dyd(new DynamicData());
  ASSERT_THROW_DYNAWO(dyd->getParametersSet("MyModel", "", "2"), Error::API, KeyError_t::MissingParameterFile);
}

TEST(ModelerCommonTest, testMissingParId) {
  boost::shared_ptr<DynamicData> dyd(new DynamicData());
  ASSERT_THROW_DYNAWO(dyd->getParametersSet("MyModel", "MyFile.par", ""), Error::API, KeyError_t::MissingParameterId);
}
}  // namespace DYN
