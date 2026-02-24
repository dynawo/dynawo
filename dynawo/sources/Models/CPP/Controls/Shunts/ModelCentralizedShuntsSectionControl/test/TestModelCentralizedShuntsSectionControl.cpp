//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file Models/CPP/Controls/Shunts/ModelCentralizedShuntsSectionControl/test/TestCentralizedShuntsSectionControl.cpp
 * @brief Unit tests for CentralizedShuntsSectionControl model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNModelCentralizedShuntsSectionControl.h"
#include "DYNModelCentralizedShuntsSectionControl.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelShunt(int nbShunts, int section0 = 0, bool isSelf = false) {
  boost::shared_ptr<SubModel> modelShunt =
  SubModelFactory::createSubModelFromLib("../DYNModelCentralizedShuntsSectionControl" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelShunt->defineParameters(parameters);
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter("nbShunts", nbShunts);
  parametersSet->createParameter("tNext", 10.);
  parametersSet->createParameter("URef0Pu", 0.95);
  for (int s = 0; s < nbShunts; ++s) {
    std::stringstream section0Name;
    section0Name << "section0_" << s;
    parametersSet->createParameter(section0Name.str(), section0);
    std::stringstream SectionMinName;
    SectionMinName << "sectionMin_" << s;
    parametersSet->createParameter(SectionMinName.str(), 0);
    std::stringstream SectionMaxName;
    SectionMaxName << "sectionMax_" << s;
    parametersSet->createParameter(SectionMaxName.str(), 2);
    std::stringstream DeadbandUPuName;
    DeadbandUPuName << "deadBandUPu_" << s;
    parametersSet->createParameter(DeadbandUPuName.str(), 0.1);
    std::stringstream isSelfName;
    isSelfName << "isSelf_" << s;
    parametersSet->createParameter(isSelfName.str(), isSelf);
  }
  modelShunt->setPARParameters(parametersSet);
  modelShunt->addParameters(parameters, false);
  modelShunt->setParametersFromPARFile();
  modelShunt->setSubModelParameters();

  modelShunt->getSize();

  return modelShunt;
}

