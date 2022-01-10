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
 * @file Models/CPP/Controls/Voltage/ModelMinMaxMean/test/TestMinMaxMean.cpp
 * @brief Unit tests for MinMaxMean model
 *
 */
#include <boost/shared_ptr.hpp>

#include "DYNModelMinMaxMean.h"
#include "DYNModelMinMaxMean.hpp"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelMinMaxMean(unsigned int nbVoltages_ = 0) {
    boost::shared_ptr<SubModel> mmm =
        SubModelFactory::createSubModelFromLib("../DYNModelMinMaxMean" + std::string(sharedLibraryExtension()));
    std::vector<ParameterModeler> parameters;
    mmm->defineParameters(parameters);
    // 5 fake connections
    boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
    parametersSet->createParameter("nbInputs", static_cast<int>(nbVoltages_));
    mmm->setPARParameters(parametersSet);
    mmm->addParameters(parameters, false);  // Might be true here.
    mmm->setParametersFromPARFile();
    mmm->setSubModelParameters();
    mmm->getSize();  // Sets all the sizes
    mmm->init(0.);  // Harmless coverage
    return mmm;
}

TEST(ModelsMinMaxMean, ModelsMinMaxMeanDefineMethods) {
    boost::shared_ptr<SubModel> mmm = initModelMinMaxMean(0);
    ASSERT_NE(mmm, nullptr);
    std::vector<boost::shared_ptr<Variable> > variables;
    mmm->defineVariables(variables);
    ASSERT_EQ(variables.size(), std::size_t(0));
    std::vector<ParameterModeler> parameters;
    mmm->defineParameters(parameters);
    ASSERT_EQ(parameters.size(), std::size_t(1));

    // Harmless coverage
    SparseMatrix mat;
    std::vector<double> resd;
    std::vector<int> resi;
    ASSERT_NO_THROW(mmm->evalF(0, UNDEFINED_EQ));
    ASSERT_NO_THROW(mmm->evalG(0));
    ASSERT_NO_THROW(mmm->evalZ(0));
    ASSERT_NO_THROW(mmm->evalJt(0, 0, mat, 0));
    ASSERT_NO_THROW(mmm->evalJtPrim(0, 0, mat, 0));
    ASSERT_NO_THROW(mmm->collectSilentZ(nullptr));
    ASSERT_NO_THROW(mmm->evalMode(0));
    ASSERT_NO_THROW(mmm->evalJCalculatedVarI(0, resd));
    ASSERT_NO_THROW(mmm->getIndexesOfVariablesUsedForCalculatedVarI(0, resi));
    // ASSERT_THROW_DYNAWO(mmm->evalCalculatedVarI(999), DYN::Error::MODELER);
}

TEST(ModelsMinMaxMean, ModelsMinMaxMeanEmptyInput) {
    boost::shared_ptr<SubModel> mmm = initModelMinMaxMean();
    std::vector<double> ySelf(mmm->sizeY(), 0);
    mmm->setBufferY(&ySelf[0], nullptr, 0);
    std::vector<double> z(mmm->sizeZ(), 0.);
    bool* zConnected = new bool[mmm->sizeZ()];
    for (std::size_t i=0; i < mmm->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    mmm->setBufferZ(&z[0], zConnected, 0);

    // Run computation of min, max and mean on empty input stream
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::minValIdx_), MAXFLOAT);
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::maxValIdx_), -MAXFLOAT);
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::avgValIdx_), 0.0);
}

TEST(ModelsMinMaxMean, ModelsMinMaxMeanSimpleInput) {
    unsigned int nbVoltages = 25;
    boost::shared_ptr<SubModel> mmm = initModelMinMaxMean(nbVoltages);
    ASSERT_EQ(mmm->sizeY(), nbVoltages);
    ASSERT_EQ(mmm->sizeZ(), nbVoltages);

    std::vector<boost::shared_ptr<Variable> > variables;
    mmm->defineVariables(variables);
    ASSERT_EQ(variables.size(), mmm->sizeY() + mmm->sizeZ());

    unsigned nbY = nbVoltages;
    unsigned nbF = 0;
    unsigned nbZ = nbVoltages;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    mmm->setBufferYType(&yTypes[0], 0);
    ASSERT_NO_THROW(mmm->evalStaticYType());
    ASSERT_EQ(mmm->sizeY(), nbY);
    ASSERT_EQ(mmm->sizeF(), nbF);
    ASSERT_EQ(mmm->sizeZ(), nbZ);
    ASSERT_EQ(mmm->sizeG(), 0);
    ASSERT_EQ(mmm->sizeMode(), 1);

    mmm->evalStaticYType();
    ASSERT_EQ(yTypes[0], DYN::EXTERNAL);
    mmm->evalStaticFType();  // Does nothing here.
    ASSERT_NO_THROW(mmm->initializeFromData(boost::shared_ptr<DataInterface>()));

    // The following is needed to check data coherence (otherwise no data has been set!)
    std::vector<double> voltages(mmm->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = i + 1;
    }
    std::vector<double> z(mmm->sizeZ(), 1.);
    bool* zConnected = new bool[mmm->sizeZ()];
    for (std::size_t i=0; i < mmm->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    mmm->setBufferZ(&z[0], zConnected, 0);
    mmm->setBufferY(&voltages[0], nullptr, 0);
    mmm->evalCalculatedVars();
    ASSERT_NO_THROW(mmm->initializeStaticData());
    ASSERT_NO_THROW(mmm->evalDynamicFType());
    ASSERT_NO_THROW(mmm->evalDynamicYType());

    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::minValIdx_), 1.0);
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::maxValIdx_), nbVoltages);
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::avgValIdx_), nbVoltages * (nbVoltages + 1) / (2*nbVoltages));
}


