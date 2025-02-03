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
 * @file API/PAR/test/TestMacroParameterSet.cpp
 * @brief Unit tests for API_PAR
 *
 */

#include "gtest_dynawo.h"
#include "PARMacroParameterSet.h"
#include "PARReference.h"
#include "PARReferenceFactory.h"
#include "PARParameter.h"
#include "PARParameterFactory.h"


namespace parameters {
  TEST(APIPARTest, MacroParameterSet) {
    const std::unique_ptr<MacroParameterSet> macroParameterSet = std::unique_ptr<MacroParameterSet>(new MacroParameterSet("macroParameterSet"));
    ASSERT_EQ(macroParameterSet->getId(), "macroParameterSet");
    std::shared_ptr<Reference> reference = ReferenceFactory::newReference("reference", Reference::OriginData::IIDM);
    ASSERT_NO_THROW(macroParameterSet->addReference(reference));
    ASSERT_THROW_DYNAWO(macroParameterSet->addReference(reference), DYN::Error::API, DYN::KeyError_t::ReferenceAlreadySetInMacroParameterSet);
    std::unique_ptr<Reference> reference_2 = ReferenceFactory::newReference("reference_2", Reference::OriginData::IIDM);
    ASSERT_NO_THROW(macroParameterSet->addReference(std::move(reference_2)));
    std::shared_ptr<Parameter> parameter = ParameterFactory::newParameter("parameter", true);
    ASSERT_NO_THROW(macroParameterSet->addParameter(parameter));
    ASSERT_THROW_DYNAWO(macroParameterSet->addParameter(parameter), DYN::Error::API, DYN::KeyError_t::ParameterAlreadySetInMacroParameterSet);
    std::unique_ptr<Parameter> parameter_2 = ParameterFactory::newParameter("parameter_2", true);
    ASSERT_NO_THROW(macroParameterSet->addParameter(std::move(parameter_2)));
    int nbParameters = 0;
    for (MacroParameterSet::parameter_const_iterator itPar = macroParameterSet->cbeginParameter();
    itPar != macroParameterSet->cendParameter();
    ++itPar) {
      nbParameters++;
    }
    ASSERT_EQ(nbParameters, 2);
    MacroParameterSet::parameter_const_iterator itPar = macroParameterSet->cbeginParameter();
    ASSERT_NO_THROW(itPar++);
    ASSERT_NO_THROW(itPar--);
    ASSERT_NO_THROW(++itPar);
    ASSERT_NO_THROW(--itPar);
    ASSERT_NO_THROW(itPar->get()->getBool());
    ASSERT_NO_THROW((*itPar)->getBool());
    ASSERT_TRUE(itPar == itPar);

    int nbReferences = 0;
    for (MacroParameterSet::reference_const_iterator itRef = macroParameterSet->cbeginReference();
    itRef != macroParameterSet->cendReference();
    ++itRef) {
      nbReferences++;
    }
    ASSERT_EQ(nbReferences, 2);
    MacroParameterSet::reference_const_iterator itRef = macroParameterSet->cbeginReference();
    ASSERT_NO_THROW(itRef++);
    ASSERT_NO_THROW(itRef->get()->getName());
    ASSERT_NO_THROW((*itRef)->getName());
    ASSERT_TRUE(itRef == itRef);
    ASSERT_NO_THROW(++itRef);
  }
}  // namespace parameters
