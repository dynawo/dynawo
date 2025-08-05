//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file Models/CPP/Controls/Voltage/ModelVoltageMeasurementsUtilities/test/TestVoltageMeasurementsUtilities.cpp
 * @brief Unit tests for ModelVoltageMeasurementsUtilities model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNModelSecondaryVoltageControlSimplified.h"
#include "DYNModelSecondaryVoltageControlSimplified.hpp"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNElement.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> createModelSecondaryVoltageControlSimplified(size_t nbGen = 0) {
    // All changes here should be adapted in the test for DefineMethods.
    boost::shared_ptr<SubModel> voltmu =
        SubModelFactory::createSubModelFromLib("../DYNModelSecondaryVoltageControlSimplified" + std::string(sharedLibraryExtension()));
    voltmu->init(0.);  // Harmless coverage
    std::vector<ParameterModeler> parameters;
    voltmu->defineParameters(parameters);
    std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
    parameters.push_back(ParameterModeler("Qr", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGenerators"));
    parameters.push_back(ParameterModeler("Q0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGenerators"));
    parametersSet->createParameter("nbGenerators", static_cast<int>(nbGen));
    parametersSet->createParameter("UDeadBandPu", 0.01);
    parametersSet->createParameter("alpha", 2.);
    parametersSet->createParameter("beta", 3.5);
    parametersSet->createParameter("UpRef0Pu", 1.);
    parametersSet->createParameter("tSample", 2.);
    for (size_t i = 0; i < nbGen; ++i) {
      parametersSet->createParameter("Qr_" + std::to_string(i), 100.);
      parametersSet->createParameter("Q0Pu_" + std::to_string(i), 1.);
    }
    voltmu->setPARParameters(parametersSet);
    voltmu->addParameters(parameters, false, false);
    voltmu->setParametersFromPARFile();
    voltmu->setSubModelParameters();
    voltmu->getSize();  // Sets all the sizes
    return voltmu;
}

TEST(ModelSecondaryVoltageControlSimplified, ModelSecondaryVoltageControlSimplifiedDefineMethods) {
    // Checks all operations required in the general initModel function up there.
    boost::shared_ptr<SubModel> svc =
        SubModelFactory::createSubModelFromLib("../DYNModelSecondaryVoltageControlSimplified" + std::string(sharedLibraryExtension()));
    svc->init(0.);
    std::vector<ParameterModeler> parameters;
    svc->defineParameters(parameters);
    ASSERT_EQ(parameters.size(), 8);
    // Define the model parameters
    size_t nbGen = 2;
    std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
    parameters.push_back(ParameterModeler("Qr", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGenerators"));
    parameters.push_back(ParameterModeler("Q0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGenerators"));
    parametersSet->createParameter("nbGenerators", static_cast<int>(nbGen));
    parametersSet->createParameter("UDeadBandPu", 0.01);
    parametersSet->createParameter("alpha", 0.08);
    parametersSet->createParameter("beta", 3.5);
    parametersSet->createParameter("UpRef0Pu", 1.);
    parametersSet->createParameter("tSample", 2.);
    for (size_t i = 0; i < nbGen; ++i) {
      parametersSet->createParameter("Qr_" + std::to_string(i), 100.);
      parametersSet->createParameter("Q0Pu_" + std::to_string(i), 1.);
    }
    ASSERT_NO_THROW(svc->setPARParameters(parametersSet));
    svc->addParameters(parameters, false, false);
    ASSERT_NO_THROW(svc->setParametersFromPARFile());
    ASSERT_NO_THROW(svc->setSubModelParameters());

    ASSERT_NO_THROW(svc->getSize());
    ASSERT_EQ(svc->sizeG(), 2);
    ASSERT_EQ(svc->sizeY(), 1);
    ASSERT_EQ(svc->sizeZ(), nbGen + DYN::ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_);
    ASSERT_EQ(svc->sizeMode(), 0);
    ASSERT_EQ(svc->sizeF(), 0);

    // Let's work out the variables and elements.
    std::vector<boost::shared_ptr<Variable> > variables;
    svc->defineVariables(variables);
    unsigned long nbVar = static_cast<unsigned long>(DYN::ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_) +
                            nbGen + static_cast<unsigned long>(DYN::ModelSecondaryVoltageControlSimplified::nbContinuousVariables_)
                            + static_cast<unsigned long>(DYN::ModelSecondaryVoltageControlSimplified::nbCalculatedVariables_);
    ASSERT_EQ(variables.size(), nbVar);
    std::vector<Element> elements;
    std::map<std::string, int> mapElements;
    svc->defineElements(elements, mapElements);
    ASSERT_EQ(elements.size(), 2*nbVar);
    ASSERT_EQ(elements.size(), mapElements.size());
}

TEST(ModelSecondaryVoltageControlSimplified, ModelSecondaryVoltageControlSimplifiedTypeMethods) {
  boost::shared_ptr<SubModel> svc = createModelSecondaryVoltageControlSimplified(2);
  std::vector<propertyContinuousVar_t> yTypes(svc->sizeY(), UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(svc->sizeF(), UNDEFINED_EQ);
  svc->setBufferYType(&yTypes[0], 0);
  svc->setBufferFType(&fTypes[0], 0);

  svc->evalStaticYType();
  svc->evalDynamicYType();
  propertyContinuousVar_t* yTypeGet = svc->getYType();
  ASSERT_EQ(yTypeGet[0], EXTERNAL);

  ASSERT_NO_THROW(svc->evalStaticFType());
  ASSERT_NO_THROW(svc->evalDynamicFType());

  ASSERT_NO_THROW(svc->dumpUserReadableElementList("MyElement"));
  ASSERT_NO_THROW(svc->initializeFromData(boost::shared_ptr<DataInterface>()));
  ASSERT_NO_THROW(svc->evalDynamicFType());
  ASSERT_NO_THROW(svc->evalDynamicYType());
  ASSERT_NO_THROW(svc->initializeStaticData());
  ASSERT_NO_THROW(svc->setGequations());
  ASSERT_NO_THROW(svc->checkDataCoherence(0));
}

TEST(ModelSecondaryVoltageControlSimplified, ModelSecondaryVoltageControlSimplifiedInit) {
  boost::shared_ptr<SubModel> svc = createModelSecondaryVoltageControlSimplified(2);
  std::vector<double> y(svc->sizeY(), 0);
  std::vector<double> yp(svc->sizeY(), 0);
  svc->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(svc->sizeZ(), 0);
  bool* zConnected = new bool[svc->sizeZ()];
  for (size_t i = 0; i < svc->sizeZ(); ++i)
    zConnected[i] = true;
  svc->setBufferZ(&z[0], zConnected, 0);
  svc->init(0);
  svc->getY0();

  ASSERT_DOUBLE_EQUALS_DYNAWO(y[ModelSecondaryVoltageControlSimplified::UpPuNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[ModelSecondaryVoltageControlSimplified::UpPuNum_], 0.);

  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], -1);
  ASSERT_EQ(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], false);
  ASSERT_EQ(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], false);
  delete[] zConnected;
}

TEST(ModelSecondaryVoltageControlSimplified, ModelSecondaryVoltageControlSimplifiedContinuousAndDiscreteMethods) {
  boost::shared_ptr<SubModel> svc = createModelSecondaryVoltageControlSimplified(2);
  std::vector<double> y(svc->sizeY(), 0);
  std::vector<double> yp(svc->sizeY(), 0);
  svc->setBufferY(&y[0], &yp[0], 0.);
  y[ModelSecondaryVoltageControlSimplified::UpPuNum_] = 0.95;
  std::vector<double> z(svc->sizeZ(), 0);
  bool* zConnected = new bool[svc->sizeZ()];
  BitMask* silentZ = new BitMask[svc->sizeZ()];
  for (size_t i = 0; i < svc->sizeZ(); ++i)
    zConnected[i] = true;
  svc->setBufferZ(&z[0], zConnected, 0);
  std::vector<state_g> g(svc->sizeG(), NO_ROOT);
  svc->setBufferG(&g[0], 0);
  svc->init(0);
  svc->getY0();
  ASSERT_NO_THROW(svc->setFequations());
  ASSERT_NO_THROW(svc->evalG(0.));
  svc->collectSilentZ(silentZ);
  for (size_t i = 0; i < svc->sizeZ(); ++i)
    ASSERT_TRUE(silentZ[i].getFlags(NotUsedInContinuousEquations));

  double level = -1;
  double time = 0.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_DOWN);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  level = -0.625;
  time = 2.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  // Not activated
  level = -0.625;
  time = 3.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_DOWN);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  level = -0.425;
  time = 4.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  level = -0.975;
  time = 6.;
  y[ModelSecondaryVoltageControlSimplified::UpPuNum_] = 1.05;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  level = -1;
  time = 8.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);


  // UDeadBand
  y[ModelSecondaryVoltageControlSimplified::UpPuNum_] = 0.99;
  level = -1;
  time = 10.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  y[ModelSecondaryVoltageControlSimplified::UpPuNum_] = 1.01;
  level = -1;
  time = 12.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  // Wind up
  y[ModelSecondaryVoltageControlSimplified::UpPuNum_] = 4;
  level = -1;
  time = 14.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  level = -1;
  time = 16.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  y[ModelSecondaryVoltageControlSimplified::UpPuNum_] = 0.1;
  level = 1;
  time = 18.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  level = 1;
  time = 20.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  // Blocking
  y[ModelSecondaryVoltageControlSimplified::UpPuNum_] = 0.95;
  z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_] = true;
  level = -1;
  time = 22.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  level = -0.8;
  time = 24.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1] = true;
  level = -0.8;  // should be -0.6 but not possible as the SVC is blocked
  time = 26.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_UP);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], 24);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  // Blocking stops
  z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_] = false;
  level = -0.6;
  time = 28.;
  svc->evalG(time);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::ActivationNum_], ROOT_UP);
  ASSERT_EQ(g[ModelSecondaryVoltageControlSimplified::BlockingNum_], ROOT_DOWN);
  svc->evalZ(time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::UpRefPuNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::tLastActivationNum_], time);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::levelValNum_], level);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_], false);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelSecondaryVoltageControlSimplified::firstIndexBlockerNum_ + 1], true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelSecondaryVoltageControlSimplified::levelNum_), level);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->getCalculatedVar(ModelSecondaryVoltageControlSimplified::levelNum_), level);

  delete[] zConnected;
}


}  // namespace DYN