TEST(ModelsMinMaxMean, ModelsMinMaxMeanTypeMethods) {
    boost::shared_ptr<SubModel> mmm = initModelMinMaxMean();

    std::vector<ParameterModeler> parameters;
    mmm->defineParameters(parameters);
    ASSERT_EQ(parameters.size(), 1);
    // 5 fake connections
    unsigned int nbVoltages = 5;
    boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
    parametersSet->createParameter("nbInputs", static_cast<int>(nbVoltages));
    ASSERT_NO_THROW(mmm->setPARParameters(parametersSet));
    mmm->addParameters(parameters, false);  // Might be true here.
    ASSERT_NO_THROW(mmm->setParametersFromPARFile());
    ASSERT_NO_THROW(mmm->setSubModelParameters());
    mmm->getSize();  // Sets all the sizes
    std::vector<boost::shared_ptr<Variable> > variables;
    mmm->defineVariables(variables);
    ASSERT_EQ(variables.size(), 2*nbVoltages);

    unsigned nbY = nbVoltages;
    unsigned nbF = 0;
    unsigned nbZ = nbVoltages;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    mmm->setBufferYType(&yTypes[0], 0);
    ASSERT_NO_THROW(mmm->evalStaticYType());
    ASSERT_EQ(mmm->sizeY(), nbY);
    ASSERT_EQ(mmm->sizeF(), nbF);
    ASSERT_EQ(mmm->sizeZ(), nbZ);
    ASSERT_EQ(mmm->sizeG(), 0);
    ASSERT_EQ(mmm->sizeMode(), 1);

    mmm->evalStaticYType();
    ASSERT_EQ(yTypes[0], DYN::EXTERNAL);
    mmm->evalStaticFType();  // Does nothing here.
    ASSERT_NO_THROW(mmm->initializeFromData(boost::shared_ptr<DataInterface>()));
}


TEST(ModelsMinMaxMean, ModelsMinMaxMeanSomeDisconnectedInputs) {
    unsigned int nbVoltages = 5;
    boost::shared_ptr<SubModel> mmm = initModelMinMaxMean(nbVoltages);
    ASSERT_EQ(mmm->sizeY(), nbVoltages);

    std::vector<boost::shared_ptr<Variable> > variables;
    mmm->defineVariables(variables);
    ASSERT_EQ(variables.size(), 2*nbVoltages);

    unsigned nbY = nbVoltages;
    unsigned nbF = 0;
    unsigned nbZ = nbVoltages;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    mmm->setBufferYType(&yTypes[0], 0);
    ASSERT_NO_THROW(mmm->evalStaticYType());
    ASSERT_EQ(mmm->sizeY(), nbY);
    ASSERT_EQ(mmm->sizeF(), nbF);
    ASSERT_EQ(mmm->sizeZ(), nbZ);
    ASSERT_EQ(mmm->sizeG(), 0);
    ASSERT_EQ(mmm->sizeMode(), 1);

    mmm->evalStaticYType();
    mmm->evalStaticFType();  // Does nothing here.
    ASSERT_NO_THROW(mmm->initializeFromData(boost::shared_ptr<DataInterface>()));

    // The following is needed to check data coherence (otherwise no data has been set!)
    std::vector<double> voltages(mmm->sizeY(), 0.);
    std::vector<double> z(mmm->sizeZ(), 0.);
    // Binary variable for line connections
    bool* zConnected = new bool[mmm->sizeZ()];
    unsigned int nbConnected = 2;
    for (std::size_t i = 0; i < nbConnected; ++i) {
        voltages[i] = static_cast<double>(i+1);
        z[i] = 1.0;
        zConnected[i] = true;
    }
    for (std::size_t i = nbConnected; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i+1);
        z[i] = -1.0;
        zConnected[i] = true;
    }
    mmm->setBufferY(&voltages[0], nullptr, 0);
    mmm->setBufferZ(&z[0], zConnected, 0);
    mmm->evalCalculatedVars();
    ASSERT_NO_THROW(mmm->checkDataCoherence(0.));
    ASSERT_NO_THROW(mmm->initializeStaticData());
    ASSERT_NO_THROW(mmm->evalDynamicFType());
    ASSERT_NO_THROW(mmm->evalDynamicYType());

    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::minValIdx_), 1.0);
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::maxValIdx_), 2.0);
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::avgValIdx_), 1.5);
}


