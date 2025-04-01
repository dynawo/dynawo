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

/**
 * @file Models/CPP/ModelFrequency/ModelOmegaRef/TestOmegaRef
 * @brief Unit tests for OmegaRef model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNModelOmegaRef.h"
#include "DYNModelOmegaRef.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelOmegaRef(double weightGen2) {
  boost::shared_ptr<SubModel> modelOmegaRef = SubModelFactory::createSubModelFromLib("../DYNModelOmegaRef" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelOmegaRef->defineParameters(parameters);
  boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet->createParameter("nbGen", 2);
  parametersSet->createParameter("weight_gen_0", 2.);
  parametersSet->createParameter("weight_gen_1", weightGen2);
  parametersSet->createParameter("omegaRefMin", 0.5);
  parametersSet->createParameter("omegaRefMax", 1.5);
  modelOmegaRef->setPARParameters(parametersSet);
  modelOmegaRef->addParameters(parameters, false);
  modelOmegaRef->setParametersFromPARFile();
  modelOmegaRef->setSubModelParameters();

  modelOmegaRef->getSize();

  return modelOmegaRef;
}

TEST(ModelsModelOmegaRef, ModelOmegaRefDefineMethods) {
  boost::shared_ptr<SubModel> modelOmegaRef = SubModelFactory::createSubModelFromLib("../DYNModelOmegaRef" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelOmegaRef->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 4);

  boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet->createParameter("nbGen", 1);
  parametersSet->createParameter("weight_gen_0", 2.);
  parametersSet->createParameter("omegaRefMin", 0.95);
  parametersSet->createParameter("omegaRefMax", 1.05);
  ASSERT_NO_THROW(modelOmegaRef->setPARParameters(parametersSet));

  modelOmegaRef->addParameters(parameters, false);
  ASSERT_NO_THROW(modelOmegaRef->setParametersFromPARFile());
  ASSERT_NO_THROW(modelOmegaRef->setSubModelParameters());

  std::vector<boost::shared_ptr<Variable> > variables;
  modelOmegaRef->defineVariables(variables);
  ASSERT_EQ(variables.size(), 14);
  boost::shared_ptr<Variable> variableOmegaRef = variables[0];
  ASSERT_EQ(variableOmegaRef->getName(), "omegaRef_0_value");
  ASSERT_EQ(variableOmegaRef->getType(), CONTINUOUS);
  ASSERT_EQ(variableOmegaRef->getNegated(), false);
  ASSERT_EQ(variableOmegaRef->isState(), true);
  ASSERT_EQ(variableOmegaRef->isAlias(), false);
  boost::shared_ptr<Variable> variableOmegaGrp = variables[10];
  ASSERT_EQ(variableOmegaGrp->getName(), "omega_grp_0_value");
  ASSERT_EQ(variableOmegaGrp->getType(), CONTINUOUS);
  boost::shared_ptr<Variable> variableOmegaRefGrp = variables[11];
  ASSERT_EQ(variableOmegaRefGrp->getName(), "omegaRef_grp_0_value");
  ASSERT_EQ(variableOmegaRefGrp->getType(), CONTINUOUS);
  boost::shared_ptr<Variable> variableNumCC = variables[12];
  ASSERT_EQ(variableNumCC->getName(), "numcc_node_0_value");
  ASSERT_EQ(variableNumCC->getType(), DISCRETE);
  boost::shared_ptr<Variable> runningGrp = variables[13];
  ASSERT_EQ(runningGrp->getName(), "running_grp_0_value");
  ASSERT_EQ(runningGrp->getType(), BOOLEAN);

  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelOmegaRef->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 28);
  Element elementOmegaRef = elements[0];
  ASSERT_EQ(elementOmegaRef.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(elementOmegaRef.name(), elementOmegaRef.id());
  ASSERT_EQ(elementOmegaRef.name(), "omegaRef_0");
  ASSERT_EQ(elementOmegaRef.subElementsNum()[0], 1);
  ASSERT_EQ(mapElements["omegaRef_0"], 0);
  Element elementOmegaRefValue = elements[1];
  ASSERT_EQ(elementOmegaRefValue.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(elementOmegaRefValue.name(), "value");
  ASSERT_EQ(elementOmegaRefValue.id(), "omegaRef_0_value");
  ASSERT_EQ(elementOmegaRefValue.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["omegaRef_0_value"], 1);
  Element elementOmegaGrp = elements[20];
  ASSERT_EQ(elementOmegaGrp.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(elementOmegaGrp.name(), elementOmegaGrp.id());
  ASSERT_EQ(elementOmegaGrp.name(), "omega_grp_0");
  ASSERT_EQ(elementOmegaGrp.subElementsNum()[0], 21);
  ASSERT_EQ(mapElements["omega_grp_0"], 20);
  Element elementOmegaGrpValue = elements[21];
  ASSERT_EQ(elementOmegaGrpValue.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(elementOmegaGrpValue.name(), "value");
  ASSERT_EQ(elementOmegaGrpValue.id(), "omega_grp_0_value");
  ASSERT_EQ(elementOmegaGrpValue.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["omega_grp_0_value"], 21);
  Element elementNumCC = elements[22];
  ASSERT_EQ(elementNumCC.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(elementNumCC.name(), elementNumCC.id());
  ASSERT_EQ(elementNumCC.name(), "numcc_node_0");
  ASSERT_EQ(elementNumCC.subElementsNum()[0], 23);
  ASSERT_EQ(mapElements["numcc_node_0"], 22);
  Element elementNumCCValue = elements[23];
  ASSERT_EQ(elementNumCCValue.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(elementNumCCValue.name(), "value");
  ASSERT_EQ(elementNumCCValue.id(), "numcc_node_0_value");
  ASSERT_EQ(elementNumCCValue.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["numcc_node_0_value"], 23);
  Element elementRunningGrp = elements[24];
  ASSERT_EQ(elementRunningGrp.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(elementRunningGrp.name(), elementRunningGrp.id());
  ASSERT_EQ(elementRunningGrp.name(), "running_grp_0");
  ASSERT_EQ(elementRunningGrp.subElementsNum()[0], 25);
  ASSERT_EQ(mapElements["running_grp_0"], 24);
  Element elementRunningGrpValue = elements[25];
  ASSERT_EQ(elementRunningGrpValue.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(elementRunningGrpValue.name(), "value");
  ASSERT_EQ(elementRunningGrpValue.id(), "running_grp_0_value");
  ASSERT_EQ(elementRunningGrpValue.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["running_grp_0_value"], 25);
  Element elementOmegaRefGrp = elements[26];
  ASSERT_EQ(elementOmegaRefGrp.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(elementOmegaRefGrp.name(), elementOmegaRefGrp.id());
  ASSERT_EQ(elementOmegaRefGrp.name(), "omegaRef_grp_0");
  ASSERT_EQ(elementOmegaRefGrp.subElementsNum()[0], 27);
  ASSERT_EQ(mapElements["omegaRef_grp_0"], 26);
  Element elementOmegaRefGrpValue = elements[27];
  ASSERT_EQ(elementOmegaRefGrpValue.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(elementOmegaRefGrpValue.name(), "value");
  ASSERT_EQ(elementOmegaRefGrpValue.id(), "omegaRef_grp_0_value");
  ASSERT_EQ(elementOmegaRefGrpValue.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["omegaRef_grp_0_value"], 27);
}

TEST(ModelsModelOmegaRef, ModelOmegaRefTypeMethods) {
  boost::shared_ptr<SubModel> modelOmegaRef = initModelOmegaRef(-1);
  unsigned nbY = 13;
  unsigned nbF = 12;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  modelOmegaRef->setBufferYType(&yTypes[0], 0);
  modelOmegaRef->setBufferFType(&fTypes[0], 0);

  ASSERT_EQ(modelOmegaRef->sizeY(), nbY);
  ASSERT_EQ(modelOmegaRef->sizeF(), nbF);
  ASSERT_EQ(modelOmegaRef->sizeZ(), 4);
  ASSERT_EQ(modelOmegaRef->sizeG(), 0);
  ASSERT_EQ(modelOmegaRef->sizeMode(), 1);

  modelOmegaRef->evalStaticYType();
  modelOmegaRef->evalDynamicYType();
  propertyContinuousVar_t* yTypeGet = modelOmegaRef->getYType();
  ASSERT_EQ(yTypeGet[0], ALGEBRAIC);
  ASSERT_EQ(yTypeGet[10], EXTERNAL);
  ASSERT_EQ(yTypeGet[11], ALGEBRAIC);
  ASSERT_EQ(yTypeGet[12], ALGEBRAIC);
  ASSERT_NE(yTypeGet[9], EXTERNAL);

  modelOmegaRef->evalStaticFType();
  modelOmegaRef->evalDynamicFType();
  ASSERT_EQ(fTypes[0], ALGEBRAIC_EQ);
  ASSERT_EQ(fTypes[10], ALGEBRAIC_EQ);

  ASSERT_NO_THROW(modelOmegaRef->dumpUserReadableElementList("MyElement"));
  ASSERT_NO_THROW(modelOmegaRef->initializeFromData(boost::shared_ptr<DataInterface>()));
  std:: vector<double> res;
  std::vector<int> indexes;
  ASSERT_NO_THROW(modelOmegaRef->evalJCalculatedVarI(0, res));
  ASSERT_NO_THROW(modelOmegaRef->getIndexesOfVariablesUsedForCalculatedVarI(0, indexes));
  ASSERT_NO_THROW(modelOmegaRef->evalCalculatedVars());
  ASSERT_NO_THROW(modelOmegaRef->evalDynamicFType());
  ASSERT_NO_THROW(modelOmegaRef->evalDynamicYType());
  ASSERT_NO_THROW(modelOmegaRef->initializeStaticData());
  ASSERT_NO_THROW(modelOmegaRef->setGequations());
  ASSERT_EQ(modelOmegaRef->evalCalculatedVarI(0), 0.);

  boost::shared_ptr<SubModel> modelOmegaRef2 = SubModelFactory::createSubModelFromLib("../DYNModelOmegaRef" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelOmegaRef2->defineParameters(parameters);
  boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet->createParameter("nbGen", 11);
  parametersSet->createParameter("weight_gen_0", 2.);
  parametersSet->createParameter("weight_gen_1", 2.);
  parametersSet->createParameter("weight_gen_2", 2.);
  parametersSet->createParameter("weight_gen_3", 2.);
  parametersSet->createParameter("weight_gen_4", 2.);
  parametersSet->createParameter("weight_gen_5", 2.);
  parametersSet->createParameter("weight_gen_6", 2.);
  parametersSet->createParameter("weight_gen_7", 2.);
  parametersSet->createParameter("weight_gen_8", 2.);
  parametersSet->createParameter("weight_gen_9", 2.);
  parametersSet->createParameter("weight_gen_10", 2.);
  parametersSet->createParameter("weight_gen_11", 2.);
  modelOmegaRef2->setPARParameters(parametersSet);
  modelOmegaRef2->addParameters(parameters, false);
  modelOmegaRef2->setParametersFromPARFile();
  modelOmegaRef2->setSubModelParameters();
  modelOmegaRef2->init(0.);
  modelOmegaRef2->getSize();
  std::vector<double> y(modelOmegaRef2->sizeY(), 0);
  std::vector<double> yp(modelOmegaRef2->sizeY(), 0);
  modelOmegaRef2->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(modelOmegaRef2->sizeZ(), 0);
  bool* zConnected = new bool[modelOmegaRef2->sizeZ()];
  for (size_t i = 0; i < modelOmegaRef2->sizeZ(); ++i)
    zConnected[i] = true;
  for (size_t i = 0; i < 11; ++i)
    z[i] = static_cast<double>(i);
  for (size_t i = 11; i < modelOmegaRef2->sizeZ(); ++i)
    z[i] = 1.;
  modelOmegaRef2->setBufferZ(&z[0], zConnected, 0);
  modelOmegaRef2->evalZ(0.);

  ASSERT_THROW_DYNAWO(modelOmegaRef2->getY0(), Error::MODELER, KeyError_t::TooMuchSubNetwork);
}

TEST(ModelsModelOmegaRef, ModelOmegaRefInit) {
  boost::shared_ptr<SubModel> modelOmegaRef = initModelOmegaRef(-1);
  std::vector<double> y(modelOmegaRef->sizeY(), 0);
  std::vector<double> yp(modelOmegaRef->sizeY(), 0);
  modelOmegaRef->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(modelOmegaRef->sizeZ(), 0);
  bool* zConnected = new bool[modelOmegaRef->sizeZ()];
  for (size_t i = 0; i < modelOmegaRef->sizeZ(); ++i)
    zConnected[i] = true;
  modelOmegaRef->setBufferZ(&z[0], zConnected, 0);
  modelOmegaRef->init(0);
  modelOmegaRef->getY0();

  ASSERT_EQ(y[0], 1);  // OmegaRef0_0
  ASSERT_EQ(yp[0], 0);
  ASSERT_EQ(y[10], 1);  // weight0_gen_0
  ASSERT_EQ(yp[10], 0);
  ASSERT_EQ(y[11], 1);  // OmegaRef0_gen_0
  ASSERT_EQ(y[12], 1);  // OmegaRef0_gen_1
  ASSERT_EQ(yp[11], 0);
  ASSERT_EQ(yp[12], 0);

  ASSERT_EQ(z[0], 0);
  ASSERT_EQ(z[2], 0);
  delete[] zConnected;
}

TEST(ModelsModelOmegaRef, ModelOmegaRefContinuousAndDiscreteMethods) {
  boost::shared_ptr<SubModel> modelOmegaRef = initModelOmegaRef(1);
  std::vector<double> y(modelOmegaRef->sizeY(), 0);
  std::vector<double> yp(modelOmegaRef->sizeY(), 0);
  modelOmegaRef->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(modelOmegaRef->sizeZ(), 0);
  bool* zConnected = new bool[modelOmegaRef->sizeZ()];
  BitMask* silentZ = new BitMask[modelOmegaRef->sizeZ()];
  for (size_t i = 0; i < modelOmegaRef->sizeZ(); ++i)
    zConnected[i] = true;
  modelOmegaRef->setBufferZ(&z[0], zConnected, 0);
  z[2] = 1;
  z[3] = 1;
  std::vector<double> f(modelOmegaRef->sizeF(), 0);
  modelOmegaRef->setBufferF(&f[0], 0);
  modelOmegaRef->init(0);
  modelOmegaRef->getY0();
  ASSERT_NO_THROW(modelOmegaRef->setFequations());
  ASSERT_NO_THROW(modelOmegaRef->evalG(0.));
  modelOmegaRef->collectSilentZ(silentZ);
  for (size_t i = 0; i < modelOmegaRef->sizeZ(); ++i)
    ASSERT_TRUE(silentZ[i].getFlags(NotUsedInDiscreteEquations));

  modelOmegaRef->evalF(0, UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[10], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[11], 0);
  modelOmegaRef->evalF(0, DIFFERENTIAL_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[10], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[11], 0);
  SparseMatrix smj;
  int size = modelOmegaRef->sizeY();
  smj.init(size, size);
  modelOmegaRef->evalJt(0, 0, smj, 0);
  smj.changeCol();
  smj.changeCol();
  ASSERT_EQ(smj.nbElem(), 16);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ap_[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ap_[1], 3);  // 3 elements non-zero for numCC_0
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ap_[2], 4);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ap_[10], 12);  // omega_grp_0
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ap_[11], 14);  // 2 elements non-zero for omega_grp_0
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ai_[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ai_[1], 10);  // first index of omega
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ai_[2], 11);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ai_[12], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ai_[13], 12);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ai_[14], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ai_[15], 13);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[0], -1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[1], 0.6666666);  // first index of omega
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[2], 0.3333333);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[12], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[13], -1);

  y[10] = 2.5;  // Modifying omegaGrp_0
  modelOmegaRef->evalF(1, UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[10], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[11], 0);

  y[0] = 2;  // Modifying omegaRef_grp_0
  modelOmegaRef->evalF(1, UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[10], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[11], 1);
  SparseMatrix smjPrim;
  smjPrim.init(size, size);
  modelOmegaRef->evalJtPrim(0, 0, smjPrim, 0);
  ASSERT_EQ(smjPrim.nbElem(), 0);
  modeChangeType_t mode = modelOmegaRef->evalMode(1);
  ASSERT_EQ(mode, NO_MODE);
  ASSERT_THROW_DYNAWO(modelOmegaRef->checkDataCoherence(0), Error::MODELER, KeyError_t::FrequencyIncrease);

  z[2] = 0;  // Switching off gen1
  y[12] = 2;
  y[13] = 2;
  mode = modelOmegaRef->evalMode(2);
  ASSERT_EQ(mode, NO_MODE);
  modelOmegaRef->evalZ(2);  // Propagating the changes to internal discrete values
  mode = modelOmegaRef->evalMode(2);
  ASSERT_EQ(mode, ALGEBRAIC_J_UPDATE_MODE);
  modelOmegaRef->evalF(2, UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[10], -1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[11], 0);
  SparseMatrix smj2;
  smj2.init(size, size);
  modelOmegaRef->evalJt(2, 0, smj2, 0);
  smj2.changeCol();
  smj2.changeCol();
  ASSERT_EQ(smj2.nbElem(), 14);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ap_[9], 10);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ap_[10], 11);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ap_[11], 12);  // 1 element non-zero for omega_grp_0
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ai_[11], 12);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ai_[12], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ai_[13], 13);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[11], -1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[12], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[13], -1);

  mode = modelOmegaRef->evalMode(2);
  ASSERT_EQ(mode, NO_MODE);
  z[0] = 1;  // Changing numCC for gen1
  modelOmegaRef->evalZ(2);  // Propagating the changes to internal discrete values
  mode = modelOmegaRef->evalMode(2);
  ASSERT_EQ(mode, ALGEBRAIC_J_UPDATE_MODE);
  delete[] zConnected;

  y[0] = 1.2;  // Modifying omegaRef_grp_0
  ASSERT_NO_THROW(modelOmegaRef->checkDataCoherence(0));

  y[0] = 0.4;  // Modifying omegaRef_grp_0
  ASSERT_THROW_DYNAWO(modelOmegaRef->checkDataCoherence(0), Error::MODELER, KeyError_t::FrequencyCollapse);
}

}  // namespace DYN
