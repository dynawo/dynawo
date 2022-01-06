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

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelMinMaxMean() {
    boost::shared_ptr<SubModel> mmm =
        SubModelFactory::createSubModelFromLib("../DYNModelMinMaxMean" + std::string(sharedLibraryExtension()));
    return mmm;
}

TEST(ModelsMinMaxMean, ModelsMinMaxMeanDefineMethods) {
    boost::shared_ptr<SubModel> mmm = initModelMinMaxMean();
    ASSERT_NE(mmm, nullptr);
    std::vector<boost::shared_ptr<Variable> > variables;
    mmm->defineVariables(variables);
    ASSERT_EQ(variables.size(), std::size_t(3));
    std::vector<ParameterModeler> parameters;
    mmm->defineParameters(parameters);
    ASSERT_EQ(parameters.size(), std::size_t(1));
}

TEST(ModelsMinMaxMean, ModelsMinMaxMeanEmptyInput) {
    boost::shared_ptr<SubModel> mmm = initModelMinMaxMean();
    /*std::vector<double> ySelf(mmm->sizeY(), 0);
    mmm->setBufferY(&ySelf[0], nullptr, 0);*/

    // Run computation of min, max and mean on empty input stream
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::minValIdx_), MAXFLOAT);
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::maxValIdx_), -MAXFLOAT);
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::avgValIdx_), 0.0);
}

TEST(ModelsMinMaxMean, ModelsMinMaxMeanSimpleInput) {
    boost::shared_ptr<SubModel> mmm = initModelMinMaxMean();
    std::vector<ParameterModeler> parameters;
    mmm->defineParameters(parameters);
    boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
    // 5 fake connections
    parametersSet->createParameter("nbInputs", 5);
    mmm->addParameters(parameters, false);
    mmm->setPARParameters(parametersSet);
    mmm->setSubModelParameters();
    mmm->setParametersFromPARFile();
    mmm->getSize();
    ASSERT_EQ(mmm->sizeY(), 2*5);

    std::vector<double> z(mmm->sizeZ(), 0);
    // Binary variable for line connections
    std::vector<char> zConnected(mmm->sizeZ(), false);
    mmm->setBufferZ(&z[0], reinterpret_cast<bool*>(zConnected.data()), 0);

    std::vector<double> voltages(mmm->sizeY(), 0.);
    mmm->setBufferY(&voltages[0], nullptr, 0);

    // Run computation of min, max and mean on empty input stream
    // ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::minValIdx_), MAXFLOAT);
    // ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::maxValIdx_), -MAXFLOAT);
    // ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::avgValIdx_), 0.0);
}

TEST(ModelsMinMaxMean, ModelsMinMaxMeanTypeMethods) {
    boost::shared_ptr<SubModel> mmm = initModelMinMaxMean();
    unsigned nbCalculated = DYN::ModelMinMaxMean::nbCalculatedVars_;
    unsigned nbVoltages = 5;
    unsigned nbY = 2*nbVoltages;
    unsigned nbF = 0;
    unsigned nbZ = 0;
    std::vector<propertyContinuousVar_t> yTypes(nbCalculated + nbY, UNDEFINED_PROPERTY);
    std::fill(yTypes.begin() + nbCalculated, yTypes.begin() + nbCalculated + nbY, DYN::EXTERNAL);
    // std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
    std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
    mmm->setBufferYType(&yTypes[0], 0);
    mmm->setBufferFType(&fTypes[0], 0);

    ASSERT_EQ(mmm->sizeY(), nbY);
    ASSERT_EQ(mmm->sizeF(), nbF);
    ASSERT_EQ(mmm->sizeZ(), nbZ);
    ASSERT_EQ(mmm->sizeG(), 0);
    ASSERT_EQ(mmm->sizeMode(), 1);

    mmm->evalStaticYType();

    mmm->evalStaticFType();
    ASSERT_NO_THROW(mmm->initializeFromData(boost::shared_ptr<DataInterface>()));
    ASSERT_NO_THROW(mmm->checkDataCoherence(0.));
    ASSERT_NO_THROW(mmm->initializeStaticData());
    ASSERT_NO_THROW(mmm->evalDynamicFType());
    ASSERT_NO_THROW(mmm->evalDynamicYType());
    }

}  // namespace DYN