TEST(ModelsMinMaxMean, ModelsMinMaxMeanAllDisconnectedInputs) {
    unsigned int nbVoltages = 25;
    boost::shared_ptr<SubModel> mmm = initModelMinMaxMean(nbVoltages);
    ASSERT_EQ(mmm->sizeY(), nbVoltages);

    // Binary variable for line connections
    std::vector<double> z(mmm->sizeZ(), 0.);
    bool* zConnected = new bool[mmm->sizeZ()];

    std::vector<boost::shared_ptr<Variable> > variables;
    mmm->defineVariables(variables);

    ASSERT_NO_THROW(mmm->initializeFromData(boost::shared_ptr<DataInterface>()));

    std::vector<double> voltages(mmm->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
        z[i] = -1.0;
        zConnected[i] = true;
    }
    mmm->setBufferY(&voltages[0], nullptr, 0);
    mmm->setBufferZ(&z[0], zConnected, 0);
    mmm->evalCalculatedVars();

    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::minValIdx_), MAXFLOAT);
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::maxValIdx_), -MAXFLOAT);
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::avgValIdx_), 0.0);
}


TEST(ModelsMinMaxMean, ModelsMinMaxMeanDataCoherenceExceptions) {
    unsigned int nbVoltages = 25;
    boost::shared_ptr<SubModel> mmm = initModelMinMaxMean(nbVoltages);
    ASSERT_EQ(mmm->sizeY(), nbVoltages);

    // Binary variable for line connections
    std::vector<double> z(mmm->sizeZ(), 0.);
    bool* zConnected = new bool[mmm->sizeZ()];

    std::vector<boost::shared_ptr<Variable> > variables;
    mmm->defineVariables(variables);

    ASSERT_NO_THROW(mmm->initializeFromData(boost::shared_ptr<DataInterface>()));

    std::vector<double> voltages(mmm->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
        z[i] = 1.0;
        zConnected[i] = true;
    }
    mmm->setBufferY(&voltages[0], nullptr, 0);
    mmm->setBufferZ(&z[0], zConnected, 0);
    // FrequencyIncrease will need to be adapted once we know better.
    ASSERT_THROW_DYNAWO(mmm->checkDataCoherence(0.), Error::MODELER, KeyError_t::FrequencyIncrease);

    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = -static_cast<double>(i + 1);
        z[i] = 1.0;
        zConnected[i] = true;
    }
    mmm->setBufferY(&voltages[0], nullptr, 0);
    mmm->setBufferZ(&z[0], zConnected, 0);
    // FrequencyCollapse will need to be adapted once we know better.
    ASSERT_THROW_DYNAWO(mmm->checkDataCoherence(0.), Error::MODELER, KeyError_t::FrequencyCollapse);
}

TEST(ModelsMinMaxMean, ModelsMinMaxMeanUnknownIdxCalculatedVar) {
    unsigned int nbVoltages = 5;
    boost::shared_ptr<SubModel> mmm = initModelMinMaxMean(nbVoltages);
    ASSERT_EQ(mmm->sizeY(), nbVoltages);

    std::vector<boost::shared_ptr<Variable> > variables;
    mmm->defineVariables(variables);
    ASSERT_EQ(variables.size(), 2*nbVoltages);

    unsigned nbY = nbVoltages;
    unsigned nbF = 0;
    unsigned nbZ = nbVoltages;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    mmm->setBufferYType(&yTypes[0], 0);
    ASSERT_NO_THROW(mmm->evalStaticYType());
    ASSERT_EQ(mmm->sizeY(), nbY);
    ASSERT_EQ(mmm->sizeF(), nbF);
    ASSERT_EQ(mmm->sizeZ(), nbZ);
    ASSERT_EQ(mmm->sizeG(), 0);
    ASSERT_EQ(mmm->sizeMode(), 1);

    mmm->evalStaticYType();
    mmm->evalStaticFType();  // Does nothing here.
    ASSERT_NO_THROW(mmm->initializeFromData(boost::shared_ptr<DataInterface>()));

    std::vector<double> voltages(mmm->sizeY(), 0.);
    // Binary variable for line connections
    std::vector<double> z(mmm->sizeZ(), 0.);
    bool* zConnected = new bool[mmm->sizeZ()];
    unsigned int nbConnected = 2;
    for (std::size_t i = 0; i < nbConnected; ++i) {
        voltages[i] = static_cast<double>(i+1);
        z[i] = 1.0;
        zConnected[i] = true;
    }
    for (std::size_t i = nbConnected; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i+1);
        z[i] = -1.0;
        zConnected[i] = true;
    }
    mmm->setBufferY(&voltages[0], nullptr, 0);
    mmm->setBufferZ(&z[0], zConnected, 0);
    mmm->evalCalculatedVars();
    mmm->checkDataCoherence(0.);
    mmm->initializeStaticData();
    mmm->evalDynamicFType();
    mmm->evalDynamicYType();

    ASSERT_THROW_DYNAWO(mmm->evalCalculatedVarI(ModelMinMaxMean::nbCalculatedVars_), Error::MODELER, KeyError_t::UndefCalculatedVarI);
}


}  // namespace DYN
