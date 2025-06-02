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
#include "PARParametersSetFactory.h"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNElement.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> createModelVoltageMeasurementsUtilities(unsigned int nbVoltages_ = 0, double step_ = 12.0) {
    // All changes here should be adapted in the test for DefineMethods.
    boost::shared_ptr<SubModel> voltmu =
        SubModelFactory::createSubModelFromLib("../DYNModelVoltageMeasurementsUtilities" + std::string(sharedLibraryExtension()));
    voltmu->init(0.);  // Harmless coverage
    std::vector<ParameterModeler> parameters;
    voltmu->defineParameters(parameters);  // stands for VOLTage Measurement Utilities
    std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
    parametersSet->createParameter("nbInputs", static_cast<int>(nbVoltages_));
    parametersSet->createParameter("updateStep", step_);
    voltmu->setPARParameters(parametersSet);
    voltmu->addParameters(parameters, false);
    voltmu->setParametersFromPARFile();
    voltmu->setSubModelParameters();
    voltmu->getSize();  // Sets all the sizes
    return voltmu;
}

static void setBuffersVMU(boost::shared_ptr<SubModel> voltmu, propertyContinuousVar_t* yTypes,
                            double* voltages, double* z, bool* zConnected, state_g* g) {
    voltmu->setBufferYType(&yTypes[0], 0);
    voltmu->evalStaticYType();

    voltmu->evalStaticFType();  // Does nothing here.
    voltmu->initializeFromData(boost::shared_ptr<DataInterface>());

    voltmu->setBufferZ(&z[0], zConnected, 0);
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    voltmu->initializeStaticData();
    voltmu->evalDynamicFType();
    voltmu->evalDynamicYType();

    voltmu->getY0();
    voltmu->setBufferG(&g[0], 0);
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesDefineMethods) {
    // Checks all operations required in the general initModel function up there.
    boost::shared_ptr<SubModel> voltmu =
        SubModelFactory::createSubModelFromLib("../DYNModelVoltageMeasurementsUtilities" + std::string(sharedLibraryExtension()));
    voltmu->init(0.);
    std::vector<ParameterModeler> parameters;
    voltmu->defineParameters(parameters);  // stands for VOLTage Measurement Utilities
    ASSERT_EQ(parameters.size(), 2);
    // Define the model parameters
    double step = 12;
    unsigned int nbVoltages = 2;
    std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
    parametersSet->createParameter("nbInputs", static_cast<int>(nbVoltages));
    parametersSet->createParameter("updateStep", step);
    ASSERT_NO_THROW(voltmu->setPARParameters(parametersSet));
    voltmu->addParameters(parameters, false);
    ASSERT_NO_THROW(voltmu->setParametersFromPARFile());
    ASSERT_NO_THROW(voltmu->setSubModelParameters());

    ASSERT_NO_THROW(voltmu->getSize());  // Sets all the sizes
    // Let's check the sizes now so that we never have to do it again. Ever.
    ASSERT_EQ(voltmu->sizeG(), DYN::ModelVoltageMeasurementsUtilities::nbRoots_);
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);
    ASSERT_EQ(voltmu->sizeZ(), nbVoltages + DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_);
    ASSERT_EQ(voltmu->sizeMode(), 0);
    ASSERT_EQ(voltmu->sizeF(), 0);

    // Let's work out the variables and elements.
    std::vector<boost::shared_ptr<Variable> > variables;
    voltmu->defineVariables(variables);
    unsigned int nbVar = static_cast<int>(ModelVoltageMeasurementsUtilities::nbCalculatedVars_) +
                            static_cast<int>(ModelVoltageMeasurementsUtilities::nbDiscreteVars_) +
                            2*nbVoltages;
    ASSERT_EQ(variables.size(), nbVar);
    std::vector<Element> elements;
    std::map<std::string, int> mapElements;
    voltmu->defineElements(elements, mapElements);
    unsigned int baseElem = 2*nbVoltages + DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_ + DYN::ModelVoltageMeasurementsUtilities::nbDiscreteVars_;
    ASSERT_EQ(elements.size(), 2*baseElem);
    ASSERT_EQ(elements.size(), mapElements.size());
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesDefineMethodsMissingParams) {
    boost::shared_ptr<SubModel> voltmu =
        SubModelFactory::createSubModelFromLib("../DYNModelVoltageMeasurementsUtilities" + std::string(sharedLibraryExtension()));
    voltmu->init(0.);
    std::vector<ParameterModeler> parameters;
    voltmu->defineParameters(parameters);  // stands for VOLTage Measurement Utilities
    ASSERT_EQ(parameters.size(), 2);
    // Define the model parameters
    double step = 12;
    std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
    parametersSet->createParameter("updateStep", step);
    ASSERT_NO_THROW(voltmu->setPARParameters(parametersSet));
    voltmu->addParameters(parameters, false);
    ASSERT_NO_THROW(voltmu->setParametersFromPARFile());
    ASSERT_THROW_DYNAWO(voltmu->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterHasNoValue);
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesSimpleInput) {
    unsigned int nbVoltages = 25;
    boost::shared_ptr<SubModel> voltmu = createModelVoltageMeasurementsUtilities(nbVoltages);

    unsigned int nbY = nbVoltages;
    std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    voltmu->setBufferYType(&yTypes[0], 0);
    ASSERT_NO_THROW(voltmu->evalStaticYType());
    ASSERT_EQ(voltmu->sizeY(), nbY);

    ASSERT_EQ(yTypes[0], DYN::EXTERNAL);
    ASSERT_NO_THROW(voltmu->evalStaticFType());  // Does nothing here.
    ASSERT_NO_THROW(voltmu->initializeFromData(boost::shared_ptr<DataInterface>()));

    // Connect everything
    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
    }
    std::vector<double> z(voltmu->sizeZ(), 1.);
    bool* zConnected = new bool[voltmu->sizeZ()];
    for (std::size_t i=0; i < voltmu->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    ASSERT_NO_THROW(voltmu->setBufferZ(&z[0], zConnected, 0));
    ASSERT_NO_THROW(voltmu->setBufferY(&voltages[0], nullptr, 0));
    ASSERT_NO_THROW(voltmu->initializeStaticData());
    ASSERT_NO_THROW(voltmu->evalDynamicFType());
    ASSERT_NO_THROW(voltmu->evalDynamicYType());
    // The internal parameters haven't been initialized, it should return 0.
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), 0.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minIValIdx_), 0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), 0.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxIValIdx_), 0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::avgValIdx_), 0.0);
    // We now make sure it is initialized
    ASSERT_NO_THROW(voltmu->getY0());
    // Until we call evalG/evalZ, nothing will happen
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), 0.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), 0.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::avgValIdx_), 0.0);

    unsigned int nbCalcVars = ModelVoltageMeasurementsUtilities::nbCalculatedVars_;
    ASSERT_THROW_DYNAWO(voltmu->evalCalculatedVarI(nbCalcVars), Error::MODELER, KeyError_t::UndefCalculatedVarI);
    // We're still missing the G buffer. Let's deal with it now.
    std::vector<state_g> g(voltmu->sizeG(), NO_ROOT);
    ASSERT_NO_THROW(voltmu->setBufferG(&g[0], 0));
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesTimeToUpdate) {
    unsigned int nbVoltages = 25;
    double step = 12;
    boost::shared_ptr<SubModel> voltmu = createModelVoltageMeasurementsUtilities(nbVoltages, step);

    std::vector<propertyContinuousVar_t> yTypes(nbVoltages, UNDEFINED_PROPERTY);
    // Connect everything
    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
    }
    std::vector<double> z(voltmu->sizeZ(), 1.);
    bool* zConnected = new bool[voltmu->sizeZ()];
    for (std::size_t i=0; i < voltmu->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    std::vector<state_g> g(voltmu->sizeG(), NO_ROOT);

    setBuffersVMU(voltmu, &yTypes[0], &voltages[0], &z[0], &zConnected[0], &g[0]);

    voltmu->evalG(0.0);
    // Nothing happens as the update has just happened through the getY0
    ASSERT_EQ(g[DYN::ModelVoltageMeasurementsUtilities::timeToUpdate_], ROOT_DOWN);
    ASSERT_EQ(voltmu->evalMode(0.0), NO_MODE);

    double next_ts = step + 1.0;
    voltmu->evalG(next_ts);
    ASSERT_EQ(g[DYN::ModelVoltageMeasurementsUtilities::timeToUpdate_], ROOT_UP);
    ASSERT_EQ(voltmu->evalMode(next_ts), ALGEBRAIC_J_UPDATE_MODE);
    // This means we now have a new update. Let's simulate something happening first!
    double minIncreasesBy = 2.0;
    double maxDecreasesBy = 3.0;
    voltages[0] += minIncreasesBy;
    voltages[nbVoltages-1] -=  maxDecreasesBy;
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    ASSERT_NO_THROW(voltmu->evalZ(next_ts));
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), 2.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), nbVoltages-1);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::avgValIdx_),
                    nbVoltages * (nbVoltages + 1) / (2*nbVoltages) + (minIncreasesBy - maxDecreasesBy)/nbVoltages);
    ASSERT_NO_THROW(voltmu->evalCalculatedVars());
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesConnectionDisconnection) {
    unsigned int nbVoltages = 25;
    double step = 12;
    boost::shared_ptr<SubModel> voltmu = createModelVoltageMeasurementsUtilities(nbVoltages, step);

    std::vector<propertyContinuousVar_t> yTypes(nbVoltages, UNDEFINED_PROPERTY);
    // Connect everything
    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
    }
    std::vector<double> z(voltmu->sizeZ(), 1.);
    bool* zConnected = new bool[voltmu->sizeZ()];
    for (std::size_t i=0; i < voltmu->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    std::vector<state_g> g(voltmu->sizeG(), NO_ROOT);

    setBuffersVMU(voltmu, &yTypes[0], &voltages[0], &z[0], &zConnected[0], &g[0]);
    // Make sure things are as you expect them to be
    voltmu->evalG(0.0);
    ASSERT_EQ(g[ModelVoltageMeasurementsUtilities::timeToUpdate_], ROOT_DOWN);
    // The calculated vars should be the default values: getY0 hasn't been called yet.
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), 0.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), 0.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::avgValIdx_), 0.0);

    // Assume we've kept these data long enough for them to be triggered at another iteration down the road
    double nextTs = step + 1.0;
    voltmu->evalG(nextTs);
    voltmu->evalZ(nextTs);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), 1.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minIValIdx_), 0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), nbVoltages);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxIValIdx_), nbVoltages-1);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::avgValIdx_),
                    nbVoltages * (nbVoltages + 1) / (2*nbVoltages));

    nextTs += step + 1.0;
    voltmu->evalG(nextTs);
    // Oh! A new calculation is coming. Better make sure we have handled the disconnection we are simulating!
    z[ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = -1.0;
    z[ModelVoltageMeasurementsUtilities::nbDiscreteVars_+nbVoltages-1] = -1;
    voltmu->evalZ(nextTs);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), 2.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), nbVoltages-1);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::avgValIdx_),
                    nbVoltages * (nbVoltages + 1) / (2*nbVoltages));
    // Simulate another connection before the next required update.
    // Nothing should change.
    double noUpdateTs = nextTs + step/2.;
    voltmu->evalG(noUpdateTs);
    ASSERT_EQ(g[ModelVoltageMeasurementsUtilities::timeToUpdate_], ROOT_DOWN);
    z[ModelVoltageMeasurementsUtilities::nbDiscreteVars_+nbVoltages-1] = 1.0;
    voltmu->evalZ(noUpdateTs);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), 2.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), nbVoltages-1);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::avgValIdx_),
                    nbVoltages * (nbVoltages + 1) / (2*nbVoltages));
    // If we wait long enough, we'll see the update.
    nextTs *= 2;
    voltmu->evalG(nextTs);
    ASSERT_EQ(g[ModelVoltageMeasurementsUtilities::timeToUpdate_], ROOT_UP);
    voltmu->evalZ(nextTs);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::minValIdx_), 2.0);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::maxValIdx_), nbVoltages);
    ASSERT_EQ(voltmu->evalCalculatedVarI(ModelVoltageMeasurementsUtilities::avgValIdx_),
                    (nbVoltages *(nbVoltages + 1.0)/2.0 - 1.0)/(nbVoltages - 1.0));
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesIndexesOfCalcVar) {
    unsigned int nbVoltages = 25;
    boost::shared_ptr<SubModel> voltmu = createModelVoltageMeasurementsUtilities(nbVoltages);

    std::vector<propertyContinuousVar_t> yTypes(nbVoltages, UNDEFINED_PROPERTY);
    // Connect everything
    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
    }
    std::vector<double> z(voltmu->sizeZ(), 1.);
    bool* zConnected = new bool[voltmu->sizeZ()];
    for (std::size_t i=0; i < voltmu->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    std::vector<state_g> g(voltmu->sizeG(), NO_ROOT);

    setBuffersVMU(voltmu, &yTypes[0], &voltages[0], &z[0], &zConnected[0], &g[0]);

    // Check the indexes needed for computing the min
    std::vector<int> minIndexes;
    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minValIdx_, minIndexes),
            Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    // Check the indexes needed for computing the max
    std::vector<int> maxIndexes;
    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxValIdx_, maxIndexes),
            Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    // Check the indexes needed for computing the average
    std::vector<int> avgIndexes;
    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::avgValIdx_, avgIndexes),
            Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_, avgIndexes),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesIndexesOfCalcVarSomeDisconnectedInputs) {
    unsigned int nbVoltages = 25;
    unsigned int nbConnected = 5;
    boost::shared_ptr<SubModel> voltmu = createModelVoltageMeasurementsUtilities(nbVoltages);

    std::vector<propertyContinuousVar_t> yTypes(nbVoltages, UNDEFINED_PROPERTY);
    // Connect everything
    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
    }
    std::vector<double> z(voltmu->sizeZ(), 1.);
    bool* zConnected = new bool[voltmu->sizeZ()];
    // Connect only those that are connected (duh!)
    for (std::size_t i=nbConnected; i < nbVoltages; ++i) {
        z[i+ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = -1.0;
    }
    for (std::size_t i=0; i < voltmu->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    std::vector<state_g> g(voltmu->sizeG(), NO_ROOT);

    setBuffersVMU(voltmu, &yTypes[0], &voltages[0], &z[0], &zConnected[0], &g[0]);

    // Check the indexes needed for computing the min
    std::vector<int> minIndexes;
    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minValIdx_, minIndexes),
            Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    // Check the indexes needed for computing the max
    std::vector<int> maxIndexes;
    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxValIdx_, maxIndexes),
            Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    // Check the indexes needed for computing the average
    std::vector<int> avgIndexes;
    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::avgValIdx_, avgIndexes),
            Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    std::vector<int> IMinIndexes;
    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minIValIdx_, IMinIndexes),
            Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    std::vector<int> IMaxIndexes;
    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxIValIdx_, IMaxIndexes),
            Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    ASSERT_THROW_DYNAWO(voltmu->getIndexesOfVariablesUsedForCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_, avgIndexes),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesEvalJCalculatedVars) {
    unsigned int nbVoltages = 25;
    double step = 12;
    boost::shared_ptr<SubModel> voltmu = createModelVoltageMeasurementsUtilities(nbVoltages, step);

    std::vector<propertyContinuousVar_t> yTypes(nbVoltages, UNDEFINED_PROPERTY);
    // Connect everything
    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
    }
    std::vector<double> z(voltmu->sizeZ(), 1.);
    bool* zConnected = new bool[voltmu->sizeZ()];
    for (std::size_t i=0; i < voltmu->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    std::vector<state_g> g(voltmu->sizeG(), NO_ROOT);

    setBuffersVMU(voltmu, &yTypes[0], &voltages[0], &z[0], &zConnected[0], &g[0]);
    // Make sure things are as you expect them to be
    // To do this, we need to make sure the connections have been handled through an evalZ.
    double t0 = step+1.;
    voltmu->evalG(t0);
    voltmu->evalZ(t0);

    // Check the values of the jacobian for the min
    std::vector<double> gradMinVal(voltmu->sizeY(), 0.);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minValIdx_, gradMinVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    std::vector<double> gradMaxVal(voltmu->sizeY(), 0.);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxValIdx_, gradMaxVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    std::vector<double> gradAvgVal(voltmu->sizeY(), 0.);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::avgValIdx_, gradAvgVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    std::vector<double> gradMinIVal(voltmu->sizeY(), 0.);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minIValIdx_, gradMinIVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    std::vector<double> gradMaxIVal(voltmu->sizeY(), 0.);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxIValIdx_, gradMaxIVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    std::vector<double> wrongIndexGrad(voltmu->sizeY(), 0.);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_, wrongIndexGrad),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesEvalJCalculatedVarsWithConnectionUpdates) {
    unsigned int nbVoltages = 25;
    double step = 12;
    boost::shared_ptr<SubModel> voltmu = createModelVoltageMeasurementsUtilities(nbVoltages, step);

    std::vector<propertyContinuousVar_t> yTypes(nbVoltages, UNDEFINED_PROPERTY);
    // Connect everything
    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
    }
    std::vector<double> z(voltmu->sizeZ(), 1.);
    bool* zConnected = new bool[voltmu->sizeZ()];
    for (std::size_t i=0; i < voltmu->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    std::vector<state_g> g(voltmu->sizeG(), NO_ROOT);

    setBuffersVMU(voltmu, &yTypes[0], &voltages[0], &z[0], &zConnected[0], &g[0]);
    // Make sure things are as you expect them to be
    double t0 = step + 1.0;
    voltmu->evalG(t0);
    voltmu->evalZ(t0);

    // Check the values of the jacobian for the min
    std::vector<double> gradMinVal(voltmu->sizeZ(), 0.);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minValIdx_, gradMinVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    std::vector<double> gradMaxVal(voltmu->sizeZ(), 0.);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxValIdx_, gradMaxVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    std::vector<double> gradAvgVal(voltmu->sizeZ(), 0.);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::avgValIdx_, gradAvgVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    std::vector<double> wrongIndexGrad(voltmu->sizeZ(), 0.);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_, wrongIndexGrad),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    // Add a disconnection before the last update expires: nothing should change.
    double newTs = t0 + step/2.0;  // This is too soon for an update.
    z[ModelVoltageMeasurementsUtilities::nbDiscreteVars_] = -1.0;  // First bus is disconnected.
    voltmu->evalG(newTs);
    voltmu->evalZ(newTs);

    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minValIdx_, gradMinVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxValIdx_, gradMaxVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::avgValIdx_, gradAvgVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::nbCalculatedVars_, wrongIndexGrad),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    // Let's now act on the disconnection!
    newTs += step;
    voltmu->evalG(newTs);
    voltmu->evalZ(newTs);

    // Update the expected grad values.
    // Min has changed, so has the average. Max remains unchanged.
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minValIdx_, gradMinVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxValIdx_, gradMaxVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::avgValIdx_, gradAvgVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);

    // We now make sure the max could change too.
    newTs += step + 1.0;
    z[nbVoltages + ModelVoltageMeasurementsUtilities::nbDiscreteVars_ - 1] = -1.0;

    voltmu->evalG(newTs);
    voltmu->evalZ(newTs);

    // Update the expected grad values.
    // Max has changed, so has the average. Min remains unchanged.
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::minValIdx_, gradMinVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::maxValIdx_, gradMaxVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
    ASSERT_THROW_DYNAWO(voltmu->evalJCalculatedVarI(DYN::ModelVoltageMeasurementsUtilities::avgValIdx_, gradAvgVal),
                    Error::MODELER, KeyError_t::UndefJCalculatedVarI);
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesEvalGNoInit) {
    unsigned int nbVoltages = 25;
    boost::shared_ptr<SubModel> voltmu = createModelVoltageMeasurementsUtilities(nbVoltages);

    std::vector<propertyContinuousVar_t> yTypes(nbVoltages, UNDEFINED_PROPERTY);
    voltmu->setBufferYType(&yTypes[0], 0);
    voltmu->evalStaticYType();
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);

    voltmu->evalStaticFType();  // Does nothing here.
    voltmu->initializeFromData(boost::shared_ptr<DataInterface>());

    // Connect everything
    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
    }
    std::vector<double> z(voltmu->sizeZ(), 1.);
    bool* zConnected = new bool[voltmu->sizeZ()];
    for (std::size_t i=0; i < voltmu->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    voltmu->setBufferZ(&z[0], zConnected, 0);
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    std::vector<state_g> g(voltmu->sizeG(), NO_ROOT);
    voltmu->setBufferG(&g[0], 0);
    voltmu->initializeStaticData();
    voltmu->evalDynamicFType();
    voltmu->evalDynamicYType();

    double t0 = 1.0;  // It could really be anything
    voltmu->evalG(t0);

    // Since things are initialized, the following line shouldn't be an issue!
    ASSERT_NO_THROW(voltmu->getY0());
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesEvalZNoInit) {
    unsigned int nbVoltages = 25;
    boost::shared_ptr<SubModel> voltmu = createModelVoltageMeasurementsUtilities(nbVoltages);

    std::vector<propertyContinuousVar_t> yTypes(nbVoltages, UNDEFINED_PROPERTY);
    voltmu->setBufferYType(&yTypes[0], 0);
    voltmu->evalStaticYType();
    ASSERT_EQ(voltmu->sizeY(), nbVoltages);

    voltmu->evalStaticFType();  // Does nothing here.
    voltmu->initializeFromData(boost::shared_ptr<DataInterface>());

    // Connect everything
    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
    }
    std::vector<double> z(voltmu->sizeZ(), 1.);
    bool* zConnected = new bool[voltmu->sizeZ()];
    for (std::size_t i=0; i < voltmu->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    voltmu->setBufferZ(&z[0], zConnected, 0);
    voltmu->setBufferY(&voltages[0], nullptr, 0);
    std::vector<state_g> g(voltmu->sizeG(), NO_ROOT);
    voltmu->setBufferG(&g[0], 0);
    voltmu->initializeStaticData();
    voltmu->evalDynamicFType();
    voltmu->evalDynamicYType();

    double t0 = 1.0;  // It could really be anything
    voltmu->evalZ(t0);

    // Since things are initialized, the following line shouldn't be an issue!
    ASSERT_NO_THROW(voltmu->getY0());
}