TEST(ModelsCentralizedShuntsSectionControl, ModelCentralizedShuntsSectionControlDefineMethods) {
  boost::shared_ptr<SubModel> modelShunt =
  SubModelFactory::createSubModelFromLib("../DYNModelCentralizedShuntsSectionControl" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelShunt->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 8);
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter("nbShunts", 1);
  parametersSet->createParameter("section0_0", 0);
  parametersSet->createParameter("sectionMin_0", 0);
  parametersSet->createParameter("sectionMax_0", 2);
  parametersSet->createParameter("isSelf_0", false);
  parametersSet->createParameter("deadBandUPu_0", 0.1);
  parametersSet->createParameter("URef0Pu", 0.95);
  parametersSet->createParameter("tNext", 10.);
  ASSERT_NO_THROW(modelShunt->setPARParameters(parametersSet));
  modelShunt->addParameters(parameters, false);
  ASSERT_NO_THROW(modelShunt->setParametersFromPARFile());
  ASSERT_NO_THROW(modelShunt->setSubModelParameters());
  std::vector<boost::shared_ptr<Variable> > variables;
  modelShunt->defineVariables(variables);
  ASSERT_EQ(variables.size(), 4);
  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelShunt->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 8);

  boost::shared_ptr<SubModel> modelShunt_missingPar =
  SubModelFactory::createSubModelFromLib("../DYNModelCentralizedShuntsSectionControl" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters_missingPar;
  modelShunt_missingPar->defineParameters(parameters_missingPar);

  std::shared_ptr<parameters::ParametersSet> parametersSet_missingPar = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet_missingPar->createParameter("nbShunts", 1);
  ASSERT_NO_THROW(modelShunt_missingPar->setPARParameters(parametersSet_missingPar));
  modelShunt_missingPar->addParameters(parameters_missingPar, false);
  ASSERT_NO_THROW(modelShunt_missingPar->setParametersFromPARFile());
  ASSERT_THROW_DYNAWO(modelShunt_missingPar->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  }

  TEST(ModelsCentralizedShuntsSectionControl, ModelCentralizedShuntsSectionControlTypeMethods) {
    int nbShunts = 2;
    boost::shared_ptr<SubModel> modelShunt = initModelShunt(nbShunts);
    unsigned nbY = 1;
    unsigned nbF = 0;
    unsigned nbZ = 2*nbShunts + 1;
    unsigned nbG = 4;
    unsigned nbMode = 0;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    modelShunt->setBufferYType(&yTypes[0], 0);
    ASSERT_EQ(modelShunt->sizeY(), nbY);
    ASSERT_EQ(modelShunt->sizeF(), nbF);
    ASSERT_EQ(modelShunt->sizeZ(), nbZ);
    ASSERT_EQ(modelShunt->sizeG(), nbG);
    ASSERT_EQ(modelShunt->sizeMode(), nbMode);
    ASSERT_NO_THROW(modelShunt->evalStaticYType());
    ASSERT_EQ(yTypes[0], EXTERNAL);
    ASSERT_NO_THROW(modelShunt->initializeFromData(boost::shared_ptr<DataInterface>()));
    ASSERT_NO_THROW(modelShunt->checkDataCoherence(0.));
    ASSERT_NO_THROW(modelShunt->initializeStaticData());
    ASSERT_NO_THROW(modelShunt->evalStaticFType());
    ASSERT_NO_THROW(modelShunt->evalDynamicFType());
    ASSERT_NO_THROW(modelShunt->evalDynamicYType());
  }
  TEST(ModelsCentralizedShuntsSectionControl, ModelCentralizedShuntsSectionControlInit) {
    int nbShunts = 2;
    boost::shared_ptr<SubModel> modelShunt = initModelShunt(nbShunts);
    std::vector<double> y(modelShunt->sizeY(), 0);
    std::vector<double> yp(modelShunt->sizeY(), 0);
    modelShunt->setBufferY(&y[0], &yp[0], 0.);
    std::vector<double> z(modelShunt->sizeZ(), 0);
    bool* zConnected = new bool[modelShunt->sizeZ()];
    modelShunt->setBufferZ(&z[0], zConnected, 0);
    ASSERT_NO_THROW(modelShunt->init(0));
    ASSERT_NO_THROW(modelShunt->getY0());
    ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 0.95);
    ASSERT_DOUBLE_EQUALS_DYNAWO(z[1], 0.);
    ASSERT_DOUBLE_EQUALS_DYNAWO(z[2], 0.);
  }

  TEST(ModelsCentralizedShuntsSectionControl, ModelCentralizedShuntsSectionControlContinuousAndDiscreteMethods) {
    // isSelf = false
    int nbShunts = 2;
    boost::shared_ptr<SubModel> modelShuntCond = initModelShunt(nbShunts, 1);
    std::vector<double> y(modelShuntCond->sizeY(), 0);
    std::vector<double> yp(modelShuntCond->sizeY(), 0);
    modelShuntCond->setBufferY(&y[0], &yp[0], 0.);
    std::vector<double> z(modelShuntCond->sizeZ(), 0);
    bool* zConnected = new bool[modelShuntCond->sizeZ()];
    for (size_t i = 0; i < modelShuntCond->sizeZ(); ++i)
      zConnected[i] = true;
    modelShuntCond->setBufferZ(&z[0], zConnected, 0);
    BitMask* silentZ = new BitMask[modelShuntCond->sizeZ()];
    ASSERT_NO_THROW(modelShuntCond->init(0));
    ASSERT_NO_THROW(modelShuntCond->getY0());
    ASSERT_NO_THROW(modelShuntCond->setFequations());
    ASSERT_NO_THROW(modelShuntCond->collectSilentZ(silentZ));
    ASSERT_NO_THROW(modelShuntCond->evalF(0, UNDEFINED_EQ));
    SparseMatrix smj;
    ASSERT_NO_THROW(modelShuntCond->evalJt(0, 0, 0, smj));
    ASSERT_NO_THROW(modelShuntCond->evalJtPrim(0, 0,  0, smj));
    ASSERT_NO_THROW(modelShuntCond->evalMode(0));
    ASSERT_NO_THROW(modelShuntCond->evalCalculatedVarI(0));
    std::vector<int> indexes;
    ASSERT_NO_THROW(modelShuntCond->getIndexesOfVariablesUsedForCalculatedVarI(0, indexes));
    std::vector<double> res;
    ASSERT_NO_THROW(modelShuntCond->evalJCalculatedVarI(0, res));
    ASSERT_NO_THROW(modelShuntCond->evalCalculatedVars());
    std::vector<state_g> g(modelShuntCond->sizeG(), ROOT_DOWN);
    modelShuntCond->setBufferG(&g[0], 0);
    ASSERT_NO_THROW(modelShuntCond->setGequations());
    // UMonitored < URef
    y[0] = 0.8;
    ASSERT_NO_THROW(modelShuntCond->evalG(0));
    ASSERT_EQ(g[0], ROOT_UP);
    ASSERT_EQ(g[1], ROOT_DOWN);
    ASSERT_EQ(g[2], ROOT_DOWN);
    ASSERT_EQ(g[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntCond->evalZ(0));
    ASSERT_NO_THROW(modelShuntCond->evalZ(5));
    ASSERT_NO_THROW(modelShuntCond->evalG(5));
    ASSERT_EQ(g[0], ROOT_UP);
    ASSERT_EQ(g[1], ROOT_DOWN);
    ASSERT_EQ(g[2], ROOT_DOWN);
    ASSERT_EQ(g[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntCond->evalG(10));
    ASSERT_EQ(g[0], ROOT_UP);
    ASSERT_EQ(g[1], ROOT_DOWN);
    ASSERT_EQ(g[2], ROOT_UP);
    ASSERT_EQ(g[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntCond->evalZ(10));
    ASSERT_EQ(z[1], 2);
    ASSERT_EQ(z[2], 1);
    // UMonitored = URef
    modelShuntCond->getY0();
    y[0] = 0.95;
    ASSERT_NO_THROW(modelShuntCond->evalG(0));
    ASSERT_EQ(g[0], ROOT_DOWN);
    ASSERT_EQ(g[1], ROOT_DOWN);
    ASSERT_EQ(g[2], ROOT_DOWN);
    ASSERT_EQ(g[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntCond->evalZ(5));
    ASSERT_NO_THROW(modelShuntCond->evalG(5));
    ASSERT_EQ(g[0], ROOT_DOWN);
    ASSERT_EQ(g[1], ROOT_DOWN);
    ASSERT_EQ(g[2], ROOT_DOWN);
    ASSERT_EQ(g[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntCond->evalG(10));
    ASSERT_EQ(g[0], ROOT_DOWN);
    ASSERT_EQ(g[1], ROOT_DOWN);
    ASSERT_EQ(g[2], ROOT_DOWN);
    ASSERT_EQ(g[3], ROOT_DOWN);
    // Umonitored > Uref
    y[0] = 1.1;
    modelShuntCond->getY0();
    ASSERT_NO_THROW(modelShuntCond->evalG(0));
    ASSERT_EQ(g[0], ROOT_DOWN);
    ASSERT_EQ(g[1], ROOT_UP);
    ASSERT_EQ(g[2], ROOT_DOWN);
    ASSERT_EQ(g[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntCond->evalZ(0));
    ASSERT_NO_THROW(modelShuntCond->evalZ(5));
    ASSERT_NO_THROW(modelShuntCond->evalG(5));
    ASSERT_EQ(g[0], ROOT_DOWN);
    ASSERT_EQ(g[1], ROOT_UP);
    ASSERT_EQ(g[2], ROOT_DOWN);
    ASSERT_EQ(g[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntCond->evalG(10));
    ASSERT_EQ(g[0], ROOT_DOWN);
    ASSERT_EQ(g[1], ROOT_UP);
    ASSERT_EQ(g[2], ROOT_DOWN);
    ASSERT_EQ(g[3], ROOT_UP);
    ASSERT_NO_THROW(modelShuntCond->evalZ(20));
    ASSERT_EQ(z[1], 1);
    ASSERT_EQ(z[2], 1);

    // isSelf = true
    boost::shared_ptr<SubModel> modelShuntSelf = initModelShunt(1, 1, true);
    std::vector<double> ySelf(modelShuntSelf->sizeY(), 0);
    std::vector<double> ypSelf(modelShuntSelf->sizeY(), 0);
    modelShuntSelf->setBufferY(&ySelf[0], &ypSelf[0], 0.);
    std::vector<double> zSelf(modelShuntSelf->sizeZ(), 0);
    bool* zConnectedSelf = new bool[modelShuntSelf->sizeZ()];
    for (size_t i = 0; i < modelShuntSelf->sizeZ(); ++i)
      zConnectedSelf[i] = true;
    modelShuntSelf->setBufferZ(&zSelf[0], zConnectedSelf, 0);
    ASSERT_NO_THROW(modelShuntSelf->getY0());
    std::vector<state_g> gSelf(modelShuntSelf->sizeG(), ROOT_DOWN);
    modelShuntSelf->setBufferG(&gSelf[0], 0);
    ASSERT_NO_THROW(modelShuntSelf->setGequations());
    // UMonitored < URef
    ySelf[0] = 0.8;
    ASSERT_NO_THROW(modelShuntSelf->evalG(0));
    ASSERT_EQ(gSelf[0], ROOT_UP);
    ASSERT_EQ(gSelf[1], ROOT_DOWN);
    ASSERT_EQ(gSelf[2], ROOT_DOWN);
    ASSERT_EQ(gSelf[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntSelf->evalZ(0));
    ASSERT_NO_THROW(modelShuntCond->evalZ(5));
    ASSERT_NO_THROW(modelShuntCond->evalG(5));
    ASSERT_EQ(gSelf[0], ROOT_UP);
    ASSERT_EQ(gSelf[1], ROOT_DOWN);
    ASSERT_EQ(gSelf[2], ROOT_DOWN);
    ASSERT_EQ(gSelf[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntSelf->evalG(10));
    ASSERT_EQ(gSelf[0], ROOT_UP);
    ASSERT_EQ(gSelf[1], ROOT_DOWN);
    ASSERT_EQ(gSelf[2], ROOT_UP);
    ASSERT_EQ(gSelf[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntSelf->evalZ(10));
    ASSERT_EQ(zSelf[1], 0);
    // UMonitored = URef
    modelShuntSelf->getY0();
    ySelf[0] = 0.95;
    ASSERT_NO_THROW(modelShuntSelf->evalG(0));
    ASSERT_EQ(gSelf[0], ROOT_DOWN);
    ASSERT_EQ(gSelf[1], ROOT_DOWN);
    ASSERT_EQ(gSelf[2], ROOT_DOWN);
    ASSERT_EQ(gSelf[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntCond->evalZ(5));
    ASSERT_NO_THROW(modelShuntCond->evalG(5));
    ASSERT_EQ(gSelf[0], ROOT_DOWN);
    ASSERT_EQ(gSelf[1], ROOT_DOWN);
    ASSERT_EQ(gSelf[2], ROOT_DOWN);
    ASSERT_EQ(gSelf[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntCond->evalG(10));
    ASSERT_EQ(gSelf[0], ROOT_DOWN);
    ASSERT_EQ(gSelf[1], ROOT_DOWN);
    ASSERT_EQ(gSelf[2], ROOT_DOWN);
    ASSERT_EQ(gSelf[3], ROOT_DOWN);
    // Umonitored > Uref
    ySelf[0] = 1.1;
    modelShuntSelf->getY0();
    ASSERT_NO_THROW(modelShuntSelf->evalG(0));
    ASSERT_EQ(gSelf[0], ROOT_DOWN);
    ASSERT_EQ(gSelf[1], ROOT_UP);
    ASSERT_EQ(gSelf[2], ROOT_DOWN);
    ASSERT_EQ(gSelf[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntSelf->evalZ(0));
    ASSERT_NO_THROW(modelShuntCond->evalZ(5));
    ASSERT_NO_THROW(modelShuntCond->evalG(5));
    ASSERT_EQ(gSelf[0], ROOT_DOWN);
    ASSERT_EQ(gSelf[1], ROOT_UP);
    ASSERT_EQ(gSelf[2], ROOT_DOWN);
    ASSERT_EQ(gSelf[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntSelf->evalG(10));
    ASSERT_EQ(gSelf[0], ROOT_DOWN);
    ASSERT_EQ(gSelf[1], ROOT_UP);
    ASSERT_EQ(gSelf[2], ROOT_DOWN);
    ASSERT_EQ(gSelf[3], ROOT_UP);
    ASSERT_NO_THROW(modelShuntSelf->evalZ(20));
    ASSERT_EQ(zSelf[1], 1);
  }



  TEST(ModelsCentralizedShuntsSectionControl, ModelCentralizedShuntsSectionControlContinuousAndDiscreteMethodsDisabledShunt) {
    // isSelf = false
    int nbShunts = 2;
    boost::shared_ptr<SubModel> modelShuntCond = initModelShunt(nbShunts, 1);
    std::vector<double> y(modelShuntCond->sizeY(), 0);
    std::vector<double> yp(modelShuntCond->sizeY(), 0);
    modelShuntCond->setBufferY(&y[0], &yp[0], 0.);
    std::vector<double> z(modelShuntCond->sizeZ(), 0);
    bool* zConnected = new bool[modelShuntCond->sizeZ()];
    for (size_t i = 0; i < modelShuntCond->sizeZ(); ++i)
      zConnected[i] = true;
    modelShuntCond->setBufferZ(&z[0], zConnected, 0);
    BitMask* silentZ = new BitMask[modelShuntCond->sizeZ()];
    ASSERT_NO_THROW(modelShuntCond->init(0));
    ASSERT_NO_THROW(modelShuntCond->getY0());
    ASSERT_NO_THROW(modelShuntCond->setFequations());
    ASSERT_NO_THROW(modelShuntCond->collectSilentZ(silentZ));
    ASSERT_NO_THROW(modelShuntCond->evalF(0, UNDEFINED_EQ));
    SparseMatrix smj;
    ASSERT_NO_THROW(modelShuntCond->evalJt(0, 0, 0, smj));
    ASSERT_NO_THROW(modelShuntCond->evalJtPrim(0, 0, 0, smj));
    ASSERT_NO_THROW(modelShuntCond->evalMode(0));
    ASSERT_NO_THROW(modelShuntCond->evalCalculatedVarI(0));
    std::vector<int> indexes;
    ASSERT_NO_THROW(modelShuntCond->getIndexesOfVariablesUsedForCalculatedVarI(0, indexes));
    std::vector<double> res;
    ASSERT_NO_THROW(modelShuntCond->evalJCalculatedVarI(0, res));
    ASSERT_NO_THROW(modelShuntCond->evalCalculatedVars());
    std::vector<state_g> g(modelShuntCond->sizeG(), ROOT_DOWN);
    modelShuntCond->setBufferG(&g[0], 0);
    ASSERT_NO_THROW(modelShuntCond->setGequations());

    // Disable a shunt
    z[3] = -1;

    // UMonitored < URef
    y[0] = 0.8;
    ASSERT_NO_THROW(modelShuntCond->evalG(0));
    ASSERT_EQ(g[0], ROOT_UP);
    ASSERT_EQ(g[1], ROOT_DOWN);
    ASSERT_EQ(g[2], ROOT_DOWN);
    ASSERT_EQ(g[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntCond->evalZ(0));
    ASSERT_NO_THROW(modelShuntCond->evalZ(5));
    ASSERT_NO_THROW(modelShuntCond->evalG(5));
    ASSERT_EQ(g[0], ROOT_UP);
    ASSERT_EQ(g[1], ROOT_DOWN);
    ASSERT_EQ(g[2], ROOT_DOWN);
    ASSERT_EQ(g[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntCond->evalG(10));
    ASSERT_EQ(g[0], ROOT_UP);
    ASSERT_EQ(g[1], ROOT_DOWN);
    ASSERT_EQ(g[2], ROOT_UP);
    ASSERT_EQ(g[3], ROOT_DOWN);
    ASSERT_NO_THROW(modelShuntCond->evalZ(10));
    ASSERT_EQ(z[1], 1);
    ASSERT_EQ(z[2], 2);
  }
}  // namespace DYN
