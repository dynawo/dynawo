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

#include "DYNModelVoltageMeasurementsUtilities.h"
#include "DYNModelVoltageMeasurementsUtilities.hpp"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelVoltageMeasurementsUtilities(unsigned int nbVoltages_ = 0, double step_ = 10.0) {
    boost::shared_ptr<SubModel> voltmu =
        SubModelFactory::createSubModelFromLib("../DYNModelVoltageMeasurementsUtilities" + std::string(sharedLibraryExtension()));
    voltmu->init(0.);  // Harmless coverage
    std::vector<ParameterModeler> parameters;
    voltmu->defineParameters(parameters);  // stands for VOLTage Measurement Utilities
    // 5 fake connections
    boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
    parametersSet->createParameter("nbInputs", static_cast<int>(nbVoltages_));
    parametersSet->createParameter("updateStep", step_);
    voltmu->setPARParameters(parametersSet);
    voltmu->addParameters(parameters, false);
    voltmu->setParametersFromPARFile();
    voltmu->setSubModelParameters();
    voltmu->getSize();  // Sets all the sizes
    return voltmu;
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesDefineMethods) {
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities(0);
    ASSERT_NE(voltmu, nullptr);
    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);
    ASSERT_EQ(variables.size(), DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_);
    std::vector<ParameterModeler> parameters;
    voltmu->defineParameters(parameters);
    ASSERT_EQ(parameters.size(), 2);

    // Harmless coverage
    SparseMatrix mat;
    std::vector<double> resd;
    std::vector<int> resi;

    // Prepare initialization of the model
    std::vector<double> y(voltmu->sizeY(), 0);
    voltmu->setBufferY(&y[0], nullptr, 0.);
    std::vector<double> z(voltmu->sizeZ(), 0);
    bool* zConnected = new bool[voltmu->sizeZ()];
    for (size_t i = 0; i < voltmu->sizeZ(); ++i)
      zConnected[i] = true;
    voltmu->setBufferZ(&z[0], zConnected, 0);
    std::vector<state_g> g(voltmu->sizeG(), ROOT_DOWN);
    voltmu->setBufferG(&g[0], 0);
    ASSERT_NO_THROW(voltmu->getY0());
    ASSERT_NO_THROW(voltmu->setFequations());
    ASSERT_NO_THROW(voltmu->evalF(0, UNDEFINED_EQ));
    ASSERT_NO_THROW(voltmu->evalG(0));
    ASSERT_NO_THROW(voltmu->evalZ(0));
    ASSERT_NO_THROW(voltmu->evalJt(0, 0, mat, 0));
    ASSERT_NO_THROW(voltmu->evalJtPrim(0, 0, mat, 0));
    BitMask* silentZ = new BitMask[voltmu->sizeZ()];
    ASSERT_NO_THROW(voltmu->collectSilentZ(silentZ));
    ASSERT_NO_THROW(voltmu->evalMode(0));
    // ASSERT_NO_THROW(voltmu->evalJCalculatedVarI(0, resd));
    ASSERT_NO_THROW(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(0, resi));
    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(999, resi), DYN::Error::MODELER, DYN::KeyError_t::UndefJCalculatedVarI);
    ASSERT_THROW_DYNAWO(voltmu->evalCalculatedVarI(999), DYN::Error::MODELER, DYN::KeyError_t::UndefCalculatedVarI);

    ASSERT_NO_THROW(voltmu->setGequations());
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesEmptyInput) {
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities();
    std::vector<double> ySelf(voltmu->sizeY(), 0);
    voltmu->setBufferY(&ySelf[0], nullptr, 0);
    std::vector<double> z(voltmu->sizeZ(), 0.);
    bool* zConnected = new bool[voltmu->sizeZ()];
    for (std::size_t i=0; i < voltmu->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    voltmu->setBufferZ(&z[0], zConnected, 0);

    // Run computation of min, max and mean on empty input stream
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), std::numeric_limits<double>::max());
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), std::numeric_limits<double>::lowest());
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::avgValIdx_), 0.0);
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesSimpleInput) {
    unsigned int nbVoltages = 25;
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities(nbVoltages);
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);
    ASSERT_EQ(voltmu->sizeZ(), nbVoltages + ModelVoltageMeasurementsUtilities::nbDiscreteVars_);

    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);
    ASSERT_EQ(variables.size(), voltmu->sizeY() + voltmu->sizeZ());

    unsigned nbY = nbVoltages;
    unsigned nbF = 0;
    unsigned nbZ = nbVoltages + DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    voltmu->setBufferYType(&yTypes[0], 0);
    ASSERT_NO_THROW(voltmu->evalStaticYType());
    ASSERT_EQ(voltmu->sizeY(), nbY);
    ASSERT_EQ(voltmu->sizeF(), nbF);
    ASSERT_EQ(voltmu->sizeZ(), nbZ);
    ASSERT_EQ(voltmu->sizeG(), DYN::ModelVoltageMeasurementsUtilities::nbRoots_);
    ASSERT_EQ(voltmu->sizeMode(), 0);

    voltmu->evalStaticYType();
    ASSERT_EQ(yTypes[0], DYN::EXTERNAL);
    voltmu->evalStaticFType();  // Does nothing here.
    ASSERT_NO_THROW(voltmu->initializeFromData(boost::shared_ptr<DataInterface>()));

    // The following is needed to check data coherence (otherwise no data has been set!)
    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = i + 1;
    }
    std::vector<double> z(voltmu->sizeZ(), 1.);
    bool* zConnected = new bool[voltmu->sizeZ()];
    for (std::size_t i=0; i < voltmu->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    voltmu->setBufferZ(&z[0], zConnected, 0);
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    voltmu->evalCalculatedVars();
    ASSERT_NO_THROW(voltmu->initializeStaticData());
    ASSERT_NO_THROW(voltmu->evalDynamicFType());
    ASSERT_NO_THROW(voltmu->evalDynamicYType());

    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), 1.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), nbVoltages);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::avgValIdx_), nbVoltages * (nbVoltages + 1) / (2*nbVoltages));
}


TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesTypeMethods) {
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities();

    std::vector<ParameterModeler> parameters;
    voltmu->defineParameters(parameters);
    ASSERT_EQ(parameters.size(), 2);
    // 5 fake connections
    unsigned int nbVoltages = 5;
    boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
    parametersSet->createParameter("nbInputs", static_cast<int>(nbVoltages));
    ASSERT_NO_THROW(voltmu->setPARParameters(parametersSet));
    voltmu->addParameters(parameters, false);  // Might be true here.
    ASSERT_NO_THROW(voltmu->setParametersFromPARFile());
    ASSERT_NO_THROW(voltmu->setSubModelParameters());
    voltmu->getSize();  // Sets all the sizes
    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);
    ASSERT_EQ(variables.size(), 2*nbVoltages + DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_);

    unsigned nbY = nbVoltages;
    unsigned nbF = 0;
    unsigned nbZ = nbVoltages + DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    voltmu->setBufferYType(&yTypes[0], 0);
    ASSERT_NO_THROW(voltmu->evalStaticYType());
    ASSERT_EQ(voltmu->sizeY(), nbY);
    ASSERT_EQ(voltmu->sizeF(), nbF);
    ASSERT_EQ(voltmu->sizeZ(), nbZ);
    ASSERT_EQ(voltmu->sizeG(), DYN::ModelVoltageMeasurementsUtilities::nbRoots_);
    ASSERT_EQ(voltmu->sizeMode(), 0);

    voltmu->evalStaticYType();
    ASSERT_EQ(yTypes[0], DYN::EXTERNAL);
    voltmu->evalStaticFType();  // Does nothing here.
    ASSERT_NO_THROW(voltmu->initializeFromData(boost::shared_ptr<DataInterface>()));
}


TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesSomeDisconnectedInputs) {
    unsigned int nbVoltages = 5;
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities(nbVoltages);
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);

    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);
    ASSERT_EQ(variables.size(), 2*nbVoltages + DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_);

    unsigned nbY = nbVoltages;
    unsigned nbF = 0;
    unsigned nbZ = nbVoltages+DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    voltmu->setBufferYType(&yTypes[0], 0);
    ASSERT_NO_THROW(voltmu->evalStaticYType());
    ASSERT_EQ(voltmu->sizeY(), nbY);
    ASSERT_EQ(voltmu->sizeF(), nbF);
    ASSERT_EQ(voltmu->sizeZ(), nbZ);
    ASSERT_EQ(voltmu->sizeG(), DYN::ModelVoltageMeasurementsUtilities::nbRoots_);
    ASSERT_EQ(voltmu->sizeMode(), 0);

    voltmu->evalStaticYType();
    voltmu->evalStaticFType();  // Does nothing here.
    ASSERT_NO_THROW(voltmu->initializeFromData(boost::shared_ptr<DataInterface>()));

    // The following is needed to check data coherence (otherwise no data has been set!)
    std::vector<double> voltages(voltmu->sizeY(), 0.);
    std::vector<double> z(voltmu->sizeZ(), 0.);
    // Binary variable for line connections
    bool* zConnected = new bool[voltmu->sizeZ()];
    // Handle the discrete variables first
    for (size_t i = 0; i < DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_; ++i) {
        z[i] = 0.0;  // This might need to be adapted if the model evolves with more discrete vars.
        zConnected[i] = true;
    }
    unsigned int nbConnected = 2;
    for (std::size_t i = 0; i < nbConnected; ++i) {
        voltages[i] = static_cast<double>(i+1);
        z[i+DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = 1.0;
        zConnected[i+DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = true;
    }
    for (std::size_t i = nbConnected; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i+1);
        z[i+DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = -1.0;
        zConnected[i+DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = true;
    }
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    voltmu->setBufferZ(&z[0], zConnected, 0);
    voltmu->evalCalculatedVars();
    ASSERT_NO_THROW(voltmu->checkDataCoherence(0.));
    ASSERT_NO_THROW(voltmu->initializeStaticData());
    ASSERT_NO_THROW(voltmu->evalDynamicFType());
    ASSERT_NO_THROW(voltmu->evalDynamicYType());

    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), 1.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), 2.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::avgValIdx_), 1.5);
}


TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesAllDisconnectedInputs) {
    unsigned int nbVoltages = 25;
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities(nbVoltages);
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);

    // Binary variable for line connections
    std::vector<double> z(voltmu->sizeZ(), 0.);
    bool* zConnected = new bool[voltmu->sizeZ()];

    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);

    ASSERT_NO_THROW(voltmu->initializeFromData(boost::shared_ptr<DataInterface>()));

    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
        z[i] = -1.0;
        zConnected[i] = true;
    }
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    voltmu->setBufferZ(&z[0], zConnected, 0);
    voltmu->evalCalculatedVars();

    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), std::numeric_limits<double>::max());
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), std::numeric_limits<double>::lowest());
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::avgValIdx_), 0.0);
}


TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesDataCoherenceExceptions) {
    unsigned int nbVoltages = 25;
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities(nbVoltages);
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);

    // Binary variable for line connections
    std::vector<double> z(voltmu->sizeZ(), 0.);
    bool* zConnected = new bool[voltmu->sizeZ()];

    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);

    ASSERT_NO_THROW(voltmu->initializeFromData(boost::shared_ptr<DataInterface>()));

    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
        z[i] = 1.0;
        zConnected[i] = true;
    }
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    voltmu->setBufferZ(&z[0], zConnected, 0);
    ASSERT_NO_THROW(voltmu->checkDataCoherence(0.));
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesUnknownIdxCalculatedVar) {
    unsigned int nbVoltages = 5;
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities(nbVoltages);
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);

    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);
    ASSERT_EQ(variables.size(), 2*nbVoltages + DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_);

    unsigned nbY = nbVoltages;
    unsigned nbF = 0;
    unsigned nbZ = nbVoltages + DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    voltmu->setBufferYType(&yTypes[0], 0);
    ASSERT_NO_THROW(voltmu->evalStaticYType());
    ASSERT_EQ(voltmu->sizeY(), nbY);
    ASSERT_EQ(voltmu->sizeF(), nbF);
    ASSERT_EQ(voltmu->sizeZ(), nbZ);
    ASSERT_EQ(voltmu->sizeG(), DYN::ModelVoltageMeasurementsUtilities::nbRoots_);
    ASSERT_EQ(voltmu->sizeMode(), 0);

    voltmu->evalStaticYType();
    voltmu->evalStaticFType();  // Does nothing here.
    ASSERT_NO_THROW(voltmu->initializeFromData(boost::shared_ptr<DataInterface>()));

    std::vector<double> voltages(voltmu->sizeY(), 0.);
    // Binary variable for line connections
    std::vector<double> z(voltmu->sizeZ(), 0.);
    bool* zConnected = new bool[voltmu->sizeZ()];
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
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    voltmu->setBufferZ(&z[0], zConnected, 0);
    voltmu->evalCalculatedVars();
    voltmu->checkDataCoherence(0.);
    voltmu->initializeStaticData();
    voltmu->evalDynamicFType();
    voltmu->evalDynamicYType();

    ASSERT_THROW_DYNAWO(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::nbCalculatedVars_), Error::MODELER, KeyError_t::UndefCalculatedVarI);
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesIndexesOfCalcVar) {
    unsigned int nbVoltages = 25;
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities(nbVoltages);
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);

    // Binary variable for line connections
    std::vector<double> z(voltmu->sizeZ(), 0.);
    bool* zConnected = new bool[voltmu->sizeZ()];

    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);

    ASSERT_NO_THROW(voltmu->initializeFromData(boost::shared_ptr<DataInterface>()));

    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
        z[i] = 1.0;
        zConnected[i] = true;
    }
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    voltmu->setBufferZ(&z[0], zConnected, 0);
    // Check the indexes needed for computing the min
    std::vector<int> minIndexes;
    voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minValIdx_, minIndexes);

    for (std::size_t i=0; i < nbVoltages; ++i) {
        ASSERT_EQ(minIndexes[i], i);
    }

    // Check the indexes needed for computing the max
    std::vector<int> maxIndexes;
    voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxValIdx_, maxIndexes);

    for (std::size_t i=0; i < nbVoltages; ++i) {
        ASSERT_EQ(maxIndexes[i], i);
    }

    // Check the indexes needed for computing the min
    std::vector<int> avgIndexes;
    voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::avgValIdx_, avgIndexes);

    for (std::size_t i=0; i < nbVoltages; ++i) {
        ASSERT_EQ(avgIndexes[i], i);
    }

    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_, avgIndexes),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesIndexesOfCalcVarDisconnectedInputs) {
    unsigned int nbVoltages = 25;
    unsigned int nbConnectedVoltages = 5;
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities(nbVoltages);
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);

    // Binary variable for line connections
    std::vector<double> z(voltmu->sizeZ(), 0.);
    bool* zConnected = new bool[voltmu->sizeZ()];

    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);

    ASSERT_NO_THROW(voltmu->initializeFromData(boost::shared_ptr<DataInterface>()));

    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbConnectedVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
        z[i] = 1.0;
        zConnected[i] = true;
    }
    for (std::size_t i = nbConnectedVoltages; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
        z[i] = -1.0;
        zConnected[i] = true;
    }
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    voltmu->setBufferZ(&z[0], zConnected, 0);
    // Check the indexes needed for computing the min
    // REMEMBER: The getIndexes function is called only once at the startup of the program and is the result is
    // therefore independent of the state of the running variables.
    std::vector<int> minIndexes;
    voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minValIdx_, minIndexes);

    for (std::size_t i=0; i < nbConnectedVoltages; ++i) {
        ASSERT_EQ(minIndexes[i], i);
    }
    ASSERT_EQ(minIndexes.size(), nbVoltages);

    // Check the indexes needed for computing the max
    std::vector<int> maxIndexes;
    voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxValIdx_, maxIndexes);

    for (std::size_t i=0; i < nbConnectedVoltages; ++i) {
        ASSERT_EQ(maxIndexes[i], i);
    }
    ASSERT_EQ(maxIndexes.size(), nbVoltages);

    // Check the indexes needed for computing the min
    std::vector<int> avgIndexes;
    voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::avgValIdx_, avgIndexes);

    for (std::size_t i=0; i < nbConnectedVoltages; ++i) {
        ASSERT_EQ(avgIndexes[i], i);
    }
    ASSERT_EQ(avgIndexes.size(), nbVoltages);

    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_, avgIndexes),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
}


TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesEvalJCalculatedVar) {
    unsigned int nbVoltages = 25;
    unsigned int nbConnectedVoltages = 5;
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities(nbVoltages);
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);

    // Binary variable for line connections
    std::vector<double> z(voltmu->sizeZ(), 0.);
    bool* zConnected = new bool[voltmu->sizeZ()];

    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);

    ASSERT_NO_THROW(voltmu->initializeFromData(boost::shared_ptr<DataInterface>()));

    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbConnectedVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
        z[i+DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = 1.0;
        zConnected[i+DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = true;
    }
    for (std::size_t i = nbConnectedVoltages; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
        z[i+DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = -1.0;
        zConnected[i+DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = true;
    }
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    voltmu->setBufferZ(&z[0], zConnected, 0);

    // Check the values of the jacobian for the min
    std::vector<double> gradMinVal(voltmu->sizeZ(), 0.);
    voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minValIdx_, gradMinVal);
    std::vector<double> expectedGradMinVal(voltmu->sizeZ(), 0.);
    expectedGradMinVal[0+DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = 1.0;

    for (std::size_t i = 0; i < voltmu->sizeZ(); ++i) {
        ASSERT_EQ(expectedGradMinVal[i], gradMinVal[i]);
    }

    std::vector<double> gradMaxVal(voltmu->sizeZ(), 0.);
    voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxValIdx_, gradMaxVal);
    std::vector<double> expectedGradMaxVal(voltmu->sizeZ(), 0.);
    expectedGradMaxVal[nbConnectedVoltages-1+DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = 1.0;

    for (std::size_t i = 0; i < voltmu->sizeZ(); ++i) {
        // ASSERT_EQ(0, gradMaxVal[i]);
        ASSERT_EQ(expectedGradMaxVal[i], gradMaxVal[i]);
    }

    std::vector<double> gradAvgVal(voltmu->sizeZ(), 0.);
    voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::avgValIdx_, gradAvgVal);
    std::vector<double> expectedGradAvgVal(voltmu->sizeZ(), 0.);
    for (std::size_t i = 0; i < nbConnectedVoltages; ++i) {
        expectedGradAvgVal[i+DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = 1.0/nbConnectedVoltages;
    }

    for (std::size_t i = 0; i < nbVoltages; ++i) {
        ASSERT_EQ(expectedGradAvgVal[i], gradAvgVal[i]);
    }

    std::vector<double> wrongIndexGrad(voltmu->sizeZ(), 0.);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_, wrongIndexGrad),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesEvalJCalculatedVarNoActiveVoltage) {
    unsigned int nbVoltages = 25;
    unsigned int nbConnectedVoltages = 0;
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities(nbVoltages);
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);

    // Binary variable for line connections
    std::vector<double> z(voltmu->sizeZ(), 0.);
    bool* zConnected = new bool[voltmu->sizeZ()];

    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);

    ASSERT_NO_THROW(voltmu->initializeFromData(boost::shared_ptr<DataInterface>()));

    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbConnectedVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
        z[i] = 1.0;
        zConnected[i] = true;
    }
    for (std::size_t i = nbConnectedVoltages; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
        z[i] = -1.0;
        zConnected[i] = true;
    }
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    voltmu->setBufferZ(&z[0], zConnected, 0);

    // Check the values of the jacobian for the min
    std::vector<double> gradMinVal(voltmu->sizeZ(), 0.);
    voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minValIdx_, gradMinVal);
    std::vector<double> expectedGradMinVal(voltmu->sizeZ(), 0.);

    for (std::size_t i = 0; i < voltmu->sizeZ(); ++i) {
        ASSERT_EQ(expectedGradMinVal[i], gradMinVal[i]);
    }

    std::vector<double> gradMaxVal(voltmu->sizeZ(), 0.);
    voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxValIdx_, gradMaxVal);
    std::vector<double> expectedGradMaxVal(voltmu->sizeZ(), 0.);

    for (std::size_t i = 0; i < voltmu->sizeZ(); ++i) {
        ASSERT_EQ(expectedGradMaxVal[i], gradMaxVal[i]);
    }

    std::vector<double> gradAvgVal(voltmu->sizeZ(), 0.);
    voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::avgValIdx_, gradAvgVal);
    std::vector<double> expectedGradAvgVal(voltmu->sizeZ(), 0.);

    for (std::size_t i = 0; i < voltmu->sizeZ(); ++i) {
        ASSERT_EQ(expectedGradAvgVal[i], gradAvgVal[i]);
    }

    std::vector<double> wrongIndexGrad(voltmu->sizeZ(), 0.);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_, wrongIndexGrad),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesSilentZ) {
    unsigned int nbVoltages = 25;
    unsigned int nbConnectedVoltages = 5;
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities(nbVoltages);
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);

    // Binary variable for line connections
    std::vector<double> z(voltmu->sizeZ(), 0.);
    bool* zConnected = new bool[voltmu->sizeZ()];

    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);

    ASSERT_NO_THROW(voltmu->initializeFromData(boost::shared_ptr<DataInterface>()));

    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbConnectedVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
        z[i] = 1.0;
        zConnected[i] = true;
    }
    for (std::size_t i = nbConnectedVoltages; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
        z[i] = -1.0;
        zConnected[i] = true;
    }
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    voltmu->setBufferZ(&z[0], zConnected, 0);

    BitMask* silentZ = new BitMask[voltmu->sizeZ()];
    voltmu->collectSilentZ(silentZ);
    for (std::size_t i = 0; i < voltmu->sizeZ(); ++i) {
        ASSERT_FALSE(silentZ[i].getFlags(NotUsedInDiscreteEquations));
    }
}


}  // namespace DYN
