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

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelMinMaxMean() {
    boost::shared_ptr<SubModel> mmm =
        SubModelFactory::createSubModelFromLib("../DYNModelMinMaxMean" + std::string(sharedLibraryExtension()));

    mmm->getSize();
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
    boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
    // 5 fake connections
    parametersSet->createParameter("nbInputs", 5);
    mmm->setPARParameters(parametersSet);
    mmm->setParametersFromPARFile();
    mmm->setSubModelParameters();

    std::vector<double> z(mmm->sizeZ(), 0);
    // Binary variable for line connections
    std::vector<char> zConnected(mmm->sizeZ(), false);
    mmm->setBufferZ(&z[0], reinterpret_cast<bool*>(zConnected.data()), 0);

    std::vector<double> voltages(mmm->sizeY(), 0.);
    mmm->setBufferY(&voltages[0], nullptr, 0);

    // Run computation of min, max and mean on empty input stream
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::minValIdx_), MAXFLOAT);
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::maxValIdx_), -MAXFLOAT);
    ASSERT_EQ(mmm->evalCalculatedVarI(ModelMinMaxMean::avgValIdx_), 0.0);
}



}  // namespace DYN
