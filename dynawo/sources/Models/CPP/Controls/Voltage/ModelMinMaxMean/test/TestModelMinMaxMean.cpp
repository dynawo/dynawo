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

TEST(ModelsMinMaxMean, Init) {
    boost::shared_ptr<SubModel> mmm =
        SubModelFactory::createSubModelFromLib("../DYNModelMinMaxMean" + std::string(sharedLibraryExtension()));
    ASSERT_NE(mmm, nullptr);
    std::vector<boost::shared_ptr<Variable> > variables;
    mmm->defineVariables(variables);
    ASSERT_EQ(variables.size(), std::size_t(3));
    std::vector<ParameterModeler> parameters;
    mmm->defineParameters(parameters);
    ASSERT_EQ(parameters.size(), std::size_t(1));
    // ASSERT_EQ(mmm->computeMin(), 0.0);
    // ASSERT_EQ(mmm->computeMax(), 0.0);
    // ASSERT_EQ(mmm->computeMean(), 0.0);
}

}  // namespace DYN