TEST(ModelsVoltageMeasurementUtilities, ModelVoltageMeasurementUtilitiesUselessFunctions) {
    unsigned int nbVoltages = 25;
    double step = 12;
    boost::shared_ptr<SubModel> voltmu = createModelVoltageMeasurementsUtilities(nbVoltages, step);

    std::vector<propertyContinuousVar_t> yTypes(nbVoltages, UNDEFINED_PROPERTY);
    // Connect everything
    std::vector<double> voltages(voltmu->sizeY(), 0.);
    for (std::size_t i = 0; i < nbVoltages; ++i) {
        voltages[i] = static_cast<double>(i + 1);
    }
    std::vector<double> z(voltmu->sizeZ(), 1.);
    bool* zConnected = new bool[voltmu->sizeZ()];
    for (std::size_t i=0; i < voltmu->sizeZ(); ++i) {
        zConnected[i] = true;
    }
    std::vector<state_g> g(voltmu->sizeG(), NO_ROOT);

    setBuffersVMU(voltmu, &yTypes[0], &voltages[0], &z[0], &zConnected[0], &g[0]);

    double t0 = 0.0;
    ASSERT_NO_THROW(voltmu->checkDataCoherence(t0));

    // Harmless coverage
    SparseMatrix mat;

    // Prepare initialization of the model
    ASSERT_NO_THROW(voltmu->setFequations());
    ASSERT_NO_THROW(voltmu->setGequations());
    ASSERT_NO_THROW(voltmu->evalF(t0, UNDEFINED_EQ));
    ASSERT_NO_THROW(voltmu->evalG(0.));
    ASSERT_NO_THROW(voltmu->evalZ(0.));
    ASSERT_NO_THROW(voltmu->evalJt(t0, 0., 0, mat));
    ASSERT_NO_THROW(voltmu->evalJtPrim(t0, 0., 0, mat));

    BitMask* silentZ = new BitMask[voltmu->sizeZ()];
    ASSERT_NO_THROW(voltmu->collectSilentZ(silentZ));

    ASSERT_NO_THROW(voltmu->dumpUserReadableElementList("MyElement"));
}

}  // namespace DYN
