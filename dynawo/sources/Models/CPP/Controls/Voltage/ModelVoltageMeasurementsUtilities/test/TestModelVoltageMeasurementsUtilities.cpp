//
// Copyright (c) 2022-2022, RTE (http://www.rte-france.com)
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

static boost::shared_ptr<SubModel> initModelVoltageMeasurementsUtilities(unsigned int nbVoltages_ = 0) {
    boost::shared_ptr<SubModel> voltmu =
        SubModelFactory::createSubModelFromLib("../DYNModelVoltageMeasurementsUtilities" + std::string(sharedLibraryExtension()));
    std::vector<ParameterModeler> parameters;
    voltmu->defineParameters(parameters);  // stands for VOLTage Measurement Utilities
    // 5 fake connections
    boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
    parametersSet->createParameter("nbInputs", static_cast<int>(nbVoltages_));
    voltmu->setPARParameters(parametersSet);
    voltmu->addParameters(parameters, false);
    voltmu->setParametersFromPARFile();
    voltmu->setSubModelParameters();
    voltmu->getSize();  // Sets all the sizes
    voltmu->init(0.);  // Harmless coverage
    return voltmu;
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesDefineMethods) {
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities(0);
    ASSERT_NE(voltmu, nullptr);
    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);
    ASSERT_EQ(variables.size(), DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_);
    std::vector<ParameterModeler> parameters;
    voltmu->defineParameters(parameters);
    ASSERT_EQ(parameters.size(), 1);

    // Harmless coverage
    SparseMatrix mat;
    std::vector<double> resd;
    std::vector<int> resi;
    ASSERT_NO_THROW(voltmu->getY0());
    ASSERT_NO_THROW(voltmu->setFequations());
    ASSERT_NO_THROW(voltmu->evalF(0, UNDEFINED_EQ));
    ASSERT_NO_THROW(voltmu->evalG(0));
    ASSERT_NO_THROW(voltmu->evalZ(0));
    ASSERT_NO_THROW(voltmu->evalJt(0, 0, mat, 0));
    ASSERT_NO_THROW(voltmu->evalJtPrim(0, 0, mat, 0));
    ASSERT_NO_THROW(voltmu->collectSilentZ(nullptr));
    ASSERT_NO_THROW(voltmu->evalMode(0));
    ASSERT_NO_THROW(voltmu->evalJCalculatedVarI(0, resd));
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
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), std::numeric_limits<float>::max());
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), std::numeric_limits<float>::lowest());
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::avgValIdx_), 0.0);
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesSimpleInput) {
    unsigned int nbVoltages = 25;
    boost::shared_ptr<SubModel> voltmu = initModelVoltageMeasurementsUtilities(nbVoltages);
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);
    ASSERT_EQ(voltmu->sizeZ(), nbVoltages);

    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);
    ASSERT_EQ(variables.size(), voltmu->sizeY() + voltmu->sizeZ() + DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_);

    unsigned nbY = nbVoltages;
    unsigned nbF = 0;
    unsigned nbZ = nbVoltages;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    voltmu->setBufferYType(&yTypes[0], 0);
    ASSERT_NO_THROW(voltmu->evalStaticYType());
    ASSERT_EQ(voltmu->sizeY(), nbY);
    ASSERT_EQ(voltmu->sizeF(), nbF);
    ASSERT_EQ(voltmu->sizeZ(), nbZ);
    ASSERT_EQ(voltmu->sizeG(), 0);
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
    ASSERT_EQ(parameters.size(), 1);
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
    ASSERT_EQ(variables.size(), 2*nbVoltages + DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_);

    unsigned nbY = nbVoltages;
    unsigned nbF = 0;
    unsigned nbZ = nbVoltages;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    voltmu->setBufferYType(&yTypes[0], 0);
    ASSERT_NO_THROW(voltmu->evalStaticYType());
    ASSERT_EQ(voltmu->sizeY(), nbY);
    ASSERT_EQ(voltmu->sizeF(), nbF);
    ASSERT_EQ(voltmu->sizeZ(), nbZ);
    ASSERT_EQ(voltmu->sizeG(), 0);
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
    ASSERT_EQ(variables.size(), 2*nbVoltages + DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_);

    unsigned nbY = nbVoltages;
    unsigned nbF = 0;
    unsigned nbZ = nbVoltages;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    voltmu->setBufferYType(&yTypes[0], 0);
    ASSERT_NO_THROW(voltmu->evalStaticYType());
    ASSERT_EQ(voltmu->sizeY(), nbY);
    ASSERT_EQ(voltmu->sizeF(), nbF);
    ASSERT_EQ(voltmu->sizeZ(), nbZ);
    ASSERT_EQ(voltmu->sizeG(), 0);
    ASSERT_EQ(voltmu->sizeMode(), 0);

    voltmu->evalStaticYType();
    voltmu->evalStaticFType();  // Does nothing here.
    ASSERT_NO_THROW(voltmu->initializeFromData(boost::shared_ptr<DataInterface>()));

    // The following is needed to check data coherence (otherwise no data has been set!)
    std::vector<double> voltages(voltmu->sizeY(), 0.);
    std::vector<double> z(voltmu->sizeZ(), 0.);
    // Binary variable for line connections
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

    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), std::numeric_limits<float>::max());
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), std::numeric_limits<float>::lowest());
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
    ASSERT_EQ(variables.size(), 2*nbVoltages + DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_);

    unsigned nbY = nbVoltages;
    unsigned nbF = 0;
    unsigned nbZ = nbVoltages;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    voltmu->setBufferYType(&yTypes[0], 0);
    ASSERT_NO_THROW(voltmu->evalStaticYType());
    ASSERT_EQ(voltmu->sizeY(), nbY);
    ASSERT_EQ(voltmu->sizeF(), nbF);
    ASSERT_EQ(voltmu->sizeZ(), nbZ);
    ASSERT_EQ(voltmu->sizeG(), 0);
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
    std::vector<int> minIndexes;
    voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minValIdx_, minIndexes);

    for (std::size_t i=0; i < nbConnectedVoltages; ++i) {
        ASSERT_EQ(minIndexes[i], i);
    }
    ASSERT_EQ(minIndexes.size(), nbConnectedVoltages);

    // Check the indexes needed for computing the max
    std::vector<int> maxIndexes;
    voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxValIdx_, maxIndexes);

    for (std::size_t i=0; i < nbConnectedVoltages; ++i) {
        ASSERT_EQ(maxIndexes[i], i);
    }
    ASSERT_EQ(maxIndexes.size(), nbConnectedVoltages);

    // Check the indexes needed for computing the min
    std::vector<int> avgIndexes;
    voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::avgValIdx_, avgIndexes);

    for (std::size_t i=0; i < nbConnectedVoltages; ++i) {
        ASSERT_EQ(avgIndexes[i], i);
    }
    ASSERT_EQ(avgIndexes.size(), nbConnectedVoltages);

    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_, avgIndexes),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
}


}  // namespace DYN
