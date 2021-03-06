//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
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
 * @file Models/CPP/ModelLoadRestorativeWithLimits/TestLoadRestorativeWithLimits.cpp
 * @brief Unit tests for ModelLoadRestorativeWithLimits model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNModelLoadRestorativeWithLimits.h"
#include "DYNModelLoadRestorativeWithLimits.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"

#include "gtest_dynawo.h"

namespace DYN {

boost::shared_ptr<SubModel> initModelLoad(double u0Pu) {
  boost::shared_ptr<SubModel> modelLoad =
  SubModelFactory::createSubModelFromLib("../DYNModelLoadRestorativeWithLimits" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelLoad->defineParameters(parameters);
  boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet->createParameter("load_U0Pu", u0Pu);
  parametersSet->createParameter("load_tFilter", 10.);
  parametersSet->createParameter("load_Alpha", 1.5);
  parametersSet->createParameter("load_Beta", 2.5);
  parametersSet->createParameter("load_UDeadBandPu", 0.01);
  parametersSet->createParameter("load_UMax0Pu", 1.15);
  parametersSet->createParameter("load_UMin0Pu", 0.85);
  parametersSet->createParameter("load_P0Pu", 1.);
  parametersSet->createParameter("load_Q0Pu", 1.);
  parametersSet->createParameter("load_UPhase0", 0.);
  modelLoad->setPARParameters(parametersSet);
  modelLoad->addParameters(parameters, false);
  modelLoad->setParametersFromPARFile();
  modelLoad->setSubModelParameters();

  modelLoad->getSize();

  return modelLoad;
}

TEST(ModelsLoadRestorativeWithLimits, ModelLoadRestorativeWithLimitsNDefineMethods) {
  boost::shared_ptr<SubModel> modelLoad =
  SubModelFactory::createSubModelFromLib("../DYNModelLoadRestorativeWithLimits" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelLoad->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 10);

  boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet->createParameter("load_U0Pu", 1.);
  parametersSet->createParameter("load_tFilter", 10.);
  parametersSet->createParameter("load_Alpha", 1.5);
  parametersSet->createParameter("load_Beta", 2.5);
  parametersSet->createParameter("load_UDeadBandPu", 0.01);
  parametersSet->createParameter("load_UMax0Pu", 1.15);
  parametersSet->createParameter("load_UMin0Pu", 0.85);
  parametersSet->createParameter("load_P0Pu", 1.);
  parametersSet->createParameter("load_Q0Pu", 1.);
  parametersSet->createParameter("load_UPhase0", 0.);
  ASSERT_NO_THROW(modelLoad->setPARParameters(parametersSet));
  modelLoad->addParameters(parameters, false);
  ASSERT_NO_THROW(modelLoad->setParametersFromPARFile());
  ASSERT_NO_THROW(modelLoad->setSubModelParameters());
  std::vector<boost::shared_ptr<Variable> > variables;
  modelLoad->defineVariables(variables);
  ASSERT_EQ(variables.size(), 11);
  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelLoad->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 22);

  boost::shared_ptr<SubModel> modelLoad2 = initModelLoad(0.85);
  boost::shared_ptr<SubModel> modelLoad3 = initModelLoad(1.15);


  boost::shared_ptr<SubModel> modelLoad_missingPar =
  SubModelFactory::createSubModelFromLib("../DYNModelLoadRestorativeWithLimits" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters_missingPar;
  modelLoad_missingPar->defineParameters(parameters_missingPar);

  boost::shared_ptr<parameters::ParametersSet> parametersSet_missingPar =
  boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet_missingPar->createParameter("load_U0Pu", 1.);
  ASSERT_NO_THROW(modelLoad_missingPar->setPARParameters(parametersSet_missingPar));
  modelLoad_missingPar->addParameters(parameters_missingPar, false);
  ASSERT_NO_THROW(modelLoad_missingPar->setParametersFromPARFile());
  ASSERT_THROW_DYNAWO(modelLoad_missingPar->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
}

TEST(ModelsLoadRestorativeWithLimits, ModelLoadRestorativeWithLimitsTypeMethods) {
  boost::shared_ptr<SubModel> modelLoad = initModelLoad(1.0);
  unsigned nbY = 8;
  unsigned nbF = 6;
  unsigned nbZ = 2;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  modelLoad->setBufferYType(&yTypes[0], 0);
  modelLoad->setBufferFType(&fTypes[0], 0);

  ASSERT_EQ(modelLoad->sizeY(), nbY);
  ASSERT_EQ(modelLoad->sizeF(), nbF);
  ASSERT_EQ(modelLoad->sizeZ(), nbZ);
  ASSERT_EQ(modelLoad->sizeG(), 2);
  ASSERT_EQ(modelLoad->sizeMode(), 2);

  modelLoad->evalYType();

  modelLoad->evalFType();
  ASSERT_NO_THROW(modelLoad->initializeFromData(boost::shared_ptr<DataInterface>()));
  std:: vector<double> res;
  std::vector<int> indexes;
  ASSERT_NO_THROW(modelLoad->evalJCalculatedVarI(0, res));
  ASSERT_NO_THROW(modelLoad->getIndexesOfVariablesUsedForCalculatedVarI(0, indexes));
  ASSERT_NO_THROW(modelLoad->evalCalculatedVars());
  ASSERT_NO_THROW(modelLoad->updateFType());
  ASSERT_NO_THROW(modelLoad->updateYType());
  ASSERT_NO_THROW(modelLoad->initializeStaticData());
}

TEST(ModelsLoadRestorativeWithLimits, ModelLoadRestorativeWithLimitsInit) {
  boost::shared_ptr<SubModel> modelLoad = initModelLoad(1.0);
  std::vector<double> y(modelLoad->sizeY(), 0);
  std::vector<double> yp(modelLoad->sizeY(), 0);
  modelLoad->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(modelLoad->sizeZ(), 0);
  bool* zConnected = new bool[modelLoad->sizeZ()];
  for (size_t i = 0; i < modelLoad->sizeZ(); ++i)
    zConnected[i] = true;
  modelLoad->setBufferZ(&z[0], zConnected, 0);
  modelLoad->init(0);
  modelLoad->getY0();

  ASSERT_EQ(y[0], 1);
  ASSERT_EQ(yp[0], 0);
  ASSERT_EQ(y[1], 1);
  ASSERT_EQ(yp[1], 0);
  ASSERT_EQ(y[2], 0);
  ASSERT_EQ(yp[2], 0);
  ASSERT_EQ(y[3], 0);
  ASSERT_EQ(yp[3], 0);
  ASSERT_EQ(y[4], 1);
  ASSERT_EQ(yp[4], 0);
  ASSERT_EQ(y[5], -1);
  ASSERT_EQ(yp[5], 0);
  ASSERT_EQ(y[6], 1);
  ASSERT_EQ(yp[6], 0);
  ASSERT_EQ(y[7], 1);
  ASSERT_EQ(yp[7], 0);
  ASSERT_EQ(z[0], 0);
  ASSERT_EQ(z[1], 0);
  delete[] zConnected;

  boost::shared_ptr<SubModel> modelLoad2 = initModelLoad(1.0);
  modelLoad2->setIsInitProcess(true);
  modelLoad2->getSize();
}

TEST(ModelsLoadRestorativeWithLimits, ModelLoadRestorativeWithLimitsContinuousAndDiscreteMethods) {
  boost::shared_ptr<SubModel> modelLoad = initModelLoad(1.0);
  std::vector<double> y(modelLoad->sizeY(), 0);
  std::vector<double> yp(modelLoad->sizeY(), 0);
  modelLoad->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(modelLoad->sizeZ(), 0);
  bool* zConnected = new bool[modelLoad->sizeZ()];
  for (size_t i = 0; i < modelLoad->sizeZ(); ++i)
    zConnected[i] = true;
  modelLoad->setBufferZ(&z[0], zConnected, 0);
  BitMask* silentZ = new BitMask[modelLoad->sizeZ()];
  z[0] = 0;
  z[1] = 0;
  std::vector<double> f(modelLoad->sizeF(), 0);
  modelLoad->setBufferF(&f[0], 0);
  modelLoad->init(0);
  modelLoad->getY0();
  ASSERT_NO_THROW(modelLoad->setFequations());
  std::vector<state_g> g(modelLoad->sizeG(), ROOT_DOWN);
  modelLoad->setBufferG(&g[0], 0);
  ASSERT_NO_THROW(modelLoad->evalG(0.));
  ASSERT_NO_THROW(modelLoad->setGequations());
  ASSERT_NO_THROW(modelLoad->evalMode(0.));
  modelLoad->collectSilentZ(silentZ);
  for (size_t i = 0; i < modelLoad->sizeZ(); ++i)
    ASSERT_FALSE(silentZ[i].getFlags(NotUsedInDiscreteEquations));
  ASSERT_NO_THROW(modelLoad->evalZ(0));
  ASSERT_NO_THROW(modelLoad->evalF(0, UNDEFINED_EQ));
  ASSERT_NO_THROW(modelLoad->evalF(0, DIFFERENTIAL_EQ));
  ASSERT_NO_THROW(modelLoad->evalF(0, ALGEBRAIC_EQ));


  SparseMatrix smj;
  int size = modelLoad->sizeY();
  smj.init(size, size);
  ASSERT_NO_THROW(modelLoad->evalJt(0, 0, smj, 0));
  SparseMatrix smjPrim;
  smjPrim.init(size, size);
  ASSERT_NO_THROW(modelLoad->evalJtPrim(0, 0, smjPrim, 0));
  ASSERT_NO_THROW(modelLoad->evalCalculatedVarI(0));
  ASSERT_THROW_DYNAWO(modelLoad->evalCalculatedVarI(1), Error::MODELER, KeyError_t::UndefCalculatedVarI);
  z[0] = 1;
  z[1] = 0;
  ASSERT_NO_THROW(modelLoad->evalZ(1));
  z[0] = 0;
  z[1] = 1;
  ASSERT_NO_THROW(modelLoad->evalZ(1));
  ASSERT_NO_THROW(modelLoad->evalMode(1));
  ASSERT_NO_THROW(modelLoad->evalF(0, UNDEFINED_EQ));
  SparseMatrix smj2;
  smj2.init(size, size);
  ASSERT_NO_THROW(modelLoad->evalJt(1, 0, smj2, 0));
  SparseMatrix smjPrim2;
  smjPrim2.init(size, size);
  ASSERT_NO_THROW(modelLoad->evalJtPrim(0, 0, smjPrim2, 0));

  g[0] = ROOT_UP;
  ASSERT_NO_THROW(modelLoad->evalZ(0));
  ASSERT_NO_THROW(modelLoad->evalMode(0));
  ASSERT_NO_THROW(modelLoad->setGequations());
  ASSERT_NO_THROW(modelLoad->evalF(0, ALGEBRAIC_EQ));
  g[0] = ROOT_DOWN;
  g[1] = ROOT_UP;
  ASSERT_NO_THROW(modelLoad->evalZ(0));
  ASSERT_NO_THROW(modelLoad->evalMode(0));
  ASSERT_NO_THROW(modelLoad->setGequations());
  ASSERT_NO_THROW(modelLoad->evalF(1, ALGEBRAIC_EQ));

  y[1] = 0;
  ASSERT_THROW_DYNAWO(modelLoad->evalF(0, ALGEBRAIC_EQ), Error::NUMERICAL_ERROR, KeyError_t::NumericalErrorFunction);
}

}  // namespace DYN
